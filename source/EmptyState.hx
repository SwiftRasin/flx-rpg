package;

class EmptyState extends flixel.FlxState
{
	override public function create()
	{
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		flixel.FlxG.switchState(new menu.MainMenu());
	}
}