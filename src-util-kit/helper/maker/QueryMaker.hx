package helper.maker;

import helper.kits.StringKit;
import haxe.ds.StringMap;
import haxe.crypto.Sha256;

class QueryMaker {

    public static var SANITIZE:String->String;

    public static function make(sql:String, data:Dynamic = null, ?escape:String->String):String {
        if (data == null) return sql;

        if (escape == null && SANITIZE == null) throw "Set a SANITIZE Method for QueryMaker";
        else if (escape == null && SANITIZE != null) escape = SANITIZE;

        var keyData:StringMap<Dynamic> = new StringMap<Dynamic>();
        for (key in Reflect.fields(data)) keyData.set(key, Reflect.field(data, key));

        var result:String = '';

        var ereg:EReg = ~/:([a-zA-Z0-9_]+)/gm;

        while (ereg.match(sql)) {
            result += ereg.matchedLeft();

            var key:String = ereg.matched(1);
            if (keyData.exists(key)) result += sanitizeValue(keyData.get(key), escape);
            else result += ':${key}';

            sql = ereg.matchedRight();
        }

        result += sql;

        return result;
    }

    static private function sanitizeValue(value:Null<Dynamic>, escape:String->String):String {
        var result:String = "";

        if (value == null) result = "NULL";
        else if (Std.isOfType(value, Bool)) result = value ? '1' : '0';
        else if (Std.isOfType(value, Int)) result = '${value}';
        else if (Std.isOfType(value, Date)) {

            var date:Date = cast value;
            var dateString:String = '' +
            '"${date.getFullYear()}-' +
            '${StringTools.lpad(Std.string(date.getMonth()+1), "0", 2)}-' +
            '${StringTools.lpad(Std.string(date.getDate()), "0", 2)} ' +
            '${StringTools.lpad(Std.string(date.getHours()), "0", 2)}:' +
            '${StringTools.lpad(Std.string(date.getMinutes()), "0", 2)}:' +
            '${StringTools.lpad(Std.string(date.getSeconds()), "0", 2)}"';

            result = '${dateString}';

        } else {
            var valueString:String = Std.string(value);

            if (valueString.length == 0) result = "''";
            else {
                result = escape(valueString);

                #if php
                    valueSanitize = "'" + valueSanitize + "'";
                    #end
            }
        }

        return result;
    }

}
