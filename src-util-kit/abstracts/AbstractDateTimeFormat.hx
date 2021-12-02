package abstracts;

import helper.kits.DateKit;

abstract AbstractDateTimeFormat(String) {

    @:from inline static public function fromDate(value:Date):AbstractDateTimeFormat {
        return new AbstractDateTimeFormat(DateKit.getDateTimeMysqlFormat(value, true));
    }

    @:to inline public function toDate():Date {
        if (this == null || this == "") return null;
        var value:String = this;
        if (value.split(":").length == 2) value = value + ":00";
        return Date.fromString(value);
    }

    @:to inline public function toString():String {
        if (this == null || this == "") return "";

        var date:Date = toDate();
        return DateKit.getDateTimeString(date);
    }

    inline function new(value:String) {
        this = value;
    }
}
