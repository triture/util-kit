package util.kit.lang;

#if macro
import haxe.Resource;
import haxe.macro.Context;

class LangMacro {
    
    static public function build() {
        var m = new LangMacro();
        return m.process();
    }

    public function new() {
        
    }

    private function getLangResource():Dynamic {
        try {
            for (name in Resource.listNames()) {
                if (name.indexOf("lang-") == 0) {
                    var data:Dynamic = haxe.Json.parse(Resource.getString(name));
                    return data;
                }
            }
        } catch (e:Dynamic) {
            Context.warning("Error loading language resource: " + e, Context.currentPos());
        }

        return null;
    }

    private function process() {
        var fields = Context.getBuildFields();

        var data:Dynamic = this.getLangResource();

        if (data == null) return fields;

        var dict = LangSupport.processDictionary(data);

        for (key in dict.keys()) {
            fields.push({
                name : key,
                pos : Context.currentPos(),
                kind : FVar(null, null),
                access : [AAbstract]
            });
        }

        return fields;
    }
}

#end