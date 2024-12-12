// the grammar for tdat RuleEngine
grammar NMLC;

// the first parser rule, also the first rule of RuleEngine grammar
// prog is a sequence of rule lines.
//起始规则为prog
prog: ruleLine+;
//一个采集装置的完整规则文件是由一组(至少包含一条)规则行（ruleLine)组成。
ruleLine: ruleID ':' '(' subject ')' '=>' '(' objects ')' ';';

ruleID: ID;

subject: effect ',' roles ',' condition;

effect: 'allow'| 'deny';

roles: roles logicalOp roles| '*'| ID;

logicalOp: 'or'| 'and';

condition: condition logicalOp condition| '*'| condition_type condition_map| ID ':%' ID;

condition_type: 'CHAREquals'| 'CHARNotEquals'| 'CHAREqualsIgnoreCase'| 'CHARNotEqualsIgnoreCase'| 'CHARLike'| 'CHARNotLike'| 'NumericEquals'| 'NumericNotEquals'| 'NumericLessThan| 'NumericLessThanEquals'| 'NumericGreaterThan'| 'NumericGreaterThanEquals'| 'DateEquals'| 'DateNotEquals'| 'DateLessThan'| 'DateLessThanEquals'| 'DateGreaterThan'| 'DateGreaterThanEquals'| 'Bool'| 'IpAddress'| 'NotIpAddress';

condition_map: condition_map logicalOp condition_map| condition_key condition_value_list;

condition_key: 'acs:CurrentTime'| 'acs:SecureTransport'| 'acs:SourceIp'| 'acs:MFAPresent'| 'acs:PrincipalARN'| 'ecs:tag/<' FLOAT '>'| 'rds:ResourceTag/<' FLOAT '>'| 'oss:Delimiter'| 'oss:Prefix';

condition_value_list: condition_value_list logicalOp condition_value_list| ID;

objects: service ',' action ',' resource_type ',' resource ',' alias;

service: 'null'| ID;
action: '*'| ID;
resource_type
    : '*'
| ID
    ;
resource
    : '*'
| ID
| 'null'
    ;
alias
    : ID
| 'null'
    ;
// the first CHAR of ID must be a letter
ID
    : ID_LETTER (ID_LETTER | DIGIT)*
    ;

INT
    : DIGIT+
    ;

FLOAT
    : DIGIT+ '.' DIGIT* // match 1. 39. 3.14159 etc...
| '.' DIGIT+        // match .1 .14159
    ;


fragment
ID_LETTER
    : 'a'..'z'|'A'..'Z'|'_'  // [a-zA-Z_]
    ;

fragment
ESC
    : '\\"' | '\\\\'
    ;

fragment
DIGIT
    : [0-9]  // match single digit
    ;

CHAR
    : [a-zA-Z]+
    ;

LINE_COMMENT
    : '//' .*? '\r'? '\n' -> skip
    ;

COMMENT
    : '/*' .*? '*/' -> skip
    ;

WS 
    : [ \t\r\n]+ -> skip
    ;
