@fpt = private constant [ 15 x i8 ] c"Hello, World!\0A\00"

define i64 @main(i64 %argc, ptr %argv) {
  call i64 @write(i64 1, ptr @fpt, i64 15)
  ret i64 0
}

declare i64 @write(i64 %fd, ptr %buf, i64 %count)
