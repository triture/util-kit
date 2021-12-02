package helper.kits;

import haxe.io.Eof;
import sys.io.Process;
import Std;
import String;
import cpp.Lib;

class CommandLineKit {

    inline private static var RED="\033[0;31m";
    inline private static var GREEN="\033[0;32m";
    inline private static var YELLOW="\033[0;33m";
    inline private static var BLUE="\033[34m";
    inline private static var MAGENTA="\033[0;35m";
    inline private static var CYAN="\033[0;36m";
    inline private static var NC="\033[0m";
    inline private static var BOLD="\033[1m";

    inline static public function print(value:Dynamic):String {
        Lib.print("\n" + value);

        return "\n" + Std.string(value);
    }

    inline static public function printInline(value:Dynamic):String {
        Sys.print(value);

        return Std.string(value);
    }

    static public function printTitle(value:Dynamic):Void {
        var text:String = Std.string(value);

        print("");
        print(" " + text.toUpperCase());
        print(" " + ([for (i in 0 ... text.length) "="].join("")));
        print("");

    }

    static public function printTab(value:Dynamic, tabs:Int = 0, tabsChar:String = "  "):String {
        var text:String = Std.string(value);
        var tabs:String = " " + ([for (i in 0 ... tabs) tabsChar].join(""));

        return print(tabs + text);
    }

    static public function printIndex(index:String, value:Dynamic):String {
        var text:String = Std.string(value);
        var inserts:Int = index.split(".").length;

        return printTab(index + " " + text, inserts, "  ");
    }

    inline public static function red(s:String, bold:Bool=false):String return '${bold?BOLD:""}${RED}${s}${NC}';
    inline public static function green(s:String, bold:Bool=false):String return '${bold?BOLD:""}${GREEN}${s}${NC}';
    inline public static function yellow(s:String, bold:Bool=false):String return '${bold?BOLD:""}${YELLOW}${s}${NC}';
    inline public static function blue(s:String, bold:Bool=false):String return '${bold?BOLD:""}${BLUE}${s}${NC}';
    inline public static function magenta(s:String, bold:Bool=false):String return '${bold?BOLD:""}${MAGENTA}${s}${NC}';
    inline public static function cyan(s:String, bold:Bool=false):String return '${bold?BOLD:""}${CYAN}${s}${NC}';



    public static function isRunning():Bool {

        try {
            var processName:String = "";

            var process:Process = null;

            if (Sys.systemName() == "Windows") {
                processName = Sys.programPath().split("\\").slice(-1)[0];
                process = new Process("tasklist");
            } else {
                processName = Sys.programPath().split("/").slice(-1)[0];
                process = new Process("ps", ["aux"]);
            }

            var loading = true;
            var processCount:Int = 0;

            while (loading) {
                try  {
                    var line = process.stdout.readLine();
                    if (line.indexOf(processName) > -1) {
                        processCount++;
                        if (processCount > 1) return true;
                    }

                } catch (e:Eof) {
                    loading = false;
                }
            }

            process.close();

        } catch (e:Dynamic) {
            trace("erro");
        }



        return false;
    }

}
