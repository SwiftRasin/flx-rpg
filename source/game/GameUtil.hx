package game;
import haxe.Timer;

#if js
    //import js.Browser;
#end

class GameUtil
{
    public static var level = "";

    public static var timer:Timer;

    public static function getWavy(offset:Float, type:String, speed:Float, amt:Float):Float
	{
		var t:Float = 0;
		t = Date.now().getTime() * speed;

		var f:Float = 0;
        if (type == 'sin')
			f = Math.sin(t / 200) * amt + offset;
        else if (type == "cos")
			f = Math.cos(t / 200) * amt + offset;
        else
			f = 0;
		return f;
    }
}