package util.kit.test.unit.lang;

import utest.Assert;
import utest.Test;

using util.kit.lang.Lang;

class TestLang extends Test {
    
    function test_print_value_from_language_dictionary() {
        // ARRANGE
        var dictionary:Dynamic = {
            WORD : "Hello"
        }

        var valueKey:String = "WORD";

        var expected:String = "Hello";
        var result:String;

        // ACT
        Lang.load(dictionary);
        result = Lang.lang(valueKey);

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_dictionary_keys_are_case_insensitives() {
        // ARRANGE
        var dictionary:Dynamic = {
            WOrd : "Hello"
        }
        
        var valueKey:String = "WoRd";

        var expected:String = "Hello";
        var result:String;

        // ACT
        Lang.load(dictionary);
        result = Lang.lang(valueKey);

        // ASSERT
        Assert.equals(expected, result);

    }

    function test_dictionary_can_process_rest_parameters() {
        // ARRANGE
        var dictionary:Dynamic = {
            KEY : "Some values: $v, $v, $v"
        }

        var valueKey:String = "KEY";

        var expected:String = "Some values: a, b, c";
        var result:String;

        // ACT
        Lang.load(dictionary);
        result = valueKey.lang("a", "b", "c");

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_dictionary_can_replace_rest_parameter_with_same_parameter_key() {
        // ARRANGE
        var dictionary:Dynamic = {
            KEY : "Some values: $v, $v"
        }

        var valueKey:String = "KEY";

        var expected:String = "Some values: $v, a";
        var result:String;

        // ACT
        Lang.load(dictionary);
        result = valueKey.lang("$v", "a");

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_null_values_should_be_replaced_with_empty_string() {
        // ARRANGE
        var dictionary:Dynamic = {
            KEY : "Some values: $v, $v, $v"
        }

        var valueKey:String = "KEY";

        var expected:String = "Some values: a, , c";
        var result:String;

        // ACT
        Lang.load(dictionary);
        result = valueKey.lang("a", null, "c");

        // ASSERT
        Assert.equals(expected, result);

    }

    function test_dictionary_accept_grouping_values() {
        // ARRANGE
        var dictionary:Dynamic = {
            SIMPLE_KEY : "KEY",

            GROUP : {
                A : "a",
                B : "b",
                C : {
                    D : "d"
                }
            }
        }

        var valueKey1:String = "SIMPLE_KEY";
        var valueKey2:String = "GROUP_A";
        var valueKey3:String = "GROUP_B";
        var valueKey4:String = "GROUP_C_D";

        var expected1:String = "KEY";
        var expected2:String = "a";
        var expected3:String = "b";
        var expected4:String = "d";

        var result1:String;
        var result2:String;
        var result3:String;
        var result4:String;

        // ACT
        Lang.load(dictionary);
        result1 = valueKey1.lang();
        result2 = valueKey2.lang();
        result3 = valueKey3.lang();
        result4 = valueKey4.lang();

        // ASSERT
        Assert.equals(expected1, result1);
        Assert.equals(expected2, result2);
        Assert.equals(expected3, result3);
        Assert.equals(expected4, result4);
        
    }
    
    function test_dictionary_accept_array_values() {
        // ARRANGE
        var dictionary:Dynamic = {
            DATA : [
                "a",
                "b",
                "c",
                "d"
            ]
        }

        var valueKey1:String = "DATA_0";
        var valueKey2:String = "DATA_1";
        var valueKey3:String = "DATA_2";
        var valueKey4:String = "DATA_3";

        var expected1:String = "a";
        var expected2:String = "b";
        var expected3:String = "c";
        var expected4:String = "d";

        var result1:String;
        var result2:String;
        var result3:String;
        var result4:String;

        // ACT
        Lang.load(dictionary);
        result1 = valueKey1.lang();
        result2 = valueKey2.lang();
        result3 = valueKey3.lang();
        result4 = valueKey4.lang();

        // ASSERT
        Assert.equals(expected1, result1);
        Assert.equals(expected2, result2);
        Assert.equals(expected3, result3);
        Assert.equals(expected4, result4);
        
    }

    function test_using_resource_english_dictionary() {
        // ARRANGE
        var valueLanguage:String = "en";
        
        var value_TEST = Lang.TEST;
        var value_A_B_C = Lang.A_B_C;
        var value_A_D = Lang.A_D;
        var value_N_0 = Lang.N_0;
        var value_N_1 = Lang.N_1;

        var expected_TEST = "en.Test";
        var expected_A_B_C = "en.A.B.C";
        var expected_A_D = "en.A.D";
        var expected_N_0 = "en.N.0";
        var expected_N_1 = "en.N.1";

        var result_TEST:String;
        var result_A_B_C:String;
        var result_A_D:String;
        var result_N_0:String;
        var result_N_1:String;

        // ACT
        Lang.setLanguage(valueLanguage);
        
        result_TEST = Lang.lang(value_TEST.key());
        result_A_B_C = Lang.lang(value_A_B_C.key());
        result_A_D = Lang.lang(value_A_D.key());
        result_N_0 = Lang.lang(value_N_0.key());
        result_N_1 = Lang.lang(value_N_1.key());

        // ASSERT
        Assert.equals(expected_TEST, result_TEST);
        Assert.equals(expected_A_B_C, result_A_B_C);
        Assert.equals(expected_A_D, result_A_D);
        Assert.equals(expected_N_0, result_N_0);
        Assert.equals(expected_N_1, result_N_1);
        
    }

    function test_using_resource_portuguese_dictionary() {
        // ARRANGE
        var valueLanguage:String = "pt";
        
        var value_TEST = Lang.TEST;
        var value_A_B_C = Lang.A_B_C;
        var value_A_D = Lang.A_D;
        var value_N_0 = Lang.N_0;
        var value_N_1 = Lang.N_1;

        var expected_TEST = "pt.Test";
        var expected_A_B_C = "pt.A.B.C";
        var expected_A_D = "pt.A.D";
        var expected_N_0 = "pt.N.0";
        var expected_N_1 = "pt.N.1";

        var result_TEST:String;
        var result_A_B_C:String;
        var result_A_D:String;
        var result_N_0:String;
        var result_N_1:String;

        // ACT
        Lang.setLanguage(valueLanguage);

        result_TEST = Lang.lang(value_TEST.key());
        result_A_B_C = Lang.lang(value_A_B_C.key());
        result_A_D = Lang.lang(value_A_D.key());
        result_N_0 = Lang.lang(value_N_0.key());
        result_N_1 = Lang.lang(value_N_1.key());

        // ASSERT
        Assert.equals(expected_TEST, result_TEST);
        Assert.equals(expected_A_B_C, result_A_B_C);
        Assert.equals(expected_A_D, result_A_D);
        Assert.equals(expected_N_0, result_N_0);
        Assert.equals(expected_N_1, result_N_1);
        
    }

    function test_using_enum_keys_to_get_value() {
        // ARRANGE
        var valueLanguage:String = "pt";
        
        var value_TEST = Lang.TEST;
        var value_A_B_C = Lang.A_B_C;
        var value_A_D = Lang.A_D;
        var value_N_0 = Lang.N_0;
        var value_N_1 = Lang.N_1;

        var expected_TEST = "pt.Test";
        var expected_A_B_C = "pt.A.B.C";
        var expected_A_D = "pt.A.D";
        var expected_N_0 = "pt.N.0";
        var expected_N_1 = "pt.N.1";

        var result_TEST:String;
        var result_A_B_C:String;
        var result_A_D:String;
        var result_N_0:String;
        var result_N_1:String;

        // ACT
        Lang.setLanguage(valueLanguage);

        result_TEST = value_TEST;
        result_A_B_C = value_A_B_C;
        result_A_D = value_A_D;
        result_N_0 = value_N_0;
        result_N_1 = value_N_1;

        // ASSERT
        Assert.equals(expected_TEST, result_TEST);
        Assert.equals(expected_A_B_C, result_A_B_C);
        Assert.equals(expected_A_D, result_A_D);
        Assert.equals(expected_N_0, result_N_0);
        Assert.equals(expected_N_1, result_N_1);
        
    }

    function test_get_value_with_parameter_from_enum_key() {
        // ARRANGE
        var valueLanguage:String = "pt";

        var value1:String = 'Hello';
        var value2:String = 'World';

        var expected:String = "parametros Hello World";
        var result:String;
        
        // ACT
        Lang.setLanguage(valueLanguage);

        result = Lang.PARAMS.params(value1, value2);

        // ASSERT
        Assert.equals(expected, result);
    }
}