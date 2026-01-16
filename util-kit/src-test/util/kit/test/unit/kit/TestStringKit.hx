package util.kit.test.unit.kit;

import helper.kits.StringKit;
import utest.Assert;
import utest.Test;

class TestStringKit extends Test {

    function test_break_single_char() {
        // Arrange
        var valueInput:String = "Hello World";
        var valueBreak:String = " ";

        var expected = ["Hello", "World"];
        var result = null;

        // Act
        result = StringKit.breakByChars(valueInput, valueBreak);

        // Assert
        Assert.same(expected, result);
    }

    function test_break_at_multi_chars() {
        // Arrange
        var valueInput:String = "Hello World";
        var valueBreak:String = " l";

        var expected = ["He", "o", "Wor", "d"];
        var result = null;

        // Act
        result = StringKit.breakByChars(valueInput, valueBreak);

        // Assert
        Assert.same(expected, result);
    }

}