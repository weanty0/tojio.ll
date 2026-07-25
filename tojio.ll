@data = private constant [ 15 x i8 ] c"Hello, World!\0A\00", align 1

define external void @main() {
  call void (ptr, ...) @printf(ptr @data)
  ret void
}

declare void @printf(ptr, ...)
