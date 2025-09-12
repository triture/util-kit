package helper.kits;

import datetime.DateTime;
import helper.types.TimeValue;

class DateKit {

    inline static public function getUTCNow():Date return convertToUTCDate(Date.now());

    public static function convertToUTCDate(localDate:Date):Date {
        #if (js || flash || php || cpp || python)

        return Date.fromTime(localDate.getTime() + localDate.getTimezoneOffset() * 60000);

        #else
        return localDate;
        #end
    }

    public static function convertToLocalDate(utcDate:Date):Date {
        #if (js || flash || php || cpp || python)

        return Date.fromTime(
            DateTools.makeUtc(
                utcDate.getFullYear(),
                utcDate.getMonth(),
                utcDate.getDate(),
                utcDate.getHours(),
                utcDate.getMinutes(),
                utcDate.getSeconds()
            )
        );

        #else
        return utcDate;
        #end
    }

    public static function getTimeFrame(date:Date):String {

        var minutes:Float = DateKit.getDiffMinutes(date, Date.now());

        if (minutes < 3) return "Há poucos minutos";
        else if (minutes < 12) return 'Há ${Math.round(minutes)} minutos';
        else if (minutes < 60) return 'Há ${Math.round(minutes/5)*5} minutos';
        else if (minutes < 120) return 'Há 1 hora';
        else if (minutes < 300) return 'Há ${Math.round(minutes/60)} horas'
        else if (minutes < (6*60) || DateTools.format(date, "%d/%m/%Y") == DateTools.format(Date.now(), "%d/%m/%Y")) {
            return DateKit.getTimeString(date);
        } else {
            return DateKit.getDateString(date);
        }

    }

    public static function getTimeFrameEnglish(date:Date):String {

        var minutes:Float = DateKit.getDiffMinutes(date, Date.now());

        if (minutes < 3) return "Few minutes ago";
        else if (minutes < 12) return '${Math.round(minutes)} minutes ago';
        else if (minutes < 60) return '${Math.round(minutes/5)*5} minutes ago';
        else if (minutes < 120) return '1 hour ago';
        else if (minutes < 300) return '${Math.round(minutes/60)} hours ago'
        else if (minutes < (6*60) || getDateStringEnglish(date) == getDateStringEnglish(Date.now())) {
            return DateKit.getTimeString(date);
        } else {
            return DateTools.format(date, "%b %d, %Y");
        }

    }

    public static function calculateYearOld(birth:Date):Int {

        if (birth == null || Std.isOfType(birth, String)) return 0;

        var cur:Date = Date.now();

        var age:Int = cur.getFullYear() - birth.getFullYear();

        if (age > 0) {
            if (birth.getMonth() > cur.getMonth()) age--;
            else if (birth.getDate() > cur.getDay()) age--;
        }

        return age;
    }

    public static function getDiffYears(date1:Date, date2:Date):Float {
        var value1:Float = date1.getTime();
        var value2:Float = date2.getTime();

        return (value2-value1) / (1000 * 60 * 60 * 24 * 365);
    }

    public static function getDiffHour(date1:Date, date2:Date):Float {
        var value1:Float = date1.getTime();
        var value2:Float = date2.getTime();

        return (value2-value1) / (1000 * 60 * 60);
    }

    public static function getDiffMinutes(dateStart:Date, dateEnd:Date):Float {
        var valStart:Float = dateStart.getTime();
        var valEnd:Float = dateEnd.getTime();

        return (valEnd-valStart) / (1000 * 60);
    }

    public static function getDiffDay(date1:Date, date2:Date):Float {
        var value1:Float = date1.getTime();
        var value2:Float = date2.getTime();

        return (value2 - value1) / (1000 * 60 * 60 * 24);
    }

