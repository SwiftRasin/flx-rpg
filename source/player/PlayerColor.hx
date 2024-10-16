package player;

import flixel.FlxBasic;
import flixel.util.FlxColor;

class PlayerColor extends FlxBasic
{
    public var basic:FlxColor;

    public static var presetBasicColors:Array<FlxColor> = [
        0xFF6cbee7, 0xFFdb6ce7, 0xFF74e76c, 0xFF8f6ce7
    ];

	public function new(?preset:Int, ?color:FlxColor)
	{
		super();
        if (preset != null && color == null)
        {
            pColor(preset);
        }
        if (color != null)
            basic = color;

	}

    public function pColor(preset:Int)
    {
        switch (preset)
        {
            case 0|1|2|3:
                basic = PlayerColor.presetBasicColors[preset];
        }
    }

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	//
}