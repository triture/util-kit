package util.kit.test.unit.kid;

import utest.Assert;
import util.kit.kid.Kid;
import utest.Test;

class TestKid extends Test {
    
    function test_kid() {
        // ARRANGE
        var kid:Kid = '00000000000000000000000000000000-00000000';

        // var kid:Kid = Kid.create();
        var expectedKey:String = '00000000000000000000000000000000';
        var expectedId:Int = 0;

        var resultKey:String;
        var resultId:Int;

        // ACT
        resultKey = kid.key;
        resultId = kid.id;

        // ASSERT
        Assert.equals(expectedKey, resultKey);
        Assert.equals(expectedId, resultId);
    }

    function test_kid_from_hex() {
        // ARRANGE
        var kid:Kid = '786875331917C27AAC863480BF5333E5-00F3100D';
        
        var expectedKey:String = '786875331917C27AAC863480BF5333E5';
        var expectedId:Int = 15929357;

        var resultKey:String;
        var resultId:Int;

        // ACT
        resultKey = kid.key;
        resultId = kid.id;

        // ASSERT
        Assert.equals(expectedKey, resultKey);
        Assert.equals(expectedId, resultId);
    }
    
    function test_kid_update_id_value() {
        // ARRANGE
        var kid:Kid = '786875331917C27AAC863480BF5333E5-00F3100D';
        
        var valueId:Int = 322;

        var expectedKid:String = '786875331917C27AAC863480BF5333E5-00000142';
        var resultKid:String;

        // ACT
        kid.id = valueId;
        resultKid = kid;

        // ASSERT
        Assert.equals(expectedKid, resultKid);
    }

    function test_kid_invalid_should_result_zero_values() {
        // ARRANGE
        var kid:Kid = 'something invalid';

        var expectedKey:String = '00000000000000000000000000000000';
        var expectedId:Int = 0;

        var resultKey:String;
        var resultId:Int;

        // ACT
        resultKey = kid.key;
        resultId = kid.id;

        // ASSERT
        Assert.equals(expectedKey, resultKey);
        Assert.equals(expectedId, resultId);
    }

    function test_kid_create_random_kid() {
        // ARRANGE
        var valueId:Int = 7926;

        var kid:Kid = new Kid(valueId);

        var notExpectedKey:String = '00000000000000000000000000000000';
        var expectedId:Int = 7926;
        
        var resultKey:String;
        var resultId:Int;

        // ACT
        resultKey = kid.key;
        resultId = kid.id;

        // ASSERT
        Assert.notEquals(notExpectedKey, resultKey);
        Assert.equals(expectedId, resultId);
    }
    
}