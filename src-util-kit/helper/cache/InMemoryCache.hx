package helper.cache;

import helper.kits.TimerKit;
import helper.kits.StringKit;
import haxe.ds.StringMap;

class InMemoryCache<T> {

    private var timeout:Int;
    private var map:StringMap<T>;
    private var internalKey:String;

    public function new(cacheTimeOut:Int = 30000) {
        this.internalKey = StringKit.generateRandomString(20);
        this.timeout = cacheTimeOut;
        this.map = new StringMap<T>();
    }

    public function reset():Void {
        for (key in this.map.keys()) this.remove(key);
    }

    public function add(key:String, data:T):Void {
        this.map.set(key, data);
        this.registerTimeout(key);
    }

    public function remove(key:String):Void {
        this.deleteTimeout(key);
        if (this.map.exists(key)) this.map.remove(key);
    }

    public function exists(key:String):Bool return this.map.exists(key);
    public function get(key:String):Null<T> return this.map.get(key);
    public function refreshTimeout(key:String):Void if (this.map.exists(key)) this.add(key, this.map.get(key));

    // TIMEOUT
    private function registerTimeout(key:String):Void TimerKit.delay('IN_CACHE_TIMEOUT:${this.internalKey}:${key}', this.timeout, this.onTimeout.bind(key));
    private function deleteTimeout(key:String):Void TimerKit.kill('IN_CACHE_TIMEOUT:${this.internalKey}:${key}');
    private function onTimeout(key:String):Void this.map.remove(key);

}