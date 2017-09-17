; ModuleID = 'YeezyGraph'

%struct.List = type { %struct.ListNode* }
%struct.ListNode = type { i8*, %struct.ListNode*, %struct.ListNode* }
%struct.Node = type { i8*, i8, %struct.map*, %struct.map*, i8* }
%struct.map = type { i32, i32, i8**, i32* }
%struct.Queue = type { %struct.Node.6*, %struct.Node.6*, i32 }
%struct.Node.6 = type { i8*, %struct.Node.6* }
%struct.Pqueue = type { %struct.Node.8**, i32, i32 }
%struct.Node.8 = type { i8*, i8, %struct.map.7*, %struct.map.7*, i8* }
%struct.map.7 = type { i32, i32, i8**, i32* }
%struct.Graph = type { %struct.List.3*, i32 }
%struct.List.3 = type { %struct.ListNode.2* }
%struct.ListNode.2 = type { i8*, %struct.ListNode.2*, %struct.ListNode.2* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt1 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@fmt2 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@fmt3 = private unnamed_addr constant [3 x i8] c"%d\00"
@fmt4 = private unnamed_addr constant [3 x i8] c"%s\00"

declare i32 @printf(i8*, ...)

declare i8* @strcat(i8*, i8*, ...)

declare %struct.List* @initList()

declare void @l_add(%struct.List*, i8*)

declare void @l_insert(%struct.List*, i8*, i32)

declare void @l_remove(%struct.List*, i32)

declare void @removeAll(%struct.List*)

declare i1 @l_isEmpty(%struct.List*)

declare i32 @l_size(%struct.List*)

declare i8* @l_get(%struct.List*, i32)

declare void @printList(%struct.List*)

declare %struct.Node* @initNode()

declare i8* @getNodeName(%struct.Node*)

declare void @setNodeData(%struct.Node*, i8*)

declare i1 @isVisited(%struct.Node*)

declare void @setVisited(%struct.Node*, i1)

declare %struct.List* @getInNodes(%struct.Node*)

declare %struct.List* @getOutNodes(%struct.Node*)

declare i8* @getNodeData(%struct.Node*)

declare void @printNode(%struct.Node*)

declare %struct.Queue* @initQueue()

declare void @enqueue(%struct.Queue*, i8*)

declare void @dequeue(%struct.Queue*)

declare i8* @front(%struct.Queue*)

declare i32 @q_size(%struct.Queue*)

declare %struct.Pqueue* @initPqueue()

declare void @pq_push(%struct.Pqueue*, %struct.Node*)

declare %struct.Node* @pq_pop(%struct.Pqueue*)

declare i1 @pq_isEmpty(%struct.Pqueue*)

declare i32 @pq_size(%struct.Pqueue*)

declare %struct.Graph* @initGraph()

declare void @addNode(%struct.Graph*, %struct.Node*)

declare void @removeNode(%struct.Graph*, %struct.Node*)

declare void @addEdge(%struct.Graph*, %struct.Node*, %struct.Node*, i32)

declare void @removeEdge(%struct.Graph*, %struct.Node*, %struct.Node*)

declare void @getWeight(%struct.Graph*, %struct.Node*, %struct.Node*)

declare %struct.Node* @getNodeByIndex(%struct.Graph*, i32)

declare void @freeGraph(%struct.Graph*)

declare void @removeAllNodes(%struct.Graph*)

declare void @printGraph(%struct.Graph*)

declare i1 @isEmpty(%struct.Graph*)

declare i32 @size(%struct.Graph*)

declare i1 @contains(%struct.Graph*, i8*)

declare %struct.Node* @getNodeByName(%struct.Graph*, i8*)

define i32 @main() {
entry:
  %i = alloca %struct.List*
  %init = call %struct.List* @initList()
  store %struct.List* %init, %struct.List** %i
  ret i32 0
}
