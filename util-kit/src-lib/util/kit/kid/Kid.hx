package util.kit.kid;

import helper.kits.StringKit;

// Key Id
// Key Part + Id Part

// 32 random hex chars (16 bytes)
// 8  hex chars for id
// KID = 00000000000000000000000000000000-000000

abstract Kid(String) {

    static private inline var ID_LENGTH:Int = 8;
    static private inline var KEY_LENGTH:Int = 32;

    public var id(get, set):Int;
    public var key(get, set):String;
    
    public function new(?id:Int, ?key:String) {
        if (id == null) id = 0;
        var key:String = key == null ? StringKit.generateRandomHex(KEY_LENGTH >> 1).toUpperCase() : key.toUpperCase();
        this = key + "-" + decToHex(id);
    }

    inline private function hexToDec(hex:String):Int return Std.parseInt("0x" + hex);
    inline private function decToHex(dec:Int):String return StringTools.hex(dec, ID_LENGTH);

    @:to
    inline public function toString():String return this;

    @:from
    inline static public function fromString(value:String):Kid return cast value;

    inline private function getIdHex():String {
        if (!isValid(this)) return '00000000';
        return this.substr(KEY_LENGTH + 1, ID_LENGTH);
    }

    inline private function get_id():Int {
        if (!isValid(this)) return 0;
        return hexToDec(this.substr(KEY_LENGTH + 1, ID_LENGTH));
    }

    inline private function set_id(value:Int):Int {
        this = get_key() + '-' + decToHex(value);
        return value;
    }

    inline private function get_key():String {
        if (!isValid(this)) return '00000000000000000000000000000000';
        return this.substr(0, KEY_LENGTH);
    }

    inline private function set_key(value:String):String {
        this = value + '-' + getIdHex();
        return value;
    }

    static public function isValid(value:String):Bool {
        var r:EReg = new EReg('^[a-fA-F0-9]{${KEY_LENGTH}}-[a-fA-F0-9]{${ID_LENGTH}}$', '');
        return r.match(value);
    }

}