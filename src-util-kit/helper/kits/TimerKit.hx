package helper.kits;

import haxe.Timer;
import haxe.ds.StringMap;

class TimerKit {

    static private var TIMERS:StringMap<Timer>;

    static public function delay(key:String, timeMS:Int, callback:Void->Void):Void {
        validateTimers();
        kill(key);

        var t:Timer = Timer.delay(runCallback.bind(key, callback), timeMS);
        TIMERS.set(key, t);
    }

    static public function kill(key:String):Void {
        validateTimers();
        if (TIMERS.exists(key)) {
            var t:Timer = TIMERS.get(key);
            t.stop();
            t.run = null;
            TIMERS.remove(key);
        }
    }

    static private function runCallback(key:String, callback:Void->Void):Void {
        validateTimers();
        if (TIMERS.exists(key)) {
            kill(key);
            callback();
        }
    }

    static private function validateTimers():Void if (TIMERS == null) TIMERS = new StringMap<Timer>();

}