; ModuleID = 'MicroC'

@a = global i32 0
@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt1 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@fmt2 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt3 = private unnamed_addr constant [4 x i8] c"%f\0A\00"

declare i32 @printf(i8*, ...)

declare i32 @printbig(i32)

declare i8* @strconcat(i8*, i8*)

define i32 @main() {
entry:
  call void @foo(i32 73)
  %a = load i32* @a
  %printf = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @fmt, i32 0, i32 0), i32 %a)
  ret i32 0
}

define void @foo(i32 %c) {
entry:
  %c1 = alloca i32
  store i32 %c, i32* %c1
  %c2 = load i32* %c1
  %tmp = add i32 %c2, 42
  store i32 %tmp, i32* @a
  ret void
}