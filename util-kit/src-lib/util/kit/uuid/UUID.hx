package util.kit.uuid;

import helper.kits.StringKit;

// Offset   0        9    14   19   24  28
// Offset+  +8       +4   +4   +4   +4  +8
// Part     P1       P2   P3   P4   P5  P6
// bits     32       16   16   16   16  32
// bytes    4        2    2    2    2   4       = 16 bytes
// UUID     00000000-0000-0000-0000-000000000000
// 36 chars
abstract UUID(String) {

    public var p1(get, set):Int;

    private function new(?hex:String) {
        if (hex == null) hex = '00000000000000000000000000000000';

        hex = hex.split("-").join("").toUpperCase();
        validate(hex);

        this = reformat(hex);
    }

    inline private function validate(value:String):Void if (!isValid(value)) throw "Invalid UUID format";

    static inline public function create():UUID return new UUID();
    static inline public function createRandom():UUID {
        return new UUID(StringKit.generateRandomHex(16));
    }

    @:to
    public function toString():String return reformat(this);
    
    @:from
    inline static public function fromString(value:String):UUID return new UUID(value);

    inline private function get_p1():Int {
        var hex:String = this.substr(0, 8);
        
        return Std.parseInt("0x" + hex);
    }

    inline private function set_p1(value:Int):Int {
        this = StringTools.hex(value, 8) + this.substring(8);
        return value;
    }
    
    static public function isValid(value:String):Bool {
        var r:EReg = new EReg('^[a-fA-F0-9]{32}$|^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$', '');
        return r.match(value);
    }

    inline private function reformat(value:String):String {
        var hex:String = value.split("-").join("").toUpperCase();

        return hex.substring(0, 8) + "-" + 
            hex.substring(8, 12) + "-" + 
            hex.substring(12, 16) + "-" + 
            hex.substring(16, 20) + "-" + 
            hex.substring(20, 32);
    }
}