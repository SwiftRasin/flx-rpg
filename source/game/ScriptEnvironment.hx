package game;

import flixel.*;
import flixel.animation.*;
import flixel.effects.*;
import flixel.effects.particles.*;
import flixel.effects.postprocess.*;
import flixel.graphics.*;
import flixel.group.*;
import flixel.input.*;
import flixel.math.*;
import flixel.path.*;
import flixel.sound.*;
import flixel.system.*;
import flixel.system.debug.*;
import flixel.system.debug.completion.*;
import flixel.system.debug.console.*;
import flixel.system.debug.interaction.*;
import flixel.system.debug.interaction.tools.*;
import flixel.system.debug.log.*;
import flixel.system.debug.stats.*;
import flixel.system.debug.watch.*;
import flixel.system.frontEnds.*;
import flixel.system.replay.*;
import flixel.system.scaleModes.*;
import flixel.system.ui.*;
import flixel.text.*;
import flixel.tile.*;
import flixel.tweens.*;
import flixel.tweens.misc.*;
import flixel.tweens.motion.*;
import flixel.ui.*;
import flixel.util.*;
import flixel.util.helpers.*;
import flixel.util.typeLimit.*;
import game.GameUtil.ScriptUtil;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.ui.RuntimeComponentBuilder;
import haxe.ui.Toolkit;
import haxe.ui.core.Component;
import haxe.ui.themes.Theme;
import haxe.ui.tooltips.ToolTipManager;
import hscript.Expr;
import hscript.Interp;
import openfl.*;
import settings.Settings;

using StringTools;

class ScriptEnvironment
{
	public static function run(interp:Interp, program:Expr)
	{
		interp.execute(program);
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
			if (StringTools.contains(line, "haxe.macro")) // I haven't blacklisted any other packages/classes yet.
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