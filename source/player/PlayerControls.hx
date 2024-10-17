package player;

import flixel.FlxBasic;
import flixel.input.keyboard.*;

class PlayerControls extends FlxBasic
{
	public var binds:Map<Input, Int> = [
		Input.UP => FlxKey.NONE, Input.DOWN => FlxKey.NONE, Input.LEFT => FlxKey.NONE, Input.RIGHT => FlxKey.NONE, 
		Input.ACTION => FlxKey.NONE, Input.ACTION2 => FlxKey.NONE, Input.PAUSE => FlxKey.NONE, Input.CONFIRM => FlxKey.NONE
	];

	public var player:Int;

	public function getBind(bind:Input):FlxKey
	{
		return binds[bind];
	}

	function cloneFrom_p(controls:PlayerControls, ?clonePlayer:Bool = false)
	{
		binds = controls.binds;
		if (clonePlayer)
			player = controls.player;
	}

	function cloneFrom(controls:PlayerControls, ?clonePlayer:Bool = false)
	{
		binds = controls.binds;
		if (clonePlayer)
			player = controls.player;
	}

	public function rebind(control:Input, newBind:Int)
	{
		binds[control] = newBind;
	}

	public function bindAllDefaults(preset:Int)
	{
		switch (preset)
		{
			case -1:
				player = -1;
			default:
				player = 0;
				rebind(Input.UP, FlxKey.UP);
				rebind(Input.DOWN, FlxKey.DOWN);
				rebind(Input.LEFT, FlxKey.LEFT);
				rebind(Input.RIGHT, FlxKey.RIGHT);

				rebind(Input.ACTION, FlxKey.Z);
				rebind(Input.ACTION2, FlxKey.X);
				rebind(Input.INTERACT, FlxKey.C);

				rebind(Input.PAUSE, FlxKey.BACKSPACE);
				rebind(Input.CONFIRM, FlxKey.ENTER);
			case 1:
				player = 1;
				rebind(Input.UP, FlxKey.W);
				rebind(Input.DOWN, FlxKey.S);
				rebind(Input.LEFT, FlxKey.A);
				rebind(Input.RIGHT, FlxKey.D);

				rebind(Input.ACTION, FlxKey.ENTER);
				rebind(Input.ACTION2, FlxKey.SHIFT);
				rebind(Input.INTERACT, FlxKey.CONTROL);

				rebind(Input.PAUSE, FlxKey.BACKSPACE);
				rebind(Input.CONFIRM, FlxKey.ENTER);
			case 2:
				player = 2;
				rebind(Input.UP, FlxKey.I);
				rebind(Input.DOWN, FlxKey.K);
				rebind(Input.LEFT, FlxKey.J);
				rebind(Input.RIGHT, FlxKey.L);

				rebind(Input.ACTION, FlxKey.ONE);
				rebind(Input.ACTION2, FlxKey.TWO);
				rebind(Input.INTERACT, FlxKey.THREE);

				rebind(Input.PAUSE, FlxKey.BACKSPACE);
				rebind(Input.CONFIRM, FlxKey.ENTER);
			case 3:
				player = 3;
				rebind(Input.UP, FlxKey.T);
				rebind(Input.DOWN, FlxKey.G);
				rebind(Input.LEFT, FlxKey.F);
				rebind(Input.RIGHT, FlxKey.H);

				rebind(Input.ACTION, FlxKey.EIGHT);
				rebind(Input.ACTION2, FlxKey.NINE);
				rebind(Input.INTERACT, FlxKey.ZERO);

				rebind(Input.PAUSE, FlxKey.BACKSPACE);
				rebind(Input.CONFIRM, FlxKey.ENTER);
		}
		
	}

	public function new(?preset:Int, ?defaultControls:PlayerControls, ?clonePlayer:Bool = false)
	{
		super();

		//instance = this;

		if (defaultControls != null)
		{
			cloneFrom_p(defaultControls, clonePlayer);
		}
		else
		{
			bindAllDefaults(preset);
		}
	}

	//function cloneFrom(defaultControls:Null<PlayerControls>) {}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	//
}

enum Input {

	//PLAYER;

	UP;
	DOWN;
	LEFT;
	RIGHT;

	ACTION;
	ACTION2;
	INTERACT;

	PAUSE;
	CONFIRM;
}
