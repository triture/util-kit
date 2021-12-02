package helper.phones;

import helper.kits.StringKit;

class PhoneNormalizer {

    public static function normalizePhones(data:Array<String>, defaultDDD:Int, defaultDDI:Int = 55):Array<PhoneModel> {
        var valids:Array<String> = filterValidNumbers(data);
        var result:Array<PhoneModel> = [];

        for (phone in valids) {
            var phoneModel:PhoneModel = convertNumberToPhone(phone, defaultDDD, defaultDDI);
            if (phoneModel != null) result.push(phoneModel);
        }

        return result;
    }

    private static function convertNumberToPhone(phone:String, defaultDDD:Int, defaultDDI:Int = 55):PhoneModel {
        if (phone == null) return null;

        // 55 11 986363051

        // remover zeros da frente
        var phoneToUse:String = phone;
        while (phoneToUse.length > 0 && phoneToUse.charAt(0) == "0") phoneToUse = phoneToUse.substr(1);


        if (phoneToUse.length >= 8 && phoneToUse.length <= 9) {
            return {
                area : defaultDDD,
                countryCode : defaultDDI,
                phone : phoneToUse
            }
        } else if (phoneToUse.length >= 10 && phoneToUse.length <= 11) {
            return {
                countryCode : defaultDDI,
                area : Std.parseInt(phoneToUse.substr(0, 2)),
                phone : phoneToUse.substr(2)
            }
        } else if (phoneToUse.length >= 12 && phoneToUse.length <= 13) {
            return {
                countryCode : Std.parseInt(phoneToUse.substr(0, 2)),
                area : Std.parseInt(phoneToUse.substr(2, 2)),
                phone : phoneToUse.substr(4)
            }
        }

        return null;
    }

    private static function filterValidNumbers(data:Array<String>):Array<String> {

        var result:Array<String> = [];

        for (value in data) {

            if (value != null) {

                if (value.indexOf("/") > -1) {
                    result = result.concat(filterValidNumbers(value.split("/")));
                } else if (value.indexOf("\\") > -1) {
                    result = result.concat(filterValidNumbers(value.split("\\")));
                } else {

                    value = StringKit.getAllowedChars(value, "0123456789");

                    if (value.length > 4) result.push(value);
                }
            }
        }

        return result;
    }
}
