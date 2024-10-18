package player;

import assets.Assets;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import game.GameUtil;
import player.PlayerColor;
import player.PlayerControls;
import player.body.*;
import settings.Settings;


class Player extends FlxObject
{

	//public var controls:PlayerControls;

	//public var color:PlayerColor;

	public var settings:PlayerSettings;

	public var scale:Float = 1;

	public var bodyParts:BodyParts;

	public var movementSettings:Map<String, Float> = ["def" => 1, "ice" => 0.3];
	public var frictionSettings:Map<String, Float> = ["def" => 0.7, "ice" => 0.95];

	public var speed:Float;

	public var friction:Float;

	public var vel:FlxPoint;

	public function new(?settings:PlayerSettings, index:Int, x:Float, y:Float, color:PlayerColor, name:String, controls:PlayerControls, skin:String)
	{
		vel = new FlxPoint(0,0);
		speed = movementSettings["def"];
		friction = frictionSettings["def"];
		this.settings = new PlayerSettings(index);
		this.settings.resetAllSettings();
		bodyParts = new BodyParts();
		FlxG.state.add(bodyParts);

		if (settings != null)
			this.settings = settings;
		else
			initSettings(index,color,name,controls,skin);
		super(x,y);
		initPlayer();
	}

	function initSettings(index:Int, color:PlayerColor, name:String, controls:PlayerControls, skin:String)
	{
		settings.player = index;
		settings.setValue("Name",name);
		settings.setValue("Color",color);
		settings.setValue("Controls",controls);
		settings.setValue("Skin",skin);
		trace(settings);
	}

	public function getControl(bind:PlayerControls.Input)
	{
		return settings.settings["Controls"].value.getBind(bind);
	}

	public function changeCostume(newCostume:String)
	{
		settings.settings["Skin"].value = newCostume;
		initPlayer();
	}

	public function initPlayer()
	{
		if (bodyParts.members.length > 0)
		{
			bodyParts.forEach(function(i:BodyPart){
				i.destroy();
			},false);
		}
		trace(Assets.getSkinData(settings.getValue("Skin")));
		var properties = haxe.Json.parse(Assets.getTxt(Assets.getSkinData(settings.getValue("Skin"))));
		trace(properties);
		var propKeys = Reflect.fields(properties);

		for (key in propKeys)
		{
			var p = Reflect.field(properties, key);
			if (p != null && p.offset != null && p.offset.length == 2 && p.tweening != null) {
				var prop:BodyPart = new BodyPart(
					p.offset[0], 
					p.offset[1], 
					p.label, 
					new FlxPoint(p.offset[0], p.offset[1]), 
					p.tweening.type, 
					p.tweening.speed
				);
				prop.loadGraphic(Assets.getBodyPart(settings.getValue("Skin"), p.img));
				prop.colored = p.colored;
				prop.alpha = p.alpha;
				if (p.flipped)
					prop.flipX = p.flipped;
				bodyParts.add(prop);
			}
		}

		// var shadow:BodyPart = new BodyPart(x, y + 20, "shadow", new FlxPoint(0, 20), "sin", 0);
		// shadow.loadGraphic(Assets.getBodyPart(settings.getValue("Skin"), "shadow.png"));
		// bodyParts.add(shadow);
		// var head:BodyPart = new BodyPart(x,y - 21, "head", new FlxPoint(0,-21), "sin", 1);
		// head.loadGraphic(Assets.getBodyPart(settings.getValue("Skin"),"head.png"));
		// bodyParts.add(head);
		// var body:BodyPart = new BodyPart(x,y, "body", new FlxPoint(0,0), "sin", 0.5);
		// body.loadGraphic(Assets.getBodyPart(settings.getValue("Skin"),"body.png"));
		// bodyParts.add(body);
		// var left_hand:BodyPart = new BodyPart(x+15,y, "hand_left", new FlxPoint(15,0), "cos", 0.75);
		// left_hand.loadGraphic(Assets.getBodyPart(settings.getValue("Skin"),"hand.png"));
		// bodyParts.add(left_hand);
		// var right_hand:BodyPart = new BodyPart(x-15,y, "hand_right", new FlxPoint(-15,0), "cos", 0.75);
		// right_hand.loadGraphic(Assets.getBodyPart(settings.getValue("Skin"),"hand.png"));
		// bodyParts.add(right_hand);
	}


	public function updateBody()
	{
		bodyParts.forEach(function(part:BodyPart){
			var extraOffset:Float = 0;

			part.antialiasing = false;

			//if (part.label != "shadow") {
			if (part.colored)
				part.color = settings.settings["Color"].value.basic;
			extraOffset = GameUtil.getWavy(0 ,part.tweenType, 1, part.tweenSpeed);
			//}

			part.x = x + part.mOffset.x;
			part.y = y + part.mOffset.y + extraOffset;
			part.visible = true;
			if (!visible)
				part.visible = false;
		},false);
	}

	override public function update(elapsed:Float)
	{
		updateBody();
		//drag.x = friction;
		//drag.y = friction;
		if (Math.abs(vel.x) < 0.05)
			vel.x = 0;
		if (Math.abs(vel.y) < 0.05)
			vel.y = 0;

		x += vel.x;
		y += vel.y;
		

		x = Math.round(x*100)/100;
		y = Math.round(y*100)/100;

		vel.x *= friction;
		vel.y *= friction;
		super.update(elapsed);
	}
}
