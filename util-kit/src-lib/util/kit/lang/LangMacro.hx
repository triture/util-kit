package util.kit.lang;

#if macro
import haxe.macro.Context;

class LangMacro {
    
    static public function build() {
        var fields = Context.getBuildFields();

        return fields;
    }


}


#end