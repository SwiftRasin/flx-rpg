package ui.dialogue;

import assets.Assets;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import haxe.Json;

class Portrait extends FlxTypedGroup<PortPart>
{
	public var port:String = "";
	public var rawData:String = "";
	public var portData:Dynamic;

	public var x:Float = 0;
	public var y:Float = 0;
	public var alpha:Float = 1;
	public var color:FlxColor = 0xFFffffff;

	public var state:String = "default";

	public var sound:String = "dia0.wav";

	public function new(port:String, state:String)
	{
		this.port = port;
		this.state = state;
		super();
		loadPort();
	}

	public function clean()
	{
		forEach(function(part:PortPart) // ?remove any pre-existing parts from this port.
		{
			part.destroy();
		});
		clear(); // ?clears the group juuuust to be sure everything is cleaned up.
	}

	public function loadPort(?newState:String)
	{
		var oldState = state;
		if (newState != null)
			state = newState;
		clean();
		rawData = Assets.getTxt(Assets.getPortData(port));
		portData = Json.parse(rawData);
		trace(Reflect.field(portData, state));
		for (i in 0...Reflect.field(portData, state).length)
		{
			var curData = Reflect.field(portData, state)[i];
			if (i > 0)
			{
				var part = new PortPart(x + curData.offset[0], y + curData.offset[1], curData.label, i);
				part.alpha = curData.alpha;
				// part.origin.set(0, 0);
				part.scale.set(curData.scale[0], curData.scale[1]);
				part.loadGraphic(Assets.getPortPart(port, curData.img));
				add(part);
			}
			else
			{
				sound = curData.sound;
			}
		}

		trace("portData: " + portData);
	}

	public function updatePort()
	{
		forEach(function(part:PortPart) // ?update the parts.
		{
			var curData = Reflect.field(portData, state)[part.partIdx];
			if (curData.colored)
				part.color = FlxColor.multiply(part.assignedColor, color);
			part.x = curData.offset[0] + x;
			part.y = curData.offset[1] + y;
			part.alpha = curData.alpha * alpha;
		});
	}

	override public function update(elapsed:Float)
	{
		updatePort();
		super.update(elapsed);
	}
}

class PortPart extends FlxSprite
{
	public var label:String;
	public var partIdx:Int;
	public var assignedColor:FlxColor;

	public function new(x:Float, y:Float, label:String, partIdx:Int, ?color:FlxColor)
	{
		super(x, y);
		this.label = label;
		this.partIdx = partIdx;
		if (color != null)
			assignColor(color);
	}

	public function assignColor(color:FlxColor)
	{
		assignedColor = color;
	}
}