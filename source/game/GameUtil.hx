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
        //var t = new Date().getTime() * speed;
        var t:Float = 0;
        #if desktop
            t = Date.now().getTime() * speed;
        #elseif js
            //t = Browser.window.performance.now() * speed;
            t = Timer.stamp() * speed;

        #end
        //trace(t);
        if (type == 'sin')
            return Math.sin(t / 200) * amt + offset;
        else if (type == "cos")
            return Math.cos(t / 200) * amt + offset;
        else
            return 0;
    }
}