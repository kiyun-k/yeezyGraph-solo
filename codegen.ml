(* Code generation: translate takes a semantically checked AST and
produces LLVM IR

LLVM tutorial: Make sure to read the OCaml version of the tutorial

http://llvm.org/docs/tutorial/index.html

Detailed documentation on the OCaml LLVM library:

http://llvm.moe/
http://llvm.moe/ocaml/

*)

module L = Llvm
module A = Ast

module StringMap = Map.Make(String)

let translate (globals, functions, structs) =
  let context = L.global_context () in
  let listctx = L.global_context () in
  let nodectx = L.global_context () in
  let graphctx = L.global_context () in
  let queuectx = L.global_context () in
  let pqueuectx = L.global_context () in

  let listmb = L.MemoryBuffer.of_file "linkedlist.bc" in
  let llm = Llvm_bitreader.parse_bitcode listctx listmb in
  let nodemb = L.MemoryBuffer.of_file"node.bc" in
  let nodem = Llvm_bitreader.parse_bitcode nodectx nodemb in
  let graphmb = L.MemoryBuffer.of_file"graph.bc" in
  let graphm = Llvm_bitreader.parse_bitcode graphctx graphmb in
  let queuemb = L.MemoryBuffer.of_file"queue.bc" in
  let queuem = Llvm_bitreader.parse_bitcode queuectx queuemb in
  let pqueuemb = L.MemoryBuffer.of_file"pqueue.bc" in
  let pqueuem = Llvm_bitreader.parse_bitcode pqueuectx pqueuemb in

  let the_module = L.create_module context "YeezyGraph"
  and i32_t  = L.i32_type  context
  and i8_t   = L.i8_type   context
  and i1_t   = L.i1_type   context
  and float_t = L.double_type context
  and list_t = L.pointer_type (match L.type_by_name llm "struct.List" with
    None -> raise (Invalid_argument "Option.get struct.List")
   | Some x -> x)
  and queue_t = L.pointer_type (match L.type_by_name queuem "struct.Queue" with
    None -> raise (Invalid_argument "Option.get queue") | Some x -> x)
  and pqueue_t = L.pointer_type (match L.type_by_name pqueuem "struct.Pqueue" with
    None -> raise (Invalid_argument "Option.get pqueue") | Some x -> x)
  and graph_t = L.pointer_type (match L.type_by_name graphm "struct.Graph" with
    None -> raise (Invalid_argument "Option.get graph") | Some x -> x )
  and node_t = L.pointer_type (match L.type_by_name nodem "struct.Node" with
    None -> raise (Invalid_argument "Option.get node") | Some x -> x )
  and void_t = L.void_type context in

  let struct_types =
     let add_struct m structdecl =
       let struct_t = L.named_struct_type context structdecl.A.sname
       in StringMap.add structdecl.A.sname struct_t m in
     List.fold_left add_struct StringMap.empty structs in

  let ltype_of_typ = function
      A.Int -> i32_t
    | A.Bool -> i1_t
    | A.Float -> float_t
    | A.String -> L.pointer_type i8_t
    | A.ListType _ -> list_t
    | A.GraphType _ -> graph_t
    | A.NodeType _  -> node_t
    | A.QueueType _ -> queue_t
    | A.PQueueType _ -> pqueue_t
    | A.StructType s -> (try StringMap.find s struct_types with Not_found -> raise (Failure("struct type " ^ s ^ " is undefined") ))
    | A.AnyType -> L.pointer_type i8_t
    | A.Void -> void_t in

  let build_struct_body sdecl =
    let struct_t = StringMap.find sdecl.A.sname struct_types in
    let element_list = Array.of_list(List.map (fun (t, _) -> ltype_of_typ t) sdecl.A.sformals) in
    L.struct_set_body struct_t element_list true in
    ignore(List.map build_struct_body structs);

  let struct_indexing_map =
    let fill_struct_indexing_map m this_struct =
      let field_name_list = List.map snd this_struct.A.sformals in
      let add_one i = i + 1 in
      let fill_field_indexing_map (m, i) field_name = StringMap.add field_name (add_one i) m, add_one i in
      let field_indexing_map = List.fold_left fill_field_indexing_map (StringMap.empty, -1) field_name_list in
      StringMap.add this_struct.A.sname (fst field_indexing_map) m
    in
    List.fold_left fill_struct_indexing_map StringMap.empty structs
  in

  (* Declare each global variable; remember its value in a map *)
  let global_types =
    let global_type m (t, n) = StringMap.add n t m in
  List.fold_left global_type StringMap.empty globals in

  let global_vars =
    let global_var m (t, n) =
      let init = L.const_int (ltype_of_typ t) 0
      in StringMap.add n (L.define_global n init the_module) m in
    List.fold_left global_var StringMap.empty globals in

  (* Declare printf(), which the print built-in function will call *)
  let printf_t = L.var_arg_function_type i32_t [| L.pointer_type i8_t |] in
  let printf_func = L.declare_function "printf" printf_t the_module in

  (* Declare built-in strcat() function *)
  let strcat_t = L.var_arg_function_type (L.pointer_type i8_t) [| L.pointer_type i8_t; L.pointer_type i8_t |] in
  let strcat_func = L.declare_function "strcat" strcat_t the_module in

  (* List functions *)
  let initList_t = L.function_type list_t [||] in
  let initList_f = L.declare_function "initList" initList_t the_module in
  let lAdd_t = L.function_type void_t [| list_t; L.pointer_type i8_t|] in
  let lAdd_f = L.declare_function "l_add" lAdd_t the_module in
  let lInsert_t = L.function_type void_t [| list_t; L.pointer_type i8_t; i32_t |] in
  let lInsert_f = L.declare_function "l_insert" lInsert_t the_module in
  let lRemove_t = L.function_type void_t [|list_t; i32_t|] in
  let lRemove_f = L.declare_function "l_remove" lRemove_t the_module in
  let lRemoveAll_t = L.function_type void_t [|list_t|] in
  let lRemoveAll_f = L.declare_function "removeAll" lRemoveAll_t the_module in
  let lIsEmpty_t = L.function_type i1_t [|list_t|] in
  let lIsEmpty_f = L.declare_function "l_isEmpty" lIsEmpty_t the_module in
  let lSize_t = L.function_type i32_t [|list_t|] in
  let lSize_f = L.declare_function "l_size" lSize_t the_module in
  let lGet_t = L.function_type (L.pointer_type i8_t) [|list_t; i32_t |] in
  let lGet_f = L.declare_function "l_get" lGet_t the_module in
  let printList_t = L.function_type void_t [|list_t|] in
  let printList_f = L.declare_function "printList" printList_t the_module in

  (* Node functions *)

  let initNode_t = L.function_type node_t [||] in
  let initNode_f = L.declare_function "initNode" initNode_t the_module in
  let getNodeName_t = L.function_type (L.pointer_type i8_t) [|node_t|] in
  let getNodeName_f = L.declare_function "getNodeName" getNodeName_t the_module in
  let setNodeData_t = L.function_type void_t [| node_t; L.pointer_type i8_t|] in
  let setNodeData_f = L.declare_function "setNodeData" setNodeData_t the_module in
  let isVisited_t = L.function_type i1_t [|node_t|] in
  let isVisited_f = L.declare_function "isVisited" isVisited_t the_module in
  let setVisited_t = L.function_type void_t [|node_t ; i1_t|] in
  let setVisited_f = L.declare_function "setVisited" setVisited_t the_module in
  let getInNodes_t = L.function_type list_t [|node_t|] in
  let getInNodes_f = L.declare_function "getInNodes" getInNodes_t the_module in
  let getOutNodes_t = L.function_type list_t [|node_t|] in
  let getOutNodes_f = L.declare_function "getOutNodes" getOutNodes_t the_module in
  let getNodeData_t = L.function_type (L.pointer_type i8_t) [|node_t|] in
  let getNodeData_f = L.declare_function "getNodeData" getNodeData_t the_module in
  let printNode_t  = L.function_type void_t [|node_t|] in
  let printNode_f = L.declare_function "printNode" printNode_t the_module in

  (* Queue functions *)
  let initQueue_t = L.function_type queue_t [||] in
  let initQueue_f = L.declare_function "initQueue" initQueue_t the_module in
  let enqueue_t = L.function_type void_t [|queue_t ; L.pointer_type i8_t|] in
  let enqueue_f = L.declare_function "enqueue" enqueue_t the_module in
  let dequeue_t = L.function_type void_t [|queue_t|] in
  let dequeue_f = L.declare_function "dequeue" dequeue_t the_module in
  let front_t = L.function_type (L.pointer_type i8_t) [|queue_t|] in
  let front_f = L.declare_function "front" front_t the_module in
  let qSize_t = L.function_type i32_t [|queue_t|] in
  let qSize_f = L.declare_function "q_size" qSize_t the_module in

  (* Pqueue functions *)
  let initPqueue_t = L.function_type pqueue_t [||] in
  let initPqueue_f = L.declare_function "initPqueue" initPqueue_t the_module in
  let pqPush_t = L.function_type void_t [| pqueue_t ; node_t |] in
  let pqPush_f = L.declare_function "pq_push" pqPush_t the_module in
  let pqPop_t = L.function_type node_t [|pqueue_t|] in
  let pqPop_f = L.declare_function "pq_pop" pqPop_t the_module in
  let pqIsEmpty_t = L.function_type i1_t [|pqueue_t|] in
  let pqIsEmpty_f = L.declare_function "pq_isEmpty" pqIsEmpty_t the_module in
  let pqSize_t = L.function_type i32_t [|pqueue_t|] in
  let pqSize_f = L.declare_function "pq_size" pqSize_t the_module in

  (* Graph functions *)
  let initGraph_t = L.function_type graph_t [||] in
  let initGraph_f = L.declare_function "initGraph" initGraph_t the_module in
  let addNode_t = L.function_type void_t [|graph_t; node_t|] in
  let addNode_f = L.declare_function "addNode" addNode_t the_module in
  let removeNode_t = L.function_type void_t [|graph_t; node_t|] in
  let removeNode_f = L.declare_function "removeNode" removeNode_t the_module in
  let addEdge_t = L.function_type void_t [|graph_t; node_t; node_t; i32_t|] in
  let addEdge_f = L.declare_function "addEdge" addEdge_t the_module in
  let removeEdge_t = L.function_type void_t [|graph_t; node_t; node_t|] in
  let removeEdge_f = L.declare_function "removeEdge" removeEdge_t the_module in
  let getWeight_t = L.function_type void_t [|graph_t; node_t; node_t|] in
  let getWeight_f = L.declare_function "getWeight" getWeight_t the_module in
  let getNodeByIndex_t = L.function_type node_t [|graph_t; i32_t|] in
  let getNodeByIndex_f = L.declare_function "getNodeByIndex" getNodeByIndex_t the_module in
  let freeGraph_t = L.function_type void_t [|graph_t|] in
  let freeGraph_f = L.declare_function "freeGraph" freeGraph_t the_module in
  let removeAllNodes_t = L.function_type void_t [|graph_t|] in
  let removeAllNodes_f = L.declare_function "removeAllNodes" removeAllNodes_t the_module in
  let printGraph_t = L.function_type void_t [|graph_t|] in
  let printGraph_f = L.declare_function "printGraph" printGraph_t the_module in
  let isEmpty_t = L.function_type i1_t [|graph_t|] in
  let isEmpty_f = L.declare_function "isEmpty" isEmpty_t the_module in
  let size_t = L.function_type i32_t [|graph_t|] in
  let size_f = L.declare_function "size" size_t the_module in
  let contains_t = L.function_type i1_t [|graph_t; L.pointer_type i8_t|] in
  let contains_f = L.declare_function "contains" contains_t the_module in
  let getNodeByName_t = L.function_type node_t [|graph_t; L.pointer_type i8_t|] in
  let getNodeByName_f = L.declare_function "getNodeByName" getNodeByName_t the_module in


  (* Define each function (arguments and return type) so we can call it *)
  let function_decls =
    let function_decl m fdecl =
      let name = fdecl.A.fname
      and formal_types = Array.of_list
          (List.map (fun (t,_) -> ltype_of_typ t) fdecl.A.formals)
      in let ftype =
          L.function_type (ltype_of_typ fdecl.A.typ) formal_types in
      StringMap.add name (L.define_function name ftype the_module, fdecl) m in
    List.fold_left function_decl StringMap.empty functions in

  (* Fill in the body of the given function *)
  let build_function_body fdecl =
    let (the_function, _) = StringMap.find fdecl.A.fname function_decls in
    let builder = L.builder_at_end context (L.entry_block the_function) in

    let int_format = L.build_global_stringptr "%d\n" "fmt" builder in
    let float_format = L.build_global_stringptr "%f\n" "fmt" builder in
    let str_format = L.build_global_stringptr "%s\n" "fmt" builder in

    let int_format2 = L.build_global_stringptr "%d" "fmt" builder in
    let str_format2 = L.build_global_stringptr "%s" "fmt" builder in

    (* Construct the function's "locals": formal arguments and locally
       declared variables.  Allocate each on the stack, initialize their
       value, if appropriate, and remember their values in the "locals" map *)
    let local_vars =
       let add_formal m (t, n) p = L.set_value_name n p;
 	       let local = L.build_alloca (ltype_of_typ t) n builder in
         ignore (L.build_store p local builder);
   	     StringMap.add n local m in

       let add_local m (t, n) =
   	     let local_var = L.build_alloca (ltype_of_typ t) n builder
   	     in StringMap.add n local_var m in

       let formals = List.fold_left2 add_formal StringMap.empty fdecl.A.formals
         (Array.to_list (L.params the_function)) in
         List.fold_left add_local formals fdecl.A.locals in

      let local_types =
         let add_type m (t, n) = StringMap.add n t m in
         let formal_types = List.fold_left add_type StringMap.empty fdecl.A.formals in
         List.fold_left add_type formal_types fdecl.A.locals in

       (* Return the value for a variable or formal argument *)
       let lookup n = try StringMap.find n local_vars
                      with Not_found -> StringMap.find n global_vars
       in

       let lookup_types n = try StringMap.find n local_types
                         with Not_found -> StringMap.find n global_types in

    let get_id_name = function
      A.Id s -> s
      | _ -> "" in

    let get_type = function
      A.ListType(t) -> t
      | A.QueueType(t) -> t
      | A.NodeType(t) -> t
      | A.PQueueType(t) -> t
      | A.GraphType(t) -> t
      | _ -> A.Void in

    (* Construct code for an expression; return its value *)
    let rec expr builder = function
      A.IntLit i -> L.const_int i32_t i
      | A.FloatLit f -> L.const_float float_t f
      | A.BoolLit b -> L.const_int i1_t (if b then 1 else 0)
      | A.StringLit s -> L.build_global_stringptr s "str" builder
      | A.Noexpr -> L.const_int i32_t 0
      | A.Id s -> L.build_load (lookup s) s builder
      | A.Infinity -> L.const_int i32_t (1000000)
      | A.Neginfinity -> L.const_int i32_t (-1000000)
      | A.Binop (e1, op, e2) ->
	       let e1' = expr builder e1
         and e2' = expr builder e2
         in
         let t1 = L.type_of e1' in
	       ( match op with
	         A.Add     -> if t1 = float_t then L.build_fadd
                        else (*if t1 = int_t then *) L.build_add
                        (* else L.build_call strcat_func [|(expr builder e1); (expr builder e2)|] "strcat" builder *)
	         | A.Sub     -> if t1 = float_t then L.build_fsub
                         else L.build_sub
           | A.Mult    -> if t1 = float_t then L.build_fmul
                        else L.build_mul
           | A.Div     -> if t1 = float_t then L.build_fdiv
                        else L.build_sdiv
	         | A.And     -> L.build_and
	         | A.Or      -> L.build_or
	         | A.Equal   -> if t1 = float_t then L.build_fcmp L.Fcmp.Oeq else L.build_icmp L.Icmp.Eq
           | A.Neq     -> if t1 = float_t then L.build_fcmp L.Fcmp.One else L.build_icmp L.Icmp.Ne
           | A.Less    -> if t1 = float_t then L.build_fcmp L.Fcmp.Olt else L.build_icmp L.Icmp.Slt
           | A.Leq     -> if t1 = float_t then L.build_fcmp L.Fcmp.Ole else L.build_icmp L.Icmp.Sle
           | A.Greater -> if t1 = float_t then L.build_fcmp L.Fcmp.Ogt else L.build_icmp L.Icmp.Sgt
           | A.Geq     -> if t1 = float_t then L.build_fcmp L.Fcmp.Oge else L.build_icmp L.Icmp.Sge
	       ) e1' e2' "tmp" builder
      
      | A.Unop(op, e) ->
	       let e' = expr builder e in
	        (match op with
	          A.Neg     -> L.build_neg
            | A.Not     -> L.build_not
          ) e' "tmp" builder
      | A.AccessStructField(e, field_name) ->
          (match e with
             A.Id s -> let etype = fst(List.find (fun local -> snd(local) = s) fdecl.A.locals) in                  (match etype with
                  A.StructType struct_type ->
                  let field_indexing_map = StringMap.find struct_type struct_indexing_map in
                  let index = StringMap.find field_name field_indexing_map in
                  let struct_llvalue = lookup s in
                  let struct_field_pointer = L.build_struct_gep struct_llvalue index "struct_field_pointer" builder in
                      let struct_field_value = L.build_load struct_field_pointer "struct_field_value" builder in                        struct_field_value
             | _ -> raise (Failure("AccessStructField failed: " ^ s ^ "is not a struct type")))
             | _ -> raise (Failure("AccessStructField failed"))
          )
      | A.Assign (e1, e2) ->
        let e2' = expr builder e2 in
          (match e1 with
               A.Id s -> ignore (L.build_store e2' (lookup s) builder); e2'
               | A.AccessStructField(e, field_name) ->
                 (match e with
                   A.Id s -> let etype = fst(List.find (fun local -> snd(local) = s) fdecl.A.locals) in
                     (match etype with
                       A.StructType struct_type ->
                       let field_indexing_map = StringMap.find struct_type struct_indexing_map in
                       let index = StringMap.find field_name field_indexing_map in
                       let struct_llvalue = lookup s in
                       let struct_field_pointer = L.build_struct_gep struct_llvalue index "struct_field_pointer" builder in
                       ignore(L.build_store e2' struct_field_pointer builder); e2'
                     | _ -> raise (Failure("AccessStructField failed: " ^ s ^ "is not a struct type"))
                   )
               | _ -> raise (Failure("AccessStructField failed"))
              )
            | _ -> raise (Failure("Assign failed"))
         )
      | A.Call ("print", [e]) | A.Call ("printb", [e]) ->
	       L.build_call printf_func [| int_format ; (expr builder e) |] "printf" builder
      | A.Call ("printfloat", [e]) ->
	       L.build_call printf_func [| float_format ; (expr builder e) |] "printf" builder
      | A.Call ("prints", [e]) -> L.build_call printf_func [| str_format; (expr builder e) |] "printf" builder
      | A.Call("printint", [e]) -> L.build_call printf_func [| int_format2; (expr builder e) |] "printf" builder
      | A.Call ("printstring", [e]) ->
         L.build_call printf_func [| str_format2; (expr builder e) |] "printf" builder
      | A.Call ("strcat", [e1; e2]) ->
          L.build_call strcat_func [|(expr builder e1); (expr builder e2)|] "strcat" builder
      | A.Call (f, act) ->
            let (fdef, fdecl) = StringMap.find f function_decls in
   	       let actuals =
               List.rev (List.map (expr builder) (List.rev act)) in
   	       let result = (match fdecl.A.typ with A.Void -> ""
                                                 | _ -> f ^ "_result") in
            L.build_call fdef (Array.of_list actuals) result builder
      
      | A.List(t, act) -> let d_ltyp = ltype_of_typ t in
        let listptr = L.build_call initList_f [||] "init" builder in
          let add_elmt elmt =
            let d_ptr = match t with
            A.ListType _ -> expr builder elmt
          | _ ->
            let d_val = expr builder elmt in
            let d_ptr = L.build_malloc d_ltyp "tmp" builder in
            ignore (L.build_store d_val d_ptr builder);
            d_ptr in
            let void_d_ptr = L.build_bitcast d_ptr (L.pointer_type i8_t) "ptr" builder in
            ignore (L.build_call lAdd_f [| listptr; void_d_ptr |] "" builder) in
          ignore (List.map add_elmt act);
        listptr
      | A.ObjectCall(l, "l_add", [e]) -> let list_ptr = expr builder l in
        let e_val = expr builder e in
        let list_name = get_id_name l in
        let list_type = get_type(lookup_types list_name) in
        ( match list_type with
           A.String -> ignore(L.build_call lAdd_f [| list_ptr; e_val |] "" builder); list_ptr
          | _ ->
            let d_ltyp = L.type_of e_val in
            let d_ptr = L.build_malloc d_ltyp "tmp" builder in
            ignore(L.build_store e_val d_ptr builder);
            let void_e_ptr = L.build_bitcast d_ptr (L.pointer_type i8_t) "ptr" builder in
            ignore (L.build_call lAdd_f [| list_ptr ; void_e_ptr |] "" builder);
            list_ptr
        )
      | A.ObjectCall(l, "l_insert", [e; idx]) -> let list_ptr = expr builder l in
        let e_val = expr builder e in
        let idx_val = expr builder idx in
        let list_name = get_id_name l in
        let list_type = get_type(lookup_types list_name) in
        (match list_type with
          A.String -> ignore(L.build_call lInsert_f [| list_ptr; e_val ; idx_val |] "" builder); list_ptr
          | _ ->
            let d_ltyp = L.type_of e_val in
            let d_ptr = L.build_malloc d_ltyp "tmp" builder in
            ignore(L.build_store e_val d_ptr builder);
            let void_e_ptr = L.build_bitcast d_ptr (L.pointer_type i8_t) "ptr" builder in
            ignore (L.build_call lInsert_f [| list_ptr ; void_e_ptr ; idx_val |] "" builder);
            list_ptr
       )
      | A.ObjectCall(l, "l_remove", [idx]) -> let list_ptr = expr builder l in
        let idx_val = expr builder idx in
        ignore (L.build_call lRemove_f [| list_ptr ; idx_val |] "" builder);
        list_ptr
      | A.ObjectCall(l, "l_removeAll", []) -> let list_ptr = expr builder l in
        ignore (L.build_call lRemoveAll_f [|list_ptr|] "" builder);
        list_ptr
      | A.ObjectCall(l, "l_size", []) -> let list_ptr = expr builder l in
        let size_ptr = L.build_call lSize_f [|list_ptr|] "size" builder in
        size_ptr
      | A.ObjectCall(l, "l_isEmpty", []) -> let list_ptr = expr builder l in
        let is_empty = L.build_call lIsEmpty_f [|list_ptr|] "isEmpty" builder in
        is_empty
      | A.ObjectCall(l, "l_get", [idx]) -> let list_ptr = expr builder l in
        let idx_val = expr builder idx in
        let l_name = get_id_name l in
        let l_type = get_type(lookup_types l_name) in
        let val_ptr = L.build_call lGet_f [| list_ptr; idx_val |] "val_ptr" builder in
        (match l_type with
          A.String -> val_ptr
          | _ ->
           let l_dtyp = ltype_of_typ l_type in
           let d_ptr = L.build_bitcast val_ptr (L.pointer_type l_dtyp) "d_ptr" builder in
           (L.build_load d_ptr "d_ptr" builder))
      | A.ObjectCall(l, "printList", []) -> let list_ptr = expr builder l in
        ignore(L.build_call printList_f [| list_ptr |] "" builder); list_ptr

      | A.Node(name, _) -> let name_val = lookup name in 
        let name_val_ptr = L.build_load name_val "name_val_ptr" builder in 
        let nodeptr = L.build_call initNode_f [|name_val_ptr|] "initNode" builder in
        nodeptr
      | A.ObjectCall(n, "getNodeName", []) -> let node_ptr = expr builder n in 
        let n_name = L.build_call getNodeName_f [|node_ptr|] "getNodeName" builder in n_name
      | A.ObjectCall(n, "getNodeData", []) -> let node_ptr = expr builder n in 
        let n_type = get_type (lookup_types(get_id_name n)) in 
        let val_ptr = L.build_call getNodeData_f [|node_ptr|] "getNodeData" builder in 
        let data_type = ltype_of_typ n_type in
        let data_ptr = L.build_bitcast val_ptr (L.pointer_type data_type) "data_ptr" builder in
        (L.build_load data_ptr "data_ptr" builder)
      | A.ObjectCall(n, "setNodeData", [e]) -> let node_ptr = expr builder n in 
        let e_val = expr builder e in 
        let data_typ = L.type_of e_val in 
        let data_ptr = L.build_malloc data_typ "tmp" builder in 
        ignore(L.build_store e_val data_ptr builder);
        let e_val_ptr = L.build_bitcast data_ptr (L.pointer_type i8_t) "ptr" builder in 
        ignore(L.build_call setNodeData_f [|node_ptr; e_val_ptr|] "" builder);
        node_ptr
      | A.ObjectCall(n, "getInNodes", []) -> let node_ptr = expr builder n in 
        let val_ptr = L.build_call getInNodes_f [|node_ptr|] "getInNodes" builder in val_ptr
      | A.ObjectCall(n, "getOutNodes", []) -> let node_ptr = expr builder n in 
        let val_ptr = L.build_call getOutNodes_f [|node_ptr|] "getOutNodes" builder in val_ptr
      | A.ObjectCall(n, "printNode", []) -> let node_ptr = expr builder n in 
        ignore(L.build_call printNode_f [|node_ptr|] "" builder); node_ptr
      | A.ObjectCall(n, "isVisited", []) -> let node_ptr = expr builder n in 
        let bool_ptr = L.build_call isVisited_f [|node_ptr|] "isVisited" builder in bool_ptr
      | A.ObjectCall(n, "setVisited", [e]) -> let node_ptr = expr builder n in 
        let visited = expr builder e in 
        ignore(L.build_call setVisited_f [|node_ptr; visited|] "" builder); 
        node_ptr

      | A.Queue(t, act) -> 
        let d_ltyp = ltype_of_typ t in
        let queue_ptr = L.build_call initQueue_f [| |] "initQueue" builder in 
        let add_element elem = 
          let d_ptr = match t with 
          | A.QueueType _ -> expr builder elem 
          | _ -> 
            let element = expr builder elem in 
            let d_ptr = L.build_malloc d_ltyp "tmp" builder in 
            ignore (L.build_store element d_ptr builder); d_ptr in 
          let void_d_ptr = L.build_bitcast d_ptr (L.pointer_type i8_t) "ptr" builder in
          ignore (L.build_call enqueue_f [| queue_ptr; void_d_ptr |] "" builder)
        in ignore (List.map add_element act);
        queue_ptr
      | A.ObjectCall(q, "enqueue", [e]) -> let q_ptr = expr builder q in
        let e_val = expr builder e in 
        let d_ltyp = L.type_of e_val in 
        let d_ptr = L.build_malloc d_ltyp "tmp" builder in 
        ignore(L.build_store e_val d_ptr builder); 
        let void_e_ptr = L.build_bitcast d_ptr (L.pointer_type i8_t) "ptr" builder in 
        ignore (L.build_call enqueue_f [| q_ptr; void_e_ptr|] "" builder); q_ptr
      | A.ObjectCall(q, "dequeue", []) -> let q_ptr = expr builder q in 
        ignore(L.build_call dequeue_f [|q_ptr|] "" builder); q_ptr
      | A.ObjectCall(q, "front", []) -> let q_ptr = expr builder q in 
        let q_type = get_type(lookup_types(get_id_name q)) in 
        let val_ptr = L.build_call front_f [| q_ptr |] "val_ptr" builder in
        let l_dtyp = ltype_of_typ q_type in
        let d_ptr = L.build_bitcast val_ptr (L.pointer_type l_dtyp) "d_ptr" builder in
        (L.build_load d_ptr "d_ptr" builder)
      | A.ObjectCall(q, "q_size", []) -> let q_ptr = expr builder q in 
        let size_ptr = L.build_call qSize_f [|q_ptr|] "" builder in 
        size_ptr

      |A.PQueue(_, act) -> let pqptr = L.build_call initPqueue_f [| |] "initPqueue" builder in 
          let add_elmt elmt = 
            let element = expr builder elmt in
          ignore (L.build_call pqPush_f [| pqptr; element |] "" builder) in 
        ignore (List.map add_elmt act);
        pqptr
      | A.ObjectCall(pq, "pq_push", [e]) ->  let pq_ptr = expr builder pq in 
        let e_val = expr builder e in 
        ignore(L.build_call pqPush_f [|pq_ptr; e_val|] "" builder); 
        pq_ptr
      | A.ObjectCall(pq, "pq_pop", []) ->  let pq_ptr = expr builder pq in 
        let node_ptr = L.build_call pqPop_f [|pq_ptr|] "" builder in node_ptr
      | A.ObjectCall(pq, "pq_isEmpty", []) -> let pq_ptr = expr builder pq in 
        let bool_ptr = L.build_call pqIsEmpty_f [|pq_ptr|] "" builder in 
        bool_ptr
      | A.ObjectCall(pq, "pq_size", []) -> let pq_ptr = expr builder pq in 
        let size_ptr = L.build_call pqSize_f [|pq_ptr|] "" builder in 
        size_ptr

      | A.Graph(_) -> let g_ptr = L.build_call initGraph_f [| |] "initGraph" builder in g_ptr
      | A.ObjectCall(g, "addNode", [e]) -> let g_val = lookup (get_id_name g) in 
          let e_val = lookup (get_id_name e) in  
          let e_val_pointer = L.build_load e_val "e_val_pointer" builder in 
          let n_val = L.build_call initNode_f [| e_val_pointer |] "init" builder in 
          let n_val_ptr = L.build_alloca (L.type_of n_val) "node_alloca" builder in 
          ignore (L.build_store n_val n_val_ptr builder); 
          let g_ptr = L.build_load g_val "graph_pointer" builder in 
          let n_ptr = L.build_load n_val_ptr "node_pointer" builder in 
          ignore(L.build_call addNode_f [|g_ptr; n_ptr|] "" builder); g_ptr
      | A.ObjectCall(g, "removeNode", [e]) -> let g_ptr = expr builder g in 
          let name_val = lookup (get_id_name e) in 
          let name_ptr = L.build_load name_val "" builder in 
          let n_ptr = L.build_call initNode_f [|name_ptr|] "initNode" builder in 
          ignore(L.build_store n_ptr name_ptr builder);
          let node_ptr = L.build_load n_ptr "" builder in 
          ignore(L.build_call removeNode_f [|g_ptr; node_ptr|] "" builder); g_ptr 
      | A.ObjectCall(g, "addEdge", [n1; n2; e]) ->  let g_val = expr builder g in 
          let e_val = expr builder e in 
          let n1_val = lookup (get_id_name n1) in 
          let n1_val_pointer = L.build_load n1_val "n1_val_pointer" builder in 
          let n2_val = lookup (get_id_name n2) in 
          let n2_val_pointer = L.build_load n2_val "n2_val_pointer" builder in 
          let g_ptr = L.build_call addEdge_f [| g_val; n1_val_pointer; n2_val_pointer; e_val|] "" builder in 
          g_ptr
      | A.ObjectCall(g, "removeEdge", [n1; n2]) ->   
           let g_val = lookup (get_id_name g) in
          let g_val_pointer = L.build_load g_val "g_val_pointer" builder in  
          let n1_val = lookup (get_id_name n1) in 
          let n1_val_pointer = L.build_load n1_val "e1_val_pointer" builder in 
          let n2_val = lookup (get_id_name n2) in 
          let n2_val_pointer = L.build_load n2_val "e2_val_pointer" builder in 
          let g_ptr = L.build_call removeEdge_f [| g_val_pointer; n1_val_pointer; n2_val_pointer|] "" builder in 
          g_ptr
      | A.ObjectCall(g, "getWeight", [n1; n2]) -> let g_ptr = expr builder g in  
          let e1_val = expr builder n1 in 
          let e2_val = expr builder n2 in 
          let weight = L.build_call getWeight_f [| g_ptr; e1_val; e2_val |] "getWeight" builder in 
          weight
      | A.ObjectCall(g, "getNodeByIndex", [e]) -> let g_ptr = expr builder g in 
        let idx_val = expr builder e in
        let node_ptr = L.build_call getNodeByIndex_f [|g_ptr; idx_val|] "" builder in node_ptr 
      | A.ObjectCall(g, "getNodeByName", [e]) -> let g_ptr = expr builder g in  
        let name_val = expr builder e in
        let node_ptr = L.build_call getNodeByName_f [|g_ptr; name_val|] "" builder in node_ptr 
      | A.ObjectCall(g, "removeAllNodes", []) -> let g_ptr = expr builder g in  
          ignore(L.build_call removeAllNodes_f [||] "" builder); g_ptr
      | A.ObjectCall(g, "freeGraph", []) -> let g_ptr = expr builder g in  
          ignore(L.build_call freeGraph_f [||] "" builder); g_ptr
      | A.ObjectCall(g, "isEmpty", []) -> let g_ptr = expr builder g in 
         let bool_ptr = L.build_call isEmpty_f [| g_ptr |] "isEmpty" builder in 
          bool_ptr 
      | A.ObjectCall(g, "size", []) -> let g_ptr = expr builder g in  
         let size = L.build_call size_f [| g_ptr |] "isEmpty" builder in 
          size
      | A.ObjectCall(g, "contains", [e]) -> let g_ptr = expr builder g in 
        let e_val = expr builder e in 
        let bool_ptr = L.build_call contains_f [| g_ptr; e_val |] "contains" builder in bool_ptr  
      | A.ObjectCall(g, "printGraph", []) -> let g_ptr = expr builder g in 
        ignore(L.build_call printGraph_f [| g_ptr |] "" builder); g_ptr

      |  A.ObjectCall(_, f, act) -> 
         let (fdef, fdecl) = StringMap.find f function_decls in
         let actuals = 
            List.rev (List.map (expr builder) (List.rev act)) in
         let result = (match fdecl.A.typ with A.Void -> ""
                                              | _ -> f ^ "_result") in
         L.build_call fdef (Array.of_list actuals) result builder 




    in

    (* Invoke "f builder" if the current block doesn't already
       have a terminal (e.g., a branch). *)
    let add_terminal builder f =
      match L.block_terminator (L.insertion_block builder) with
	      Some _ -> ()
      | None -> ignore (f builder) in

    (* Build the code for the given statement; return the builder for
       the statement's successor *)
    let rec stmt builder = function
	      A.Block sl -> List.fold_left stmt builder sl
      | A.Expr e -> ignore (expr builder e); builder
      | A.Return e -> ignore (match fdecl.A.typ with
	         A.Void -> L.build_ret_void builder
	       | _ -> L.build_ret (expr builder e) builder); builder
      | A.If (predicate, then_stmt, else_stmt) ->
         let bool_val = expr builder predicate in
	       let merge_bb = L.append_block context "merge" the_function in
	       let then_bb = L.append_block context "then" the_function in
	       add_terminal (stmt (L.builder_at_end context then_bb) then_stmt)
                      (L.build_br merge_bb);
	       let else_bb = L.append_block context "else" the_function in
	       add_terminal (stmt (L.builder_at_end context else_bb) else_stmt)
	                    (L.build_br merge_bb);
	       ignore (L.build_cond_br bool_val then_bb else_bb builder);
	       L.builder_at_end context merge_bb
      | A.While (predicate, body) ->
	        let pred_bb = L.append_block context "while" the_function in
	        ignore (L.build_br pred_bb builder);

	        let body_bb = L.append_block context "while_body" the_function in
	        add_terminal (stmt (L.builder_at_end context body_bb) body)
	                     (L.build_br pred_bb);

	        let pred_builder = L.builder_at_end context pred_bb in
	        let bool_val = expr pred_builder predicate in

          let merge_bb = L.append_block context "merge" the_function in
	        ignore (L.build_cond_br bool_val body_bb merge_bb pred_builder);
	        L.builder_at_end context merge_bb

      | A.For (e1, e2, e3, body) -> stmt builder
	           ( A.Block [A.Expr e1 ;
                        A.While (e2, A.Block [body ;
                                              A.Expr e3]) ] )
    in

    (* Build the code for each statement in the function *)
    let builder = stmt builder (A.Block fdecl.A.body) in

    (* Add a return if the last block falls off the end *)
    add_terminal builder (match fdecl.A.typ with
        A.Void -> L.build_ret_void
      | t -> L.build_ret (L.const_int (ltype_of_typ t) 0))
  in

  List.iter build_function_body functions;
  the_module
