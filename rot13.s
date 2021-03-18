SYSEXIT32 = 1
SYSREAD = 3
SYSWRITE = 4
STDIN = 0
STDOUT = 1
SYSCALL = 0x80
SUCCESSEDEXIT = 0

input_length = 100

.global _start

.data
msg_start: .ascii "Podaj zdanie: "
msg_start_length = . - msg_start

msg_rot13: .ascii "Rot13: "
msg_rot13_length = . - msg_rot13

