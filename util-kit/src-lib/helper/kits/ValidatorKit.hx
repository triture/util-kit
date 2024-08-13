package helper.kits;

import helper.validators.MedtConvertion;

class ValidatorKit {

    public static function cannotBeNull(value:Dynamic, errorMessage:String):Void {
        if (value == null) throw errorMessage;
    }

    public static function required(value:String, minChar:Int, errorMessage:String):Void {
        if (value == null || value.length < minChar) throw errorMessage;
    }

    public static function requireWords(value:String, minWords:Int, errorMessage:String):Void {
        var breakWords:Array<String> = StringTools.trim(value).split(" ");
        var count:Int = 0;

        for (word in breakWords) {
            if (StringTools.trim(word).length > 1) {
                count ++;
            }
        }

        if (count < minWords) throw errorMessage;
    }

    public static function options(value:Array<Dynamic>, minOptions:Int, errorMessage:String):Void {
        if (value == null || value.length < minOptions) throw errorMessage;
    }

    public static function requiredEmail(value:String, errorMessage:String):Void {
        if (!StringKit.isEmail(value)) throw errorMessage;
    }

    public static function requiredCPF(value:String, errorMessage:String):Void {
        if (MedtConvertion.cleanCPF(value) == null) throw errorMessage;
    }

    public static function requiredDate(value:String, errorMessage:String):Void {
        if (StringKit.formatToDate(value) == null) throw errorMessage;
    }

    public static function minYearsOld(value:String, minYears:Int, errorMessage:String):Void {
        var date:Date = DateKit.convertToDate(DateKit.applyDateMask(value), false);

        if (date == null) throw errorMessage;
        else {
            if (DateKit.getDiffYears(date, Date.now()) < minYears) throw errorMessage;
        }

    }

    public static function maxYearsOld(value:String, maxYears:Int, errorMessage:String):Void {
        var date:Date = DateKit.convertToDate(DateKit.applyDateMask(value), false);

        if (date == null) throw errorMessage;
        else {
            if (DateKit.getDiffYears(date, Date.now()) > maxYears) throw errorMessage;
        }

    }

    public static function minDaysOld(value:String, minDays:Int, errorMessage:String):Void {
        var date:Date = DateKit.convertToDate(DateKit.applyDateMask(value), false);

        if (date == null) throw errorMessage;
        else {
            if (DateKit.getDiffDay(date, Date.now()) < minDays) throw errorMessage;
        }

    }

    public static function maxDaysOld(value:String, maxDays:Int, errorMessage:String):Void {
        var date:Date = DateKit.convertToDate(DateKit.applyDateMask(value), false);

        if (date == null) throw errorMessage;
        else {
            if (DateKit.getDiffDay(date, Date.now()) > maxDays) throw errorMessage;
        }

    }
}
