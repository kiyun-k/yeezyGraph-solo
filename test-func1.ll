; ModuleID = 'MicroC'

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt1 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@fmt2 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt3 = private unnamed_addr constant [4 x i8] c"%f\0A\00"

declare i32 @printf(i8*, ...)

declare i32 @printbig(i32)

declare i8* @strconcat(i8*, i8*)

define i32 @main() {
entry:
  %a = alloca i32
  %add_result = call i32 @add(i32 39, i32 3)
  store i32 %add_result, i32* %a
  %a1 = load i32* %a
  %printf = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @fmt, i32 0, i32 0), i32 %a1)
  ret i32 0
}

define i32 @add(i32 %a, i32 %b) {
entry:
  %a1 = alloca i32
  store i32 %a, i32* %a1
  %b2 = alloca i32
  store i32 %b, i32* %b2
  %a3 = load i32* %a1
  %b4 = load i32* %b2
  %tmp = add i32 %a3, %b4
  ret i32 %tmp
}
