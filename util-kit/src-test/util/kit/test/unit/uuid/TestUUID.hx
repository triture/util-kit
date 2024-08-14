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

    function test_valid_uuid() {
        // ARRANGE
        var uuid:UUID;
        
        var valueCorrect_1:String = "AA000000-BB00-CC00-DD00-EE00FF000000";
        var valueCorrect_2:String = "AA000000BB00CC00DD00EE00FF000000";
        var valueCorrect_3:String = "aa000000-bb00-cc00-dd00-ee00ff000000";

        var valueWrong_1:String = "AA000000-BB00-CC00-DD00-EE00FF00000";
        var valueWrong_2:String = "AA000000BB00CC00DD00EE00FF0000000";
        var valueWrong_3:String = "AA000000-BB00-CC00-DD00-EE00FF00000G";

        var resultCorrect_1:Bool;
        var resultCorrect_2:Bool;
        var resultCorrect_3:Bool;

        var resultWrong_1:Bool;
        var resultWrong_2:Bool;
        var resultWrong_3:Bool;

        // ACT
        resultCorrect_1 = UUID.isValid(valueCorrect_1);
        resultCorrect_2 = UUID.isValid(valueCorrect_2);
        resultCorrect_3 = UUID.isValid(valueCorrect_3);

        resultWrong_1 = UUID.isValid(valueWrong_1);
        resultWrong_2 = UUID.isValid(valueWrong_2);
        resultWrong_3 = UUID.isValid(valueWrong_3);
        
        
        // ASSERT
        Assert.isTrue(resultCorrect_1);
        Assert.isTrue(resultCorrect_2);
        Assert.isTrue(resultCorrect_3);

        Assert.isFalse(resultWrong_1);
        Assert.isFalse(resultWrong_2);
        Assert.isFalse(resultWrong_3);
    }
}