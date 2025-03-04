package util.kit.lang;

import haxe.ds.StringMap;

class LangSupport {
    
    static public function processDictionary(data:Dynamic, ?field:String, ?result:StringMap<String>):StringMap<String> {
        var sep:String = '_';

        if (result == null) result = new StringMap<String>();
        if (data == null) return result;
        
        if (field == null) field = '';
        else field = field.toUpperCase() + sep;
            for (key in Reflect.fields(data)) {
            var value:Dynamic = Reflect.field(data, key);
            
            if (Std.isOfType(value, Array)) {
                var arr:Array<Dynamic> = value;
                
                for (i in 0...arr.length) {
                    var item:Dynamic = arr[i];
                    result.set(field + key.toUpperCase() + '${sep}${i}', Std.string(item));
                }
            }
            else if (Std.isOfType(value, String)) result.set(field + key.toUpperCase(), value);
            else if (Std.isOfType(value, Bool) || Std.isOfType(value, Int) || Std.isOfType(value, Float)) result.set(field + key.toUpperCase(), Std.string(value));
            else processDictionary(value, field + key, result);
        }
        
        return result;
    }

}