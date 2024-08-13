package helper.kits;

class MathKit {

    // https://github.com/Tom-Alexander/regression-js

    inline static public function round(number:Float, precision:Int):Float {
        var factor:Float = Math.pow(10, precision);
        return (Math.fround(number * factor) / factor);
    }

    static public function linear(data:Array<Array<Float>>):Dynamic {
        var precision:Int = 2;

        var sum:Array<Float> = [0, 0, 0, 0, 0];
        var len:Int = 0;

        for (n in 0 ... data.length) {
            if (data[n][1] != null) {
                len++;

                sum[0] += data[n][0];
                sum[1] += data[n][1];
                sum[2] += data[n][0] * data[n][0];
                sum[3] += data[n][0] * data[n][1];
                sum[4] += data[n][1] * data[n][1];
            }
        }

        var run:Float = ((len * sum[2]) - (sum[0] * sum[0]));
        var rise:Float = ((len * sum[3]) - (sum[0] * sum[1]));
        var gradient:Float = run == 0.0 ? 0.0 : round(rise / run, precision);
        var intercept:Float = round((sum[1] / len) - ((gradient * sum[0]) / len), precision);

        var predict = function(x) {
            return [
                round(x, precision),
                round((gradient * x) + intercept, precision)
            ];
        }

        var points:Array<Array<Float>> = data.map(
            function(point:Array<Float>):Array<Float> return predict(point[0])
        );

        return {
            points : points,
            predict : predict
        };
    }

}
