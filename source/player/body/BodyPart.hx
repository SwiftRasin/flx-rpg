package player.body;

import flixel.FlxSprite;
import flixel.math.FlxPoint;


class BodyPart extends FlxSprite
{
    public var mOffset:FlxPoint;
    public var label:String;

    public var tweenType:String;
    public var tweenSpeed:Float;

    public var colored:Bool;

    public function new(x:Float,y:Float,label:String,?mOffset:FlxPoint, tweenType:String, tweenSpeed:Float)
    {
        this.tweenType = tweenType;
        this.tweenSpeed = tweenSpeed;
        if (mOffset == null)
            mOffset = new FlxPoint(0,0);
        else
            this.mOffset = mOffset;
        this.label = label;
        super(x,y);
    }

    override public function update(elapsed:Float)
    {
        offset = new FlxPoint(width / 2, height / 2);
        super.update(elapsed);
    }
}