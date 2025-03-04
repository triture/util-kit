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
            word : "World",
            WORD : "Hello"
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

}