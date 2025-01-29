package util.kit.test.unit.nothing;

import utest.Assert;
import util.kit.nothing.Nothing;
import utest.Test;

class TestNothing extends Test {
    
    function test_nothing() {
        // ARRANGE
        var value:Nothing = Nothing.NULL;

        var expected:Dynamic = null;
        var result:Dynamic;

        // ACT
        result = value;

        // ASSERT
        Assert.equals(expected, result);

    }

}