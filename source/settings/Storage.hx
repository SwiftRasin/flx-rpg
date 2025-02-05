package settings;
import haxe.Json;
import settings.Settings;

class Storage
{
	public static var storage:Array<PlayerSettings> = [];

	public static function add(s:PlayerSettings):Int // "s" stands for "settings"
	{
		storage.push(s);
		return storage.length - 1; // returns the index of this new item.
	}

	public static function clear()
	{
		storage = [];
		trace("storage cleared");
	}
	public static function save()
	{
		//
	}

	public static function test(data:PlayerSettings)
	{
		trace(Json.stringify(data));
	}
}