package assets;

import game.GameUtil;
import lime.utils.Assets as Lime_Assets;
import openfl.Assets as OpenFL_Assets;

class Assets
{
    public static var IMG:String = ".png";
    public static var SND:String = ".ogg";
    public static var MUS:String = ".ogg";

    public static function checkPath(path:String, root:String):Bool
    {
        return OpenFL_Assets.exists("assets/" + root + "/" + path);
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

    public static function getTxt(path:String):Dynamic
    {
        return Lime_Assets.getAsset(path, TEXT, false);
    }
}