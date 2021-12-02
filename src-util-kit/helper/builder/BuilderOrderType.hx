package helper.builder;

@:enum
abstract BuilderOrderType(String) from String to String {
    var ASC = "ASC";
    var DESC = "DESC";
}