    public static function applyDateMask(value:String):String {
        if (value.split("/").length == 3) return value;

        var onlyNumbers:String = StringKit.getAllowedChars(value, "0123456789");
        var result:String = "";

        for (i in 0 ... onlyNumbers.length) {
            if (result.length == 2) result += "/";
            if (result.length == 5) result += "/";

            result += onlyNumbers.charAt(i);
        }

        if (value.length == 3 && result.length == 2) result += "/";
        if (value.length == 6 && result.length == 5) result += "/";

        return result;
    }

    public static function getDateMidnight(date:Date):Date return Date.fromString(getDateMysqlFormat(date) + " 23:59:59");
    public static function getDateFreshDay(date:Date):Date return Date.fromString(getDateMysqlFormat(date) + " 00:00:00");


    public static function brazilStringDateToDate(value:String, subjectiveDate:Bool = true):Date {
        value = StringTools.trim(value).toLowerCase();

        if (subjectiveDate) {
            if (value == "hoje" || value == "today") return Date.now();
            if (value == "amanha" || value == "amanhã" || value == "tomorrow") return addDays(Date.now(), 1);
            if (value == "ontem" || value == "yesterday") return addDays(Date.now(), -1);
        }

        value = value.split("-").join(".");
        value = value.split("/").join(".");
        value = value.split("\\").join(".");
        value = value.split(":").join(".");
        value = value.split(" ").join(".");

        while (value.indexOf("..") >= 0) value = value.split("..").join(".");

        var vals:Array<String> = value.split(".");

        if (vals.length != 3 && vals.length != 5) return null;

        for (i in 0 ... vals.length) {
            vals[i] = StringKit.getAllowedChars(vals[i], "0123456789");
            if (vals[i].length == 0) return null;
        }

        var day:Null<Int> = Std.parseInt(vals[0]);
        var month:Null<Int> = Std.parseInt(vals[1]);
        var year:Null<Int> = Std.parseInt(vals[2]);

        if (day == null || month == null || year == null) return null;
        if (day < 1 || day > 31 || month < 1 || month > 12 || year <= 0) return null;

        if (vals[2].length < 4) {
            year = year + 2000;
            vals[2] = Std.string(year);
        }

        vals[1] = StringTools.lpad(Std.string(month), "0", 2);
        vals[0] = StringTools.lpad(Std.string(day), "0", 2);

        if (vals.length == 5) {
            var hour:Null<Int> = Std.parseInt(vals[3]);
            var minute:Null<Int> = Std.parseInt(vals[4]);

            if (hour == null || minute == null) return null;
            if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

            vals[4] = StringTools.lpad(Std.string(minute), "0", 2);
            vals[3] = StringTools.lpad(Std.string(hour), "0", 2);
        }

        try {
            var date:Date = null;

            if (vals.length == 3) date = Date.fromString(vals[2] + "-" + vals[1] + "-" + vals[0]);
            else date = Date.fromString(vals[2] + "-" + vals[1] + "-" + vals[0] + " " + vals[3] + ":" + vals[4] + ":00");

            if (DateTools.format(date, "%d.%m.%Y") == '${vals[0]}.${vals[1]}.${vals[2]}') return date;

            return null;
        } catch (e:Dynamic) {
            return null;
        }
    }

