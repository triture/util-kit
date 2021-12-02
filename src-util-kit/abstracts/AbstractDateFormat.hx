package abstracts;

import helper.kits.DateKit;

abstract AbstractDateFormat(String) {

    @:from inline static public function fromDate(value:Date):AbstractDateFormat {
        return new AbstractDateFormat(DateKit.getDateMysqlFormat(value));
    }

    @:to inline public function toDate():Date {
        if (this == null || this == "") return null;
        return Date.fromString(this);
    }

    inline public function toReaderString():String {
        if (this == null || this == "") return "";
        return DateKit.getDateString(Date.fromString(this));
    }

    inline function new(value:String) {
        this = value;
    }
}
