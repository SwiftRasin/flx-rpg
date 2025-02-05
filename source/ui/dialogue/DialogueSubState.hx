package ui.dialogue;

import assets.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;
import ui.dialogue.Portrait;

using StringTools;

class DialogueSubState extends FlxSubState
{
	public var typeText:FlxText;
	public var dialogueBox:FlxSprite;
	public var ports:FlxTypedGroup<Portrait>;
	public var diaPath:String = "";
	public var dialogueData:Dynamic;
	public var diaIdx:Int = 0;
	public var content:String = "";
	public var skipped:Bool = false;
	public var typing:Bool = false;
	public var canSkip:Bool = true;

	public var onComplete:Void->Void;

	public function new(dialoguePath:String, ?onComplete:() -> Void)
	{
		super();
		this.onComplete = onComplete;
		initDialogue(dialoguePath);
	}

	public function initDialogue(diaPath)
	{
		this.diaPath = diaPath;
		var rawData = Assets.getTxt(Assets.getFile("data/dialogue/" + diaPath));
		dialogueData = Json.parse(rawData);
		ports = new FlxTypedGroup<Portrait>();
		add(ports);
		loadDialogue();
	}

	public function cleanUp()
	{
		ports.forEach(function(destroyThis:Portrait)
		{
			destroyThis.destroy();
		});
		ports.clear();
	}

	public function startTyping(diaConfig:Dynamic)
	{
		var iText = 0;
		var splitContent = content.split("");
		typing = true;
		new FlxTimer().start(diaConfig.textSpeed, function(tmr:FlxTimer)
		{
			canSkip = true;
			if (!skipped && typing)
			{
				typeText.text += splitContent[iText];
				var snd:String = ports.members[0].sound;
				FlxG.sound.play(Assets.snd("dialogue/" + snd));
				iText++;
				if (iText < splitContent.length)
					tmr.reset();
				else
					typing = false;
			}
		});
	}

	public function loadDialogue()
	{
		cleanUp();
		var thisConfig:Dynamic = dialogueData.text[diaIdx].config;
		// trace("dialogueData: " + dialogueData);
		// trace(dialogueData.text[0].ports[0]);
		var boxData:Dynamic = dialogueData.box;
		if (dialogueBox != null)
			remove(dialogueBox);
		if (typeText != null)
			remove(typeText);
		dialogueBox = new FlxSprite(boxData.position[0], boxData.position[1]);
		if (boxData.img != null || boxData.img != "")
			dialogueBox.loadGraphic(Assets.getUIImage("dialogue/" + boxData.img));
		dialogueBox.origin.set(0, 0);
		dialogueBox.scale.set(boxData.scale[0], boxData.scale[1]);
		if (boxData.transition != "none" && thisConfig.boxIn)
		{
			var trans:Dynamic = boxData.transition;
			if (trans._in != null)
			{
				var transIn:Dynamic = trans._in;
				switch (transIn.type)
				{
					case "fade":
						dialogueBox.alpha = 0;
						FlxTween.tween(dialogueBox, {alpha: 1}, transIn.duration, {
							type: ONESHOT,
							ease: Reflect.field(FlxEase, transIn.ease),
							startDelay: transIn.startDelay
						});
				}
			}
		}
		if (FlxG.cameras.list[1] != null)
			dialogueBox.cameras = [FlxG.cameras.list[1]];
		add(dialogueBox);
		var portData:Array<Dynamic> = dialogueData.text[diaIdx].ports;
		trace(portData);
		for (i in 0...portData.length)
		{
			var metaPort = portData[i];
			trace(metaPort);
			var port = new Portrait(metaPort.id, metaPort.state);
			if (!(Reflect.field(dialogueData.presets, Std.string(metaPort.position)) != null))
			{
				port.x = metaPort.position[0];
				port.y = metaPort.position[1];
			}
			else
			{
				var presetPos = Reflect.field(dialogueData.presets, Std.string(metaPort.position));
				trace(presetPos);
				port.x = presetPos[0];
				port.y = presetPos[1];
			}
			if (FlxG.cameras.list[1] != null)
				port.cameras = [FlxG.cameras.list[1]];
			ports.add(port);

			var finalColor:FlxColor;
			if (StringTools.startsWith(metaPort.color, "player"))
			{
				// if (Reflect.field(FlxG.state, "players") != null)
				// {
				var plrStuff = PlayState.getPlayer(Std.parseInt(metaPort.color.replace("player", "")));
				finalColor = plrStuff.getBasicColor();
				trace(finalColor);
				// }
			}
			else
			{
				finalColor = FlxColor.fromString(metaPort.color);
			}
			port.forEach(function(part:PortPart) // ?color each part.
			{
				part.assignColor(finalColor);
			});
			trace(port);
			var trans:Dynamic = metaPort.transition;
			if (trans != "none")
			{
				switch (trans.type)
				{
					case "fade":
						port.alpha = 0;
						FlxTween.tween(port, {alpha: 1}, trans.duration, {
							type: ONESHOT,
							ease: Reflect.field(FlxEase, trans.ease),
							startDelay: trans.startDelay
						});
				}
			}
		}

		var dialogueConfig:Dynamic = dialogueData.dialogueConfig;
		content = dialogueData.text[diaIdx].content;
		typeText = new FlxText(dialogueBox.x
			+ dialogueConfig.offset[0], dialogueBox.y
			+ dialogueConfig.offset[1],
			(dialogueBox.width * dialogueBox.scale.x)
			- dialogueConfig.offset[0]
			- dialogueConfig.padding, "", thisConfig.textSize);
		if (FlxG.cameras.list[1] != null)
			typeText.cameras = [FlxG.cameras.list[1]];
		typeText.font = Assets.getFile(thisConfig.textFont);
		add(typeText);
		startTyping(thisConfig);
	}

	public function nextText()
	{
		if (dialogueData.text[diaIdx + 1] != null)
		{
			diaIdx++;
			skipped = false;
			canSkip = false;
			loadDialogue();
		}
		else
		{
			var boxData:Dynamic = dialogueData.box;
			if (boxData.transition != "none" && (boxData.transition._out != null && boxData.transition._out != "none"))
			{
				var trans:Dynamic = boxData.transition;
				if (trans._out != null)
				{
					var transOut:Dynamic = trans._out;
					switch (transOut.type)
					{
						case "fade":
							dialogueBox.alpha = 1;
							FlxTween.tween(dialogueBox, {alpha: 0}, transOut.duration, {
								type: ONESHOT,
								ease: Reflect.field(FlxEase, transOut.ease),
								startDelay: transOut.startDelay,
								onComplete: function(twn:FlxTween)
								{
									cleanUp();

									FlxG.state.closeSubState();
									if (onComplete != null)
										onComplete();
								}
							});
							for (port in ports)
							{
								FlxTween.tween(port, {alpha: 0}, transOut.duration, {
									type: ONESHOT,
									ease: Reflect.field(FlxEase, transOut.ease),
									startDelay: transOut.startDelay
								});
							}
					}
				}
			}
			else
			{
				cleanUp();

				FlxG.state.closeSubState();
				if (onComplete != null)
					onComplete();
			}
		}
	}

	override public function update(elapsed:Float) // todo: change dialogue action key to P1's Action button
	{
		if (FlxG.keys.justPressed.ENTER && !typing)
		{
			nextText();
		}
		if (FlxG.keys.justPressed.ENTER && (typing && !skipped) && canSkip)
		{
			skipped = true;
			typing = false;
			typeText.text = content;
		}
		super.update(elapsed);
	}
}