package helper.builder;

import helper.builder.QueryBuilder;

class QueryBuilder {

    public static var SANITIZE:String->String;

    private var _fromTable:Dynamic;
    private var _fromTableAlias:String;
    private var _recordId:Null<Int>;
    private var _fields:Array<Dynamic>;
    private var _leftJoins:Array<String>;

    private var _whereData:Array<WhereBuilder>;

    private function new() {
        this._whereData = [];
        this._fields = [];
        this._leftJoins = [];
    }

    private function getWhereString():String return [for (where in _whereData) where.toString()].join(" AND ");

    static public function update():QueryBuilderUpdate return new QueryBuilderUpdate();
    static public function remove():QueryBuilderRemove return new QueryBuilderRemove();
    static public function select():QueryBuilderSelect return new QueryBuilderSelect();

    public function toString():String return "";
}

private class QueryBuilderSelect extends QueryBuilder {

    private var max_limit:Null<Int>;
    private var order_fields:Array<Dynamic> = [];

    public function new() {
        super();
    }

    public function record(id:Int):QueryBuilderSelect {
        this._recordId = id;
        return this;
    }

    public function from(table:Dynamic, alias:String = ""):QueryBuilderSelect {
        this._fromTable = table;
        this._fromTableAlias = alias;
        return this;
    }

    public function leftJoin(table:Dynamic, tableAlias:String, on:String):QueryBuilderSelect {
        this._leftJoins.push(' LEFT JOIN ${table} ${tableAlias} ON ${on} ');
        return this;
    }

    public function join(table:Dynamic, tableAlias:String, on:String):QueryBuilderSelect {
        this._leftJoins.push(' JOIN ${table} ${tableAlias} ON ${on} ');
        return this;
    }

    public function fields(itens:Array<Dynamic>):QueryBuilderSelect {
        this._fields = itens;
        return this;
    }

    public function andWhere(builder:WhereBuilder):QueryBuilderSelect {
        this._whereData.push(builder);
        return this;
    }

    public function limit(max:Int):QueryBuilderSelect {
        this.max_limit = max;
        return this;
    }

    public function addOrderBy(field:String, orderType:BuilderOrderType):QueryBuilderSelect {
        this.order_fields.push(
            {
                field : field,
                orderType : orderType
            }
        );

        return this;
    }

    override public function toString():String {

        var selectFields:String = this._fields.length == 0 ? "*" : this._fields.join(", ");
        var result:String = 'SELECT ${selectFields} FROM ${this._fromTable} ${this._fromTableAlias} ';

        for (leftjoin in this._leftJoins) result += leftjoin;

        if (this._recordId == null) {
            if (this._whereData.length > 0) result += ' WHERE ${this.getWhereString()} ';

        } else {
            result += ' WHERE id = ${this._recordId} ';
            if (this._whereData.length > 0) result += ' AND ${this.getWhereString()} ';
        }

        if (this.order_fields != null && this.order_fields.length > 0) {
            result += ' ORDER BY ' + [for (order in this.order_fields) { '${order.field} ${order.orderType}'; }].join(",");
        }

        if (this.max_limit != null && this.max_limit > 0) {
            result += ' LIMIT ${this.max_limit}';
        }

        return result;
    }
}

private class QueryBuilderRemove extends QueryBuilder {

    public function new() {
        super();
    }

    public function where(builder:WhereBuilder):QueryBuilderRemove {
        this._whereData.push(builder);
        return this;
    }

    public function leftJoin(table:Dynamic, tableAlias:String, on:String):QueryBuilderRemove {
        this._leftJoins.push(' LEFT JOIN ${table} ${tableAlias} ON ${on} ');
        return this;
    }

    public function from(table:Dynamic, alias:String = ""):QueryBuilderRemove {
        this._fromTable = table;
        this._fromTableAlias = alias;

        return this;
    }

    public function record(id:Int):QueryBuilderRemove {
        this._recordId = id;
        return this;
    }

