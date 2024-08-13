package helper.types;

abstract TimeMiliMeasure(Float) to Float from Float {
    #if !sys
    inline public function toSeconds():Float return this == null ? null : this/1000;
    inline public function toMinutes():Float return this == null ? null : toSeconds()/60;
    inline public function toHours():Float return this == null ? null : toMinutes()/60;
    inline public function toDays():Float return this == null ? null : toHours()/24;
    #end

}
