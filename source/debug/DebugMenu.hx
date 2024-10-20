package debug;

import assets.Assets;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
// import flixel.system.frontEnds.CameraFrontEnd;
import flixel.ui.FlxButton;
import game.GameUtil.ScriptUtil;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.ui.RuntimeComponentBuilder;
import haxe.ui.Toolkit;
import haxe.ui.components.*;
import haxe.ui.components.popups.ColorPickerPopup;
import haxe.ui.containers.*;
import haxe.ui.containers.dialogs.*;
import haxe.ui.containers.menus.*;
import haxe.ui.containers.windows.*;
import haxe.ui.core.Component;
import haxe.ui.core.ItemRenderer;
import haxe.ui.data.ArrayDataSource;
import haxe.ui.data.DataSource;
import haxe.ui.themes.Theme;
import haxe.ui.tooltips.ToolTipManager;
import settings.Settings;
// // import haxe.ui.containers.*;
// // import haxe.ui.containers.TabView;

class DebugMenu extends FlxSubState
{

	var dbm:FlxSprite;
	var c64:FlxSprite;

	public var oldState:PlayState;

	public function new(oldState:PlayState)
	{
		this.oldState = oldState;
		super();
		// FlxG.cameras.setDefaultDrawTarget(FlxG.camera, );
		dbm = new FlxSprite(140, -25);
		dbm.loadGraphic(Assets.getFile("images/menu/debug menu.png"));
		// dbm.x -= dbm.width / 2;
		// dbm.y -= dbm.height / 2;
		dbm.scale.set(0.5, 0.5);
		add(dbm);
		// c64 = new FlxSprite(0, 50);
		// c64.loadGraphic(Assets.getFile("images/c64.png"));
		// add(c64);
		dbm.cameras = [FlxG.cameras.list[1]];
		// c64.cameras = [FlxG.cameras.list[1]];

		Toolkit.init();
		Toolkit.theme = Theme.DARK;

		var path:String = Assets.getFile("data/debug/main-view.xml");

		var mainView:Component = RuntimeComponentBuilder.fromAsset(path);
		add(mainView);

		var mainViewHandler = ScriptUtil.makeDebugScript("main-view", mainView);
		mainViewHandler.interp.variables.set("state", this);
		try
		{
			mainViewHandler.interp.execute(mainViewHandler.program);
		}
		catch (e)
		{
			trace(e.message);
		}
	}

	override public function update(elapsed:Float)
	{
		// if (FlxG.keys.justPressed.BACKSPACE)
		// {
		// oldState.paused = false;
		// close();
		// }
		super.update(elapsed);
	}
}
