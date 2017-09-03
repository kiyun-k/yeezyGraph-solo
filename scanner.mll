(* Ocamllex scanner for YeezyGraph *)

{ open Parser }

rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| "/*"     { comment lexbuf }           (* Comments *)
| '('      { LPAREN }		| ')'      { RPAREN }
| '{'      { LBRACE }		| '}'      { RBRACE }
| '['      { LBRACKET }		| ']'      { RBRACKET }
| ';'      { SEMI }			| ','      { COMMA }

| '+'      { PLUS }			| '-'      { MINUS }
| '*'      { TIMES }		| '/'      { DIVIDE }
| '='      { ASSIGN }

| "=="     { EQ }			| "!="     { NEQ }
| '<'      { LT }			| "<="     { LEQ }
| ">"      { GT }			| ">="     { GEQ }
| "&&"     { AND }			| "||"     { OR }
| "!"      { NOT }

| "if"     { IF }			| "else"   { ELSE }
| "for"    { FOR }			| "while"  { WHILE }
| "return" { RETURN }		| "new"		{ NEW }
| "."		{ DOT }

| "int"    { INT }			| "bool"   { BOOL }			| "string"	{ STRING }
| "void"   { VOID }			| "float"  { FLOAT }

| "struct"	{ STRUCT }		| "List"	{ LIST }		| "Queue"	{ QUEUE }
| "Node" 	{ NODE }		| "Graph"	{ GRAPH }		| "Pqueue"	{ PQUEUE }

| '~' { TILDE }

| "true"   { TRUE }			| "false"  { FALSE }

| ['0'-'9']+ as lxm { INT_LITERAL(int_of_string lxm) }
| '"'([^'"']* as lxm)'"' {STR_LITERAL(lxm)}
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) }
| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  "*/" { token lexbuf }
| _    { comment lexbuf }
