package debug;

import assets.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import game.GameUtil.ScriptUtil;
import haxe.ui.RuntimeComponentBuilder;
import haxe.ui.Toolkit;
import haxe.ui.core.Component;
import haxe.ui.themes.Theme;

class DebugMenu extends FlxSubState
{

	var dbm:FlxSprite;
	var c64:FlxSprite;

	public var oldState:PlayState;

	public var upd:Void->Void;

	public var mainView:Component;

	public function new(oldState:PlayState)
	{

		this.oldState = oldState;
		super();
		// FlxG.cameras.setDefaultDrawTarget(FlxG.camera, );
		dbm = new FlxSprite(100, -25);
		dbm.loadGraphic(Assets.getFile("images/menu/debug menu.png"));
		// dbm.x -= dbm.width / 2;
		// dbm.y -= dbm.height / 2;
		dbm.scale.set(0.5, 0.5);
		add(dbm);
		dbm.scrollFactor.set(0, 0);
		// c64 = new FlxSprite(0, 50);
		// c64.loadGraphic(Assets.getFile("images/c64.png"));
		// add(c64);
		dbm.cameras = [FlxG.cameras.list[1]];
		// var idx = 0;
		// for (camera in FlxG.cameras.list)
		// {
		// 	if (idx == 1)
		// 		camera.zoom = 2;
		// 	idx++;
		// }
		// c64.cameras = [FlxG.cameras.list[1]];

		Toolkit.init();
		Toolkit.theme = Theme.DARK;

		var path:String = Assets.getFile("data/debug/main-view.xml");

		mainView = RuntimeComponentBuilder.fromAsset(path);
		mainView.scrollFactor.set(0, 0);
		mainView.cameras = [FlxG.cameras.list[1]];
		add(mainView);
		mainView.screenCenter();

		var mainViewHandler = ScriptUtil.makeDebugScript("main-view", mainView);
		mainViewHandler.interp.variables.set("state", this);
		try
		{
			game.ScriptEnvironment.run(mainViewHandler.interp, mainViewHandler.program);
			// mainViewHandler.interp.execute(mainViewHandler.program);
		}
		catch (e)
		{
			trace(e.message);
		}
		upd = mainViewHandler.interp.variables.get("update");
	}

	override public function update(elapsed:Float)
	{
		// if (FlxG.keys.justPressed.BACKSPACE)
		// {
		// oldState.paused = false;
		// close();
		// }
		if (upd != null)
			upd();
		super.update(elapsed);
	}
}
