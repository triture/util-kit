package helper.kits;

import helper.kits.DateKit;
import haxe.ds.StringMap;

using StringTools;

class StringKit {

    public static function removeQuotes(value:String):String {
        if (value.length > 1 && value.charAt(0) == '"' && value.charAt(value.length-1) == '"') {
            return value.substring(1, value.length-1);
        } else return value;
    }

    public static function getWordSurroundingCharAt(value:String, position:Int):String {
        var words:Array<String> = value.split(' ');
        var lastWord:String = '';

        if (words.length == 1) return value;
        else {
            var count:Int = 0;

            for (word in words) {
                if (!isEmpty(word)) lastWord = word;

                count += word.length;
                if (count >= position) return lastWord;
                count ++; // add space
            }

            return lastWord;
        }
    }

    public static function simpleScape(value:String):String {
        if (value == null) return "";

        var finalValue:String = Std.string(value);

        finalValue = htmlEscape(finalValue);
        finalValue = finalValue.replace("\n", "<br>");
        finalValue = finalValue.replace("{[[", "<b>");
        finalValue = finalValue.replace("]]}", "</b>");

        return finalValue;
    }

    public static function getValueOrEmptyString(value:String):String return value != null ? value : '';

    public static function getFirstFilledValue(values:Array<String>, defaultValue:Null<String> = null):Null<String> {

        for (item in values) {
            if (!isEmpty(item)) return item;
        }

        return defaultValue;

    }

    public static function preventBreakLine(value:Null<String>, html:Bool = true):Null<String> {
        if (value == null) return value;

        var finalValue:String = value;
        finalValue = finalValue.replace('\n', ' ');
        finalValue = finalValue.replace('\r', ' ');
        if (html) finalValue = finalValue.replace('<br>', ' ');

        return finalValue;
    }

    public static function getBetweenTags(content:String, startTag:String, endTag:String):String {

        var contentLower:String = content.toLowerCase();

        var startIndex:Int = contentLower.indexOf(startTag.toLowerCase()) + startTag.length;
        var endIndex:Int = contentLower.indexOf(endTag.toLowerCase());

        if (startIndex == (startTag.length-1) && endIndex > -1) {
            // start not found but end index exists
            return content.substring(0, endIndex);
        } else if (startIndex >= startTag.length && endIndex < 0) {
            // start index exists but end index dont
            return content.substring(startIndex);
        } else if (startIndex == (startTag.length-1) && endIndex < 0) {
            // both not found
            return content;
        } else {

            // both exists

            if (startIndex <= endIndex) {
                return content.substring(startIndex, endIndex);
            } else {
                return content.substring(endIndex, startIndex);
            }

        }
    }

    public static function replaceBetweenTags(content:String, startTag:String, endTag:String, replaceWith:String):String {

        var contentLower:String = content.toLowerCase();

        var startIndex:Int = contentLower.indexOf(startTag.toLowerCase());
        var endIndex:Int = contentLower.indexOf(endTag.toLowerCase()) + endTag.length;

        if (startIndex == (startTag.length-1) && endIndex > -1) {
            // start not found but end index exists
            startIndex = 0;
        } else if (startIndex >= startTag.length && endIndex < 0) {
            // start index exists but end index dont
            endIndex = content.length - 1;
        } else if (startIndex == (startTag.length-1) && endIndex < 0) {
            // both not found
            return content;
        } else {

            // both exists
            if (startIndex > endIndex) {
                var temp_end = endIndex;
                startIndex = endIndex;
                endIndex = temp_end;
            }
        }

        var result:String = content.substring(0, startIndex) + replaceWith + content.substring(endIndex, content.length-1);

        return result;
    }

    public static function splitSQL(multiQuery:String):Array<String> {
        var result:Array<String> = [];

        var insideDoubleQuote:Bool = false;
        var insideSingleQuote:Bool = false;

        var query:String = "";

        for (i in 0 ... multiQuery.length) {

            var currLetter:String = multiQuery.charAt(i);
            var lastLetter:String = multiQuery.charAt(i-1);


            if (!insideDoubleQuote && !insideSingleQuote && currLetter == '"') insideDoubleQuote = true;
            else if (!insideDoubleQuote && !insideSingleQuote && currLetter == "'") insideSingleQuote = true;
            else {

                if (insideDoubleQuote && currLetter == '"' && lastLetter != "\\") insideDoubleQuote = false;
                else if (insideSingleQuote && currLetter == "'" && lastLetter != "\\") insideSingleQuote = false;

            }

            if (!insideDoubleQuote && ! insideDoubleQuote && currLetter == ";") {
                if (StringTools.trim(query) != "") result.push(query);
                query = "";
            } else {
                query += currLetter;
            }
        }

        if (StringTools.trim(query) != "") result.push(query);

        return result;
    }

    public static function makeSnake(value:String):String {

        var data:String = value.toLowerCase();
        data = stripSpecialChars(data, 'abcdefghijklmnopqrstuvxywz _-');
        data = data.split(" ").join("_");
        data = data.split("-").join("_");

        return data;

    }

