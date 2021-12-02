package helper.kits;

private typedef CSVOption = {
    @:optional var delimiter:String;
    @:optional var quote:String;
    @:optional var escapedQuote:String;
    @:optional var newline:String;
}

class CsvKit {

    public function new() {

    }

    public static function encode(data:Array<Array<String>>):String {
        var options:CSVOption = {};
        options.delimiter = ",";
        options.quote = '"';
        options.escapedQuote = options.quote == '"' ? '""' : '\\${options.quote}';
        options.newline = '\n';

        return data.map(
            function(row:Array<String>) {
                return row.map(
                    function(cell:String) {
                        if (requiresQuotes(cell, options.delimiter, options.quote)) {
                            return applyQuotes(cell, options.quote, options.escapedQuote);
                        } else return cell;
                    }
                ).join(options.delimiter);
            }
        ).join(options.newline);
    }

    static function requiresQuotes(value:String, delimiter:String, quote:String):Bool {
        return (value.indexOf(delimiter) > -1) || (value.indexOf(quote) > -1) || (value.indexOf('\n') > -1) || (value.indexOf('\r') > -1);
    }

    static function applyQuotes(value:String, quote:String, escapedQuote:String):String {
        value = value.split(quote).join(escapedQuote);
        return '$quote$value$quote';
    }


    public static function decode(data:String):Array<Array<String>> {
        var options:Dynamic = {};
        options.delimiter = ",";
        options.quote = '"';
        options.escapedQuote = options.quote == '"' ? '""' : '\\${options.quote}';
        options.newline = '\n';

        if (options.trimEmptyLines) data = data.split('\n\r').join("");

// removendo espacos
        data = data.split(" ").join("");

        var lines:Array<String> = data.split(options.newline);

        var i:Int = 0;
        var n:Int = lines.length;

        var result:Array<Array<String>> = [];

// https://regex101.com/r/tS5mB9/1
        var r:EReg = ~/(?:(?<=^)|(?<=,))(?:(?!$)\s)*"?((?<=").*?(?=")|((?!,)\S)*)"?(?:(?!$)\s)*(?=$|,)/gms;



        while (i < n) {
            var line:String = lines[i];

            var lineSplit:Array<String> = [];

            r.map(line, function(r:EReg):String {
                lineSplit.push(StringTools.trim(r.matched(1)));
                return "";
            });

            result.push(lineSplit);

            i++;
        }

        return result;
    }

}
