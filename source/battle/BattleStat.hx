package battle;

import assets.Assets;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

class BattleStat extends FlxObject
{
	public var value:String = "<value>";

	public var valueText:FlxText;

	public var spr:FlxSprite;

	public function new(x:Float, y:Float, graphic:String)
	{
		super(x, y);
		spr = new FlxSprite(0, 0).loadGraphic(graphic);
		spr.scale.set(2, 2);
		FlxG.state.add(spr);
		valueText = new FlxText(0, 0, 0, value, 8, true);
		valueText.font = Assets.getFile("fonts/futura-pt-bold.ttf");
		FlxG.state.add(valueText);
	}

	override public function update(elapsed:Float)
	{
		spr.x = x - spr.width / 2;
		spr.y = y - spr.height / 2;
		//
		valueText.text = value;
		valueText.x = spr.x + spr.width + valueText.width / 2;
		valueText.y = spr.y + spr.height + valueText.height;
		//
		super.update(elapsed);
	}

	override public function destroy()
	{
		spr.destroy();
		valueText.destroy();
		super.destroy();
	}
}