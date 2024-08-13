package helper.maker;

class CSVMaker {

    public function new() {

    }

    public static function encode(data:Array<Array<String>>, delimiter:String = ','):String {
        var options:Dynamic = {};
        options.delimiter = delimiter;
        options.quote = '"';
        options.escapedQuote = options.quote == '"' ? '""' : '\\${options.quote}';
        options.newline = '\n';

        return data.map(function(row:Array<String>):String {
            return row.map(function(cell:String):String {
                if (cell == null) return '';

                if (requiresQuotes(cell, options.delimiter, options.quote)) return applyQuotes(cell, options.quote, options.escapedQuote);
                else return cell;

            }).join(options.delimiter);
        }).join(options.newline);
    }

    static function requiresQuotes(value:String, delimiter:String, quote:String):Bool {
        return (value.indexOf(delimiter) > -1) || (value.indexOf(quote) > -1) || (value.indexOf('\n') > -1) || (value.indexOf('\r') > -1);
    }

    static function applyQuotes(value:String, quote:String, escapedQuote:String):String {
        value = value.split(quote).join(escapedQuote);
        return '$quote$value$quote';
    }

}