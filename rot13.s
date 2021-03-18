SYSEXIT32 = 1
SYSREAD = 3
SYSWRITE = 4
STDIN = 0       		#deskryptor SYSREAD
STDOUT = 1				#deskryptor SYSWRITE
SYSCALL = 0x80
SUCCESSEDEXIT = 0

input_length = 100

.global _start

.bss
input: .space input_length #zarezerwowanie w pamieci ciagu pustego o dlugosci 100

.data
msg_start: .ascii "Podaj zdanie: "
msg_start_length = . - msg_start

msg_rot13: .ascii "Rot13: "
msg_rot13_length = . - msg_rot13

.text

_start:
mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $msg_start, %ecx
mov $msg_start_length, %edx
int $SYSCALL

mov $SYSREAD, %eax
mov $STDIN, %ebx
mov $input, %ecx
mov $input_length, %edx
int $SYSCALL

mov $SYSEXIT32, %eax
mov $SUCCESSEDEXIT, %ebx
int $SYSCALL
