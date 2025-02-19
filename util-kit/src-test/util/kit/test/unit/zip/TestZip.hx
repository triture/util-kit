package util.kit.test.unit.zip;

import utest.Assert;
import util.kit.zip.Zip;
import haxe.io.Bytes;
import utest.Test;

class TestZip extends Test {
    
    function test_make_zip_file() {
        // ARRANGE
        var valueFileNames:Array<String> = ["file1.txt", "file2.txt"];
        var valueFileContents:Array<Bytes> = [Bytes.ofString("Hello, World!"), Bytes.ofString("Goodbye, World!")];

        var expectedZipFileContents:String = '504b030414000000080000002152d0c34aec0f0000000d0000000900000066696c65312e747874f348cdc9c9d75108cf2fca49510400504b030414000000080000002152fb2329ec110000000f0000000900000066696c65322e74787473cfcf4f49aa4cd55108cf2fca49510400504b0102140014000000080000002152d0c34aec0f0000000d00000009000000000000000000000000000000000066696c65312e747874504b0102140014000000080000002152fb2329ec110000000f00000009000000000000000000000000003600000066696c65322e747874504b050600000000020002006e0000006e0000000000';
        var resultZipFilecontent:String;

        // ACT
        var zip = new Zip();
        zip.addFile(valueFileNames[0], valueFileContents[0], Date.fromString("2021-01-01"));
        zip.addFile(valueFileNames[1], valueFileContents[1], Date.fromString("2021-01-01"));

        resultZipFilecontent = zip.exportZip().toHex();

        // ASSERT
        Assert.equals(expectedZipFileContents, resultZipFilecontent);
    }

    function test_unzip_file() {
        // ARRANGE
        var valueZipBytes:Bytes = Bytes.ofHex('504b030414000000080000002152d0c34aec0f0000000d0000000900000066696c65312e747874f348cdc9c9d75108cf2fca49510400504b030414000000080000002152fb2329ec110000000f0000000900000066696c65322e74787473cfcf4f49aa4cd55108cf2fca49510400504b0102140014000000080000002152d0c34aec0f0000000d00000009000000000000000000000000000000000066696c65312e747874504b0102140014000000080000002152fb2329ec110000000f00000009000000000000000000000000003600000066696c65322e747874504b050600000000020002006e0000006e0000000000');

        var expectedFileLenght:Int = 2;

        var expectedFileName1:String = 'file1.txt';
        var expectedFileContent1:String = Bytes.ofString('Hello, World!').toHex();
        var resultFileContent1:String;

        var expectedFileName2:String = 'file2.txt';
        var expectedFileContent2:String = Bytes.ofString('Goodbye, World!').toHex();
        var resultFileContent2:String;

        // ACT
        var zip = new Zip(valueZipBytes);

        resultFileContent1 = zip.getContent(expectedFileName1).toHex();
        resultFileContent2 = zip.getContent(expectedFileName2).toHex();

        // ASSERT
        Assert.equals(expectedFileLenght, zip.length);

        Assert.equals(expectedFileContent1, resultFileContent1);
        Assert.equals(expectedFileContent2, resultFileContent2);
    }

    function test_extract_zip() {
        // ARRANGE
        var valueZipBytes:Bytes = Bytes.ofHex('504b030414000000080000002152d0c34aec0f0000000d0000000900000066696c65312e747874f348cdc9c9d75108cf2fca49510400504b030414000000080000002152fb2329ec110000000f0000000900000066696c65322e74787473cfcf4f49aa4cd55108cf2fca49510400504b0102140014000000080000002152d0c34aec0f0000000d00000009000000000000000000000000000000000066696c65312e747874504b0102140014000000080000002152fb2329ec110000000f00000009000000000000000000000000003600000066696c65322e747874504b050600000000020002006e0000006e0000000000');

        var expectedFileContent1:String = 'Hello, World!';
        var expectedFileContent2:String = 'Goodbye, World!';
        
        // ACT
        var zip = new Zip(valueZipBytes);
        zip.extract('./temp');

        // ASSERT
        Assert.equals(true, sys.FileSystem.exists('./temp/file1.txt'));
        Assert.equals(expectedFileContent1, sys.io.File.getContent('./temp/file1.txt'));

        Assert.equals(true, sys.FileSystem.exists('./temp/file2.txt'));
        Assert.equals(expectedFileContent2, sys.io.File.getContent('./temp/file2.txt'));
    }

}