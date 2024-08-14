package util.kit.test.unit.path;

import util.kit.path.PathMatchData;
import util.kit.path.PathParamData;
import util.kit.path.PathParamType;
import util.kit.path.Path;
import util.kit.path.PathPartData;
import utest.Assert;
import utest.Test;

class TestPath extends Test {
    
    function test_path_parts_should_provide_list_of_parts() {
        // ARRANGE
        var path:Path = '/some/path';

        var expected:Array<PathPartData> = [{part: "some", is_param: false}, {part: "path", is_param: false}];
        var result:Array<PathPartData>;
        
        // ACT
        result = path.parts();
        
        // ASSERT
        Assert.same(expected, result);
    }

    function test_path_parts_should_be_url_decoded() {
        // ARRANGE
        var path:Path = '/some%20path';

        var expected:Array<PathPartData> = [{part: "some path", is_param: false}];
        var result:Array<PathPartData>;
        
        // ACT
        result = path.parts();
        
        // ASSERT
        Assert.same(expected, result);
    }

    function test_path_params_should_provide_list_of_params() {
        // ARRANGE
        var path:Path = '/some/{paramInt:Int}/{paramString:String}/{paramFloat:Float}/{paramBool:Bool}/{paramBool:Bool}/{paramBool:Bool}';

        var expected:Array<PathParamData> = [
            { param: "paramInt", type: PathParamType.INT },
            { param: "paramString", type: PathParamType.STRING },
            { param: "paramFloat", type: PathParamType.FLOAT },
            { param: "paramBool", type: PathParamType.BOOL },
            { param: "paramBool_2", type: PathParamType.BOOL },
            { param: "paramBool_3", type: PathParamType.BOOL }
        ];

        var result:Array<PathParamData>;

        // ACT
        result = path.params();

        // ASSERT
        Assert.same(expected, result);
    }

    function test_path_match_should_match_with_same_path_url() {
        // ARRANGE
        var path:Path = '/some/simple/path';

        var valueToMath:String = 'some/simple/path/';
        var expectedMatch:PathMatchData = {matched: true, params: []};
        var resultMatch:PathMatchData;

        // ACT
        resultMatch = path.match(valueToMath);

        // ASSERT
        Assert.same(expectedMatch, resultMatch);
    }

    function test_path_match_should_not_match_with_same_path_url_missing() {
        // ARRANGE
        var path:Path = '/some/simple/path';

        var valueToMath:String = 'some/simple/';
        var expectedMatch:PathMatchData = {matched: false, params: []};
        var resultMatch:PathMatchData;

        // ACT
        resultMatch = path.match(valueToMath);

        // ASSERT
        Assert.same(expectedMatch, resultMatch);
    }

    function test_path_match_should_not_match_with_same_path_url_extra() {
        // ARRANGE
        var path:Path = '/some/simple/path/';

        var valueToMath:String = 'some/simple/path/extra';
        var expectedMatch:PathMatchData = {matched: false, params: []};
        var resultMatch:PathMatchData;

        // ACT
        resultMatch = path.match(valueToMath);

        // ASSERT
        Assert.same(expectedMatch, resultMatch);
    }

    function test_path_match_should_not_match_with_different_path_url() {
        // ARRANGE
        var path:Path = '/some/simple/path';

        var valueToMath:String = 'some/complex/path/';
        var expectedMatch:PathMatchData = {matched: false, params: []};
        var resultMatch:PathMatchData;

        // ACT
        resultMatch = path.match(valueToMath);

        // ASSERT
        Assert.same(expectedMatch, resultMatch);
    }

    function test_path_match_should_match_with_string_param() {
        // ARRANGE
        var path:Path = '/some/{p1:String}/path/{p2:String}';

        var valueToMath:String = 'some/simple/path/10';

        var expectedMatch:PathMatchData = {
            matched: true, 
            params: [
                {param: "p1", value: "simple", type: PathParamType.STRING},
                {param: "p2", value: "10", type: PathParamType.STRING}
            ]
        };

        var resultMatch:PathMatchData;

        // ACT
        resultMatch = path.match(valueToMath);

        // ASSERT
        Assert.same(expectedMatch, resultMatch);
    }

