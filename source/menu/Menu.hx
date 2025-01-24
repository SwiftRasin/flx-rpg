package menu;

import flixel.FlxState;
import flixel.FlxSubState;
import game.GameUtil;

class Menu extends FlxState
{
	public var menuID:String = "";

	public function new(menuID:String)
	{
		// game.ModUtil.loadMods();
		super();
		this.menuID = menuID;
	}

	public function onSubMenuClosed()
	{
		//
	}

	public function onSubMenuOpened()
	{
		//
	}
}

class SubMenu extends FlxSubState
{
	public var menuID:String = "";

	public function new(menuID:String)
	{
		// game.ModUtil.loadMods();
		super();
		this.menuID = menuID;
	}
}