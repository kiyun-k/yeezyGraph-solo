; ModuleID = 'MicroC'

@b = global i32 0
@a = global i32 0
@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt1 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@fmt2 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt3 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@fmt4 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt5 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@fmt6 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt7 = private unnamed_addr constant [4 x i8] c"%f\0A\00"

declare i32 @printf(i8*, ...)

declare i32 @printbig(i32)

declare i8* @strconcat(i8*, i8*)

define i32 @main() {
entry:
  store i32 42, i32* @a
  store i32 21, i32* @b
  call void @printa()
  call void @printb()
  call void @incab()
  call void @printa()
  call void @printb()
  ret i32 0
}

define void @incab() {
entry:
  %a = load i32* @a
  %tmp = add i32 %a, 1
  store i32 %tmp, i32* @a
  %b = load i32* @b
  %tmp1 = add i32 %b, 1
  store i32 %tmp1, i32* @b
  ret void
}

define void @printb() {
entry:
  %b = load i32* @b
  %printf = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @fmt4, i32 0, i32 0), i32 %b)
  ret void
}

define void @printa() {
entry:
  %a = load i32* @a
  %printf = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @fmt6, i32 0, i32 0), i32 %a)
  ret void
}
