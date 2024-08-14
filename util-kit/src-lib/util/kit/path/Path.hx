package util.kit.path;

import helper.kits.StringKit;
import haxe.ds.StringMap;

abstract Path(String) {

    inline private function new(value:String) {
        this = value;
    }

    @:from
    inline static private function fromString(value:String):Path return new Path(value);

    inline public function parts():Array<PathPartData> {
        var result:Array<PathPartData> = [];

        var capturedParams:StringMap<Int> = new StringMap<Int>();
        var pathParts:Array<String> = supportBreakParts(this);

        for (part in pathParts) {
            var param:PathParamData = supportGetParam(part);

            if (param == null) {
                result.push({part: part, is_param: false});
                continue;
            }


            if (!capturedParams.exists(param.param)) capturedParams.set(param.param, 1);
            else {
                capturedParams.set(param.param, capturedParams.get(param.param) + 1);
                param.param += '_' + capturedParams.get(param.param);
            }

            result.push({part: part, is_param: true, param: param.param, type: param.type});
        }

        return result;
    }

    private function supportBreakParts(value:String):Array<String> {
        var result:Array<String> = [];
        var parts:Array<String> = value.split('/');

        for (part in parts) if (part != '') result.push(StringTools.urlDecode(part));
        
        return result;
    }

    inline private function supportCreateEReg():EReg {
        return new EReg('^{([a-zA-Z_]+[\\w_]?):(Int|String|Float|Bool)}$', "");
    }

    public function params():Array<PathParamData> {
        var result:Array<PathParamData> = [];
        var parts:Array<PathPartData> = parts();
        
        for (part in parts) {
            if (part.is_param) result.push({param: part.param, type: part.type});
        }

        return result;
    }

    private function supportGetParam(part:String):PathParamData {
        var r:EReg = supportCreateEReg();
        
        if (r.match(part)) {
            var param:String = r.matched(1);
            var type:PathParamType = r.matched(2);

            return {
                param: param, 
                type: type
            };
        }

        return null;
    }

    public function match(toMatch:String):PathMatchData {
        var result:PathMatchData = {matched: true, params: [] };

        var pathParts:Array<PathPartData> = parts();
        var toMatchParts:Array<String> = supportBreakParts(toMatch);

        if (pathParts.length != toMatchParts.length) return {matched: false, params: [] };

        for (i in 0 ... pathParts.length) {
            var pathPart:PathPartData = pathParts[i];
            var toMatchPart:String = toMatchParts[i];

            if (!pathPart.is_param && pathPart.part != toMatchPart) return {matched: false, params: [] };
            else if (pathPart.is_param) {

                switch (pathPart.type) {
                    case STRING : {
                        result.params.push({param: pathPart.param, value: toMatchPart, type:STRING});
                    }
                    
                    case PathParamType.INT: {
                        if (!isIntValue(toMatchPart)) return {matched: false, params: [] };
                        result.params.push({param: pathPart.param, value: Std.parseInt(toMatchPart), type: PathParamType.INT});
                    }

                    case PathParamType.FLOAT: {
                        if (!isFloat(toMatchPart)) return {matched: false, params: [] };
                        result.params.push({param: pathPart.param, value: Std.parseFloat(toMatchPart), type: PathParamType.FLOAT});
                    }

                    case PathParamType.BOOL: {
                        if (toMatchPart.toLowerCase() == 'true') {
                            result.params.push({param: pathPart.param, value: true, type: PathParamType.BOOL});
                        } else if (toMatchPart.toLowerCase() == 'false') {
                            result.params.push({param: pathPart.param, value: false, type: PathParamType.BOOL});
                        } else {
                            return {matched: false, params: [] };
                        }
                    }
                }
            }
        }

        return result;
    }

    inline private function isIntValue(value:String):Bool {
        var r:EReg = new EReg('^[-]?[\\d]+$|^[-]?0[xX][0123456789ABCFEFabcdef]+$', "");
        return r.match(value);
    }

    inline private function isFloat(value:String):Bool {
        var r:EReg = new EReg('^[-]?[\\d]+[.]?[\\d]*$', "");
        return r.match(value);
    }
}
