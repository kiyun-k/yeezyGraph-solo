type token =
  | SEMI
  | LPAREN
  | RPAREN
  | LBRACE
  | RBRACE
  | COMMA
  | PLUS
  | MINUS
  | TIMES
  | DIVIDE
  | ASSIGN
  | NOT
  | EQ
  | NEQ
  | LT
  | LEQ
  | GT
  | GEQ
  | TRUE
  | FALSE
  | AND
  | OR
  | INT
  | BOOL
  | STRING
  | IF
  | ELSE
  | FOR
  | WHILE
  | RETURN
  | VOID
  | INT_LITERAL of (int)
  | STR_LITERAL of (string)
  | ID of (string)
  | EOF

open Parsing;;
let _ = parse_error;;
# 4 "parser.mly"
open Ast
# 43 "parser.ml"
let yytransl_const = [|
  257 (* SEMI *);
  258 (* LPAREN *);
  259 (* RPAREN *);
  260 (* LBRACE *);
  261 (* RBRACE *);
  262 (* COMMA *);
  263 (* PLUS *);
  264 (* MINUS *);
  265 (* TIMES *);
  266 (* DIVIDE *);
  267 (* ASSIGN *);
  268 (* NOT *);
  269 (* EQ *);
  270 (* NEQ *);
  271 (* LT *);
  272 (* LEQ *);
  273 (* GT *);
  274 (* GEQ *);
  275 (* TRUE *);
  276 (* FALSE *);
  277 (* AND *);
  278 (* OR *);
  279 (* INT *);
  280 (* BOOL *);
  281 (* STRING *);
  282 (* IF *);
  283 (* ELSE *);
  284 (* FOR *);
  285 (* WHILE *);
  286 (* RETURN *);
  287 (* VOID *);
    0 (* EOF *);
    0|]

