package helper.builder;

import helper.builder.QueryBuilder;

class WhereBuilder {

    private var whereList:Array<WhereItemValue>;

    public function new(field:Dynamic, op:BuilderOperator, ?value:String, ?values:Array<String>) {
        this.whereList = [];
        this.and(field, op, value, values);
    }

    public function and(field:Dynamic, op:BuilderOperator, ?value:String, ?values:Array<String>):WhereBuilder {
        return this.constructor("AND", field, op, value, values);
    }

    public function or(field:String, op:BuilderOperator, ?value:String, ?values:Array<String>):WhereBuilder {
        return this.constructor("OR", field, op, value, values);
    }

    private function constructor(glue:String, field:Dynamic, op:BuilderOperator, ?value:String, ?values:Array<String>):WhereBuilder {
        if (QueryBuilder.SANITIZE == null) throw "Set a Sanitize Method for QueryBuilder";

        var finalValue:String = "";

        if (values != null && values.length > 0) {
            finalValue = "(";
            finalValue += [for (item in values) ("'" + QueryBuilder.SANITIZE(item) + "'")].join(", ");
            finalValue += ")";
        } else if (value == null) {
            finalValue = "NULL";
        } else {
            finalValue = "'" + QueryBuilder.SANITIZE(value) + "'";
        }

        this.whereList.push(
            {
                type : this.whereList.length == 0 ? "" : glue,
                field : field,
                op : op,
                value : finalValue
            }
        );

        return this;
    }

    public function toString():String {
        var result:String = "(";

        for (whereItem in this.whereList) {
            if (whereItem.op == BuilderOperator.IN || whereItem.op == BuilderOperator.NOT_IN) {
                result += ' ${whereItem.type} ${whereItem.field} ${whereItem.op} ${whereItem.value} ';
            } else if (whereItem.value == null) {
                result += ' ${whereItem.type} ${whereItem.field} ${whereItem.op} NULL ';
            } else {
                result += ' ${whereItem.type} ${whereItem.field} ${whereItem.op} ${whereItem.value} ';
            }
        }

        result += ")";

        return result;
    }
}

private typedef WhereItemValue = {
    var type:String;
    var field:String;
    var op:BuilderOperator;
    var value:String;
}