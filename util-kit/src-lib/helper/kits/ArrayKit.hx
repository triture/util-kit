package helper.kits;

import haxe.ds.StringMap;
class ArrayKit {

    public static function getRandomItem<T>(values:Array<T>):T return values[NumberKit.getRandom(values.length, true)];

    public static function appendStringToArray(value:Array<String>, prepend:String, append:String):Array<String> {
        var result:Array<String> = [];
        for (item in value) result.push(prepend + item + append);
        return result;
    }

    public static function listToArray<T>(listValues:List<T>):Array<T> {
        var result:Array<T> = [];

        for (item in listValues) result.push(item);

        return result;
    }

    public static function mergeArrayByUniqueFields<T>(a:Array<T>, b:Array<T>, field:String):Array<T> {
        var result:Array<T> = [];
        var existValues:Array<Dynamic> = [];

        var merged:Array<T> = mergeUniques(a, b);

        for (item in merged) {

            var fieldValue = Reflect.getProperty(item, field);

            if (existValues.indexOf(fieldValue) < 0) {
                result.push(item);
                existValues.push(fieldValue);
            }

        }

        return result;
    }

    public static function mergeArrayByUniqueUpdating<T>(oldValues:Array<T>, newValues:Array<T>, field:String):Array<T> {
        var result:Array<T> = oldValues.copy(); // clone dos objetos antigos
        var fieldsResult:Array<Dynamic> = [for (item in result) Reflect.getProperty(item, field)]; // lista de FIELDS dos objs antigos


        for (item in newValues) {

            var newFieldValue = Reflect.getProperty(item, field);
            var index:Int = fieldsResult.indexOf(newFieldValue);

            if (index >= 0) result[index] = item;
            else {

                result.push(item);
                fieldsResult.push(newValues);

            }

        }

        return result;
    }

    public static function joinArray<T>(arrayA:Array<T>, arrayB:Array<T>, onPosition:Int):Array<T> {
        var result:Array<T> = [];

        for (i in 0 ... onPosition) result.push(arrayA[i]);
        for (i in 0 ... arrayB.length) result.push(arrayB[i]);
        for (i in onPosition ... arrayA.length) result.push(arrayA[i]);

        return result;
    }

    public static function mergeUniques<T>(arr1:Array<T>, arr2:Array<T>):Array<T> {
        var result:Array<T> = [];

        for (item in arr1) if (result.indexOf(item) == -1) result.push(item);
        for (item in arr2) if (result.indexOf(item) == -1) result.push(item);

        return result;
    }

    public static function addToArray<T>(src:Array<T>, dest:Array<T>):Void {
        if (src == null) return;

        for (i in 0 ... src.length) {
            dest.push(src[i]);
        }
    }

    public static function indexOfByFieldValue(a:Array<Dynamic>, field:String, fieldValue:Dynamic):Int {
        var i:Int = 0;
        var n:Int = a.length;
        var val:Dynamic = null;
        var result:Int = -1;

        while (i < n) {

            val = Reflect.getProperty(a[i], field);

            if (val == fieldValue) {
                result = i;
                i = n;
            }

            i++;
        }

        return result;
    }

    public static function getItemByQueryObject<T>(a:Array<T>, query:Dynamic):T {
        var result:Array<T> = getListByQueryObject(a, query);

        if (result.length > 0) {
            return result[0];
        }

        return null;
    }

    public static function getUniqueStringValues(a:Array<String>):Array<String> {
        var map:StringMap<Bool> = new StringMap<Bool>();
        for (item in a) map.set(item, true);
        return [for (key in map.keys()) key];
    }

    public static function getUniqueValues<T>(a:Array<T>, field:String):Array<Dynamic> {
        var result:Array<Dynamic> = [];

        for (i in 0 ... a.length) {

            var val = Reflect.getProperty(a[i], field);

            if (result.indexOf(val) == -1) {
                result.push(val);
            }

        }

        return result;
    }

    public static function getListByQueryObject<T>(a:Array<T>, query:Dynamic):Array<T> {
        var result:Array<T> = [];

        var i:Int = 0;
        var n:Int = a.length;

        var queryFields:Array<String> = Reflect.fields(query);

        while (i < n) {
            var accept:Bool = true;
            var item:T = a[i];

            var j:Int = 0;
            var m:Int = queryFields.length;

            while (j < m) {
                var itemValue:Dynamic = Reflect.getProperty(item, queryFields[j]);
                var expectedValue:Dynamic = Reflect.getProperty(query, queryFields[j]);

                if (itemValue != expectedValue) {
                    accept = false;
                    j = m;
                } else {
                    j++;
                }
            }

            if (accept) result.push(item);

            i++;
        }

        return result;
    }

