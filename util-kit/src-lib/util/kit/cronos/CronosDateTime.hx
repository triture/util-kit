package util.kit.cronos;

import datetime.DateTime;

abstract CronosDateTime(String) {
        
    public function new(dateTime:DateTime) {
        this = dateTime.format('%F %T');
    }

    static public function now():CronosDateTime return new CronosDateTime(DateTime.now());
    
    @:to public function toString():String return this;

    @:from static public function fromString(date:String):CronosDateTime {
        var dateTime:DateTime = DateTime.fromString(date);
        return new CronosDateTime(dateTime);
    }

    @:to public function toDateTime():DateTime return DateTime.fromString(this);

    @:from static public function fromDateTime(dateTime:DateTime):CronosDateTime return new CronosDateTime(dateTime);

    @:to public function toDate():Date return Date.fromString(this);

    @:from static public function fromDate(date:Date):CronosDateTime return new CronosDateTime(DateTime.fromDate(date));
    
}