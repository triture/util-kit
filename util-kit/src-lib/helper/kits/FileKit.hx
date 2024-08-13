package helper.kits;

import sys.io.File;
import sys.FileSystem;
import haxe.io.Bytes;

class FileKit {


    static public function secureSaveData(data:Bytes, filePath:String, fileName:String):Void {
        initializePath(filePath);

        var tempFile:String = addPath(filePath, '${fileName}.tmp');
        var hashFile:String = addPath(filePath, '${fileName}.hsh');
        var realFile:String = addPath(filePath, fileName);

        if (FileSystem.exists(tempFile)) FileSystem.deleteFile(tempFile);
        File.saveBytes(tempFile, data);

        if (FileSystem.exists(realFile)) FileSystem.deleteFile(realFile);
        File.copy(tempFile, realFile);

        if (FileSystem.exists(hashFile)) FileSystem.deleteFile(hashFile);
        File.saveContent(hashFile, haxe.crypto.Md5.make(data).toHex());
    }

    static public function secureLoadData(filePath:String, fileName:String):Bytes {
        var tempFile:String = addPath(filePath, '${fileName}.tmp');
        var hashFile:String = addPath(filePath, '${fileName}.hsh');
        var realFile:String = addPath(filePath, fileName);

        if (FileSystem.exists(hashFile) &&
            FileSystem.exists(tempFile) &&
            FileSystem.exists(realFile)
        ) {
            var hash:String = File.getContent(hashFile);
            var content:Bytes = File.getBytes(realFile);

            if (hash == haxe.crypto.Md5.make(content).toHex()) return content;
            else return File.getBytes(tempFile);
        }

        return null;
    }

    static public function addPath(path1:String, path2:String):String {
        if (StringTools.endsWith(path1, '/')) return path1 + path2;
        else return path1 + '/' + path2;
    }

    static public function initializePath(path:String):Void {
        if (FileSystem.exists(path) && !FileSystem.isDirectory(path)) throw 'Path Init Error - Path is not an directory';
        else {
            try {
                FileSystem.createDirectory(path);
            } catch (e) {
                throw 'Path Init Error  - ' + Std.string(e);
            }
        }
    }


}