SYSEXIT32 = 1
SYSREAD = 3
SYSWRITE = 4
STDIN = 0       		#deskryptor SYSREAD
STDOUT = 1				#deskryptor SYSWRITE
SYSCALL = 0x80
SUCCESSEDEXIT = 0

input_length = 100
operation_length = 2

.global _start

.bss
firstNumber: .space input_length 
secondNumber: .space input_length
operationNumber: .space operation_length
roundNumber: .space operation_length

.data
msg_first: .ascii "Wpisz pierwsza liczbe:\n"
msg_first_length = . - msg_first

msg_second: .ascii "Wpisz druga liczbe:\n"
msg_second_length = . - msg_second

msg_operation: .ascii "Wybierz operacje:\n1-dodawanie, 2-odejmowanie, 3-mnozenie, 4-dzielenie\n"
msg_operation_length = . - msg_operation

msg_round: .ascii "Wybierz typ zaokraglania:\n1-najblizsze, 2-w gore, 3-w dol, 4-do zera\n"
msg_round_length = . - msg_round

.text

_start:
mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $msg_first, %ecx
mov $msg_first_length, %edx
int $SYSCALL

mov $SYSREAD, %eax
mov $STDIN, %ebx
mov $firstNumber, %ecx
mov $input_length, %edx
int $SYSCALL

mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $msg_second, %ecx
mov $msg_second_length, %edx
int $SYSCALL

mov $SYSREAD, %eax
mov $STDIN, %ebx
mov $secondNumber, %ecx
mov $input_length, %edx
int $SYSCALL

mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $msg_operation, %ecx
mov $msg_operation_length, %edx
int $SYSCALL

mov $SYSREAD, %eax
mov $STDIN, %ebx
mov $operationNumber, %ecx
mov $operation_length, %edx
int $SYSCALL

mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $msg_round, %ecx
mov $msg_round_length, %edx
int $SYSCALL

mov $SYSREAD, %eax
mov $STDIN, %ebx
mov $roundNumber, %ecx
mov $operation_length, %edx
int $SYSCALL


#Wysjcie z programu
mov $SYSEXIT32, %eax
mov $SUCCESSEDEXIT, %ebx
int $SYSCALL
