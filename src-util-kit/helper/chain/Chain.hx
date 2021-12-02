package helper.chain;

import haxe.Timer;

class Chain {

    private var functions:Array<(resolve:ChainResolve, abort:ChainError)->Void>;

    public function new() {
        this.functions = [];
    }

    public function add(action:(resolve:ChainResolve, abort:ChainError)->Void):Chain {
        this.functions.push(action);
        return this;
    }

    public function runSerie(onDone:ChainResolve, onError:ChainError):Void {
        var funcs:Array<(resolve:ChainResolve, abort:ChainError)->Void> = this.functions.copy();
        this.functions = [];

        var timer:Timer = null;
        var aborted:Bool = false;
        var runSomething = null;

        var killTimer = function():Void {
            if (timer != null) {
                timer.stop();
                timer.run = null;
                timer = null;
            }
        }

        var onAbort = function(error:String):Void {
            killTimer();
            aborted = true;
            funcs = [];
            onError(error);
        }

        var onResolve = function():Void {
            killTimer();
            if (aborted) return;
            else if (funcs.length == 0) onDone();
            else {
                var currFunc = funcs.shift();
                runSomething(currFunc);
            }
        }

        runSomething = function(someFunc:(resolve:ChainResolve, abort:ChainError)->Void):Void {
            try {
                timer = Timer.delay(onAbort.bind('Execution Timeout...'), 15 * 1000);

                someFunc(onResolve, onAbort);
            } catch(e:Dynamic) {
                onAbort(Std.string(e));
            }
        }

        onResolve();
    }

}

typedef ChainResolve = ()->Void;
typedef ChainError = (error:String)->Void;