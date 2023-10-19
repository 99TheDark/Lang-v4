source_filename = "lib/builtin/function/print"

%type.string = type { i32, i32, i8* }

declare void @putchar(i8)

; print(string str) {
; 	  for int i = 0; i < str.size; i++ {
; 		  putchar(str.addr[i])
; 	  }
; }
define void @.print(%type.string %str) {
entry:
	%ptr.str = alloca %type.string, align 8
	store %type.string %str, %type.string* %ptr.str, align 8
	%i = alloca i32, align 8
	%0 = getelementptr inbounds %type.string, %type.string* %ptr.str, i32 0, i32 1
	%1 = getelementptr inbounds %type.string, %type.string* %ptr.str, i32 0, i32 2
	%2 = load i32, i32* %0, align 8
	%3 = load i8*, i8** %1, align 8
	store i32 0, i32* %i, align 8
	br label %for.cond

for.cond:
	%4 = load i32, i32* %i, align 8
	%ptr.str.len = getelementptr inbounds %type.string, %type.string* %ptr.str, i32 0, i32 1
	%5 = load i32, i32* %ptr.str.len, align 8
	%cmp = icmp slt i32 %4, %5
	br i1 %cmp, label %for.body, label %for.end

for.body:
	%ptr.str.addr = getelementptr inbounds %type.string, %type.string* %ptr.str, i32 0, i32 2
	%6 = load i8*, i8** %ptr.str.addr, align 8
	%7 = load i32, i32* %i, align 8
	%ptr.str.idx = getelementptr inbounds i8, i8* %6, i32 %7
	%8 = load i8, i8* %ptr.str.idx, align 1
	call void @putchar(i8 %8)
	br label %for.inc

for.inc:
	%9 = load i32, i32* %i, align 8
	%inc = add nsw i32 %9, 1
	store i32 %inc, i32* %i, align 8
	br label %for.cond

for.end:
	ret void
}

; println(string str) {
;     print(str)
;     putchar('\n')
; }
define void @.println(%type.string %str) {
entry:
	call void @.print(%type.string %str)
	call void @putchar(i8 10)
	ret void
}