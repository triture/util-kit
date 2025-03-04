#!/bin/bash

yes | haxelib git dox https://github.com/HaxeFoundation/dox.git

rm -rf ./build/docs
rm -rf ./docs/*

haxe haxe-dox.hxml

haxelib run dox                                         \
    --title "Util Kit Docs"                             \
    -i ./build/docs -o ./docs                           \
    -ex ^helper.display -ex ^datetime -ex ^haxe -ex ^sys      
