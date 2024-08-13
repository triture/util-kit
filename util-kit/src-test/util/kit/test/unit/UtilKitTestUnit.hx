package util.kit.test.unit;

import util.kit.test.unit.uuid.TestUUID;
import utest.ui.Report;
import utest.Runner;

class UtilKitTestUnit {

    static public function main() {
        var runner = new Runner();

        runner.addCase(new TestUUID());
        
        Report.create(runner);
        runner.run();
    }

}