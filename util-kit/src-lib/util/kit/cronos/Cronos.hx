package util.kit.cronos;

import haxe.Timer;

abstract Cronos(Int) from Int to Int {
    
    public function new() {
        this = Math.floor(Timer.stamp() * 1000);
    }

    static public function start():Cronos return new Cronos();

    public function elapsed():Int {
        return Math.floor(Timer.stamp() * 1000) - this;
    }
    
}