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
import settings.Settings.PlayerSettings;
import ui.dialogue.DialogueSubState;

class MainMenu extends NiceMenu
{
	public var solid:FlxSprite;
	public var bg:FlxSprite;

	// public var tri1:FlxSprite;
	// public var tri2:FlxSprite;
	// public var tri3:FlxSprite;
	public var grid:FlxSprite;

	public var gridMovement:Float = 1;
	public var lerpM:Float = 1;

	public var hueIdx:Int = 0;

	public function new()
	{
		super("main", MainMenu); // overrides niceID and niceMenu because this is a custom menu.
		menuItems = [
			"%main%play",
			// "%main%battle test",
			"%main%options",
			"%main%extras",
			"%main%debug",

			"%options%back",
			"%options%save data",
			"%options%quit",

			"%play%back",
			"%play%singleplayer",
			"%play%multiplayer",

			"%config%back",
			"%config%2 player",
			"%config%3 player", // ,"%config%4P"

			"%extras%back",
			"%extras%sound test",

			"%debug%back",
			"%debug%open\nDialogueSubState",
			"%debug%storage test"
		];
		themes = [
			"main" => [0xFFffffff, 0xFFffff00],
			"options" => [0xFF9facff, 0xffffffff],
			"play" => [0xFF9facff, 0xffffffff],
			"config" => [0xffff4646, 0xffffffff],
			"extras" => [0xff3ea14d, 0xffffffff],
			"debug" => [0xff8d3bf7, 0xffffffff]
		];
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

		grid = new FlxSprite(-400, -400).loadGraphic(Assets.getFile("images/menu/main/grid_full.png"));
		add(grid);
		grid.scrollFactor.set(0, 0);
		FlxG.sound.playMusic(Assets.mus("menu"));
		niceInit();
	}

	override public function changeID(newID:String)
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

	override public function selectOption(item:String)
	{
		switch (item)
		{
			case "%main%play":
				changeID("play");
				menu_confirm();
			case "%main%options":
				// hideMenu();
				// GameUtil.openSubMenu("options", []);
				changeID("options");
				menu_confirm(); // case "%main%battle test":
			case "%main%extras":
				// hideMenu();
				// GameUtil.openSubMenu("options", []);
				changeID("extras");
				menu_confirm(); // case "%main%battle test":
			// 	openSubState(new battle.BattleState());
			case "%options%quit":
				System.exit(0);
			case "%play%singleplayer":
				// do something
				GameUtil.players = 1;
				FlxG.switchState(new PlayState());
				menu_confirm();
			case "%play%multiplayer":
				// do something
				changeID("config");
				menu_confirm();
			case "%config%2 player":
				// do something
				GameUtil.players = 2;
				FlxG.switchState(new PlayState());
				menu_confirm();
			case "%config%3 player":
				// do something
				GameUtil.players = 3;
				FlxG.switchState(new PlayState());
				menu_confirm();
			case "%extras%sound test":
				// menu_error();
				menu_confirm();
				FlxG.switchState(new SoundTest());
			case "%options%save data":
				menu_error();
			case "%options%back" | "%play%back" | "%config%back" | "%extras%back" | "%debug%back":
				// do something
				changeID("main");
				menu_back();
			case "%main%debug":
				changeID("debug");
				menu_confirm();
			case "%debug%open\nDialogueSubState":
				openSubState(new ui.dialogue.DialogueSubState("base/test.json"));
			case "%debug%storage test":
				settings.Storage.test(new PlayerSettings(0));

		}
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

		niceUpdate();

		super.update(elapsed);
	}
}