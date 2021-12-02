package helper.types;

class TimeValue {

    @:isVar public var hours(default, set):Int;
    @:isVar public var minutes(default, set):Int;
    @:isVar public var seconds(default, set):Int;

    public function new(hours:Int = null, minutes:Int = null, seconds:Int = null) {
        var current:Date = Date.now();

        this.hours = hours == null ? current.getHours() : hours;
        this.minutes = minutes == null ? current.getMinutes() : minutes;
        this.seconds = seconds == null ? current.getSeconds() : seconds;
    }

    private function set_hours(value:Int):Int {
        if (value == this.hours) return value;
        if (value >= 24 || value < 0) throw "Invalid Hours Value : " + value;
        return this.hours = value;
    }

    private function set_minutes(value:Int):Int {
        if (value == this.minutes) return value;
        if (value >= 60 || value < 0) throw "Invalid Minutes Value : " + value;
        return this.minutes = value;
    }

    private function set_seconds(value:Int):Int {
        if (value == this.seconds) return value;
        if (value >= 60 || value < 0) throw "Invalid Seconds Value : " + value;
        return this.seconds = value;
    }

    public function toString():String {
        return (this.hours < 10 ? '0${this.hours}' : '${this.hours}') + ":" + (this.minutes < 10 ? '0${this.minutes}' : '${this.minutes}');
    }

    public function fromString(value:String):Void {
        var block:Array<String> = value.split(":");

        if (block.length > 0) this.hours = Std.parseInt(block[0]);
        else this.hours = 0;

        if (block.length > 1) this.minutes = Std.parseInt(block[1]);
        else this.minutes = 0;

        if (block.length > 2) this.seconds = Std.parseInt(block[2]);
        else seconds = 0;
    }
}
