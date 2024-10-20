package game;
import haxe.ui.core.Component;
import flixel.FlxBasic;
import haxe.Timer;
import flixel.math.FlxPoint;
import haxe.macro.Type;
import assets.Assets;
import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;

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
class Bounds extends FlxBasic
{
	public var min:FlxPoint;
	public var max:FlxPoint;

	public function new(min:FlxPoint, max:FlxPoint)
	{
		this.min = min;
		this.max = max;
		super();
	}
}

class ScriptUtil
{
	// var blacklisted = ["haxe.macro", "haxe.macro.TypeTools"];
	public static function makeLevelScript(onCreate:Void->Void, onCreatePre:Void->Void, onCreatePost:Void->Void, onUpdate:Void->Void, onUpdatePre:Void->Void,
			onUpdatePost:Void->Void)
	{
		var script = Assets.getTxt("assets/shared/data/levels/" + GameUtil.level + ".hscript");
		var parser = new hscript.Parser();
		var program = parser.parseString(script);
		var interp = new hscript.Interp();

		interp.variables.set("create", onCreate);
		interp.variables.set("update", onUpdate);
		interp.variables.set("createPost", onCreatePost);
		interp.variables.set("updatePost", onUpdatePost);
		interp.variables.set("createPre", onCreatePre);
		interp.variables.set("updatePre", onUpdatePre);

		interp = importClasses(script, interp);

		return {
			script: script,
			parser: parser,
			program: program,
			interp: interp,
		};
	}

	public static function makeDebugScript(stylesheet:String, component:Component)
	{
		// var script = Assets.getTxt("assets/shared/data/levels/" + GameUtil.level + "/" + stylesheet + ".hscript");
		var script = Assets.getTxt(Assets.getFile("data/debug/" + stylesheet + ".hscript"));
		var parser = new hscript.Parser();
		var program = parser.parseString(script);
		var interp = new hscript.Interp();

		interp.variables.set("sheet", component);

		interp = importClasses(script, interp);

		return {
			script: script,
			parser: parser,
			program: program,
			interp: interp,
		};
	}

	public static function importClasses(script:String, interp:hscript.Interp)
	{
		for (line in script.split("\n"))
		{
			if (!StringTools.startsWith(line, "//@import"))
			{
				// trace("not import line");
				continue;
			}
			if (StringTools.contains(line, "haxe.macro"))
			{
				trace("any 'haxe.macro' class path is blacklisted!");
				continue;
			}

			var classString = StringTools.replace(line, "//@import ", "");
			classString = StringTools.replace(classString, ";", "").trim();

			var classPath = Type.resolveClass(classString);

			if (classPath == null)
			{
				trace("Class not found: " + classString);
				continue;
			}

			var simpleClassName = classString.split(".").pop();
			interp.variables.set(simpleClassName, classPath); // i forgot this earlier and I got confused

			trace("classString: " + classString);
			trace("Resolved class: " + Type.getClassName(classPath));
		}
		// trace(interp.variables);
		return interp;
	}
}