    public static function convertToInt(a:Array<Dynamic>):Array<Int>{
        var i:Int = 0;
        var n:Int = a.length;
        var result:Array<Int> = [];

        while (i < n) {
            result.push(Std.parseInt(a[i]));

            i++;
        }

        return result;
    }

    public static function getListByFieldContains<T>(a:Array<T>, field:String, containsValue:String):Array<T> {
        var result:Array<T> = [];

        var i:Int = 0;
        var n:Int = a.length;

        while (i < n) {
            var val:Dynamic = Reflect.getProperty(a[i], field);

            if (Std.string(val).toLowerCase().indexOf(containsValue.toLowerCase()) > -1) {
                result.push(a[i]);
            }

            i++;
        }

        return result;
    }

    public static function getIdListFromItens(a:Array<Dynamic>, idField:String = "id"):Array<Int> {
        var result:Array<Int> = [];

        for (i in 0 ... a.length) {
            var value:Null<Dynamic> = Reflect.getProperty(a[i], idField);

            if (value != null) {
                result.push(value);
            }
        }


        return result;
    }

    public static function getListByIdList<T>(a:Array<T>, idList:Array<Int>, idField:String = "id"):Array<T> {
        var result:Array<T> = [];

        for (i in 0...idList.length) {
            var item = getItemByFieldValue(a, idField, idList[i]);

            if (item != null) {
                result.push(item);
            }
        }

        return result;
    }

    public static function getListOfValues<T>(a:Array<T>, field:String):Array<String> {
        var result:Array<String> = [];

        for (item in a) result.push(StringKit.getLabelForData(item, field));

        return result;
    }

    public static function getListByFieldValue<T>(a:Array<T>, field:String, fieldValue:Dynamic):Array<T> {
        var result:Array<T> = [];

        var i:Int = 0;
        var n:Int = a.length;

        while (i < n) {
            var val:Dynamic = Reflect.getProperty(a[i], field);

            if (val == fieldValue) {
                result.push(a[i]);
            }

            i++;
        }

        return result;
    }

    public static function getItemByFieldValue(a:Array<Dynamic>, field:String, fieldValue:Dynamic):Dynamic {
        var index:Int = indexOfByFieldValue(a, field, fieldValue);
        var result:Dynamic = null;

        if (index > -1) {
            result = a[index];
        }

        return result;
    }

    public static function sortAsc<T, R>(a:Array<T>, extraction:(v:T)->R):Array<T> return sort(a, extraction, true);
    public static function sortDesc<T, R>(a:Array<T>, extraction:(v:T)->R):Array<T> return sort(a, extraction, false);
    private static function sort<T, R>(a:Array<T>, extraction:(v:T)->R, ASC:Bool = true):Array<T> {
        a.sort((a:T, b:T) -> {
            var vx:Dynamic = extraction(ASC ? a : b);
            var vy:Dynamic = extraction(ASC ? b : a);

            if (Std.isOfType(vx, Date)) vx = cast(vx, Date).getTime();
            if (Std.isOfType(vy, Date)) vy = cast(vy, Date).getTime();

            if (!Std.isOfType(vx, Float) && !Std.isOfType(vx, Int)) {
                vx = Std.string(vx).toLowerCase();
                vy = Std.string(vy).toLowerCase();
            }

            if (vx > vy) return 1;
            else if (vy > vx) return -1;
            else return 0;
        });

        return a;
    }

    public static function sortByFieldAndReturn<T>(a:Array<T>, field:String = null, ASC:Bool = true):Array<T> {
        sortByField(a, field, ASC);
        return a;
    }

    public static function sortByField(a:Array<Dynamic>, field:String = null, ASC:Bool = true):Void {
        a.sort(function(x:Dynamic, y:Dynamic):Int {
            var vx:Dynamic;
            var vy:Dynamic;

            if (field == null || field == "") {
                vx = x;
                vy = y;
            } else {
                vx = Reflect.getProperty(x, field);
                vy = Reflect.getProperty(y, field);
            }

            if (Std.isOfType(vx, Date)) vx = cast(vx, Date).getTime();
            if (Std.isOfType(vy, Date)) vy = cast(vy, Date).getTime();

            if (!Std.isOfType(vx, Float) && !Std.isOfType(vx, Int)) {
                vx = Std.string(vx).toLowerCase();
                vy = Std.string(vy).toLowerCase();
            }

            if (ASC) {
                if (vx > vy) return 1;
                if (vy > vx) return -1;
            } else {
                if (vx > vy) return -1;
                if (vy > vx) return 1;
            }

            return 0;
        });
    }
}