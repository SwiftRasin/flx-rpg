package;

import flixel.FlxG;
import flixel.FlxGame;
import game.GameUtil;
import haxe.Timer;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		GameUtil.timer = new Timer(1);
		addChild(new FlxGame(0, 0, PlayState));
		FlxG.camera.pixelPerfectRender = false;
	}
}
