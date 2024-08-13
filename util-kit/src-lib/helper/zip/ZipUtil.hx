package helper.zip;

import haxe.io.BytesInput;
import haxe.zip.Reader;
import haxe.crypto.Crc32;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import haxe.zip.Compress;
import haxe.zip.Entry;
import haxe.zip.Writer;

class ZipUtil {

    private var zipEntries:Array<Entry> = [];

    public function new() {

    }

    public function readZip(data:Bytes):Bool {

        try {
            var input:BytesInput = new BytesInput(data);

            var entries:Array<Entry> = [for (item in Reader.readZip(input)) item];
            this.zipEntries = entries;

        } catch (e:Dynamic) {
            return false;
        }

        return true;
    }

    public function saveData(entryName:String, toFileName:String):Bool {

        try {
            for (item in this.zipEntries) {

                if (item.fileName == entryName) {

                    sys.io.File.saveBytes(toFileName, Reader.unzip(item));
                    return true;

                }
            }
        } catch (e:Dynamic) {

        }

        return false;

    }

    public function getData(entryName:String):BytesInput {

        try {
            for (item in this.zipEntries) {

                if (item != null && item.fileName == entryName) {
                    this.zipEntries[this.zipEntries.indexOf(item)] = null;

                    return new BytesInput(Reader.unzip(item));
                }
            }
        } catch (e:Dynamic) {

        }

        return null;
    }

    public function createZip():Void {
        this.zipEntries = [];
    }

    public function output():Bytes {

        var entries:List<Entry> = new List();
        for (item in this.zipEntries) entries.add(item);

        try {
            var bytes = this.generateBytes(entries);

            return bytes;

        } catch (e:Dynamic) {

        }

        return null;
    }

    public function addDataString(internalFileName:String, ?data:String, ?dataBytes:BytesOutput):Void {

        if (data != null && dataBytes == null) {
            var bytes:Bytes = Bytes.ofString(data);

            this.addData(internalFileName, bytes);
        } else if (dataBytes != null) {

            this.addData(internalFileName, dataBytes.getBytes());
        }
    }

    public function addData(internalFileName:String, bytes:Bytes):Void {
        var compressedBytes = Compress.run(bytes, 8);
        compressedBytes = compressedBytes.sub(2, compressedBytes.length - 6);

        // Create a zip entry for the bytes:
        var entry:Entry = {
            fileName : internalFileName, // "path/to/textfile.txt", // <- This is the internal zip file folder structure
            fileSize : bytes.length,
            fileTime : Date.now(),
            compressed : true,
            dataSize : compressedBytes.length,
            data : compressedBytes,
            crc32 : Crc32.make(bytes)
        };

        this.zipEntries.push(entry);
    }

    private function generateBytes(entries:List<Entry>):Bytes {
        var bytesOutput = new BytesOutput();

        var writer = new Writer(bytesOutput);
        writer.write(entries);

        return bytesOutput.getBytes();
    }


}
