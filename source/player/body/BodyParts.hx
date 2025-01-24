package player.body;

import flixel.group.FlxGroup.FlxTypedGroup;

class BodyParts extends FlxTypedGroup<BodyPart>
{
	public function getPart(label:String, ?first:Bool = true):BodyPart // finds the first, or last, instance of a body part labeled the string label
	{
		var thePart:BodyPart = null;
		var keepLooking:Bool = true;
		forEach(function(part:BodyPart)
		{
			if (keepLooking && part.label == label)
				thePart = part;
			if (first && thePart != null)
				keepLooking = false;
		});
		return thePart; // returns the found body part.
	}

	public function getParts(label:String):Array<BodyPart> // finds all instances of body parts labeled the string label
	{
		var theParts:Array<BodyPart> = [];
		forEach(function(part:BodyPart)
		{
			if (part.label == label)
				theParts.push(part);
		});
		return theParts; // returns an array of the found body parts.
	}
}