package helper.kits;

import haxe.ds.StringMap;

class DebuggerKit {

    static private var TIMERS:StringMap<Float>;

    static public function timeTrack(key:String, remove:Bool = false):Void {
        #if production
        return;
        #end

        if (TIMERS == null) TIMERS = new StringMap<Float>();

        if (TIMERS.exists(key)) {
            var diff:Float = (getCurrTime() - TIMERS.get(key))/1000;
            #if js
            js.Browser.console.log('--- ${key} : ${NumberKit.maxDecimal(diff, 2)}');
            #else
            trace('--- ${key} : ${NumberKit.maxDecimal(diff, 2)}');
            #end
        }

        if (remove) TIMERS.remove(key);
        else TIMERS.set(key, getCurrTime());
    }

    private static function getCurrTime():Float {
        #if sys
        return Sys.time() * 1000;
        #else
        return Date.now().getTime();
        #end
    }

}