package util.kit.path;

typedef PathPartData = {
    var part:String;
    var is_param:Bool;
    
    @:optional var param:String;
    @:optional var type:PathParamType;
}