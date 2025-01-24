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

class MainMenuOLD extends Menu
{
	public var menuItems:Array<String> = [
		"%main%play",
		// "%main%battle test",
		"%main%options",
		"%options%back",
		"%options%save data",
		"%options%quit",
		"%play%back",
		"%play%singleplayer",
		"%play%multiplayer",
		"%config%back",
		"%config%2 player",
		"%config%3 player" // ,"%config%4P"
	];
	public var curItems:Array<String> = [];
	public var menuTexts:Array<FlxText> = [];
	public var curID = "main";

	public var curItem:Int = 0;
	public var themes:Map<String, Array<FlxColor>> = [
		"main" => [0xFFffffff, 0xFFffff00],
		"options" => [0xFF9facff, 0xffffffff],
		"play" => [0xFF9facff, 0xffffffff],
		"config" => [0xffff4646, 0xffffffff]
	];

	// public var txt:FlxText;
	public var solid:FlxSprite;
	public var bg:FlxSprite;

	// public var tri1:FlxSprite;
	// public var tri2:FlxSprite;
	// public var tri3:FlxSprite;
	public var grid:FlxSprite;

	public var inSub:Bool = false;

	public var hueIdx:Int = 0;

	public var camTarget:FlxObject;

	public var gridMovement:Float = 1;
	public var lerpM:Float = 1;
	public var lerpTarget:FlxObject;

	public function new()
	{
		super("main"); // overrides the entryID because this is a custom menu.
		GameUtil.addMenu("main", MainMenu);
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
		solid = new FlxSprite(0, 0).makeGraphic(800, 800, 0xFFffffff);
		add(solid);
		solid.scrollFactor.set(0, 0);
		bg = new FlxSprite(0, 0).loadGraphic(Assets.getFile("images/menu/main/coolBG.png"));
		add(bg);
		bg.scrollFactor.set(0, 0);

		// tri1 = new FlxSprite(-200, -200).loadGraphic(Assets.getFile("images/menu/main/grid_tri.png"));
		// add(tri1);
		// tri1.scale.set(2, 2);
		// tri2 = new FlxSprite(200, 200).loadGraphic(Assets.getFile("images/menu/main/grid_tri.png"));
		// add(tri2);
		// tri2.scale.set(2, 2);
		// tri3 = new FlxSprite(600, 600).loadGraphic(Assets.getFile("images/menu/main/grid_tri.png"));
		// add(tri3);
		// tri3.scale.set(2, 2);
		grid = new FlxSprite(-400, -400).loadGraphic(Assets.getFile("images/menu/main/grid_full.png"));
		add(grid);
		grid.scrollFactor.set(0, 0);
		FlxG.sound.playMusic(Assets.mus("menu"));
		camTarget = new FlxObject(0, 0);
		add(camTarget);
		lerpTarget = new FlxObject(0, 0);
		add(lerpTarget);
		refresh();
		FlxG.camera.follow(camTarget);
	}

	override public function update(elapsed:Float)
	{
		hueIdx++;
		if (hueIdx > 359)
			hueIdx -= 359;
		bg.color = FlxColor.fromHSB(hueIdx, 1, 0.5, 1);
		gridMovement = FlxMath.lerp(gridMovement, lerpM, 0.02);
		grid.x += gridMovement;
		grid.y += gridMovement;
		if (gridMovement > 0)
		{
			if (grid.x >= 0)
			{
				grid.x -= 400;
				grid.y -= 400;
			}
		}
		if (gridMovement < 0)
		{
			if (grid.x <= -400)
			{
				grid.x += 400;
				grid.y += 400;
			}
		}

		// tri1.x += 1;
		// tri1.y += 1;
		// tri2.x += 1;
		// tri2.y += 1;
		// tri3.x += 1;
		// tri3.y += 1;
		// if (tri1.x >= 0)
		// {
		// 	tri1.x = -200;
		// 	tri1.y = -200;
		// 	tri2.x = 200;
		// 	tri2.y = 200;
		// 	tri3.x = 600;
		// 	tri3.y = 600;
		// }

		if (!inSub)
		{
			if (FlxG.keys.justPressed.UP)
				moveI(-1);
			if (FlxG.keys.justPressed.DOWN)
				moveI(1);
			if (FlxG.keys.justPressed.ENTER)
			{
				switch (curItems[curItem])
				{
					case "%main%play":
						changeID("play");
					case "%main%options":
						// hideMenu();
						// GameUtil.openSubMenu("options", []);
						changeID("options");
					// case "%main%battle test":
					// 	openSubState(new battle.BattleState());
					case "%options%quit":
						System.exit(0);
					case "%play%singleplayer":
						// do something
						GameUtil.players = 1;
						FlxG.switchState(new PlayState());
					case "%play%multiplayer":
						// do something
						changeID("config");
					case "%config%2 player":
						// do something
						GameUtil.players = 2;
						FlxG.switchState(new PlayState());
					case "%config%3 player":
						// do something
						GameUtil.players = 3;
						FlxG.switchState(new PlayState());
					case "%options%back" | "%play%back" | "%config%back":
						// do something
						changeID("main");
				}
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
	}

	public function changeID(newID:String)
	{
		curID = newID;
		if (curID == "main")
			lerpM = 1;
		else
			lerpM = -1;
		if (curID == "play")
			lerpM = 0;
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