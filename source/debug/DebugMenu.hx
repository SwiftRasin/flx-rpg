package debug;

import assets.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import haxe.ui.Toolkit;
import haxe.ui.components.*;
import haxe.ui.containers.*;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import haxe.ui.containers.dialogs.Dialogs.FileDialogTypes;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.MessageBox.MessageBoxType;
import haxe.ui.containers.dialogs.MessageBox;
import haxe.ui.containers.dialogs.OpenFileDialog;
import haxe.ui.containers.dialogs.SaveFileDialog;
import haxe.ui.containers.menus.*;
import haxe.ui.containers.windows.*;
import haxe.ui.core.Component;
import haxe.ui.core.ItemRenderer;
import haxe.ui.data.ArrayDataSource;
import haxe.ui.data.DataSource;
import haxe.ui.themes.Theme;
import haxe.ui.tooltips.ToolTipManager;
import settings.Settings;

class DebugMenu extends FlxSubState
{
	var dbm:FlxSprite;
	var c64:FlxSprite;

	public function new()
	{
		super();
		dbm = new FlxSprite(0,0);
		dbm.loadGraphic(Assets.getFile("images/menu/debug menu.png"));
		//dbm.scale.set(0.25,0.25);
		add(dbm);
		c64 = new FlxSprite(0, 50);
		c64.loadGraphic(Assets.getFile("images/c64.png"));
		add(c64);
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.BACKSPACE)
			close();
		super.update(elapsed);
	}
}