    override public function toString():String {
        var result:String = 'DELETE `${this._fromTableAlias != null && this._fromTableAlias != '' ? this._fromTableAlias :  this._fromTable}` ';
        result += 'FROM ${this._fromTable} `${this._fromTableAlias != null && this._fromTableAlias != '' ? this._fromTableAlias :  this._fromTable}` ';

        for (leftjoin in this._leftJoins) {
            result += leftjoin;
        }

        if (this._recordId == null) {
            if (this._whereData.length > 0) result += ' WHERE ${this.getWhereString()} ';
        } else {
            result += ' WHERE id = ${this._recordId} ';
            if (this._whereData.length > 0) result += ' AND ${this.getWhereString()} ';
        }

        return result;
    }
}

private class QueryBuilderUpdate extends QueryBuilder {

    private var _setData:Dynamic;

    public function new() {
        super();
    }

    public function record(id:Null<Int>):QueryBuilderUpdate {
        if (id != null && id != 0) {
            this._recordId = id;
        } else {
            this._recordId = null;
        }

        return this;
    }

    public function from(table:Dynamic):QueryBuilderUpdate {
        this._fromTable = table;
        this._fromTableAlias = "";
        return this;
    }

    public function set(data:Dynamic):QueryBuilderUpdate {
        this._setData = data;
        return this;
    }

    public function where(builder:WhereBuilder):QueryBuilderUpdate {
        this._whereData.push(builder);
        return this;
    }

    override public function toString():String {

        if (QueryBuilder.SANITIZE == null) throw "Set a Sanitize Method for QueryBuilder";

        var result:String = "";

        var keys:Array<String> = [];
        var values:Array<String> = [];

        for (key in Reflect.fields(this._setData)) {

            var value:Dynamic = Reflect.field(this._setData, key);

            keys.push('${key}');

            if (value == null) {

                values.push("NULL");

            } else if (Std.is(value, BuilderRawValue)) {

                var rawValue:BuilderRawValue = cast value;
                values.push(rawValue.value);

            } else if (Std.is(value, Bool)) {

                values.push(value ? '1' : '0');

            } else if (Std.is(value, String) || Std.is(value, Int) || Std.is(value, Float)) {

                values.push("'" + QueryBuilder.SANITIZE(Std.string(value)) + "'");

            } else if (Std.is(value, Date)) {
                var date:Date = cast value;
                var dateString:String = '' +
                    '"${date.getFullYear()}-' +
                    '${StringTools.lpad(Std.string(date.getMonth()+1), "0", 2)}-' +
                    '${StringTools.lpad(Std.string(date.getDate()), "0", 2)} ' +
                    '${StringTools.lpad(Std.string(date.getHours()), "0", 2)}:' +
                    '${StringTools.lpad(Std.string(date.getMinutes()), "0", 2)}:' +
                    '${StringTools.lpad(Std.string(date.getSeconds()), "0", 2)}"';

                values.push('${dateString}');
            } else {
                throw "Query Builder aceita apenas objetos String, Bool, Int, Float ou valores nulos";
            }


        }

        if (this._recordId == null && this._whereData.length == 0) {
            // INSERT INTO table_name (column1, column2, column3, ...) VALUES (value1, value2, value3, ...);

            var keyList:String = keys.join(",");
            var valueList:String = values.join(",");

            result = 'INSERT INTO ${this._fromTable} (${keyList}) VALUES ($valueList);';

        } else {
            // UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;

            var keyValueList:Array<String> = [];

            for (i in 0 ... keys.length) {
                keyValueList.push('${keys[i]}=${values[i]}');
            }

            result = 'UPDATE ${this._fromTable} SET ${keyValueList.join(",")} WHERE 1 = 1 ';

            if (this._recordId != null) {
                result += ' AND id=${this._recordId} ';
            }

            if (this._whereData.length > 0) {
                result += ' AND ${this.getWhereString()};';
            } else {
                result += ';';
            }
        }

        return result;

    }
}