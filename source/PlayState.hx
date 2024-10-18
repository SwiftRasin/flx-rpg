package;

import assets.Assets;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import game.GameUtil;
import player.Player;
import player.PlayerColor;
import player.PlayerControls;
import settings.Settings;

class PlayState extends FlxState
{
	// public static var level:String = "";

	public var players:FlxTypedGroup<Player>;

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

	public var onCreate:Void->Void;
	public var onCreatePost:Void->Void;
	public var onUpdate:Void->Void;
	public var onUpdatePost:Void->Void;

	public var onCreatePre:Void->Void;
	public var onUpdatePre:Void->Void;

	function exec(scr:Void->Void, ?name:String = "func")
	{
		if (scr != null)
			scr();
		// else
		// 	trace(name + " couldn't be executed because it was never initialized.");
	}

	override public function create()
	{
		/*
			actually init level
		 */

		if (level != null)
			GameUtil.level = level;
		if (GameUtil.level == "")
			GameUtil.level = "test";

		level = GameUtil.level;

		/*	do the level shit */
		var script = Assets.getTxt("assets/shared/data/levels/" + level + ".hscript");
		var parser = new hscript.Parser();
		var program = parser.parseString(script);
		var interp = new hscript.Interp();
		interp.variables.set("Math", Math);
		interp.variables.set("Assets", Assets);
		interp.variables.set("FlxG", FlxG);
		interp.variables.set("Player", Player);
		// interp.variables.set("players", players);
		interp.variables.set("PlayerColor", PlayerColor);
		interp.variables.set("PlayerControls", PlayerControls);
		// interp.variables.set("Settings", Settings);
		interp.variables.set("PlayerSettings", PlayerSettings);
		interp.variables.set("WorldSettings", WorldSettings);
		interp.variables.set("GameUtil", GameUtil);
		interp.variables.set("BattleUtil", battle.BattleUtil);
		interp.variables.set("instance", this);
		interp.variables.set("PlayState", PlayState);
		interp.variables.set("FlxSprite", FlxSprite);
		interp.variables.set("FlxObject", FlxObject);

		interp.variables.set("BodyPart", player.body.BodyPart);
		interp.variables.set("BodyParts", player.body.BodyParts);
		// interp.variables.set("source", source);

		interp.variables.set("create", onCreate);
		interp.variables.set("update", onUpdate);
		interp.variables.set("createPost", onCreatePost);
		interp.variables.set("updatePost", onUpdatePost);
		interp.variables.set("createPre", onCreatePre);
		interp.variables.set("updatePre", onUpdatePre);

		interp.execute(program);

		onCreatePre = interp.variables.get("createPre");
		onCreate = interp.variables.get("create");
		onCreatePost = interp.variables.get("createPost");

		onUpdatePre = interp.variables.get("updatePre");
		onUpdate = interp.variables.get("update");
		onUpdatePost = interp.variables.get("updatePost");

		exec(onCreatePre, "createPre");

		// bg = new FlxSprite(0,0).loadGraphic(Assets.getFile("images/bg/grid_bg.png"));
		// add(bg);

		exec(onCreate, "create");

		players = new FlxTypedGroup<Player>();
		add(players);
		//add(player1);

		var player1 = new Player(0, 100, 200, new PlayerColor(0), "stinky", new PlayerControls(0), "dummy");
		add(player1);
		players.add(player1);

		FlxG.watch.add(player1, "vel", "player1.vel: ");

		super.create();
		exec(onCreatePost, "createPost");
	}

	override public function update(elapsed:Float)
	{
		exec(onUpdatePre, "updatePre");
		//trace("- " + (players != null));
		//trace((player1 != null));
		players.forEach(function(player:Player)
		{
			//trace("x: " + player.x);
			//trace("y: " + player.y);
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
		exec(onUpdate, "update");

		if (FlxG.keys.justPressed.HOME || FlxG.keys.justPressed.SLASH)
		{
			openSubState(new debug.DebugMenu());
		}
		super.update(elapsed);
		exec(onUpdatePost, "updatePost");
	}
}
