package helper.builder;


/**
*
* https://dev.mysql.com/doc/refman/5.7/en/non-typed-operators.html
*
*
*
LIke Operator
WHERE CustomerName LIKE 'a%'	Finds any values that starts with "a"
WHERE CustomerName LIKE '%a'	Finds any values that ends with "a"
WHERE CustomerName LIKE '%or%'	Finds any values that have "or" in any position
WHERE CustomerName LIKE '_r%'	Finds any values that have "r" in the second position
WHERE CustomerName LIKE 'a_%_%'	Finds any values that starts with "a" and are at least 3 characters in length
WHERE ContactName LIKE 'a%o'	Finds any values that starts with "a" and ends with "o"
**/

@:enum
abstract BuilderOperator (String){
    var EQUAL = "=";
    var NOT_EQUAL = "<>";
    var GREATER = ">";
    var EQUAL_OR_GREATER = ">=";
    var EQUAL_OR_LESS = "<=";
    var LESS = "<";
    var LIKE = "LIKE";
    var IN = "IN";
    var NOT_IN = "NOT IN";
    var IS = "IS";
    var IS_NOT = "IS NOT";
}
