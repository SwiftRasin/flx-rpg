package game;

import assets.Assets;
import haxe.Json;
import polymod.Polymod;
import polymod.Polymod;

class ModUtil
{
	public static var loadedMods:Array<String> = [];

	public static function init()
	{
		Polymod.init({
			modRoot: "./mods",
			dirs: []
		});
		var modsList:Dynamic = Json.parse(Assets.getTxt("mods/modsList.json"));
		var mods:Array<Dynamic> = modsList.mods;
		for (mod in mods)
		{
			trace("found " + (mod.enabled ? "enabled" : "disabled") + " mod: " + "\"" + mod.name + "\"");
			/* example, in this case there is a mod called "testMod" which is enabled
				source/Main.hx:25: found enabled mod: "testMod"
			 */
			if (mod.enabled)
				loadedMods.push(mod.name);
		}
		if (mods == [])
			trace("no mods found :(");

		loadMods();
	}

	public static function loadMods(?modsList:Array<String>)
	{
		if (modsList == null)
			modsList = loadedMods;
		// trace(modsList);
		// trace(Main.loadedMods);
		Polymod.unloadAllMods();
		Polymod.loadOnlyMods(modsList);
	}
}