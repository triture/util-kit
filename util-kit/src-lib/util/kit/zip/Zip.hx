package util.kit.zip;

import haxe.zip.Reader;
import haxe.io.BytesInput;
import haxe.ds.StringMap;
import haxe.zip.Writer;
import haxe.io.BytesOutput;
import haxe.crypto.Crc32;
import haxe.zip.Compress;
import haxe.io.Bytes;
import haxe.zip.Entry;

class Zip {

    private var entries:StringMap<Entry>;
    private var entryOrder:Array<String>;

    public var length(get, null):Int;
    
    public function new(?zipBytes:Bytes) {
        this.entries = new StringMap<Entry>();
        this.entryOrder = [];

        if (zipBytes != null) this.importZip(zipBytes);
    }

    private function get_length():Int return this.entryOrder.length;

    public function addFile(filename:String, bytes:Bytes, ?fileTime:Date):Void {
        if (this.entries.exists(filename)) {
            this.entries.remove(filename);
            this.entryOrder.remove(filename);
        }

        var compressedBytes:Bytes = Compress.run(bytes, 8);
        compressedBytes = compressedBytes.sub(2, compressedBytes.length - 6);

        // Create a zip entry for the bytes:
        var entry:Entry = {
            fileName : filename, // "path/to/textfile.txt", // <- This is the internal zip file folder structure
            fileSize : bytes.length,
            fileTime : fileTime == null ? Date.now() : fileTime,
            compressed : true,
            dataSize : compressedBytes.length,
            data : compressedBytes,
            crc32 : Crc32.make(bytes)
        };

        this.entries.set(filename, entry);
        this.entryOrder.push(filename);
    }

    inline public function existFile(filename:String):Bool return this.entries.exists(filename);

    public function getFileNames():Array<String> return this.entryOrder.copy();

    public function getContent(filename:String):Bytes {
        if (!existFile(filename)) return null;

        var entry:Entry = this.entries.get(filename);

        return Reader.unzip(entry);
    }

    public function exportZip():Bytes {
        var output:BytesOutput = new BytesOutput();

        var list:List<Entry> = new List();
        for (filename in this.entryOrder) list.add(this.entries.get(filename));
        
        var writer = new Writer(output);
        writer.write(list);

        var result:Bytes = output.getBytes();
        output.close();

        return result;
    }

    private function importZip(data:Bytes):Void {
        this.entries = new StringMap<Entry>();
        this.entryOrder = [];

        try {
            var input:BytesInput = new BytesInput(data);

            var list:List<Entry> = Reader.readZip(input);

            for (entry in list) {
                
                this.entries.set(entry.fileName, entry);
                this.entryOrder.push(entry.fileName);
            }
            
        } catch (e:Dynamic) {
            
        }
    }

    #if sys
    public function extract(path:String):Void {
        if (!StringTools.endsWith(path, "/")) path += "/";
        
        helper.kits.FileKit.initializePath(path);

        for (filename in this.entryOrder) {
            var content:Bytes = this.getContent(filename);
            
            sys.io.File.saveBytes(path + filename, content);
        }
    }
    #end

}