package abstracts;

abstract AbstractDateTimeUTCFormat(String) {

    @:to inline public function toDate():Date {
        if (this == null || this == "") return null;
        var value:String = this;
        if (value.split(":").length == 2) value = value + ":00";

        var date:Date = Date.fromString(value);

        #if (js || flash || php || cpp || python)
        return Date.fromTime(DateTools.makeUtc(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds()));
        #else
        return date;
        #end
    }

    inline function new(value:String) {
        this = value;
    }
}
