package helper.event;

class SimpleEvent {

    public var onSuccess:()->Void;
    public var onFail:()->Void;

    public function new() {

    }

    private function dispatchSuccess():Void if (this.onSuccess != null) this.onSuccess();
    private function dispatchFail():Void if (this.onFail != null) this.onFail();

}