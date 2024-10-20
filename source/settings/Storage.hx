package settings;
import settings.Settings;

class Storage
{
	public static var storage:Array<PlayerSettings> = [];

	public static function add(s:PlayerSettings) // "s" stands for "settings"
	{
		storage.push(s);
	}

	public static function clear()
	{
		storage = [];
		trace("storage cleared");
	}
}