    public static function convertToDate(value:String, subjectiveDate:Bool = true):Date {
        value = StringTools.trim(value).toLowerCase();

        if (subjectiveDate) {
            if (value == "hoje" || value == "today") return Date.now();
            if (value == "amanha" || value == "amanhã" || value == "tomorrow") return addDays(Date.now(), 1);
            if (value == "ontem" || value == "yesterday") return addDays(Date.now(), -1);
        }

        value = value.split("-").join(".");
        value = value.split("/").join(".");
        value = value.split("\\").join(".");
        value = value.split(":").join(".");
        value = value.split(" ").join(".");

        value = value.split("..").join(".");
        value = value.split("..").join(".");
        value = value.split("..").join(".");
        value = value.split("..").join(".");

        var vals:Array<String> = value.split(".");

        if (vals.length != 3 && vals.length != 5) return null;

        if (vals[2].length < 4) {
            var yearNumber:Null<Int> = Std.parseInt(vals[2]);

            if (yearNumber == null) return null;

            var currYear:Int = (Date.now().getFullYear() + 10) - 2000;

            if (yearNumber > currYear) yearNumber += 1900;
            else yearNumber += 2000;

            vals[2] = Std.string(yearNumber);
        }

        vals[1] = StringTools.lpad(Std.string(Std.parseInt(vals[1])), "0", 2);
        vals[0] = StringTools.lpad(Std.string(Std.parseInt(vals[0])), "0", 2);

        if (vals.length == 5) {
            vals[4] = StringTools.lpad(Std.string(Std.parseInt(vals[4])), "0", 2);
            vals[3] = StringTools.lpad(Std.string(Std.parseInt(vals[3])), "0", 2);
        }

        try {
            var date:Date = Date.fromString(vals[2] + "-" + vals[1] + "-" + vals[0]);

            if (vals.length == 5) {
                date = Date.fromString(vals[2] + "-" + vals[1] + "-" + vals[0] + " " + vals[3] + ":" + vals[4] + ":00");
            }

            if (DateTools.format(date, "%d.%m.%Y") == '${vals[0]}.${vals[1]}.${vals[2]}') return date;

            return null;
        } catch (e:Dynamic) {
            return null;
        }
    }

    public static function addDays(date:Date, days:Int):Date {
        return Date.fromTime(date.getTime() + days * 24 * 60 * 60 * 1000);
    }

    public static function addMinutes(date:Date, minutes:Int):Date {
        return Date.fromTime(date.getTime() + minutes * 60 * 1000);
    }

    public static function addMonth(date:Date, months:Int):Date {
        var curYear:Int = date.getFullYear();
        var curMonth:Int = date.getMonth() + 1;
        var curDay:Int = date.getDate();

        curMonth += months;

        if (curMonth > 12) {
            curYear += Math.floor(curMonth / 12);
            curMonth = curMonth % 12;
        } else if (curMonth < 0) {
            curYear += Math.floor((curMonth - 12)/12);
            curMonth = 12 + ((curMonth - 12) % 12);
        }

        var maxDays:Int = DateTools.getMonthDays(new Date(curYear, curMonth-1, 1, 0, 0, 0));

        if (curDay > maxDays) curDay = maxDays;

        return new Date(curYear, curMonth-1, curDay, date.getHours(), date.getMinutes(), date.getSeconds());
    }

    public static function getDates(month:Int, year:Int):Array<Date> {

        var monthString:String = month < 9 ? "0" + (month+1) : "" + (month+1);
        var yearString:String = Std.string(year);

        var referenceDate:Date = Date.fromString('${yearString}-${monthString}-01');
        var maxDays:Int = DateTools.getMonthDays(referenceDate);

        var result:Array<Date> = [];

        for (i in 0 ... maxDays) {
            var dayString:String = i < 9 ? "0" + (i+1) : "" + (i+1);
            result.push(Date.fromString('${yearString}-${monthString}-${dayString}'));
        }

        return result;
    }

    /**
    * -1 : date < toDate
    * 0 : date = toDate
    * +1 date > toDate
    **/
    public static function compare(date:Null<Date>, toDate:Null<Date>):Null<Int> {
        if (date == null || toDate == null) return null;

        var cleanDate:Date = getOnlyDate(date);
        var cleanToDate:Date = getOnlyDate(toDate);

        if (cleanDate.getTime() < cleanToDate.getTime()) return -1;
        if (cleanDate.getTime() > cleanToDate.getTime()) return 1;
        return 0;
    }

