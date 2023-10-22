source_filename = "lib/builtin/reference/bool_ref"

%ref.bool = type { i1*, i32 }

declare i8* @malloc(i32)
declare void @free(i8*)

declare void @freeMsg()
declare void @countMsg(i32)

define %ref.bool* @"newref:bool"(i1 %value) {
entry:
    %value.addr = alloca i1, align 4
    %ref = alloca %ref.bool*, align 8
    store i1 %value, i1* %value.addr, align 4
    %call = call i8* @malloc(i32 16) ; sizeof(&bool) = 16
    %0 = bitcast i8* %call to %ref.bool*
    store %ref.bool* %0, %ref.bool** %ref, align 8
    %call1 = call i8* @malloc(i32 1) ; sizeof(bool) = 1
    %1 = bitcast i8* %call1 to i1*
    %2 = load %ref.bool*, %ref.bool** %ref, align 8
    %value2 = getelementptr inbounds %ref.bool, %ref.bool* %2, i32 0, i32 0
    store i1* %1, i1** %value2, align 8
    %3 = load i1, i1* %value.addr, align 4
    %4 = load %ref.bool*, %ref.bool** %ref, align 8
    %value3 = getelementptr inbounds %ref.bool, %ref.bool* %4, i32 0, i32 0
    %5 = load i1*, i1** %value3, align 8
    store i1 %3, i1* %5, align 4
    %6 = load %ref.bool*, %ref.bool** %ref, align 8
    %count = getelementptr inbounds %ref.bool, %ref.bool* %6, i32 0, i32 1
    store i32 0, i32* %count, align 8
    %7 = load %ref.bool*, %ref.bool** %ref, align 8
    ret %ref.bool* %7
}

define void @"ref:bool"(%ref.bool* %ref) {
entry:
    %0 = getelementptr inbounds %ref.bool, %ref.bool* %ref, i32 0, i32 1
    %1 = load i32, i32* %0, align 8
    %2 = add i32 %1, 1
    call void @countMsg(i32 %2)
    store i32 %2, i32* %0, align 8
    ret void
}

define void @"deref:bool"(%ref.bool* %ref) {
entry:
    %0 = getelementptr inbounds %ref.bool, %ref.bool* %ref, i32 0, i32 1
    %1 = load i32, i32* %0, align 8
    %2 = add i32 %1, -1
    call void @countMsg(i32 %2)
    store i32 %2, i32* %0, align 8
    %3 = icmp eq i32 %2, 0
    br i1 %3, label %if.then, label %exit

if.then:
    %4 = getelementptr inbounds %ref.bool, %ref.bool* %ref, i32 0, i32 0
    %5 = load i1*, i1** %4, align 8
    %6 = bitcast i1* %5 to i8*
    call void @free(i8* %6)
    %7 = bitcast %ref.bool* %ref to i8*
    call void @free(i8* %7)
    call void @freeMsg()
    br label %exit

exit:
    ret void
}