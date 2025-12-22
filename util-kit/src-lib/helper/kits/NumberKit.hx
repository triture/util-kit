package helper.kits;

import haxe.ds.StringMap;
import haxe.crypto.Md5;
import helper.types.VarianceValue;
import helper.types.TimeAverage;

class NumberKit {

    static public function bestNumberBetween(minValue:Float, currentValue:Float, maxValue:Float):Float  {
        return Math.max(Math.min(currentValue, maxValue), minValue);
    }

    static public function getClosestNumber(options:Array<Float>, reference:Float):Float {
        if (options == null || options.length == 0) return reference;

        var choiceIndex:Int = 0;

        for (i in 1 ... options.length) {
            if (Math.abs(options[choiceIndex] - reference) > Math.abs(options[i] - reference)) {
                choiceIndex = i;
            }
        }

        return options[choiceIndex];
    }

    static public function radialPosition(radius:Float, angleDegree:Float):{x:Float, y:Float} {
        // sena = py / radius
        // py = sena / radius
        // px = cosa / radius

        var r:Float = degreeToRad(angleDegree);

        return {
            x : Math.cos(r) * radius,
            y : Math.sin(r) * radius * -1
        };
    }

    inline static public function radToDegree(rad:Float):Float return rad * (180 / Math.PI);
    inline static public function degreeToRad(degree:Float):Float return degree * (Math.PI / 180);

    static public function getKeyForSeed(seed:String, precision:Int = 10):Float {
        if (precision <= 1) precision = 1;

        var hash:String = seed;

        var out:Array<String> = [];
        var minChar:Int = 48; // -> 0
        var maxChar:Int = 57; // -> 9

        while (out.length < precision) {
            hash = Md5.encode(hash);

            for (i in 0 ... hash.length) {
                var code:Int = hash.charCodeAt(i);
                if (code >= minChar && code <= maxChar) out.push(hash.charAt(i));
                if (out.length == precision) break;
            }
        }

        return Std.parseFloat("0." + out.join(""));
    }

    static public function getIntKeyForSeed(seed:String, min:Int, max:Int):Int {
        return min + Math.round((max - min) * getKeyForSeed(seed, 12));
    }

    static public function getRandom(max:Int, useBaseZero:Bool = false):Int {
        return Math.floor(Math.random() * max + (useBaseZero ? 0 : 1));
    }

    static public function maxDecimal(value:Float, max:Int = 2):Float {
        return Math.round(value * Math.pow(10, max)) / Math.pow(10, max);
    }

    static public function getVarianceData(values:Array<Float>):VarianceValue {
        var average:Float = getAverage(values);
        var variance:Float = getVariance(average, values);
        var deviation:Float = Math.sqrt(variance);

        return {
            variance : variance,
            standardDeviation : deviation
        }
    }

    static public function getIncreasePercent(before:Float, after:Float):Float {
        if (after == 0 && before == 0) return 0;
        if (before == 0) return Math.POSITIVE_INFINITY;

        return (after - before)/before*100;
    }

    static public function getTimeAverage(values:Array<Float>):TimeAverage {
        var average:Float = getAverage(values);

        return {
            valuesMili : values,
            average : average
        }
    }

    static public function getDeviation(average:Float, values:Array<Float>):Float {
        var variance:Float = getVariance(average, values);
        return Math.sqrt(variance);
    }

    static public function getVariance(?average:Float, values:Array<Float>):Float {
        #if !sys
        if (values == null || values.length == 0) return null;
        #end

        var calcAverage:Float = average == null ? getAverage(values) : average;
        var squareSum:Float = 0;

        for (value in values) squareSum += Math.pow(value - calcAverage, 2);

        return squareSum/values.length;
    }

    static public function getAverage(values:Array<Float>):Null<Float> {
        #if !sys
        if (values == null || values.length == 0) return null;
        #else
        if (values.length == 0) return null;
        #end

        var sum:Float = 0;

        for (value in values) sum += value;

        return (sum / values.length);
    }

    static public function getMediana(values:Array<Float>):Null<Float> {
        #if !sys
        if (values == null || values.length == 0) return null;
        #else
        if (values.length == 0) return null;
        #end

        var sum:Float = 0;

        var sorted:Array<Float> = ArrayKit.sortByFieldAndReturn(values.copy(), null, true);

        if (sorted.length % 2 == 0) {
            // quantidade par
            var index:Int = Math.floor(sorted.length/2) - 1;
            return ((sorted[index] + sorted[index + 1])/2);

        } else {
            // quantidade impar
            if (sorted.length == 1) return sorted[0];
            else {
                var index:Int = Math.floor(sorted.length/2);
                return sorted[index];
            }
        }
    }

    static public function getMax(values:Array<Float>):Float {
        if (values == null || values.length == 0) return 0;

        var max:Float = values[0];

        for (value in values) max = Math.max(max, value);

        return max;
    }

    static public function getMin(values:Array<Float>):Float {
        if (values == null || values.length == 0) return 0;

        var min:Float = values[0];

        for (value in values) min = Math.min(min, value);

        return min;
    }

    static public function isEmpty(value:Null<Int>, negativesIsEmpty:Bool):Bool {

        if (value == null) return true;
        else if (!Std.isOfType(value, Int)) return true;
        else if (Std.parseInt(Std.string(value)) == 0 ) return true;
        else if (negativesIsEmpty && Std.parseInt(Std.string(value)) < 0) return true;

        return false;

    }

    //https://gist.github.com/gre/1650294
    inline static private function tweenCalculate(percentElapsedTime:Float):Float {
        return 1 * ((--percentElapsedTime)*percentElapsedTime*percentElapsedTime+1);
    }

    private static var tweenKeys:StringMap<haxe.Timer> = new StringMap<haxe.Timer>();

    static public function killTween(key:String):Void {
        if (tweenKeys.exists(key)) {
            tweenKeys.get(key).stop();
            tweenKeys.get(key).run = null;
            tweenKeys.remove(key);
        }
    }

    static public function tween(key:String, maxTimeMS:Float, onUpdate:Float->Void, ?onConclusion:Void->Void):Void {

        killTween(key);

        var startTime:Float = Date.now().getTime();

        var timer:haxe.Timer = new haxe.Timer(20);

        tweenKeys.set(key, timer);

        timer.run = function():Void {

            var currTime:Float = Date.now().getTime();
            var percentTime:Float = (currTime - startTime) / maxTimeMS;

            if (percentTime >= 1) {
                timer.stop();
                timer.run = null;

                tweenKeys.remove(key);

                onUpdate(1);
                if (onConclusion != null) onConclusion();

            } else {
                if (tweenKeys.exists(key)) onUpdate(tweenCalculate(percentTime));
            }

        }

    }
}
