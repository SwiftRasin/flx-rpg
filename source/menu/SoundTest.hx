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

using StringTools;

class SoundTest extends NiceMenu
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
		super("sound_test", SoundTest); // overrides niceID and niceMenu because this is a custom menu.
		menuItems = [
			"%main%back",
			"%main%sounds",
			"%main%music",
			"%sound%back",
			"%sound%menu_confirm",
			"%sound%menu_back",
			"%sound%menu_error",
			"%sound%menu_select",
			"%sound%menu_enter",
			"%sound%bump",
			"%sound%marimba",
			"%sound%marimba_hq",
			"%sound%win_tune1",
			"%sound%win_tune2",
			"%music%back",
			"%music%stop music",
			"%music%battle",
			"%music%battle-boss-1_1-lq",
			"%music%battle-boss-1_2-lq",
			"%music%choice",
			"%music%drums_easy",
			"%music%drums_test",
			"%music%menu",
			"%music%scary",
			"%music%scary-stem_cloudy",
			"%music%scary-stem_sticks",
			"%music%shop theme",
			"%music%shop-lq",
		];

		themes = [
			"main" => [0xFFffffff, 0xFFffff00],
			"sound" => [0xffc02323, 0xffff8b8b],
			"music" => [0xff234fc0, 0xffa4eeff],
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
		// FlxG.sound.playMusic(Assets.mus("menu"));
		FlxG.sound.music.stop();
		niceInit();
	}

	override public function changeID(newID:String)
	{
		curID = newID;
		if (curID == "main")
			lerpM = 1;
		else
			lerpM = -1;
		curItem = 0;
		refresh();
	}

	override public function selectOption(item:String)
	{
		switch (item)
		{
			case "%main%sounds":
				changeID("sound");
				menu_confirm();
			case "%main%music":
				changeID("music");
				menu_confirm();
			case "%main%back":
				menu_confirm();
				FlxG.switchState(new MainMenu());
			case "%music%back" | "%sound%back":
				menu_back();
				changeID("main");
			case "%music%stop music":
				FlxG.sound.music.stop();
			default:
				if (item.startsWith("%m"))
				{
					FlxG.sound.music.stop();
					FlxG.sound.playMusic(Assets.mus(item.replace("%music%", "")));
				}
				if (item.startsWith("%s"))
				{
					FlxG.sound.play(Assets.snd(item.replace("%sound%", "")));
				}
		}
	}

	override public function update(elapsed:Float)
	{
		hueIdx++;
		if (hueIdx > 359)
			hueIdx -= 359;
		bg.color = FlxColor.fromHSB(hueIdx, 1, 0.25, 1);
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