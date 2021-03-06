(* Semantic checking for the MicroC compiler *)

open Ast

module StringMap = Map.Make(String)

(* Semantic checking of a program. Returns void if successful,
   throws an exception if something is wrong.

   Check each global variable, then check each function *)

let check (globals, functions, structs) =

  (* Raise an exception if the given list has a duplicate *)
  let report_duplicate exceptf list =
    let rec helper = function
	     n1 :: n2 :: _ when n1 = n2 -> raise (Failure (exceptf n1))
      | _ :: t -> helper t
      | [] -> ()
    in helper (List.sort compare list)
  in

  (* Raise an exception if a given binding is to a void type *)
  let check_not_void exceptf = function
      (Void, n) -> raise (Failure (exceptf n))
    | _ -> ()
  in

  (* Raise an exception of the given rvalue type cannot be assigned to
     the given lvalue type *)
     let check_assign lvaluet rvaluet err =
       if (lvaluet) = (rvaluet) then lvaluet else raise err
    in
     

  (**** Checking Global Variables ****)

  List.iter (check_not_void (fun n -> "illegal void global " ^ n)) globals;

  report_duplicate (fun n -> "duplicate global " ^ n) (List.map snd globals);

  (**** Checking Structs ****)
  report_duplicate (fun n -> "duplicate struct type " ^ n)
    (List.map (fun sd -> sd.sname) structs);

  (**** Checking Functions ****)

  if List.mem "print" (List.map (fun fd -> fd.fname) functions)
  then raise (Failure ("function print may not be defined")) else ();

  if List.mem "strconcat" (List.map (fun fd -> fd.fname) functions)
  then raise (Failure ("function strconcat may not be defined")) else ();

  if List.mem "node" (List.map (fun fd -> fd.fname) functions)
  then raise (Failure ("function node may not be defined")) else ();

  if List.mem "graph" (List.map (fun fd -> fd.fname) functions)
  then raise (Failure ("function graph may not be defined")) else ();

  if List.mem "queue" (List.map (fun fd -> fd.fname) functions)
  then raise (Failure ("function queue may not be defined")) else ();

  if List.mem "list" (List.map (fun fd -> fd.fname) functions)
  then raise (Failure ("function list may not be defined")) else ();

  if List.mem "map" (List.map (fun fd -> fd.fname) functions)
  then raise (Failure ("function map may not be defined")) else ();

  if List.mem "pqueue" (List.map (fun fd -> fd.fname) functions)
  then raise (Failure ("function pqueue may not be defined")) else ();

  report_duplicate (fun n -> "duplicate function " ^ n)
    (List.map (fun fd -> fd.fname) functions);

  (* Function declaration for a named function *)
  let built_in_decls =
    StringMap.add "print"
      { typ = Void; fname = "print"; formals = [(Int, "x")];
       locals = []; body = [] }
    (StringMap.add "printb"
        { typ = Void; fname = "printb"; formals = [(Bool, "x")];
          locals = []; body = [] }
    (StringMap.add "printint"
      { typ = Void; fname = "printint"; formals = [(Int, "x")];
      locals = []; body = [] }
    (StringMap.add "printfloat"
      { typ = Void; fname = "printfloat"; formals = [(Float, "x")];
       locals = []; body = [] }
    (StringMap.add "prints"
      { typ = Void; fname = "prints"; formals = [(String, "x")];
       locals = []; body = [] }
    (StringMap.add "printstring"
     { typ = Void; fname = "printstring"; formals = [(String, "x")];
      locals = []; body = [] }
    (StringMap.add "strconcat"
     { typ = String; fname = "strconcat"; formals = [(String, "x"); (String, "x")];
      locals = []; body = [] }
    (StringMap.add "printList"
     { typ = Void; fname = "printList"; formals = [];
       locals = []; body = [] }
    (StringMap.add "initList"
     { typ = Void; fname = "initList"; formals = [];
       locals = []; body = [] }
    (StringMap.add "getNode"
     { typ = AnyType; fname = "getNode"; formals = [(Int, "x")];
       locals = []; body = [] }
    (StringMap.add "addNode"
     { typ = Void; fname = "addNode"; formals = [(AnyType, "x")];
       locals = []; body = [] }
    (StringMap.add "removeNode"
     { typ = Void; fname = "removeNode"; formals = [(Int, "x")];
       locals = []; body = [] }
    (StringMap.add "appendNode"
     { typ = Void; fname = "appendNode"; formals = [(AnyType, "x")];
       locals = []; body = [] }
    (StringMap.add "removeAll"
     { typ = Void; fname = "removeAll"; formals = [];
       locals = []; body = [] }
    (StringMap.add "isEmpty"
     { typ = Bool; fname = "isEmpty"; formals = [];
       locals = []; body = [] }
    (StringMap.singleton "size"
     { typ = Int; fname = "size"; formals = [];
       locals = []; body = [] }
     )))))))))))))))
   in

  let function_decls = List.fold_left (fun m fd -> StringMap.add fd.fname fd m)
                         built_in_decls functions
  in

  let function_decl s = try StringMap.find s function_decls
       with Not_found -> raise (Failure ("unrecognized function " ^ s))
  in

  let _ = function_decl "main" in (* Ensure "main" is defined *)


  let check_AccessStructField struct_name field_name =
    match struct_name with
        StructType struct_type ->
          (let the_struct_type = try List.find (fun s -> s.sname = struct_type) structs
                                 with Not_found -> raise (Failure("struct type " ^ struct_type ^ " is undefined")) in
          try fst( List.find (fun s -> snd(s) = field_name) the_struct_type.sformals)
          with Not_found -> raise (Failure("struct " ^ struct_type ^ " does not contain field " ^ field_name)))
      | _ -> raise (Failure(string_of_typ struct_name ^ " is not a struct type"))
  in

  let check_function func =

    List.iter (check_not_void (fun n -> "illegal void formal " ^ n ^
      " in " ^ func.fname)) func.formals;

    report_duplicate (fun n -> "duplicate formal " ^ n ^ " in " ^ func.fname)
      (List.map snd func.formals);

    List.iter (check_not_void (fun n -> "illegal void local " ^ n ^
      " in " ^ func.fname)) func.locals;

    report_duplicate (fun n -> "duplicate local " ^ n ^ " in " ^ func.fname)
      (List.map snd func.locals);

    (* Type of each variable (global, formal, or local *)
    let symbols = List.fold_left (fun m (t, n) -> StringMap.add n t m)
	                               StringMap.empty
                                 (globals @ func.formals @ func.locals )
    in

    let get_type = function
      ListType(t) -> t
      | QueueType(t) -> t
      | NodeType(t) -> t
      | PQueueType(t) -> t
      | GraphType(t) -> t
      | _ -> Void in

    let type_of_identifier s =
      try StringMap.find s symbols
      with Not_found -> raise (Failure ("undeclared identifier " ^ s))
    in

    (* Return the type of an expression or throw an exception *)
    let rec expr = function
	      IntLit _ -> Int
      | Infinity -> Int
      | Neginfinity -> Int
      | FloatLit _ -> Float
      | BoolLit _ -> Bool
      | StringLit _ -> String
      | Id s -> type_of_identifier s
      | List (t, _) -> ListType(t)
      | Queue (t, _) -> QueueType(t)
      | PQueue(t, _) -> PQueueType(t)
      | Node(_, t) -> NodeType(t)
      | Graph(t) -> GraphType(t)
      | Binop(e1, op, e2) as e -> let t1 = expr e1
                                  and t2 = expr e2 in
	      (match op with
         Add | Sub | Mult | Div      when t1 = Int && t2 = Int -> Int
       | Add | Sub | Mult | Div      when t1 = Float && t2 = Float -> Float
       | Add                         when t1 = String && t2 = String -> String
	     | Equal | Neq                 when t1 = t2 -> Bool
	     | Less | Leq | Greater | Geq  when t1 = Int && t2 = Int -> Bool
       | Less | Leq | Greater | Geq  when t1 = Float && t2 = Float -> Bool
	     | And | Or                    when t1 = Bool && t2 = Bool -> Bool
       | _ -> raise (Failure ("illegal binary operator " ^
              string_of_typ t1 ^ " " ^ string_of_op op ^ " " ^
              string_of_typ t2 ^ " in " ^ string_of_expr e))
        )

      | Unop(op, e) as ex -> let t = expr e in
	      (match op with
	       Neg when t = Int -> Int
	     | Not when t = Bool -> Bool
       | _ -> raise (Failure ("illegal unary operator " ^ string_of_uop op ^
	  		       string_of_typ t ^ " in " ^ string_of_expr ex)))

      | Noexpr -> Void
      | Assign(e1, e2) as ex ->
        (match e1 with
          Id s -> let lt = type_of_identifier s and rt = expr e2 in
            if rt <> AnyType then check_assign lt rt (Failure ("illegal assignment " ^ string_of_typ lt ^
                                     " = " ^ string_of_typ rt ^ " in " ^ string_of_expr ex))
            else  check_assign rt rt (Failure ("illegal assignment " ^ string_of_typ lt ^
                                     " = " ^ string_of_typ rt ^ " in " ^
                                     string_of_expr ex))
        | AccessStructField(_, _) -> expr e2
        | _ -> raise (Failure("illegal graph operator")))

      | Call(fname, actuals) as call -> let fd = function_decl fname in
         if List.length actuals != List.length fd.formals then
           raise (Failure ("expecting " ^ string_of_int
             (List.length fd.formals) ^ " arguments in " ^ string_of_expr call))
         else
           List.iter2 (fun (ft, _) e -> let et = expr e in
              ignore (check_assign ft et
                (Failure ("illegal actual argument found " ^ string_of_typ et ^
                " expected " ^ string_of_typ ft ^ " in " ^ string_of_expr e))))
             fd.formals actuals;
           fd.typ
      | AccessStructField(e, field_name) -> let lt = expr e in check_AccessStructField lt field_name
      | ObjectCall(obj, func, act) as objectCall -> let fd = function_decl func in
        let returntype = ref (fd.typ) in
        if List.length act != List.length fd.formals then
          raise (Failure ("expecting " ^ string_of_int
            (List.length fd.formals) ^ " arguments in " ^ string_of_expr objectCall))
        else
          List.iter2 (fun (ft, _) e -> let et = expr e in
            if func = "q_add" then
               let acttype = expr obj in
               let actqtype = get_type acttype in
              ignore(check_assign actqtype et (Failure ("illegal actual queue argument found " ^ string_of_typ et ^
              " expected " ^ string_of_typ actqtype ^ " in " ^ string_of_expr e)))

            else if func = "weight" then
               let acttype = expr (List.hd act) in
                ignore(check_assign acttype et (Failure ("illegal actual node argument found " ^ string_of_typ et ^
              " expected " ^ string_of_typ acttype ^ " in " ^ string_of_expr e)))

            else if func = "p_push" then
               let acttype = expr (List.hd act) in
                ignore(check_assign acttype et (Failure ("illegal actual pqueue argument found " ^ string_of_typ et ^
              " expected " ^ string_of_typ acttype ^ " in " ^ string_of_expr e)))

            else if func = "setNodeData" then
               let acttype = expr obj in
               let actntype = get_type acttype in
                ignore(check_assign actntype et (Failure ("illegal actual node argument found " ^ string_of_typ et ^
              " expected " ^ string_of_typ actntype ^ " in " ^ string_of_expr e)))
            else if func = "l_add" then
              let acttype = expr obj in
              let actltype = get_type acttype in
              ignore(check_assign actltype et (Failure ("illegal actual list argument found " ^ string_of_typ et ^
              " expected " ^ string_of_typ actltype ^ " in " ^ string_of_expr e)))
            else ignore (check_assign ft et (Failure ("illegal actual argument found " ^ string_of_typ et ^
              " expected " ^ string_of_typ ft ^ " in " ^ string_of_expr e)))) fd.formals act;
          !returntype
        | Nop(n, op) -> let t = expr n in 
          (match t with 
            NodeType typ ->
              (match op with
                GetName -> String
                | GetData -> typ
                | GetVisited -> Bool
                | GetInNodes -> ListType(String)
                | GetOutNodes -> ListType(String)
              )
              | _ -> raise(Failure("Not a valid node operator"))
          )
        | Gop(g, op, n) -> let gt = type_of_identifier g and nt = type_of_identifier n in 
          ( match gt with 
            GraphType typ ->
              ( match op with 
                AccessNode when nt = String -> NodeType(typ)
                | AddNode when nt = String -> GraphType(typ)
                | RemoveNode when nt = String -> GraphType(typ)
                | _ -> raise(Failure("Not a valid graph operator"))
              )
            | _ -> raise(Failure("This is not a graph"))
          )
          
        | GopAddEdge(g, _, op, n1, n2) -> let gt = expr g and nt1 = type_of_identifier n1 and nt2 = type_of_identifier n2 in
          (match gt with 
            GraphType(typ) -> 
            (match op with 
              AddEdge when nt1 = NodeType(typ) && nt2 = NodeType(typ) -> GraphType(typ)
              | _ -> raise(Failure("Not a valid graph operator"))
            )
            | _ -> raise(Failure("This is not a graph"))
          )
        | GopRemoveEdge(g, op, n1, n2) -> let gt = expr g and nt1 = type_of_identifier n1 and nt2 = type_of_identifier n2 in
          (match gt with 
            GraphType(typ) -> 
            (match op with 
              RemoveEdge when nt1 = NodeType(typ) && nt2 = NodeType(typ) -> GraphType(typ)
              | _ -> raise(Failure("Not a valid graph operator"))
            )
            | _ -> raise(Failure("This is not a graph"))
          )
    in

    let check_bool_expr e = if expr e != Bool
                            then raise (Failure ("expected Boolean expression in " ^ string_of_expr e))
                            else () in

    (* Verify a statement or throw an exception *)
    let rec stmt = function
	      Block sl -> let rec check_block = function
           [Return _ as s]  -> stmt s
         | Return _ :: _    -> raise (Failure "nothing may follow a return")
         | Block sl :: ss   -> check_block (sl @ ss)
         | s :: ss          -> stmt s ; check_block ss
         | [] -> ()
        in check_block sl
      | Expr e -> ignore (expr e)
      | Return e -> let t = expr e in if t = func.typ then () else
         raise (Failure ("return gives " ^ string_of_typ t ^ " expected " ^
                         string_of_typ func.typ ^ " in " ^ string_of_expr e))
      | If(p, b1, b2) -> check_bool_expr p; stmt b1; stmt b2
      | For(e1, e2, e3, st) -> ignore (expr e1); check_bool_expr e2;
                               ignore (expr e3); stmt st
      | While(p, s) -> check_bool_expr p; stmt s
    in

    stmt (Block func.body)

  in
  List.iter check_function functions
