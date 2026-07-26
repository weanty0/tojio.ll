;This is the lib that is linked with tojio and my other llvm projects.
;;Only god knows how it works.
;Please to anyone contributing increase the counter to show the total amount of hours wasted on this dumpsterfire.
;Ty yall
;Hours wasted: 1
;Also this lib is useful for me to not care about libc.
;
;Footnote: this only works for x86_64 linux

define i64 @syscall(i64 %call, i64 %rdi, i64 %rsi, i64 %rdx, i64 %r10, i64 %r8, i64 %r9) alwaysinline {
  ;Movin all the shit for a single syscall... Why...
  %rax = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11}"(i64 %call, i64 %rdi, i64 %rsi, i64 %rdx, i64 %r10, i64 %r8, i64 %r9)
  ret i64 %rax
}

;declaring that main exsits so no brain infarct
declare i64 @main(i64 %argc, ptr %argv)

;starting a program
define void @_start() naked {
  ;Accessing rsp and clearing base ptr
  call void asm sideeffect "xorq %rbp, %rbp", "~{rbp}"()
  %rsp = call ptr asm "", "={rsp}"()

  ;deref rsp to get argc
  %argc = load i64, ptr %rsp
  ;get the addr of argv
  %argv = getelementptr i8, ptr %rsp, i64 8

  ;Call main finally. Yipee...
  %exitcode = call i64 @main(i64 %argc, ptr %argv)
  call void @exit(i64 %exitcode)
  unreachable
}

;exit does not happen magically
define void @exit(i64 %exitcode) alwaysinline noreturn {
  call i64 @syscall(i64 60, i64 %exitcode, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef)

  ;this is just for letting me sleep peacefully at night
  call void asm sideeffect "hlt", ""() noreturn
  unreachable
}

;we need a write since we dont have printf
define i64 @write(i64 %fd, ptr %buf, i64 %count) alwaysinline {
  %nob_written = call i64 @syscall(i64 1, i64 %fd, ptr %buf, i64 %count, i64 undef, i64 undef, i64 undef)
  %io_err_chk = icmp eq i64 %nob_written, %count
  br i1 %io_err_chk, label %ok, label %ioerr
ok:
  ;ret the number of bytes written if its the same as the count of bytes
  ret i64 %nob_written
ioerr:
  ;exit with an io error
  call void @exit(i64 1)
  unreachable
}
