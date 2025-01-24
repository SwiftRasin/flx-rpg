package;

import assets.Assets;
import flixel.FlxG;
import flixel.FlxGame;
import game.GameUtil;
import haxe.Timer;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var loadedMods = [];
	public static var mainGame:FlxGame;
	public function new()
	{
		super();
		GameUtil.timer = new Timer(1);
		game.ModUtil.init();
		mainGame = new FlxGame(0, 0, menu.MainMenu);
		addChild(mainGame);
		FlxG.camera.pixelPerfectRender = false;
	}
}
