package util.kit.branch;

class Branch {

    @:isVar public var resolved(default, null):Bool;

    private var onDone:()->Void;
    private var branches:Array<Branch>;
    
    public function new(onDone:()->Void) {
        this.resolved = false;
        this.branches = [];
        this.onDone = onDone;
    }

    public function done():Void {
        if (this.resolved) throw "Branch already done.";
        else if (this.branches.length > 0) throw "Branch has unresolved branches.";
        
        this.resolved = true;
        if (this.onDone != null) this.onDone();
    }

    public function branch():Branch {
        var branched:Branch = null;

        var onBranchDone = () -> {
            var branchIndex:Int = this.branches.indexOf(branched);
            if (branchIndex >= 0) this.branches.splice(branchIndex, 1);
            else throw "Branch already done.";

            if (this.branches.length == 0) this.done();
        }

        branched = new Branch(onBranchDone);
        this.branches.push(branched);

        return branched;
    }

}