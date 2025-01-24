package menu;

import assets.Assets;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import game.GameUtil;
import lime.system.System;

class NiceMenu extends Menu
{
	public var menuItems:Array<String> = ["%main%option0", "%main%option1", "%main%option2",];
	public var curItems:Array<String> = [];
	public var menuTexts:Array<FlxText> = [];
	public var curID = "main";

	public var curItem:Int = 0;
	public var themes:Map<String, Array<FlxColor>> = ["main" => [0xFFffffff, 0xFFffff00]];

	public var inSub:Bool = false;

	public var camTarget:FlxObject;

	public var lerpTarget:FlxObject;

	public var sounds:Bool = true;

	public function new(niceID:String, niceMenu:Class<Menu>)
	{
		super(niceID); // overrides the entryID because this is a NICE menu
		GameUtil.addMenu(niceID, niceMenu);
		GameUtil.setCurMenu(this);
		// GameUtil.addSubMenu("options", OptionsMenu);
		// trace(GameUtil.menus);

		// txt = new FlxText(0, 0, 0, "text test", 64, true);
		// txt.font = Assets.getFile("fonts/futura-pt-bold.ttf");
		// txt.screenCenter();
		// add(txt);

		persistentDraw = true;
		persistentUpdate = true;
	}

	override public function create()
	{
		super.create();
		// niceInit();
	}

	public function niceInit()
	{
		camTarget = new FlxObject(0, 0);
		add(camTarget);
		lerpTarget = new FlxObject(0, 0);
		add(lerpTarget);
		refresh();
		FlxG.camera.follow(camTarget);
	}

	public function selectOption(item:String)
	{
		switch (item)
		{
			case "%main%option0":
				// do whatever
		}
	}

	public function niceUpdate()
	{
		if (!inSub)
		{
			if (FlxG.keys.justPressed.UP)
				moveI(-1);
			if (FlxG.keys.justPressed.DOWN)
				moveI(1);
			if (FlxG.keys.justPressed.ENTER)
			{
				selectOption(curItems[curItem]);
			}
		}
		// FlxG.camera.x = FlxMath.lerp(FlxG.camera.x, camTarget.x, 0.5);
		// FlxG.camera.y = FlxMath.lerp(camTarget.y, FlxG.camera.y, 0.5);

		if (!inSub)
		{
			lerpTarget.x = FlxMath.lerp(lerpTarget.x, menuTexts[curItem].x + (menuTexts[curItem].width / 2), 0.5);
			lerpTarget.y = FlxMath.lerp(lerpTarget.y, menuTexts[curItem].y + (menuTexts[curItem].height / 2), 0.5);
			camTarget.x = FlxMath.lerp(camTarget.x, lerpTarget.x, 0.1);
			camTarget.y = FlxMath.lerp(camTarget.y, lerpTarget.y, 0.1);
		}
	}

	override public function update(elapsed:Float)
	{
		// niceUpdate();
		super.update(elapsed);
	}

	public function moveI(amt:Int)
	{
		menuTexts[curItem].color = themes[curID][0];
		curItem += amt;
		if (curItem < 0)
			curItem = menuTexts.length - 1;
		if (curItem > menuTexts.length - 1)
			curItem = 0;

		menuTexts[curItem].color = themes[curID][1];
		if (sounds)
			FlxG.sound.play(Assets.snd("menu_select"));
	}

	public function menu_back()
	{
		FlxG.sound.play(Assets.snd("menu_back"));
	}

	public function menu_error()
	{
		FlxG.sound.play(Assets.snd("menu_error"));
	}

	public function menu_confirm()
	{
		FlxG.sound.play(Assets.snd("menu_confirm"));
	}

	public function changeID(newID:String)
	{
		curID = newID;
		curItem = 0;
		refresh();
	}

	public function hideMenu()
	{
		for (i in menuTexts)
			i.destroy();
		menuTexts = [];
	}

	public function refresh()
	{
		for (i in menuTexts)
			i.destroy();
		menuTexts = [];
		curItems = [];
		var scrollIdx:Int = -1;
		for (i in 0...menuItems.length)
		{
			var finalItemName:String = "";
			var splitChars:Array<String> = menuItems[i].split("");
			var inID:Bool = false;
			var itemID:String = "";
			for (i in 0...splitChars.length)
				/*splits characters up into itemID and finalItemName. 
					For example, //*"%main%hello" will result with itemID "main", and finalItemName "hello".
				 */
			{
				var char = splitChars[i];
				if (char == "%" && inID == false)
				{
					inID = true;
					continue;
				}
				if (char == "%" && inID == true)
				{
					inID = false;
					continue;
				}
				if (inID)
					itemID = itemID + char;
				else
					finalItemName = finalItemName + char;
			}
			trace(itemID);
			trace(finalItemName);
			if (itemID == curID)
			{
				scrollIdx++;
				curItems.push(menuItems[i]);
			}
			else
				continue;
			var txt = new FlxText(0, 0, 0, finalItemName, 100, true);
			txt.font = Assets.getFile("fonts/futura-pt-bold.ttf");
			txt.screenCenter();
			txt.y = (250 * scrollIdx) + 30;
			add(txt);
			trace(txt);
			txt.color = themes[curID][0];
			// if (curID == "options")
			// 	txt.color = 0xff9facff;
			// else
			// 	txt.color = 0xffffffff;
			menuTexts.push(txt);
		}
		menuTexts[curItem].color = themes[curID][1];
		trace(curItems);
		// trace(camTarget);
	}

	override public function onSubMenuClosed()
	{
		inSub = false;
		refresh();
	}

	override public function onSubMenuOpened()
	{
		inSub = true;
		hideMenu();
	}
}