    public static function getDatesBetweenDates(dateA:Date, dateB:Date):Array<Date> {

        var result:Array<Date> = [];

        var ta:Float = getOnlyDate(dateA).getTime();
        var tb:Float = getOnlyDate(dateB).getTime();

        var currentTime:Float = ta;
        var dayMS:Float = 1000 * 60 * 60 * 24;

        while (currentTime <= tb) {
            result.push(getOnlyDate(Date.fromTime(currentTime)));
            currentTime += dayMS;
        }

        return result;
    }

    public static function getDaysBetweenDates(dateA:Date, dateB:Date):Int {

        var ta:Float = dateA.getTime();
        var tb:Float = dateB.getTime();

        var delta:Float = tb - ta;

        var dayMS:Float = 1000 * 60 * 60 * 24;

        return Math.floor(delta/dayMS);
    }

    public static function getFirstDay(month:Int, year:Int):Date {
        return new Date(year, month, 1, 0, 0, 0);
    }

    public static function getLastDay(month:Int, year:Int):Date {
        var first:Date = getFirstDay(month, year);
        var lastDay:Int = DateTools.getMonthDays(first);

        return new Date(year, month, lastDay, 0, 0, 0);
    }

    public static function getOnlyDate(date:Date):Date {
        if (date == null) return null;
        return new Date(date.getFullYear(), date.getMonth(), date.getDate(), 0, 0, 0);
    }

    public static function getOnlyTime(date:Date):TimeValue {
        if (date == null) return null;
        return new TimeValue(date.getHours(), date.getMinutes(), date.getSeconds());
    }

    public static function getCurrentDate():Date {
        return getOnlyDate(Date.now());
    }

    public static function getDateMysqlFormat(date:Date):String {
        if (date == null) return "-";
        return DateTools.format(date, "%Y-%m-%d");
    }

    public static function getDateTimeMysqlFormat(date:Date, includeSeconds:Bool = false):String {
        if (date == null) return "-";
        return DateTools.format(date, "%Y-%m-%d %H:%M" + (includeSeconds ? ':%S' : ''));
    }

    public static function getSmallDateString(date:Date):String {
        if (date == null) return "-";
        return DateTools.format(date, "%d/%m");
    }

    public static function getDateString(date:Date):String {
        if (date == null) return "-";
        return DateTools.format(date, "%d/%m/%Y");
    }

    public static function getDateStringEnglish(date:Date):String {
        if (date == null) return "-";
        return DateTools.format(date, "%m/%d/%Y");
    }

    public static function getDateTimeString(date:Date):String {
        if (date == null) return "-";
        return DateTools.format(date, "%d/%m/%Y %H:%Mh");
    }

    public static function getTimeString(date:Date):String {
        if (date == null) return "-";
        return DateTools.format(date, "%H:%M") + "h";
    }

    public static function getMonthYearString(date:Date):String {
        return getMonthName(date.getMonth()) + " " + date.getFullYear();
    }

    public static function getMonthName(monthValue:Int):String {
        return [
            "Janeiro",
            "Fevereiro",
            "Março",
            "Abril",
            "Maio",
            "Junho",
            "Julho",
            "Agosto",
            "Setembro",
            "Outubro",
            "Novembro",
            "Dezembro"
        ][monthValue];
    }

    public static function getExtendedDateString(date:Date):String {
        return date.getDate() + " de " + getMonthName(date.getMonth()) + " de " + date.getFullYear();
    }

    public static function getMysqlDateField(fieldName:String):String return 'DATE_FORMAT($fieldName, \'%Y-%m-%d %H:%i:%s\') as $fieldName';


    public static function isValidDateValue(value:Null<Dynamic>):Bool {
        if (value == null) return false;

        if (Std.isOfType(value, Date)) return true;
        else if (Std.isOfType(value, String)) {
            try {
                var d = DateTime.fromString(value);
                if (d.getYear() >= 1970) return true;
            } catch (e:Dynamic) {}
        } else if (Std.isOfType(value, Float)) {
            try {
                DateTime.fromTime(value);
                return true;
            } catch (e:Dynamic) {}
        }

        return false;
    }


}
