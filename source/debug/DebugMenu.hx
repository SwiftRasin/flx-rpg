package debug;

import assets.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import settings.Settings;

class DebugMenu extends FlxSubState
{

	var dbm:FlxSprite;

	public function new()
	{
		super();
		dbm = new FlxSprite(0,0);
		dbm.loadGraphic(Assets.getFile("images/menu/debug menu.png"));
		//dbm.scale.set(0.25,0.25);
		add(dbm);
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.BACKSPACE)
			close();
		super.update(elapsed);
	}
}
