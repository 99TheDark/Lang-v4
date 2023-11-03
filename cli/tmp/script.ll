; ModuleID = 'examples/main/script.su'
source_filename = "examples/main/script.su"

%type.string = type { i32, i32* }

@.str0 = private unnamed_addr constant [1 x i32] [i32 32], align 4

define void @main() {
entry:
	%i = alloca i32, align 4
	store i32 0, i32* %i
	br label %for.cond0

exit:
	ret void

for.cond0:
	%0 = load i32, i32* %i, align 4
	%1 = icmp slt i32 %0, 10
	br i1 %1, label %for.body0, label %for.end0

for.body0:
	%2 = load i32, i32* %i, align 4
	%3 = srem i32 %2, 10
	%4 = add i32 %3, 1
	%5 = call %type.string @".conv:int_string"(i32 %4)
	%6 = getelementptr inbounds [1 x i32], [1 x i32]* @.str0, i32 0, i32 0
	%7 = alloca %type.string, align 8
	%8 = getelementptr inbounds %type.string, %type.string* %7, i32 0, i32 0
	store i32 1, i32* %8, align 8
	%9 = getelementptr inbounds %type.string, %type.string* %7, i32 0, i32 1
	store i32* %6, i32** %9, align 8
	%10 = load %type.string, %type.string* %7, align 8
	%11 = call %type.string @".copy:string"(%type.string %10)
	%12 = call %type.string @".add:string_string"(%type.string %5, %type.string %11)
	call void @.print(%type.string %12)
	call void @".free:string"(%type.string %11)
	br label %for.inc0

for.inc0:
	%13 = load i32, i32* %i, align 4
	%14 = add i32 %13, 1
	store i32 %14, i32* %i
	br label %for.cond0

for.end0:
	br label %exit
}

declare void @.print(%type.string %0)

declare %type.string @".add:string_string"(%type.string %0, %type.string %1)

declare %type.string @".conv:int_string"(i32 %0)

declare i32 @llvm.ctlz.i32(i32 %0, i1 immarg %1)

declare i32 @llvm.cttz.i32(i32 %0, i1 immarg %1)

declare %type.string @".copy:string"(%type.string %0)

declare void @".free:string"(%type.string %0)