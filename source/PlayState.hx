package;

import assets.Assets;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import player.Player;
import player.PlayerColor;
import player.PlayerControls;

class PlayState extends FlxState
{
	public var players:FlxTypedGroup<Player>;

	var bg:FlxSprite;

	override public function create()
	{
		bg = new FlxSprite(0,0).loadGraphic(Assets.getFile("images/bg/grid_bg.png"));
		add(bg);

		players = new FlxTypedGroup<Player>();
		add(players);
		//add(player1);

		var player1 = new Player(0, 100, 200, new PlayerColor(0), "stinky", new PlayerControls(0), "cool");
		add(player1);
		//
		var player2 = new Player(0, 300, 200, new PlayerColor(1), "doodoo", new PlayerControls(1), "bot");
		add(player2);
		//
		var player3 = new Player(0, 200, 200, new PlayerColor(2), "potty", new PlayerControls(2), "default");
		add(player3);
		//
		var player4 = new Player(0, 200, 100, new PlayerColor(3), "oops", new PlayerControls(3), "dummy");
		add(player4);

		var player5 = new Player(0, 200, 300, new PlayerColor(-1, 0xFF8584d8), "oops", new PlayerControls(-1), "c64");
		add(player5);

		players.add(player1);
		players.add(player2);
		players.add(player3);
		players.add(player4);

		FlxG.watch.add(player1, "vel", "player1.vel: ");
		FlxG.watch.add(player2, "vel", "player2.vel: ");
		FlxG.watch.add(player3, "vel", "player3.vel: ");
		FlxG.watch.add(player4, "vel", "player4.vel: ");

		//player.screenCenter();
		//FlxG.camera.zoom = 100;
		///trace((players != null));
		//trace((player1 != null));
		super.create();
	}

	override public function update(elapsed:Float)
	{
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
		if (FlxG.keys.justPressed.HOME || FlxG.keys.justPressed.SLASH)
		{
			openSubState(new debug.DebugMenu());
		}
		super.update(elapsed);
	}
}
