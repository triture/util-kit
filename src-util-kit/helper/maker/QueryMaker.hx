package helper.maker;

import haxe.ds.StringMap;
import haxe.crypto.Sha256;
class QueryMaker {

    public static var SANITIZE:String->String;

    public static function make(sql:String, data:Dynamic = null, ?escape:String->String):String {
        if (data == null) return sql;

        if (escape == null && SANITIZE == null) throw "Set a SANITIZE Method for QueryMaker";
        else if (escape == null && SANITIZE != null) escape = SANITIZE;

        var fields:Array<String> = Reflect.fields(data);

        // reordenando nome de campos para evitar sopreposição. Ex: :nome_campo pode ser encontrado em :nome_campo_1

        fields.sort(
            function(a:String, b:String):Int {
                if (a > b) return -1;
                else if (b > a) return 1;
                else return 0;
            }
        );

        // substituindo nome dos campos por hashes, para evitar injecao
        // de sql por dados que carregam instruções previsiveis.
        // exemplo: um valor de string que carrega no conteudo a instrução :id que posteriormente
        // pode comprometer a montagem da query resubstituindo o valor de :id

        var result:String = sql;
        var hashedMap:StringMap<String> = new StringMap<String>();

        for (i in 0 ... fields.length) {
            var originalField:String = fields[i];
            var hashedField:String = Sha256.encode(originalField + Date.now().toString());

            hashedMap.set(fields[i], hashedField);

            result = result.split(":" + originalField).join(":" + hashedField);
        }


        for (key in fields) {

            var value:Dynamic = Reflect.field(data, key);
            var valueSanitize:String = "";

            if (value == null) {
                valueSanitize = "NULL";

            } else if (Std.is(value, Bool)) {
                valueSanitize = value ? '1' : '0';

            } else if (Std.is(value, Date)) {
                var date:Date = cast value;
                var dateString:String = '' +
                '"${date.getFullYear()}-' +
                '${StringTools.lpad(Std.string(date.getMonth()+1), "0", 2)}-' +
                '${StringTools.lpad(Std.string(date.getDate()), "0", 2)} ' +
                '${StringTools.lpad(Std.string(date.getHours()), "0", 2)}:' +
                '${StringTools.lpad(Std.string(date.getMinutes()), "0", 2)}:' +
                '${StringTools.lpad(Std.string(date.getSeconds()), "0", 2)}"';

                valueSanitize = '${dateString}';

            } else if (Std.is(value, Int)) {
                valueSanitize = '${value}';

            } else {
                var valueString:String = Std.string(value);

                if (valueString.length == 0) valueSanitize = "''";
                else {
                    valueSanitize = escape(valueString);

                    #if php
                    valueSanitize = "'" + valueSanitize + "'";
                    #end
                }
            }

            result = result.split(":" + hashedMap.get(key)).join(valueSanitize);
        }

        return result;
    }

}
