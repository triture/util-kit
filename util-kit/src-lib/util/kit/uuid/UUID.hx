package util.kit.uuid;

import helper.kits.StringKit;
import haxe.io.Encoding;
import haxe.io.Bytes;

// Offset   0        8    12   16   20  24
// Offset+  +8       +4   +4   +4   +4  +8
// Part     P1       P2   P3   P4   P5  P6
// bits     32       16   16   16   16  32
// bytes    4        2    2    2    2   4       = 16 bytes
// UUID     00000000 0000 0000 0000 000000000000
abstract UUID(Bytes) {

    public var p1(get, set):Int;

    inline private function new(?hex:String) {
        if (hex == null) {
            this = Bytes.alloc(16);
            this.fill(0, 16, 0);
        } else {
            hex = hex.split("-").join("").toUpperCase();
            if (hex.length != 32) throw "Invalid UUID format";
            
            this = Bytes.ofHex(hex);
        }
    }

    static inline public function create():UUID return new UUID();
    static inline public function createRandom():UUID return new UUID(StringKit.generateRandomHex(16));

    @:to
    public function toString():String {
        var hex:String = this.toHex().toUpperCase();
        
        var result:String = 
            hex.substring(0, 8) + "-" + 
            hex.substring(8, 12) + "-" + 
            hex.substring(12, 16) + "-" + 
            hex.substring(16, 20) + "-" + 
            hex.substring(20, 32);
        
        return result;
    }

    @:from
    inline static public function fromString(value:String):UUID return new UUID(value);

    inline private function get_p1():Int return this.getInt32(0);
    inline private function set_p1(value:Int):Int {
        this.setInt32(0, value);
        return value;
    }
}