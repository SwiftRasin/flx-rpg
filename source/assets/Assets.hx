package assets;

import flixel.FlxG;
import game.GameUtil;
import lime.utils.Assets as Lime_Assets;
import openfl.Assets as OpenFL_Assets;

class Assets
{
    public static var IMG:String = ".png";
    public static var SND:String = ".ogg";
    public static var MUS:String = ".ogg";

	public static function exists(path:String)
	{
		return OpenFL_Assets.exists(path);
	}

    public static function checkPath(path:String, root:String):Bool
    {
		return exists("assets/" + root + "/" + path);
    }

	public static function checkRawPath(path:String)
	{
		return OpenFL_Assets.exists(path);
	}

    public static function getFile(path:String):String
    {
        var finalPath = "assets/shared" + "/" + path;
        if (GameUtil.level != "" || GameUtil.level == null)
        {
			if (checkPath(path, "levels/" + GameUtil.level))
				finalPath = "assets/levels/" + GameUtil.level + "/" + path;
        }
        return finalPath;
    }

    public static function getBodyPart(skin:String,path:String)
    {
        return getFile("images/player/" + skin + "/"+ path);
    }
    public static function getSkinData(skin:String)
    {
        return getFile("data/costumes/"+skin+"/properties.json");
    }

	public static function getPortPart(port:String, path:String)
	{
		return getFile("images/ui/dialogue/ports/" + port + "/" + path);
	}

	public static function getPortData(port:String)
	{
		return getFile("data/ports/" + port + "/port.json");
	}

	public static function getUIImage(path:String)
	{
		return getFile("images/ui/" + path);
	}

    public static function getTxt(path:String):Dynamic
    {
        return Lime_Assets.getAsset(path, TEXT, false);
    }
	public static function aud(path:String, type:String)
	{
		var finalPath = "";
		if (checkRawPath(getFile(type + "/" + path + ".ogg")))
			finalPath = getFile(type + "/" + path + ".ogg");
		else if (checkRawPath(getFile(type + "/" + path + ".wav")))
			finalPath = getFile(type + "/" + path + ".wav");
		else
			finalPath = getFile(type + "/" + path + ".mp3");
		return finalPath;
	}
	public static function mus(path:String):String
	{
		return aud(path, "music");
	}

	public static function snd(path:String):String
	{
		return aud(path, "sounds");
	}
}