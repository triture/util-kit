package util.kit.path;

enum abstract PathParamType(String) {
    
    var STRING:PathParamType = 'String';
    var INT:PathParamType = 'Int';
    var FLOAT:PathParamType = 'Float';
    var BOOL:PathParamType = 'Bool';
 
    @:from
    static private function fromString(value:String):PathParamType  {
        return switch value.toLowerCase() {
            case 'string': PathParamType.STRING;
            case 'int': PathParamType.INT;
            case 'float': PathParamType.FLOAT;
            case 'bool': PathParamType.BOOL;
            default : throw 'Invalid PathParamType';
        }
    }
}