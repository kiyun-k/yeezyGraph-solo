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

val program :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.program
