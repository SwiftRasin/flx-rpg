package settings;

import battle.*;
import flixel.FlxBasic;
import player.*;
import settings.Settings;

class Storage
{
	public static var storage:Array<PlayerSettings> = [];

	public static function clear()
	{
		storage = [];
		trace("storage cleared");
	}
}