package settings;

import battle.*;
import flixel.FlxBasic;
import player.*;

class WorldSettings
{
    public static var settings:Map<String, Setting> = [
        "PlayerBounding" => new Setting("Player Bounding", 
            "if the players are too far apart, stop them from moving away even more.",
            "this only fully works with 2 players.", [true]),
        "CoCamera" => new Setting("Co-op Camera", 
            "Camera's position is the average of all player's positions.",
            "", [true]),
        "ShowFPS" => new Setting("Show FPS", 
            "Text will appear in the top left corner displaying current framerate.",
            "", [false]),
        "ShowIntro" => new Setting("Play Title Sequence", 
            "Toggle whether or not to play the title sequence.",
            "", [true]),
        "PlayMusic" => new Setting("Play Music", 
            "Toggle whether or not to play music.",
            "", [true]),
    ];

    public function setValue(key:String, newValue:Dynamic)
    {
        settings[key].value = newValue;
    }

    public function getValue(key:String)
    {
        return settings[key].value;
    }

    public static function resetAllSettings()
    {
        for (s in settings)
        {
            s.value = s.def[0];
        }
    }

    public static function resetSetting(key:String)
    {
        settings[key].value = settings[key].def[0];
    }
}

class PlayerSettings extends FlxBasic
{
    public var player:Int;

    public var settings:Map<String, Setting> = [
        "Skin" => new Setting("Skin", 
            "The player's costume.",
            "", ["default"]),
        "Name" => new Setting("Name", 
            "The player's.. name.",
            "", ["Blue"]),
        "Controls" => new Setting("Controls", 
            "The player's keybinds / inputs.",
            "", [new PlayerControls(0),new PlayerControls(1),new PlayerControls(2),new PlayerControls(3)]),
        "Color" => new Setting("Color", 
            "The color of your player.. not much to say here.",
            "", [new PlayerColor(0),new PlayerColor(1),new PlayerColor(2),new PlayerColor(3)]),
        "AccuratePixels" => new Setting("Retro Look", 
            "Animations are blockier, giving a nice retro look.",
            "", [false]),
        "Inventory" => new Setting("Inventory", 
            "The player's inventory.",
            "", [false]),
        "Stats" => new Setting("Stats", 
            "The player's stats.",
            "", [{
                atk: 25, 
                def: 50, 
                sp: 50, 
                hp: 200, 
                maxHP: 200, 
                maxSP: 50
            }], {editable: false, hidden: true}),
        "Moveset" => new Setting("Moveset", 
            "The player's abilities.",
            "", [BattleUtil.createMoveset([BattleUtil.createMove("Punch", Rough, 10, 0), BattleUtil.createMove("Cosmic Kick", Magic, 25, 10)])], {editable: false, hidden: true}),
    
    ];  

    public function setValue(key:String, newValue:Dynamic)
    {
        settings[key].value = newValue;
    }

    public function getValue(key:String)
    {
        return settings[key].value;
    }

    public function resetAllSettings()
    {
        for (s in settings)
        {
            var i = player;
            if (s.def[i] == null)
                i = 0;
            s.value = s.def[i];
        }
    }

    public function resetSetting(key:String)
    {
        var i = player;
        if (settings[key].def[i] == null)
            i = 0;
        settings[key].value = settings[key].def[i];
    }

    public function new(player:Int)
    {
        this.player = player;
        super();
    }
}

class Setting
{
    public var name:String;
    public var desc:String;
    public var note:String;
    public var value:Dynamic;
    public var def:Array<Dynamic>;
    public var params:Params;

    public function new(name:String,desc:String,note:String,def:Array<Dynamic>, ?params:Params)
    {
        this.name = name;
        this.desc = desc;
        this.note = note;
        //this.value = value;
        this.def = def;
        if (params != null)
            this.params = params;
        else
            this.params = {editable: true, hidden: false};
    }
}

typedef Params = {
    editable: Bool,
    hidden: Bool
}