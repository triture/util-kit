package helper.kits;

class DisplayKit {

    static public function distribute(
        itens:Array<PriDisplay>,
        containerWidth:Float,
        widthSizes:Array<Float> = null,
        ?yPosition:Float = 0,
        ?gap:Float = 10,
        ?xPosition:Float = 0
    ):Float {

        if (widthSizes == null) widthSizes = [for (i in 0 ... itens.length) 1];

        if (itens.length % widthSizes.length != 0) {
            throw "Informe uma quantidade de itens multipla da quantidade de larguras";
        }

        var totalCols:Int = widthSizes.length;
        var totalLines:Int = Math.floor(itens.length / totalCols);
        var lastY:Float = yPosition;

        for (i in 0 ... totalLines) {

            var pack:Array<PriDisplay> = itens.slice(i * totalCols, i * totalCols + totalCols);

            lastY = columnize(pack, containerWidth, widthSizes, lastY + (i == 0 ? 0 : gap), gap, xPosition);
        }

        return lastY;
    }

    static public function removeAnyTextSelection():Void {
        if (js.Browser.window.getSelection != null) {
            if (js.Browser.window.getSelection().empty != null) {  // Chrome
                js.Browser.window.getSelection().empty();
            } else if (js.Browser.window.getSelection().removeAllRanges != null) {  // Firefox
                js.Browser.window.getSelection().removeAllRanges();
            }
        }
    }

    static public function columnize(
        itens:Array<PriDisplay>,
        containerWidth:Float,
        ?widthSizes:Array<Float> = null,
        ?yPosition:Float = null,
        ?gap:Float = 10,
        ?xPosition:Float = 0
    ):Float {

        if (widthSizes == null) widthSizes = [for (i in 0 ... itens.length) 1];

        if (itens.length != widthSizes.length) throw "Erro na quantidade de itens";

        var sizes:Array<Float> = normalizePercentuals(widthSizes);

        var availableSpace:Float = getAvailableSpace(gap, sizes, containerWidth);
        var lastX:Float = xPosition;
        var maxY:Float = 0;

        var totalGapToRemove:Float = ((itens.length - 1)*gap) / itens.length;

        for (i in 0 ... itens.length) {

            var item:PriDisplay = itens[i];

            if (item != null) {
                var width:Float = sizes[i];

                item.width = resizeTo(availableSpace, width) - totalGapToRemove;
                item.x = lastX;
                if (yPosition != null) item.y = yPosition;

                validate(item);

                maxY = Math.max(item.maxY, maxY);

                lastX = item.maxX + gap;
            } else {
                var width:Float = resizeTo(availableSpace, sizes[i]) - totalGapToRemove;

                lastX = lastX + width + gap;
            }

        }

        return maxY;
    }

    static private function normalizePercentuals(values:Array<Float>):Array<Float> {
        var percentualTotal:Float = 0;
        for (value in values) if (value <= 1) percentualTotal += value;

        if (percentualTotal == 1 || percentualTotal == 0) return values;

        var percentReduction:Float = 1 / percentualTotal;
        var result:Array<Float> = [];

        for (value in values) {
            if (value <= 1) result.push(value * percentReduction);
            else result.push(value);
        }

        return result;
    }

    static private function validate(item:PriDisplay):Void {
        if (Std.is(item, PriGroup)) {
            var g:PriGroup = cast item;
            g.validate();
        }
    }

    static private function resizeTo(availableSpace:Float, widthRequested:Float):Float {
        if (widthRequested > 1) return widthRequested;
        else return availableSpace * widthRequested;
    }

    static private function getAvailableSpace(gap:Float, widthSizes:Array<Float>, containerWidth:Float):Float {
        var availableSpace:Float = containerWidth;
        for (width in widthSizes) if (width > 1) availableSpace -= width;
        if (availableSpace < 0) availableSpace = 0;

        return availableSpace;
    }

    static private var buzzReferences:Map<PriDisplay, {key:String, px:Float}>;

    static public function buzz(display:PriDisplay):Void {
        if (buzzReferences == null) buzzReferences = new Map<PriDisplay, {key:String, px:Float}>();

        var tw:{key:String, px:Float} = buzzReferences.exists(display)
            ? buzzReferences.get(display)
            : {key:StringKit.generateRandomString(20), px:display.x};

        buzzReferences.set(display, tw);

        display.x = tw.px;
        var curx:Float = tw.px;

        NumberKit.tween(
            tw.key,
            450,
            function(percent:Float):Void {
                display.x = curx + (Math.sin(percent*8) * 15 * (1-percent));
            },
            function():Void {
                display.x = curx;
                buzzReferences.remove(display);
            }
        );

    }

}
