package helper.types;

import helper.kits.DateKit;

abstract DateValue(String) {

    @:from inline static public function fromDate(value:Date):DateValue {
        return new DateValue(DateKit.getDateMysqlFormat(value));
    }

    @:to inline public function toDate():Date {
        if (this == null || this == "") return null;
        return Date.fromString(this);
    }

    inline function new(value:String) {
        this = value;
    }
}
