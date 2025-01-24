package;

import assets.Assets;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import game.GameUtil;
import menu.MainMenu;
import player.Player;
import player.PlayerColor;
import player.PlayerControls;
import settings.Settings;

class PlayState extends state.State
{
	// public static var level:String = "";

	public var players:FlxTypedGroup<Player>;

	public var camGAME:FlxCamera;
	public var camHUD:FlxCamera;

	// var bg:FlxSprite;
	// public function new(?level:String)
	// {
	// 	if (level != null)
	// 		GameUtil.level = level;
	// 	if (GameUtil.level == "")
	// 		GameUtil.level = "test";
	// 	super();
	// }
	public var level:String = '';

	public var cameraBounds:Bounds;
	public var freeCam:Bool = true;
	public var focusedPlayer:Int = 0;

	public var camFocus:FlxObject;

	public var paused:Bool = false;


	public var onCreate:Void->Void;
	public var onCreatePost:Void->Void;
	public var onUpdate:Void->Void;
	public var onUpdatePost:Void->Void;

	public var onCreatePre:Void->Void;
	public var onUpdatePre:Void->Void;

	public var spawnPoint:FlxPoint;

	function exec(scr:Void->Void, ?name:String = "func")
	{
		if (scr != null)
			scr();
		// else
		// trace(name + " couldn't be executed because it was never initialized.");
	}
	function exitToMenu()
	{
		players.forEach(function(plr:Player)
		{
			plr.destroy();
		});
		FlxG.switchState(new MainMenu());
	}

	// // var bg:FlxSprite;
	// public function new(?level:String)
	// {
	// 	if (level != null)
	// 		GameUtil.level = level;
	// 	if (GameUtil.level == "")
	// 		GameUtil.level = "test";
	// 	super();
	// }

	override public function create()
	{
		this.persistentUpdate = true;
		this.persistentDraw = true;
		
		/*
			actually init level
		 */

		if (level != null)
			GameUtil.level = level;
		if (GameUtil.level == "" || GameUtil.level == null)
			GameUtil.level = "test";

		level = GameUtil.level;

		cameraBounds = new Bounds(new FlxPoint(0, 0), new FlxPoint(400, 400));

		camGAME = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		camFocus = new FlxObject(cameraBounds.min.x, cameraBounds.min.y);
		add(camFocus);

		spawnPoint = new FlxPoint(0, 0);

		FlxG.cameras.reset(camGAME);
		FlxG.cameras.add(camHUD, false);

		/*	do the level shit */
		var util = ScriptUtil.makeLevelScript(onCreate, onCreatePre, onCreatePost, onUpdate, onUpdatePre, onUpdatePost);
		var script = util.script;
		// var parser = util.parser;
		var program = util.program;
		var interp = util.interp;

		interp.variables.set("instance", this);

		game.ScriptEnvironment.run(interp, program); // interp.execute(program);

		onCreatePre = interp.variables.get("createPre");
		onCreate = interp.variables.get("create");
		onCreatePost = interp.variables.get("createPost");

		onUpdatePre = interp.variables.get("updatePre");
		onUpdate = interp.variables.get("update");
		onUpdatePost = interp.variables.get("updatePost");

		exec(onCreatePre, "createPre");

		players = new FlxTypedGroup<Player>();
		add(players);
		//add(player1);

		var player1 = new Player(0, spawnPoint.x, spawnPoint.y, new PlayerColor(0), "stinky", new PlayerControls(0), "default");
		add(player1);
		players.add(player1);
		if (GameUtil.players > 1)
		{
			var player2 = new Player(1, spawnPoint.x + 100, spawnPoint.y + 100, new PlayerColor(1), "stinky", new PlayerControls(1), "default");
			add(player2);
			players.add(player2);
		}
		if (GameUtil.players > 2)
		{
			var player2 = new Player(2, spawnPoint.x + 200, spawnPoint.y + 200, new PlayerColor(2), "stinky", new PlayerControls(2), "default");
			add(player2);
			players.add(player2);
		}

		exec(onCreate, "create");

		FlxG.watch.add(player1, "vel", "player1.vel: ");
		FlxG.watch.add(FlxG.camera.x, "camera.x: ");
		FlxG.watch.add(FlxG.camera.y, "camera.y: ");

		super.create();
		exec(onCreatePost, "createPost");
		FlxG.camera.follow(players.members[focusedPlayer], 0.1);
		FlxG.camera.snapToTarget();
	}

	override public function update(elapsed:Float)
	{
		exec(onUpdatePre, "updatePre");
		//trace("- " + (players != null));
		//trace((player1 != null));

		if (!paused)
		{
			players.forEach(function(player:Player)
			{
				// trace("x: " + player.x);
				// trace("y: " + player.y);
				if (FlxG.keys.anyPressed([player.getControl(UP)]))
				{
					player.vel.y -= player.speed;
				}
				if (FlxG.keys.anyPressed([player.getControl(DOWN)]))
				{
					player.vel.y += player.speed;
				}
				if (FlxG.keys.anyPressed([player.getControl(LEFT)]))
				{
					player.vel.x -= player.speed;
				}
				if (FlxG.keys.anyPressed([player.getControl(RIGHT)]))
				{
					player.vel.x += player.speed;
				}
			});
		}
		
		exec(onUpdate, "update");

		if (FlxG.keys.justPressed.HOME || FlxG.keys.justPressed.SLASH && !paused)
		{
			paused = true;
			openSubState(new debug.DebugMenu(this));
		}
		super.update(elapsed);
		if (freeCam)
		{
			if (WorldSettings.settings["CoCamera"].value)
			{
				camFocus.x = players.members[focusedPlayer].x;
				camFocus.y = players.members[focusedPlayer].y;
			}
			else
			{
				var avgPos:Array<Float> = [0, 0];
				var sums:Array<Float> = [0, 0];
				for (i in 0...players.members.length)
				{
					sums[0] += players.members[i].x;
					sums[1] += players.members[i].y;
				}

				avgPos[0] = sums[0] / players.members.length;
				avgPos[1] = sums[1] / players.members.length;

				// camera.x = lerp(camera.x, avgPos[0], 0.1);
				// camera.y = lerp(camera.y, avgPos[1], 0.1);
				camFocus.x = avgPos[0];
				camFocus.y = avgPos[1];
			}
		}
		else
		{
			FlxG.camera.follow(null);
		}

		FlxG.camera.follow(camFocus, 0.1);
		

		// if (FlxG.keys.justPressed.BACKSPACE && paused)
		// {
		// 	closeSubState();
		// 	paused = false;
		// }

		// FlxG.camera.deadzone = new flixel.math.FlxRect(cameraBounds.min.x, cameraBounds.min.y, cameraBounds.max.x, cameraBounds.max.y);
		// if (FlxG.camera.x > cameraBounds.max.x)
		// 	FlxG.camera.x = cameraBounds.max.x;
		// if (FlxG.camera.x < cameraBounds.min.x)
		// 	FlxG.camera.x = cameraBounds.min.x;

		// if (FlxG.camera.y > cameraBounds.max.y)
		// 	FlxG.camera.y = cameraBounds.max.y;
		// if (FlxG.camera.y < cameraBounds.min.y)
		// 	FlxG.camera.y = cameraBounds.min.y;
		FlxG.camera.setScrollBounds(cameraBounds.min.x, cameraBounds.max.x, cameraBounds.min.y, cameraBounds.max.y);
		

		exec(onUpdatePost, "updatePost");
	}
}
