package util.kit.test.unit;

import util.kit.test.unit.kit.TestStringKit;
#if sys
import util.kit.test.unit.zip.TestZip;
#end

import util.kit.test.unit.branch.TestBranch;
import util.kit.test.unit.lang.TestLang;
import util.kit.test.unit.nothing.TestNothing;
import util.kit.test.unit.kit.TestArrayKit;
import util.kit.test.unit.kid.TestKid;
import util.kit.test.unit.path.TestPath;
import util.kit.test.unit.uuid.TestUUID;
import utest.ui.Report;
import utest.Runner;

class UtilKitTestUnit {

    static public function main() {
        var runner = new Runner();

        #if sys
        runner.addCase(new TestZip());
        #end

        runner.addCase(new TestUUID());
        runner.addCase(new TestPath());
        runner.addCase(new TestKid());
        runner.addCase(new TestStringKit());
        runner.addCase(new TestArrayKit());
        runner.addCase(new TestNothing());
        runner.addCase(new TestLang());
        runner.addCase(new TestBranch());

        Report.create(runner);
        runner.run();
    }

}