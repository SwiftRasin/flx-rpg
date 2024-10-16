package battle;

import flixel.FlxBasic;

class BattleUtil
{
    public static function createMove(name:String,type:MoveType,damage:Float,sp:Float)
    {
        var m:Move = {name: name,type: type,damage: damage,sp: sp};

        return m;
    }

    public static function createMoveset(moves:Array<Move>)
    {
        return new Moveset(moves);
    }
}

class Moveset extends FlxBasic
{
    public function new(moves:Array<Move>)
    {
        super();
    }
}

enum MoveType
{
    Rough; //Rough; Physical; it's like a punch, or kick or whatever.
    Magic; //Magic; Wizardry; it's like a special move that costs sp.
}

typedef Move =
{
    name: String, //NAME OF MOVE
    type: MoveType, //MOVE TYPE
    damage: Float, //DAMAGE
    sp: Float //SP COST
}