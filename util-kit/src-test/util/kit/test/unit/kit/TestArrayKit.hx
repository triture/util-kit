package util.kit.test.unit.kit;

import helper.kits.ArrayKit;
import utest.Assert;
import utest.Test;

class TestArrayKit extends Test {
    
    function test_sort_simple_array() {
        // Arrange
        var value = [3, 1, 2];

        var expected = [1, 2, 3];

        var result = null;

        // Act
        result = ArrayKit.sortAsc(value, (v) -> {return v;});

        // Assert
        Assert.same(expected, result);
    }

    // sort desc test
    function test_sort_desc_simple_array() {
        // Arrange
        var value = [3, 1, 2];

        var expected = [3, 2, 1];

        var result = null;

        // Act
        result = ArrayKit.sortDesc(value, (v) -> {return v;});

        // Assert
        Assert.same(expected, result);
    }



}