    public static function generateRandomHex(bytesLen:Int):String {
        return generateRandomString(bytesLen * 2, '0123456789abcdef'.split(''));
    }

    public static function generateRandomString(len:Int, ?allowedChars:Array<String> = null):String {
        if (allowedChars == null) allowedChars = "abcdefghijklmnopqrstuvxywz0123456789".split("");
        var result:String = "";

        if (allowedChars.length == 0) return result;

        for (i in 0 ... len) result += allowedChars[Math.floor(Math.random()*allowedChars.length)];

        return result;
    }

    // Verifica se todas as palavras declaradas em SEARCHFOR se encontra em alguma posição de SEARCHIN
    public static function matchValue(searchFor:String, searchIn:String):Bool {
        searchFor = StringTools.trim(searchFor);
        if (searchFor.length == 0) return true;

        searchFor = stripSpecialChars(searchFor.toLowerCase());
        searchIn = stripSpecialChars(StringTools.trim(searchIn).toLowerCase());

        var pieces:Array<String> = searchFor.split(" ");

        for (piece in pieces) if (searchIn.indexOf(piece) == -1) return false;

        return true;
    }

    // Verifica se VALUE existe dentro da string SEARCHIN
    public static function existsIn(searchIn:String, value:String):Bool {
        var value:String = StringTools.trim(value);
        if (value.length == 0) return true;

        value = stripSpecialChars(value.toLowerCase());

        var searchIn:String = stripSpecialChars(StringTools.trim(searchIn).toLowerCase());

        if (searchIn.indexOf(value) == -1) return false;
        return true;
    }

    public static function filterList(filter:String, values:Array<String>, breakFilter:Bool = false):Array<String> {

        var valueFilter:String = stripSpecialChars(StringTools.trim(filter).toLowerCase());
        if (valueFilter.length == 0) return values;

        var filterListBlock:Array<String> = breakFilter ? valueFilter.split(" ") : [valueFilter];

        // clean filter
        var filterListValues:Array<String> = [];
        for (filterValue in filterListBlock) {
            if (StringTools.trim(filterValue).length > 2) filterListValues.push(filterValue);
        }

        if (filterListValues.length == 0) return values;

        var result:Array<String> = [];

        for (item in values) {

            var toSearch:String = stripSpecialChars(item.toLowerCase());

            var add:Bool = true;

            for (filter in filterListValues) {
                if (toSearch.indexOf(filter) == -1) {
                    add = false;
                    break;
                }
            }

            if (add) result.push(item);
        }

        return result;
    }

    private static var STRIP_A:Array<String> = ["á", "à", "ã", "â", "ä"];
    private static var STRIP_E:Array<String> = ["é", "è", "ë", "ê"];
    private static var STRIP_I:Array<String> = ["í", "ì", "ï"];
    private static var STRIP_O:Array<String> = ["ó", "ò", "õ", "ö", "ô"];
    private static var STRIP_U:Array<String> = ["ú", "ù", "ü", "û"];
    private static var STRIP_C:Array<String> = ["ç"];

    public static function stripSpecialChars(value:String, allowed:String = ""):String {
        var result:String = value;

        if (allowed == "") allowed = "abcdefghijklmnopqrstuvxwyz 1234567890-_";

        result = replace(result, STRIP_A, "a");
        result = replace(result, STRIP_E, "e");
        result = replace(result, STRIP_I, "i");
        result = replace(result, STRIP_O, "o");
        result = replace(result, STRIP_U, "u");
        result = replace(result, STRIP_C, "c");

        result = getAllowedChars(result, allowed);

        return result;
    }

    public static function getLabelForData(data:Dynamic, field:String):String {
        var result:String = "";

        if (field != null && field != "") {
            var val:Dynamic = Reflect.getProperty(data, field);
            if (val == null) result = Std.string(data);
            else result = Std.string(val);
        } else {
            result = Std.string(data);
        }

        return result;
    }


    public static function formatToDate(value:String):String {
        if (value == null) return null;

        var date:Date = DateKit.convertToDate(DateKit.applyDateMask(value), false);

        if (date == null) return null;
        else {
            return DateTools.format(date, "%d/%m/%Y");
        }
    }

    public static function formatToToken(value:String):String {
        var cleanValue:String = stripSpecialChars(value.toUpperCase(), "ABCDEFGHIJKLMNOPQRSTUVXWYZ0123456789");
        var finalValue:String = "";

        for (i in 0 ... cleanValue.length) {

            if (i > 0 && i%4 == 0 && i < 16) {
                finalValue += "-" + cleanValue.charAt(i);
            } else {
                finalValue += cleanValue.charAt(i);
            }

        }

        return finalValue;
    }

    public static function formatToCPF(value:String):String {
        if (value == null) return "";

        var result:String = getAllowedChars(value, "0123456789");

        // 004.630.025-20
        if (result.length == 11) {
            result = result.substr(0, 3) + "." + result.substr(3, 3) + "." + result.substr(6, 3) + "-" + result.substr(9, 2);
        }

        return result;
    }

    public static function replace(value:String, itensToReplace:Array<String>, replaceWith:String):String {
        var result:String = value;

        for (item in itensToReplace) {
            result = result.split(item).join(replaceWith);
        }

        return result;
    }

