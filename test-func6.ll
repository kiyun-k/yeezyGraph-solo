; ModuleID = 'MicroC'

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt1 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@fmt2 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt3 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@fmt4 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt5 = private unnamed_addr constant [4 x i8] c"%f\0A\00"

declare i32 @printf(i8*, ...)

declare i32 @printbig(i32)

declare i8* @strconcat(i8*, i8*)

define i32 @main() {
entry:
  %bar_result = call i32 @bar(i32 17, i1 false, i32 25)
  %printf = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @fmt, i32 0, i32 0), i32 %bar_result)
  ret i32 0
}

define i32 @bar(i32 %a, i1 %b, i32 %c) {
entry:
  %a1 = alloca i32
  store i32 %a, i32* %a1
  %b2 = alloca i1
  store i1 %b, i1* %b2
  %c3 = alloca i32
  store i32 %c, i32* %c3
  %a4 = load i32* %a1
  %c5 = load i32* %c3
  %tmp = add i32 %a4, %c5
  ret i32 %tmp
}

define void @foo() {
entry:
  ret void
}
