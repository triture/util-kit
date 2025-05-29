package util.kit.test.unit.branch;

import utest.Async;
import utest.Assert;
import util.kit.branch.Branch;
import utest.Test;

class TestBranch extends Test {
    
    function test_main_branch() {
        // ARRANGE
        var main:Branch;

        var expectedDone:Bool = true;
        var valueDone:Bool = false;

        // ACT
        var onDone:()->Void = function() {
            valueDone = true;
        };

        main = new Branch(onDone);
        main.done();

        // ASSERT
        
        Assert.equals(expectedDone, valueDone);
    }

    function test_one_branched() {
        // ARRANGE
        var main:Branch;
        var branched:Branch;

        var expectedDone:Bool = true;
        var valueDone:Bool = false;

        // ACT
        var onDone:()->Void = function() {
            valueDone = true;
        };

        main = new Branch(onDone);
        
        branched = main.branch();
        branched.done();
        
        // ASSERT
        Assert.equals(expectedDone, valueDone);
    }

    function test_three_branched() {
        // ARRANGE
        var main:Branch;
        var branched1:Branch;
        var branched2:Branch;
        var branched3:Branch;

        var expectedDone:Bool = true;
        var valueDone:Bool = false;

        // ACT
        var onDone:()->Void = function() {
            valueDone = true;
        };

        main = new Branch(onDone);
        
        branched1 = main.branch();
        branched2 = main.branch();
        branched3 = main.branch();

        branched1.done();
        branched2.done();
        branched3.done();

        // ASSERT
        Assert.equals(expectedDone, valueDone);
    }

    function test_async_two_branched(async:Async):Void {
        // ARRANGE
        var main:Branch;

        var branched1:Branch;
        var branched2:Branch;

        var delay1:Int = Math.floor(Math.random() * 200);
        var delay2:Int = Math.floor(Math.random() * 200);

        var expectedDone:Bool = true;
        var valueDone:Bool = false;

        var assert:()->Void = () -> {};

        // ACT
        var onDone:()->Void = function() {
            valueDone = true;
            assert();
        };

        main = new Branch(onDone);
        
        branched1 = main.branch();
        branched2 = main.branch();

        haxe.Timer.delay(branched1.done, delay1);
        haxe.Timer.delay(branched2.done, delay2);

        // ASSERT
        assert = () -> {
            Assert.equals(expectedDone, valueDone);
            async.done();
        };
    }

    function test_branch_should_throw_error_if_sub_branches_not_done() {
        // ARRANGE
        var main:Branch;
        var branched:Branch;

        // ACT
        var onDone:()->Void = function() {};

        main = new Branch(onDone);

        branched = main.branch();

        // ASSERT
        Assert.raises(
            () -> {
                main.done();

            }
        );
    }

    function test_call_done_again_should_throw_error() {
        // ARRANGE
        var main:Branch;

        // ACT
        var onDone:()->Void = function() {};

        main = new Branch(onDone);
        main.done();

        // ASSERT
        Assert.raises(
            () -> {
                main.done();
            }
        );
    }

}