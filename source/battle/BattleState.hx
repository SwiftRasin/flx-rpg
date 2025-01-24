package battle;

import assets.Assets;
import flixel.group.FlxGroup.FlxTypedGroup;
import state.State;

class BattleState extends SubState
{
	public var battleStats:FlxTypedGroup<BattleStat>;

	public function new()
	{
		super();
		battleStats = new FlxTypedGroup<BattleStat>();
		add(battleStats);

		addStat(50, 250, Assets.getFile("images/battle/battle_atk.png"));
		addStat(100, 250, Assets.getFile("images/battle/battle_def.png"));

		trace("uhh hello? we're BATTLING NOW");
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function addStat(x:Float, y:Float, graphic:String)
	{
		var st = new BattleStat(x, y, graphic);
		battleStats.add(st);
	}
}