let yytransl_block = [|
  288 (* INT_LITERAL *);
  289 (* STR_LITERAL *);
  290 (* ID *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\002\000\004\000\006\000\006\000\009\000\
\009\000\005\000\005\000\005\000\005\000\007\000\007\000\003\000\
\008\000\008\000\010\000\010\000\010\000\010\000\010\000\010\000\
\010\000\010\000\012\000\012\000\011\000\011\000\011\000\011\000\
\011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
\011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
\011\000\011\000\013\000\013\000\014\000\014\000\000\000"

let yylen = "\002\000\
\002\000\000\000\002\000\002\000\009\000\000\000\001\000\002\000\
\004\000\001\000\001\000\001\000\001\000\000\000\002\000\003\000\
\000\000\002\000\002\000\002\000\003\000\003\000\005\000\007\000\
\009\000\005\000\000\000\001\000\001\000\001\000\001\000\001\000\
\001\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
\003\000\003\000\003\000\003\000\003\000\002\000\002\000\003\000\
\004\000\003\000\000\000\001\000\001\000\003\000\002\000"

let yydefred = "\000\000\
\002\000\000\000\055\000\000\000\010\000\011\000\012\000\013\000\
\001\000\003\000\004\000\000\000\000\000\016\000\000\000\000\000\
\000\000\000\000\008\000\000\000\000\000\014\000\000\000\000\000\
\009\000\015\000\000\000\000\000\000\000\000\000\017\000\005\000\
\000\000\000\000\031\000\032\000\000\000\000\000\000\000\000\000\
\029\000\030\000\000\000\018\000\000\000\000\000\000\000\046\000\
\047\000\000\000\000\000\000\000\020\000\000\000\000\000\000\000\
\019\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\050\000\022\000\000\000\
\000\000\000\000\000\000\021\000\000\000\000\000\000\000\000\000\
\000\000\000\000\036\000\037\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\049\000\
\000\000\000\000\000\000\026\000\000\000\000\000\000\000\024\000\
\000\000\000\000\025\000"

let yydgoto = "\002\000\
\003\000\004\000\010\000\011\000\012\000\017\000\024\000\028\000\
\018\000\044\000\045\000\074\000\078\000\079\000"

let yysindex = "\022\000\
\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\224\254\040\255\000\000\070\255\011\255\
\048\255\046\255\000\000\053\255\070\255\000\000\024\255\070\255\
\000\000\000\000\026\255\051\255\064\255\160\255\000\000\000\000\
\160\255\160\255\000\000\000\000\066\255\067\255\076\255\042\255\
\000\000\000\000\013\255\000\000\212\255\176\000\084\255\000\000\
\000\000\160\255\160\255\160\255\000\000\230\255\160\255\160\255\
\000\000\160\255\160\255\160\255\160\255\160\255\160\255\160\255\
\160\255\160\255\160\255\160\255\160\255\000\000\000\000\192\000\
\224\000\065\255\208\000\000\000\224\000\069\255\081\255\224\000\
\038\255\038\255\000\000\000\000\011\001\011\001\156\255\156\255\
\156\255\156\255\255\000\240\000\141\255\160\255\141\255\000\000\
\160\255\055\255\248\255\000\000\224\000\141\255\160\255\000\000\
\087\255\141\255\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\088\255\000\000\
\000\000\095\255\000\000\000\000\000\000\000\000\000\000\103\255\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\194\255\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\099\255\000\000\000\000\000\000\106\255\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\016\255\000\000\000\000\000\000\006\255\000\000\116\255\096\255\
\027\000\049\000\000\000\000\000\143\000\160\000\071\000\093\000\
\115\000\137\000\184\255\005\255\000\000\000\000\000\000\000\000\
\000\000\122\255\000\000\000\000\010\255\000\000\117\255\000\000\
\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\000\000\082\000\000\000\025\000\000\000\000\000\090\000\
\000\000\168\255\226\255\035\000\000\000\000\000"

let yytablesize = 541
let yytable = "\046\000\
\009\000\013\000\048\000\049\000\098\000\045\000\100\000\045\000\
\053\000\054\000\045\000\053\000\054\000\104\000\055\000\054\000\
\028\000\107\000\028\000\072\000\073\000\075\000\001\000\056\000\
\077\000\080\000\045\000\081\000\082\000\083\000\084\000\085\000\
\086\000\087\000\088\000\089\000\090\000\091\000\092\000\016\000\
\014\000\015\000\053\000\030\000\019\000\023\000\060\000\061\000\
\027\000\033\000\020\000\021\000\030\000\034\000\031\000\032\000\
\022\000\025\000\033\000\029\000\035\000\036\000\034\000\099\000\
\014\000\094\000\101\000\050\000\051\000\035\000\036\000\096\000\
\073\000\041\000\042\000\043\000\037\000\052\000\038\000\039\000\
\040\000\102\000\041\000\042\000\043\000\030\000\097\000\031\000\
\071\000\106\000\006\000\033\000\005\000\006\000\007\000\034\000\
\048\000\007\000\048\000\027\000\008\000\048\000\035\000\036\000\
\017\000\026\000\017\000\017\000\051\000\037\000\017\000\038\000\
\039\000\040\000\017\000\041\000\042\000\043\000\052\000\027\000\
\047\000\017\000\017\000\023\000\000\000\023\000\023\000\000\000\
\017\000\023\000\017\000\017\000\017\000\023\000\017\000\017\000\
\017\000\105\000\000\000\000\000\023\000\023\000\030\000\000\000\
\031\000\000\000\000\000\023\000\033\000\023\000\023\000\023\000\
\034\000\023\000\023\000\023\000\000\000\000\000\000\000\035\000\
\036\000\030\000\058\000\059\000\060\000\061\000\037\000\033\000\
\038\000\039\000\040\000\034\000\041\000\042\000\043\000\000\000\
\000\000\000\000\035\000\036\000\000\000\000\000\000\000\000\000\
\044\000\000\000\044\000\000\000\000\000\044\000\000\000\041\000\
\042\000\043\000\033\000\000\000\033\000\000\000\000\000\033\000\
\033\000\033\000\033\000\033\000\044\000\044\000\033\000\033\000\
\033\000\033\000\033\000\033\000\057\000\000\000\033\000\033\000\
\000\000\000\000\058\000\059\000\060\000\061\000\000\000\000\000\
\062\000\063\000\064\000\065\000\066\000\067\000\076\000\000\000\
\068\000\069\000\000\000\000\000\058\000\059\000\060\000\061\000\
\000\000\000\000\062\000\063\000\064\000\065\000\066\000\067\000\
\103\000\000\000\068\000\069\000\000\000\000\000\058\000\059\000\
\060\000\061\000\000\000\000\000\062\000\063\000\064\000\065\000\
\066\000\067\000\000\000\000\000\068\000\069\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\005\000\
\006\000\007\000\000\000\034\000\000\000\034\000\000\000\008\000\
\034\000\034\000\034\000\000\000\000\000\000\000\000\000\034\000\
\034\000\034\000\034\000\034\000\034\000\000\000\000\000\034\000\
\034\000\035\000\000\000\035\000\000\000\000\000\035\000\035\000\
\035\000\000\000\000\000\000\000\000\000\035\000\035\000\035\000\
\035\000\035\000\035\000\000\000\000\000\035\000\035\000\040\000\
\000\000\040\000\000\000\000\000\040\000\000\000\000\000\000\000\
\000\000\000\000\000\000\040\000\040\000\040\000\040\000\040\000\
\040\000\000\000\000\000\040\000\040\000\041\000\000\000\041\000\
\000\000\000\000\041\000\000\000\000\000\000\000\000\000\000\000\
\000\000\041\000\041\000\041\000\041\000\041\000\041\000\000\000\
\000\000\041\000\041\000\042\000\000\000\042\000\000\000\000\000\
\042\000\000\000\000\000\000\000\000\000\000\000\000\000\042\000\
\042\000\042\000\042\000\042\000\042\000\000\000\000\000\042\000\
\042\000\043\000\000\000\043\000\000\000\000\000\043\000\038\000\
\000\000\038\000\000\000\000\000\038\000\043\000\043\000\043\000\
\043\000\043\000\043\000\038\000\038\000\043\000\043\000\000\000\
\039\000\000\000\039\000\038\000\038\000\039\000\000\000\000\000\
\000\000\000\000\000\000\000\000\039\000\039\000\000\000\000\000\
\000\000\000\000\070\000\000\000\039\000\039\000\058\000\059\000\
\060\000\061\000\000\000\000\000\062\000\063\000\064\000\065\000\
\066\000\067\000\093\000\000\000\068\000\069\000\058\000\059\000\
\060\000\061\000\000\000\000\000\062\000\063\000\064\000\065\000\
\066\000\067\000\095\000\000\000\068\000\069\000\058\000\059\000\
\060\000\061\000\000\000\000\000\062\000\063\000\064\000\065\000\
\066\000\067\000\000\000\000\000\068\000\069\000\058\000\059\000\
\060\000\061\000\000\000\000\000\062\000\063\000\064\000\065\000\
\066\000\067\000\000\000\000\000\068\000\069\000\058\000\059\000\
\060\000\061\000\000\000\000\000\062\000\063\000\064\000\065\000\
\066\000\067\000\000\000\000\000\068\000\058\000\059\000\060\000\
\061\000\000\000\000\000\062\000\063\000\064\000\065\000\066\000\
\067\000\058\000\059\000\060\000\061\000\000\000\000\000\000\000\
\000\000\064\000\065\000\066\000\067\000"

let yycheck = "\030\000\
\000\000\034\001\033\000\034\000\093\000\001\001\095\000\003\001\
\003\001\040\000\006\001\006\001\003\001\102\000\002\001\006\001\
\001\001\106\000\003\001\050\000\051\000\052\000\001\000\011\001\
\055\000\056\000\022\001\058\000\059\000\060\000\061\000\062\000\
\063\000\064\000\065\000\066\000\067\000\068\000\069\000\015\000\
\001\001\002\001\001\001\002\001\034\001\021\000\009\001\010\001\
\024\000\008\001\003\001\006\001\002\001\012\001\004\001\005\001\
\004\001\034\001\008\001\034\001\019\001\020\001\012\001\094\000\
\001\001\001\001\097\000\002\001\002\001\019\001\020\001\003\001\
\103\000\032\001\033\001\034\001\026\001\002\001\028\001\029\001\
\030\001\027\001\032\001\033\001\034\001\002\001\006\001\004\001\
\005\001\003\001\003\001\008\001\023\001\024\001\025\001\012\001\
\001\001\003\001\003\001\001\001\031\001\006\001\019\001\020\001\
\002\001\024\000\004\001\005\001\003\001\026\001\008\001\028\001\
\029\001\030\001\012\001\032\001\033\001\034\001\003\001\003\001\
\031\000\019\001\020\001\002\001\255\255\004\001\005\001\255\255\
\026\001\008\001\028\001\029\001\030\001\012\001\032\001\033\001\
\034\001\103\000\255\255\255\255\019\001\020\001\002\001\255\255\
\004\001\255\255\255\255\026\001\008\001\028\001\029\001\030\001\
\012\001\032\001\033\001\034\001\255\255\255\255\255\255\019\001\
\020\001\002\001\007\001\008\001\009\001\010\001\026\001\008\001\
\028\001\029\001\030\001\012\001\032\001\033\001\034\001\255\255\
\255\255\255\255\019\001\020\001\255\255\255\255\255\255\255\255\
\001\001\255\255\003\001\255\255\255\255\006\001\255\255\032\001\
\033\001\034\001\001\001\255\255\003\001\255\255\255\255\006\001\
\007\001\008\001\009\001\010\001\021\001\022\001\013\001\014\001\
\015\001\016\001\017\001\018\001\001\001\255\255\021\001\022\001\
\255\255\255\255\007\001\008\001\009\001\010\001\255\255\255\255\
\013\001\014\001\015\001\016\001\017\001\018\001\001\001\255\255\
\021\001\022\001\255\255\255\255\007\001\008\001\009\001\010\001\
\255\255\255\255\013\001\014\001\015\001\016\001\017\001\018\001\
\001\001\255\255\021\001\022\001\255\255\255\255\007\001\008\001\
\009\001\010\001\255\255\255\255\013\001\014\001\015\001\016\001\
\017\001\018\001\255\255\255\255\021\001\022\001\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\023\001\
\024\001\025\001\255\255\001\001\255\255\003\001\255\255\031\001\
\006\001\007\001\008\001\255\255\255\255\255\255\255\255\013\001\
\014\001\015\001\016\001\017\001\018\001\255\255\255\255\021\001\
\022\001\001\001\255\255\003\001\255\255\255\255\006\001\007\001\
\008\001\255\255\255\255\255\255\255\255\013\001\014\001\015\001\
\016\001\017\001\018\001\255\255\255\255\021\001\022\001\001\001\
\255\255\003\001\255\255\255\255\006\001\255\255\255\255\255\255\
\255\255\255\255\255\255\013\001\014\001\015\001\016\001\017\001\
\018\001\255\255\255\255\021\001\022\001\001\001\255\255\003\001\
\255\255\255\255\006\001\255\255\255\255\255\255\255\255\255\255\
\255\255\013\001\014\001\015\001\016\001\017\001\018\001\255\255\
\255\255\021\001\022\001\001\001\255\255\003\001\255\255\255\255\
\006\001\255\255\255\255\255\255\255\255\255\255\255\255\013\001\
\014\001\015\001\016\001\017\001\018\001\255\255\255\255\021\001\
\022\001\001\001\255\255\003\001\255\255\255\255\006\001\001\001\
\255\255\003\001\255\255\255\255\006\001\013\001\014\001\015\001\
\016\001\017\001\018\001\013\001\014\001\021\001\022\001\255\255\
\001\001\255\255\003\001\021\001\022\001\006\001\255\255\255\255\
\255\255\255\255\255\255\255\255\013\001\014\001\255\255\255\255\
\255\255\255\255\003\001\255\255\021\001\022\001\007\001\008\001\
\009\001\010\001\255\255\255\255\013\001\014\001\015\001\016\001\
\017\001\018\001\003\001\255\255\021\001\022\001\007\001\008\001\
\009\001\010\001\255\255\255\255\013\001\014\001\015\001\016\001\
\017\001\018\001\003\001\255\255\021\001\022\001\007\001\008\001\
\009\001\010\001\255\255\255\255\013\001\014\001\015\001\016\001\
\017\001\018\001\255\255\255\255\021\001\022\001\007\001\008\001\
\009\001\010\001\255\255\255\255\013\001\014\001\015\001\016\001\
\017\001\018\001\255\255\255\255\021\001\022\001\007\001\008\001\
\009\001\010\001\255\255\255\255\013\001\014\001\015\001\016\001\
\017\001\018\001\255\255\255\255\021\001\007\001\008\001\009\001\
\010\001\255\255\255\255\013\001\014\001\015\001\016\001\017\001\
\018\001\007\001\008\001\009\001\010\001\255\255\255\255\255\255\
\255\255\015\001\016\001\017\001\018\001"

let yynames_const = "\
  SEMI\000\
  LPAREN\000\
  RPAREN\000\
  LBRACE\000\
  RBRACE\000\
  COMMA\000\
  PLUS\000\
  MINUS\000\
  TIMES\000\
  DIVIDE\000\
  ASSIGN\000\
  NOT\000\
  EQ\000\
  NEQ\000\
  LT\000\
  LEQ\000\
  GT\000\
  GEQ\000\
  TRUE\000\
  FALSE\000\
  AND\000\
  OR\000\
  INT\000\
  BOOL\000\
  STRING\000\
  IF\000\
  ELSE\000\
  FOR\000\
  WHILE\000\
  RETURN\000\
  VOID\000\
  EOF\000\
  "

let yynames_block = "\
  INT_LITERAL\000\
  STR_LITERAL\000\
  ID\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'decls) in
    Obj.repr(
# 43 "parser.mly"
            ( _1 )
# 348 "parser.ml"
               : Ast.program))
; (fun __caml_parser_env ->
    Obj.repr(
# 46 "parser.mly"
                 ( [], [] )
# 354 "parser.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'decls) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'vdecl) in
    Obj.repr(
# 47 "parser.mly"
               ( (_2 :: fst _1), snd _1 )
# 362 "parser.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'decls) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'fdecl) in
    Obj.repr(
# 48 "parser.mly"
               ( fst _1, (_2 :: snd _1) )
# 370 "parser.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 8 : 'typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 7 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 5 : 'formals_opt) in
    let _7 = (Parsing.peek_val __caml_parser_env 2 : 'vdecl_list) in
    let _8 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 52 "parser.mly"
     ( { typ = _1;
	 fname = _2;
	 formals = _4;
	 locals = List.rev _7;
	 body = List.rev _8 } )
# 385 "parser.ml"
               : 'fdecl))
; (fun __caml_parser_env ->
    Obj.repr(
# 59 "parser.mly"
                  ( [] )
# 391 "parser.ml"
               : 'formals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'formal_list) in
    Obj.repr(
# 60 "parser.mly"
                  ( List.rev _1 )
# 398 "parser.ml"
               : 'formals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 63 "parser.mly"
                             ( [(_1,_2)] )
# 406 "parser.ml"
               : 'formal_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'formal_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'typ) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 64 "parser.mly"
                             ( (_3,_4) :: _1 )
# 415 "parser.ml"
               : 'formal_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 67 "parser.mly"
        ( Int )
# 421 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 68 "parser.mly"
         ( Bool )
# 427 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 69 "parser.mly"
           ( String )
# 433 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 70 "parser.mly"
         ( Void )
# 439 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 73 "parser.mly"
                     ( [] )
# 445 "parser.ml"
               : 'vdecl_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'vdecl_list) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'vdecl) in
    Obj.repr(
# 74 "parser.mly"
                     ( _2 :: _1 )
# 453 "parser.ml"
               : 'vdecl_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 77 "parser.mly"
               ( (_1, _2) )
# 461 "parser.ml"
               : 'vdecl))
; (fun __caml_parser_env ->
    Obj.repr(
# 80 "parser.mly"
                   ( [] )
# 467 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 81 "parser.mly"
                   ( _2 :: _1 )
# 475 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 84 "parser.mly"
              ( Expr _1 )
# 482 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 85 "parser.mly"
                ( Return Noexpr )
# 488 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 86 "parser.mly"
                     ( Return _2 )
# 495 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 87 "parser.mly"
                            ( Block(List.rev _2) )
# 502 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 88 "parser.mly"
                                            ( If(_3, _5, Block([])) )
# 510 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : 'stmt) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 89 "parser.mly"
                                            ( If(_3, _5, _7) )
# 519 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 6 : 'expr_opt) in
    let _5 = (Parsing.peek_val __caml_parser_env 4 : 'expr) in
    let _7 = (Parsing.peek_val __caml_parser_env 2 : 'expr_opt) in
    let _9 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 91 "parser.mly"
     ( For(_3, _5, _7, _9) )
# 529 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 92 "parser.mly"
                                  ( While(_3, _5) )
# 537 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 95 "parser.mly"
                  ( Noexpr )
# 543 "parser.ml"
               : 'expr_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 96 "parser.mly"
                  ( _1 )
# 550 "parser.ml"
               : 'expr_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 99 "parser.mly"
                     ( IntLit(_1) )
# 557 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 100 "parser.mly"
                     ( StringLit(_1) )
# 564 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 101 "parser.mly"
                     ( BoolLit(true) )
# 570 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 102 "parser.mly"
                     ( BoolLit(false) )
# 576 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 103 "parser.mly"
                     ( Id(_1) )
# 583 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 104 "parser.mly"
                     ( Binop(_1, Add,   _3) )
# 591 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 105 "parser.mly"
                     ( Binop(_1, Sub,   _3) )
# 599 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 106 "parser.mly"
                     ( Binop(_1, Mult,  _3) )
# 607 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 107 "parser.mly"
                     ( Binop(_1, Div,   _3) )
# 615 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 108 "parser.mly"
                     ( Binop(_1, Equal, _3) )
# 623 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 109 "parser.mly"
                     ( Binop(_1, Neq,   _3) )
# 631 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 110 "parser.mly"
                     ( Binop(_1, Less,  _3) )
# 639 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 111 "parser.mly"
                     ( Binop(_1, Leq,   _3) )
# 647 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 112 "parser.mly"
                     ( Binop(_1, Greater, _3) )
# 655 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 113 "parser.mly"
                     ( Binop(_1, Geq,   _3) )
# 663 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 114 "parser.mly"
                     ( Binop(_1, And,   _3) )
# 671 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 115 "parser.mly"
                     ( Binop(_1, Or,    _3) )
# 679 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 116 "parser.mly"
                         ( Unop(Neg, _2) )
# 686 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 117 "parser.mly"
                     ( Unop(Not, _2) )
# 693 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 118 "parser.mly"
                     ( Assign(_1, _3) )
# 701 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'actuals_opt) in
    Obj.repr(
# 119 "parser.mly"
                                 ( Call(_1, _3) )
# 709 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 120 "parser.mly"
                       ( _2 )
# 716 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 123 "parser.mly"
                  ( [] )
# 722 "parser.ml"
               : 'actuals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'actuals_list) in
    Obj.repr(
# 124 "parser.mly"
                  ( List.rev _1 )
# 729 "parser.ml"
               : 'actuals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 127 "parser.mly"
                            ( [_1] )
# 736 "parser.ml"
               : 'actuals_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'actuals_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 128 "parser.mly"
                            ( _3 :: _1 )
# 744 "parser.ml"
               : 'actuals_list))
(* Entry program *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let program (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Ast.program)
