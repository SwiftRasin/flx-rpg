package game;
import haxe.ui.core.Component;
import flixel.FlxBasic;
import haxe.Timer;
import flixel.math.FlxPoint;
import haxe.macro.Type;
import assets.Assets;
import haxe.macro.Context;
import haxe.macro.Expr;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSubState;
import menu.Menu;

using StringTools;

#if js
    //import js.Browser;
#end

class GameUtil
{
    public static var level = "";

    public static var timer:Timer;

	public static var menus:Map<String, Class<Menu>> = [];
	public static var submenus:Map<String, Class<SubMenu>> = [];

	public static var curMenu:String;
	public static var curSubMenu:String;

	public static var curMenuI:Menu;
	public static var curSubMenuI:SubMenu;

	public static var log:String = "";

	public static var players:Int = 1;

	public static function appendLog(msg:String, ?type:String = "LOG")
	{
		log += "@TYPE: " + type + " -----\n" + msg + "\n";
	}

	public static function resetLog()
	{
		log = "";
	}

	public static function defaultLogFilters()
	{
		return {
			"LOG": true,
			"WARN": true,
			"ERROR": true,
			"CUSTOM": {
				"enabled": false,
				"id": ""
			}
		};
	}

	public static function setCurMenu(i:Menu) // i stands for instance
	{
		curMenuI = i;
	}

	public static function setCurSubMenu(i:SubMenu) // i stands for instance
	{
		curSubMenuI = i;
	}

	public static function addMenu(id:String, menu:Class<Menu>, ?setCurMenu:Bool = false)
	{
		menus.set(id, menu);
		if (curMenu == null)
		{
			curMenu = id;
		}
	}

	public static function addSubMenu(id:String, menu:Class<SubMenu>)
	{
		submenus.set(id, menu);
		// if (curSubMenu == null)
		// 	curSubMenu = id;
	}

	public static function switchMenu(menu:String, args:Array<Dynamic>)
	{
		// var cl = Type.getClass(menus[menu]); //! obviously does not work

		try
		{
			curMenuI = Type.createInstance(menus[menu], args);
			FlxG.switchState(curMenuI);
		}
		catch (e)
		{
			throw "menu \"" + menu + "\" does not exist, or has not been added yet.";
		}
		curMenu = menu;
		// FlxG.switchState(Type.createInstance(menus[menu], args));
	}

	public static function openSubMenu(menu:String, args:Array<Dynamic>)
	{
		// var cl = Type.getClass(menus[menu]); //! obviously does not work

		try
		{
			curSubMenuI = Type.createInstance(submenus[menu], args);
			FlxG.state.openSubState(curSubMenuI);
			trace(curMenuI);
			curMenuI.onSubMenuOpened();
		}
		catch (e)
		{
			throw "submenu \"" + menu + "\" does not exist, or has not been added yet.";
		}
		curSubMenu = menu;
		// FlxG.switchState(Type.createInstance(menus[menu], args));
	}

	public static function closeSubMenu()
	{
		FlxG.state.closeSubState();
		curSubMenu = null;
		curMenuI.onSubMenuClosed();
		// curSubMenuI = null;
	}


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

	public function set(minX, minY, maxX, maxY)
	{
		min = new FlxPoint(minX, minY);
		max = new FlxPoint(maxX, maxY);
	}

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

		interp = game.ScriptEnvironment.importClasses(script, interp);

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

		interp = game.ScriptEnvironment.importClasses(script, interp);

		return {
			script: script,
			parser: parser,
			program: program,
			interp: interp,
		};
	}
}