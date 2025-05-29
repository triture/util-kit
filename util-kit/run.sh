haxe test-on-cpp.hxml                           && \
./build/util/kit/test/cpp/UtilKitTestUnit       && \

haxe test-on-js.hxml                            && \
node ./build/util/kit/test/unit.js              && \

haxe test-on-java.hxml                          && \
java -jar ./build/util/kit/test/java/UtilKitTestUnit.jar

