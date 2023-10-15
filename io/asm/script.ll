; ModuleID = 'script.su'
source_filename = "script.su"

%type.string = type { i32, i32, i8* }

@.str0 = private unnamed_addr constant [2 x i8] c", ", align 1
@.str1 = private unnamed_addr constant [16 x i8] c"I did something!", align 1
@.str2 = private unnamed_addr constant [4 x i8] c"John", align 1
@.str3 = private unnamed_addr constant [5 x i8] c"Smith", align 1

define void @main() {
entry:
	%0 = call i32 @mod.fibonacci(i32 25)
	%1 = call %type.string @.conv.int_string(i32 %0)
	call void @.println(%type.string %1)
	%2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str2, i32 0, i32 0
	%3 = alloca %type.string, align 8
	%4 = getelementptr inbounds %type.string, %type.string* %3, i32 0, i32 0
	store i32 4, i32* %4, align 8
	%5 = getelementptr inbounds %type.string, %type.string* %3, i32 0, i32 1
	store i32 4, i32* %5, align 8
	%6 = getelementptr inbounds %type.string, %type.string* %3, i32 0, i32 2
	store i8* %2, i8** %6, align 8
	%7 = load %type.string, %type.string* %3, align 8
	%8 = getelementptr inbounds [5 x i8], [5 x i8]* @.str3, i32 0, i32 0
	%9 = alloca %type.string, align 8
	%10 = getelementptr inbounds %type.string, %type.string* %9, i32 0, i32 0
	store i32 5, i32* %10, align 8
	%11 = getelementptr inbounds %type.string, %type.string* %9, i32 0, i32 1
	store i32 5, i32* %11, align 8
	%12 = getelementptr inbounds %type.string, %type.string* %9, i32 0, i32 2
	store i8* %8, i8** %12, align 8
	%13 = load %type.string, %type.string* %9, align 8
	%14 = call %type.string @mod.formatName(%type.string %7, %type.string %13)
	call void @.println(%type.string %14)
	call void @mod.doSomething()
	%15 = call i32 @mod.add(i32 3, i32 4)
	br label %exit

exit:
	ret void
}

define private %type.string @mod.formatName(%type.string %0, %type.string %1) {
entry:
	%.ret = alloca %type.string
	%2 = getelementptr inbounds [2 x i8], [2 x i8]* @.str0, i32 0, i32 0
	%3 = alloca %type.string, align 8
	%4 = getelementptr inbounds %type.string, %type.string* %3, i32 0, i32 0
	store i32 2, i32* %4, align 8
	%5 = getelementptr inbounds %type.string, %type.string* %3, i32 0, i32 1
	store i32 2, i32* %5, align 8
	%6 = getelementptr inbounds %type.string, %type.string* %3, i32 0, i32 2
	store i8* %2, i8** %6, align 8
	%7 = load %type.string, %type.string* %3, align 8
	%8 = call %type.string @.add.string_string(%type.string %1, %type.string %7)
	%9 = call %type.string @.add.string_string(%type.string %8, %type.string %0)
	store %type.string %9, %type.string* %.ret, align 8
	br label %exit

exit:
	%10 = load %type.string, %type.string* %.ret
	ret %type.string %10
}

define private i32 @mod.fibonacci(i32 %0) {
entry:
	%.ret = alloca i32
	%1 = icmp sle i32 %0, 1
	br i1 %1, label %if.then0, label %if.else0

exit:
	%2 = load i32, i32* %.ret
	ret i32 %2

if.then0:
	store i32 1, i32* %.ret
	br label %if.end0

if.else0:
	%3 = sub i32 %0, 2
	%4 = call i32 @mod.fibonacci(i32 %3)
	%5 = sub i32 %0, 1
	%6 = call i32 @mod.fibonacci(i32 %5)
	%7 = add i32 %4, %6
	store i32 %7, i32* %.ret
	br label %if.end0

if.end0:
	br label %exit
}

define private i32 @mod.add(i32 %0, i32 %1) {
entry:
	%.ret = alloca i32
	%2 = add i32 %0, %1
	store i32 %2, i32* %.ret
	br label %exit

exit:
	%3 = load i32, i32* %.ret
	ret i32 %3
}

define private void @mod.doSomething() {
entry:
	%0 = getelementptr inbounds [16 x i8], [16 x i8]* @.str1, i32 0, i32 0
	%1 = alloca %type.string, align 8
	%2 = getelementptr inbounds %type.string, %type.string* %1, i32 0, i32 0
	store i32 16, i32* %2, align 8
	%3 = getelementptr inbounds %type.string, %type.string* %1, i32 0, i32 1
	store i32 16, i32* %3, align 8
	%4 = getelementptr inbounds %type.string, %type.string* %1, i32 0, i32 2
	store i8* %0, i8** %4, align 8
	%5 = load %type.string, %type.string* %1, align 8
	call void @.println(%type.string %5)
	br label %exit

exit:
	ret void
}

declare void @.print(%type.string %0)

declare void @.println(%type.string %0)

declare %type.string @.add.string_string(%type.string %0, %type.string %1)

declare %type.string @.conv.int_string(i32 %0)

declare %type.string @.conv.bool_string(i1 %0)
