;This is the lib that is linked with tojio and my other llvm projects.
;;Only god knows how it works.
;Please to anyone contributing increase the counter to show the total amount of hours wasted on this dumpsterfire.
;Ty yall
;Hours wasted:
;Also this lib is useful for me to not care about libc.

define i64 @syscall(i64 %call, i64 %rdi, i64 %rsi, i64 %rdx, i64 %r10, i64 %r9, i64 %r8) alwaysinline {
  ;Movin all the shit for a single syscall... Why...
  %rax = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10}
                                  ,{r9},{r8},~{rcx}, ~{r11}"(i64 %call,
                                  i64 %rdi, i64 %rsi, i64 %rdx, i64 %r10, i64 %r9, i64 %r8)

  ret i64 %rax
}

;starting a program
define void @_start() naked {
  ;Accessing rsp and clearing base ptr
  call void asm sideeffect "", "={rbp}"(i64 0)
  %rsp = call ptr asm "", "={rsp},{rsp}"(ptr undef)

  ;deref rsp to get argc
  %argc = load i64, ptr %rsp
  ;get the addr of argv
  %argv = getelementptr i8, ptr %rsp, i64 8

  ;Call main finally. Yipee...
  call i64 @main(i64 %argc, ptr %argv)
  ret void
}

;exit does not happen magically
define void @exit(i64 %exitcode) alwaysinline noreturn {
  call i64 @syscall(i64 60, i64 %exitcode, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef)

  ;this is just for letting me sleep peacefully at night
  call void asm sideeffect "hlt", ""() noreturn
  unreachable
}