    function test_path_match_should_match_with_int_param() {
        // ARRANGE
        var path:Path = '/some/{p1:Int}/path/{p2:Int}/{p3:Int}/{p4:Int}';

        var valueToMatch_1:String = 'some/0/path/0/0/0';
        var valueToMatch_2:String = 'some/10/path/0xFF/-20/-0xFF';
        var valueToMatch_3:String = 'some/0/path/0/0/x';

        var expectedMatch_1:PathMatchData = {
            matched: true, 
            params: [
                {param: "p1", value: 0, type: PathParamType.INT},
                {param: "p2", value: 0, type: PathParamType.INT},
                {param: "p3", value: 0, type: PathParamType.INT},
                {param: "p4", value: 0, type: PathParamType.INT}
            ]
        };

        var expectedMatch_2:PathMatchData = {
            matched: true, 
            params: [
                {param: "p1", value: 10, type: PathParamType.INT},
                {param: "p2", value: 255, type: PathParamType.INT},
                {param: "p3", value: -20, type: PathParamType.INT},
                {param: "p4", value: -255, type: PathParamType.INT}
            ]
        };

        var expectedMatch_3:PathMatchData = {
            matched: false, 
            params: []
        };

        var resultMatch_1:PathMatchData;
        var resultMatch_2:PathMatchData;
        var resultMatch_3:PathMatchData;

        // ACT
        resultMatch_1 = path.match(valueToMatch_1);
        resultMatch_2 = path.match(valueToMatch_2);
        resultMatch_3 = path.match(valueToMatch_3);

        // ASSERT
        Assert.same(expectedMatch_1, resultMatch_1);
        Assert.same(expectedMatch_2, resultMatch_2);
        Assert.same(expectedMatch_3, resultMatch_3);
    }

    function test_path_match_should_match_with_float_param() {
        // ARRANGE
        var path:Path = '/some/{p1:Float}/path/{p2:Float}/{p3:Float}/{p4:Float}';

        var valueToMatch_1:String = 'some/0/path/0/0/0';
        var valueToMatch_2:String = 'some/1./path/0.1/-2./-0.1';
        var valueToMatch_3:String = 'some/0/path/0/0/x';

        var expectedMatch_1:PathMatchData = {
            matched: true, 
            params: [
                {param: "p1", value: 0.0, type: PathParamType.FLOAT},
                {param: "p2", value: 0.0, type: PathParamType.FLOAT},
                {param: "p3", value: 0.0, type: PathParamType.FLOAT},
                {param: "p4", value: 0.0, type: PathParamType.FLOAT}
            ]
        };

        var expectedMatch_2:PathMatchData = {
            matched: true, 
            params: [
                {param: "p1", value: 1.0, type: PathParamType.FLOAT},
                {param: "p2", value: 0.1, type: PathParamType.FLOAT},
                {param: "p3", value: -2.0, type: PathParamType.FLOAT},
                {param: "p4", value: -0.1, type: PathParamType.FLOAT}
            ]
        };

        var expectedMatch_3:PathMatchData = {
            matched: false, 
            params: []
        };

        var resultMatch_1:PathMatchData;
        var resultMatch_2:PathMatchData;
        var resultMatch_3:PathMatchData;

        // ACT
        resultMatch_1 = path.match(valueToMatch_1);
        resultMatch_2 = path.match(valueToMatch_2);
        resultMatch_3 = path.match(valueToMatch_3);

        // ASSERT
        Assert.same(expectedMatch_1, resultMatch_1);
        Assert.same(expectedMatch_2, resultMatch_2);
        Assert.same(expectedMatch_3, resultMatch_3);
    }

    
}