    public static function replaceMap(value:String, replace:StringMap<String>):String {
        var result:String = value;

        for (key in replace.keys()) {
            result = result.split(key).join(replace.get(key));
        }

        return result;
    }

    public static function getAllowedChars(value:String, allowed:String = ""):String {
        if (allowed == null || allowed == "") return value;

        var result:String = "";

        for (i in 0 ... value.length) {
            if (allowed.indexOf(value.charAt(i)) > -1) result += value.charAt(i);
        }

        return result;
    }

    public static function removeDuplicatedSpaces(value:String):String {
        var result:String = value;

        while (result.indexOf("  ") > -1) {
            result = result.split("  ").join(" ");
        }

        result = StringTools.trim(result);
        return result;
    }

    public static function getFirstName(fullname:String):String {
        var full:String = StringKit.removeDuplicatedSpaces(fullname);
        var breakName:Array<String> = full.split(" ");
        var firstName:String = "";
        if (breakName.length > 1) breakName.pop();
        firstName = breakName.join(" ");
        return firstName;
    }

    public static function removeBreaks(value:String):String {
        var result:String = value;

        result = result.split("<br>").join(" ");
        result = result.split("<BR>").join(" ");
        result = result.split("\n").join(" ");

        return result;
    }

    public static function getLastName(fullname:String):String {
        var full:String = StringKit.removeDuplicatedSpaces(fullname);
        var breakName:Array<String> = full.split(" ");
        var lastName:String = "";
        if (breakName.length > 1) lastName = breakName.pop();
        return lastName;
    }

    public static function getEmail(value:String):Null<String> {
        var ereg:EReg = ~/[A-Z0-9]+[A-Z0-9._%-]*@[A-Z0-9]+[A-Z0-9.-]*\.[A-Z][A-Z][A-Z]?/i;

        if (ereg.match(value)) return ereg.matched(0).toLowerCase();
        else return null;
    }

    public static function isEmail(email:String):Bool {
        var emailExpression:EReg = ~/[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z][A-Z][A-Z]?/i;
        return emailExpression.match(email);
    }

    public static function isURL(value:String):Bool {
        if (isEmpty(value)) return false;

        var e = new EReg(
            "^" +
                // protocol identifier (optional)
                // short syntax // still required
            "(?:(?:(?:https?|ftp):)?\\/\\/)" +
                // user:pass BasicAuth (optional)
            "(?:\\S+(?::\\S*)?@)?" +
            "(?:" +
                // IP address exclusion
                // private & local networks
            "(?!(?:10|127)(?:\\.\\d{1,3}){3})" +
            "(?!(?:169\\.254|192\\.168)(?:\\.\\d{1,3}){2})" +
            "(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})" +
                // IP address dotted notation octets
                // excludes loopback network 0.0.0.0
                // excludes reserved space >= 224.0.0.0
                // excludes network & broadcast addresses
                // (first & last IP address of each class)
            "(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])" +
            "(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}" +
            "(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))" +
            "|" +
                // host & domain names, may end with dot
                // can be replaced by a shortest alternative
                // (?![-_])(?:[-\\w\\u00a1-\\uffff]{0,63}[^-_]\\.)+
            "(?:" +
            "(?:" +
            "[a-z0-9\\u00a1-\\uffff]" +
            "[a-z0-9\\u00a1-\\uffff_-]{0,62}" +
            ")?" +
            "[a-z0-9\\u00a1-\\uffff]\\." +
            ")+" +
                // TLD identifier name, may end with dot
            "(?:[a-z\\u00a1-\\uffff]{2,}\\.?)" +
            ")" +
                // port number (optional)
            "(?::\\d{2,5})?" +
                // resource path (optional)
            "(?:[/?#]\\S*)?" +
            "$", "i"
        );

        return e.match(value);
    }

    public static function trim(value:Null<String>):String {
        if (value == null) return '';
        else {
            value = value.split(String.fromCharCode(160)).join(' ');
            return StringTools.trim(value);
        }
    }

    public static function isNumericInt(value:Null<String>):Bool {
        if (StringKit.isEmpty(value)) return false;
        else if (Std.parseInt(value) != null) return true;
        else return false;
    }

    public static function isEmpty(value:Null<String>):Bool {
        if (value == null) return true;
        else if (StringKit.trim(value).length == 0) return true;
        else return false;
    }

    public static function htmlEscape(value:String):String {
        if (value == null) return '';
        return value.htmlEscape();
    }

    public static function isSemanticVersion(value:String):Bool {
        if (isEmpty(value)) return false;
        else {
            var b:Array<String> = value.split('.');

            if (b.length != 3) return false;
            else {

                for (part in b) if (
                    (part != '0' && part.charAt(0) == '0')
                    || !isNumericInt(part)
                ) return false;
                return true;
            }
        }
    }

    public static function isValidJson(value:String):Bool {
        if (isEmpty(value)) return false;
        
        try {
            var json:Dynamic = haxe.Json.parse(value);
            return true;
        } catch (e:Dynamic) {
            return false;
        }
    }

}
