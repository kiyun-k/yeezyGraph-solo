(* Abstract Syntax Tree and functions for printing it *)

type op = Add | Sub | Mult | Div |
          Equal | Neq | Less | Leq | Greater | Geq |
          And | Or

type uop = Neg | Not

type nodeop = GetName | GetVisited | GetInNodes | GetOutNodes | GetData

type graphop = AccessNode | AddNode | RemoveNode 

type addedge = AddEdge 
type removeedge = RemoveEdge

type typ = Int | Bool | Float | String | Void | StructType of string
| GraphType of typ | NodeType of typ | QueueType of typ |PQueueType
| ListType of typ | AnyType


type bind = typ * string

type expr =
    IntLit of int
  | BoolLit of bool
  | FloatLit of float
  | StringLit of string
  | Id of string
  | Binop of expr * op * expr
  | Unop of uop * expr
  | Nop of expr * nodeop
  | Gop of string * graphop * string
  | GopAddEdge of expr * int * addedge * string * string
  | GopRemoveEdge of expr * removeedge * string * string
  | Assign of expr * expr
  | Call of string * expr list
  | List of typ * expr list
  | Queue of typ * expr list
  | PQueue of expr list
  | Graph of typ
  | Node of string * typ
  | Noexpr
  | AccessStructField of expr * string
  | ObjectCall of expr * string * expr list
  | Infinity
  | Neginfinity

type stmt =
    Block of stmt list
  | Expr of expr
  | Return of expr
  | If of expr * stmt * stmt
  | For of expr * expr * expr * stmt
  | While of expr * stmt

type func_decl = {
    typ : typ;
    fname : string;
    formals : bind list;
    locals : bind list;
    body : stmt list;
  }

type struct_decl = {
  sname : string;
  sformals : bind list;
}

type program = bind list * func_decl list * struct_decl list

(* Pretty-printing functions *)

let rec string_of_typ = function
    Int -> "int"
  | Float -> "float"
  | Bool -> "bool"
  | String -> "string"
  | Void -> "void"
  | StructType(s) -> s
  | ListType(t) -> "List " ^ string_of_typ t
  | QueueType(t) -> "Queue " ^ string_of_typ t
  | PQueueType(t) -> "Pqueue "
  | NodeType(t) -> "Node " ^ string_of_typ t
  | GraphType(t) -> "Graph " ^ string_of_typ t
  | AnyType -> "AnyType"

let string_of_op = function
    Add -> "+"
  | Sub -> "-"
  | Mult -> "*"
  | Div -> "/"
  | Equal -> "=="
  | Neq -> "!="
  | Less -> "<"
  | Leq -> "<="
  | Greater -> ">"
  | Geq -> ">="
  | And -> "&&"
  | Or -> "||"

let string_of_uop = function
    Neg -> "-"
  | Not -> "!"

let string_of_nop = function 
  GetName -> "@name"
  | GetVisited -> "@visited"
  | GetData -> "@data"
  | GetInNodes -> "@in"
  | GetOutNodes -> "@out"

let string_of_gop = function
  AccessNode -> "_"
  | AddNode -> "++"
  | RemoveNode -> "--"
  
let string_of_gop2 = function 
  AddEdge -> "->"

let string_of_gop3 = function 
  RemoveEdge -> "!->"

let rec string_of_expr = function
    IntLit(l) -> string_of_int l
  | BoolLit(true) -> "true"
  | BoolLit(false) -> "false"
  | FloatLit(l) -> string_of_float l
  | StringLit(s) -> s
  | Id(s) -> s
  | Binop(e1, o, e2) ->
      string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
  | Unop(o, e) -> string_of_uop o ^ string_of_expr e
  | Assign(v, e) -> string_of_expr v ^ " = " ^ string_of_expr e
  | Call(f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"
  | Noexpr -> ""
  | List (t, e1) ->
      "new " ^ "List" ^ "<" ^ string_of_typ t ^ ">" ^ "(" ^ String.concat ", " (List.map string_of_expr e1) ^ ")"
  | Queue(t, e1) -> "new " ^ "Queue" ^ "<" ^ string_of_typ t ^ ">" ^ "(" ^ String.concat ", " (List.map string_of_expr e1) ^ ")"
  | PQueue(t, e1) -> "new" ^ "Pqueue" ^ "(" ^ String.concat ", " (List.map string_of_expr e1) ^ ")"
  | Graph(t) -> "new Graph" ^ "<" ^ string_of_typ t ^ ">"
  | Node(n, t) -> "new Node" ^ "<" ^ string_of_typ t ^ ">" ^ "(" ^ n ^ ")"
  | AccessStructField(v, e) -> string_of_expr v ^ "~" ^ e
  | ObjectCall(o, f, e1) -> string_of_expr o ^ "." ^ f ^ "(" ^ String.concat ", " (List.map string_of_expr e1) ^ ")"
  | Infinity -> "INFINITY"
  | Neginfinity -> "NEGINFINITY"
  | Gop (e1, o, e2) -> e1 ^ string_of_gop o ^ e2
  | GopAddEdge(e1, i, o, e2, e3) -> string_of_expr e1 ^ string_of_int i ^ string_of_gop2 o ^  "(" ^ e2 ^ ", " ^ e3 ^ ")"
  | GopRemoveEdge (e1, o, e2, e3) ->  string_of_expr e1 ^ string_of_gop3 o ^ "(" ^ e2 ^ ", " ^ e3 ^ ")"
  | Nop (e1, o) -> string_of_expr e1 ^ string_of_nop o

let rec string_of_stmt = function
    Block(stmts) ->
      "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | Expr(expr) -> string_of_expr expr ^ ";\n";
  | Return(expr) -> "return " ^ string_of_expr expr ^ ";\n";
  | If(e, s, Block([])) -> "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s
  | If(e, s1, s2) ->  "if (" ^ string_of_expr e ^ ")\n" ^
      string_of_stmt s1 ^ "else\n" ^ string_of_stmt s2
  | For(e1, e2, e3, s) ->
      "for (" ^ string_of_expr e1  ^ " ; " ^ string_of_expr e2 ^ " ; " ^
      string_of_expr e3  ^ ") " ^ string_of_stmt s
  | While(e, s) -> "while (" ^ string_of_expr e ^ ") " ^ string_of_stmt s


let string_of_vdecl (t, id) = string_of_typ t ^ " " ^ id ^ ";\n"

let string_of_fdecl fdecl =
  string_of_typ fdecl.typ ^ " " ^
  fdecl.fname ^ "(" ^ String.concat ", " (List.map snd fdecl.formals) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_vdecl fdecl.locals) ^
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "}\n"

let string_of_structdecl structdecl =
  "struct " ^ structdecl.sname ^ " \n{\n" ^
  String.concat "; " (List.map snd structdecl.sformals) ^
  "}\n"

let string_of_program (vars, funcs, structs) =
  String.concat "" (List.map string_of_vdecl vars) ^ "\n" ^
  String.concat "\n" (List.map string_of_structdecl structs) ^ "\n" ^
  String.concat "\n" (List.map string_of_fdecl funcs)
