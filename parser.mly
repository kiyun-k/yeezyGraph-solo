/* Ocamlyacc parser for MicroC */

%{
open Ast
let get1of3 (a, _, _) = a
let get2of3 (_, a, _) = a
let get3of3 (_, _, a) = a
%}

/* Punctuation tokens */
%token SEMI LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET COMMA

/* Arithmetic tokens */
%token PLUS MINUS TIMES DIVIDE ASSIGN NOT

/* Logical tokens */
%token EQ NEQ LT LEQ GT GEQ TRUE FALSE AND OR

/* Primitive datatype tokens */
%token INT BOOL STRING FLOAT INFINITY NEGINFINITY

/* Struct tokens */
%token STRUCT TILDE

/* Collections tokens */
%token LIST QUEUE PQUEUE

/* Graph tokens */
%token GRAPH NODE

/* Graph Op Tokens */
%token ADDNODE REMOVENODE ADDEDGE REMOVEEDGE UNDERSCORE

/* Node Op Tokens */
%token GETNAME GETVISITED GETINNODES GETOUTNODES GETDATA

/* Control flow tokens */
%token IF ELSE FOR WHILE

/* Function tokens */
%token RETURN VOID NEW DOT

%token <int> INT_LITERAL
%token <float> FLOAT_LITERAL
%token <string> STR_LITERAL

/* Variable names */
%token <string> ID
%token EOF

%nonassoc NOELSE
%nonassoc ELSE
%nonassoc LBRACKET RBRACKET 
%nonassoc ADDNODE REMOVENODE ADDEDGE REMOVEEDGE UNDERSCORE

%right ASSIGN
%right NOT NEG

%left OR
%left AND
%left EQ NEQ
%left LT GT LEQ GEQ
%left PLUS MINUS
%left TIMES DIVIDE
%left DOT TILDE
%left GETNAME GETVISITED GEINNODES GETOUTNODES GETDATA


%start program
%type <Ast.program> program

%%

program:
  decls EOF { $1 }

decls:
   /* nothing */ { [], [], [] }
 | decls vdecl { ($2 :: get1of3($1)), get2of3($1), get3of3($1) }
 | decls fdecl { get1of3($1), ($2 :: get2of3($1)), get3of3($1) }
 | decls structdecl { get1of3($1), get2of3($1), ($2 :: get3of3($1)) }

fdecl:
   typ ID LPAREN formals_opt RPAREN LBRACE vdecl_list stmt_list RBRACE
     { { typ = $1;
	 fname = $2;
	 formals = $4;
	 locals = List.rev $7;
	 body = List.rev $8 } }

formals_opt:
    /* nothing */ { [] }
  | formal_list   { List.rev $1 }

formal_list:
    typ ID                   { [($1,$2)] }
  | formal_list COMMA typ ID { ($3,$4) :: $1 }

typ:
    INT { Int }
  | BOOL { Bool }
  | STRING { String }
  | VOID { Void }
  | STRUCT ID { StructType ($2) }
  | GRAPH LT typ GT { GraphType($3)}
  | NODE LT typ GT { NodeType($3) }
  | QUEUE LT typ GT {QueueType($3)}
  | PQUEUE { PQueueType }
  | LIST LT typ GT { ListType($3) }


vdecl_list:
    /* nothing */    { [] }
  | vdecl_list vdecl { $2 :: $1 }

vdecl:
   typ ID SEMI { ($1, $2) }

structdecl:
  STRUCT ID LBRACE vdecl_list RBRACE
    { {
        sname = $2;
        sformals = $4;
    } }

stmt_list:
    /* nothing */  { [] }
  | stmt_list stmt { $2 :: $1 }

stmt:
    expr SEMI { Expr $1 }
  | RETURN SEMI { Return Noexpr }
  | RETURN expr SEMI { Return $2 }
  | LBRACE stmt_list RBRACE { Block(List.rev $2) }
  | IF LPAREN expr RPAREN stmt %prec NOELSE { If($3, $5, Block([])) }
  | IF LPAREN expr RPAREN stmt ELSE stmt    { If($3, $5, $7) }
  | FOR LPAREN expr_opt SEMI expr SEMI expr_opt RPAREN stmt
     { For($3, $5, $7, $9) }
  | WHILE LPAREN expr RPAREN stmt { While($3, $5) }

expr_opt:
    /* nothing */ { Noexpr }
  | expr          { $1 }

expr:
    INT_LITERAL      { IntLit($1) }
  | STR_LITERAL      { StringLit($1) }
  | TRUE             { BoolLit(true) }
  | FALSE            { BoolLit(false) }
  | ID               { Id($1) }
  | expr PLUS   expr { Binop($1, Add,   $3) }
  | expr MINUS  expr { Binop($1, Sub,   $3) }
  | expr TIMES  expr { Binop($1, Mult,  $3) }
  | expr DIVIDE expr { Binop($1, Div,   $3) }
  | expr EQ     expr { Binop($1, Equal, $3) }
  | expr NEQ    expr { Binop($1, Neq,   $3) }
  | expr LT     expr { Binop($1, Less,  $3) }
  | expr LEQ    expr { Binop($1, Leq,   $3) }
  | expr GT     expr { Binop($1, Greater, $3) }
  | expr GEQ    expr { Binop($1, Geq,   $3) }
  | expr AND    expr { Binop($1, And,   $3) }
  | expr OR     expr { Binop($1, Or,    $3) }
  | MINUS expr %prec NEG { Unop(Neg, $2) }
  | NOT expr         { Unop(Not, $2) }
  | expr ASSIGN expr   { Assign($1, $3) }
  | ID LPAREN actuals_opt RPAREN { Call($1, $3) }
  | LPAREN expr RPAREN { $2 }
  | NEW QUEUE LT typ GT LPAREN actuals_opt RPAREN { Queue($4, $7) }
  | NEW PQUEUE LPAREN actuals_opt RPAREN { PQueue($4) }
  | NEW LIST LT typ GT LPAREN actuals_opt RPAREN { List($4,$7) }
  | NEW GRAPH LT typ GT LPAREN RPAREN { Graph($4) }
  | NEW NODE LT typ GT LPAREN ID RPAREN {Node($7, $4)}
  | expr TILDE ID        { AccessStructField($1, $3) }
  | expr DOT ID LPAREN actuals_opt RPAREN { ObjectCall($1, $3, $5) } 
  | INFINITY { Infinity }
  | NEGINFINITY { Neginfinity } 
  | ID UNDERSCORE ID {Gop($1, AccessNode, $3)}
  | expr LBRACKET INT_LITERAL RBRACKET ADDEDGE LPAREN ID COMMA ID RPAREN { GopAddEdge($1, $3, AddEdge, $7, $9)}
  | expr REMOVEEDGE LPAREN ID COMMA ID RPAREN { GopRemoveEdge($1, RemoveEdge, $4, $6)}
  | ID ADDNODE ID { Gop($1, AddNode, $3) }
  | ID REMOVENODE ID { Gop($1, RemoveNode, $3) }
  | expr GETNAME  { Nop($1, GetName) }
  | expr GETVISITED  { Nop($1, GetVisited) }
  | expr GETINNODES  { Nop($1, GetInNodes) }
  | expr GETOUTNODES  { Nop($1, GetOutNodes) }
  | expr GETDATA  { Nop($1, GetData) }


actuals_opt:
    /* nothing */ { [] }
  | actuals_list  { List.rev $1 }

actuals_list:
    expr                    { [$1] }
  | actuals_list COMMA expr { $3 :: $1 }
