package util.kit.test.unit.uuid;

import utest.Assert;
import util.kit.uuid.UUID;
import utest.Test;

class TestUUID extends Test {
    
    function test_create_clean_uuid() {
        // ARRANGE
        var uuid:UUID = UUID.create();
        var expected:String = "00000000-0000-0000-0000-000000000000";
        var result:String;

        // ACT
        result = uuid.toString();

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_create_uuid_from_hex() {
        // ARRANGE
        var uuid:UUID = "AA000000-BB00-CC00-DD00-EE00FF000000";

        var expected:String = "AA000000-BB00-CC00-DD00-EE00FF000000";
        var result:String;

        // ACT
        result = uuid.toString();

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_create_random_uuid() {
        // ARRANGE
        var uuidA:UUID = UUID.createRandom();
        var uuidB:UUID = UUID.createRandom();
        var uuidC:UUID = UUID.createRandom();

        var expectedEquals:Bool = false;
        var resultEquals:Bool;

        // ACT
        resultEquals = (uuidA.toString() == uuidB.toString()) || (uuidB.toString() == uuidC.toString()) || (uuidA.toString() == uuidC.toString());

        // ASSERT
        Assert.equals(expectedEquals, resultEquals);
    }

    function test_create_random_uuid_with_p1_equal_100() {
        // ARRANGE
        var uuid:UUID = UUID.createRandom();
        var valueP1:Int = 100;

        var expectedP1:Int = 100;
        var resultP1:Int;
        
        // ACT
        uuid.p1 = valueP1;
        resultP1 = uuid.p1;

        // ASSERT
        Assert.equals(expectedP1, resultP1);
    }

    function test_invalid_uuid() {
        // ARRANGE
        var uuid:UUID;
        
        var raisesSmaller:()->Void;
        var raisesBigger:()->Void;
        var raisesInvalidChar:()->Void;

        // ACT
        raisesSmaller = () -> {
            uuid = "AA000000-BB00-CC00-DD00-EE00FF00000";
        };

        raisesBigger = () -> {
            uuid = "AA000000-BB00-CC00-DD00-EE00FF0000000";
        };

        raisesInvalidChar = () -> {
            uuid = "AA000000-BB00-CC00-DD00-EE00FF00000G";
        };
        
        // ASSERT
        Assert.raises(raisesSmaller);
        Assert.raises(raisesBigger);
        Assert.raises(raisesInvalidChar);
    }
}