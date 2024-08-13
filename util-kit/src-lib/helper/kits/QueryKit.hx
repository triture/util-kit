package helper.kits;

class QueryKit {

    public static function generateFilter_OR_LIKE(field:String, values:Array<Dynamic>, dataStack:Dynamic, processNegatives:Bool=false):String return generateFilterGeneric(field, values, dataStack, true, processNegatives);

    public static function generateFilter_OR_EQUAL(field:String, values:Array<Dynamic>, dataStack:Dynamic, processNegatives:Bool=false):String return generateFilterGeneric(field, values, dataStack, false, processNegatives);

    public static function generateFilterGeneric(field:String, values:Array<Dynamic>, dataStack:Dynamic, useLike:Bool = false, processNegatives:Bool = false):String {

        var resultPos:String = '';
        var countResultPos:Int = 0;

        var resultNeg:String = '';
        var countResultNeg:Int = 0;

        var equalConnectorPos:String = useLike ? " LIKE " : " = ";
        var equalConnectorNeg:String = useLike ? " NOT LIKE " : " != ";

        for (i in 0 ... values.length) {
            var valueKey:String = 'gen_${i}_${StringKit.generateRandomString(12)}';
            var valueReal:Dynamic = values[i];
            var isNegative:Bool = false;

            if (processNegatives) {
                if (Std.isOfType(values[i], String)) {
                    var sval:String = values[i];

                    if (sval.charAt(0) == '-') {
                        valueReal = sval.substring(1);
                        isNegative = true;
                    } else if (sval.substr(0, 2) == '"-') {
                        // Condicao extremamente especial para a situacao da especialidade medica
                        valueReal = '"' + sval.substring(2);
                        isNegative = true;
                    } else if (sval.substr(0, 2) == '#-') {
                        // Condicao extremamente especial para a situacao do dashboard
                        valueReal = '#' + sval.substring(2);
                        isNegative = true;
                    }
                } else if (Std.isOfType(values[i], Float) && values[i] < 0) {
                    valueReal = values[i] * -1;
                    isNegative = true;
                }
            }

            if (useLike) {
                var finalValue:String = Std.string(valueReal);
                if (finalValue.indexOf('%') == -1) finalValue = '%${finalValue}%';

                Reflect.setField(dataStack, valueKey, finalValue);

            } else Reflect.setField(dataStack, valueKey, valueReal);

            if (isNegative) {
                resultNeg += (countResultNeg > 0 ? ' AND ' : ' ') + field;
                resultNeg += equalConnectorNeg + ' :' + valueKey + ' ';
                countResultNeg++;
            } else {
                resultPos += (countResultPos > 0 ? ' OR ' : ' ') + field;
                resultPos += equalConnectorPos + " :" + valueKey + " ";
                countResultPos++;
            }
        }

        var result:String = '';

        if (countResultPos > 0 && countResultNeg == 0) result = resultPos;
        else if (countResultPos == 0 && countResultNeg > 0) result = ' (${field} IS NULL OR (${resultNeg})) ';
        else if (countResultPos > 0 && countResultNeg > 0) result = ' (${resultPos}) AND (${field} IS NULL OR (${resultNeg})) ';

        return result;

    }

}