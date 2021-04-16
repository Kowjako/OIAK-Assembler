.data

format_s: .ascii "%s\0"
format_f: .ascii "%f\0"
format_d: .ascii "%d\0"

a: .space 100
b: .space 100
trash: .double 0
operation: .space 1
round: .space 1
result: .space 32

msg_first: .ascii "Wpisz pierwsza liczbe:\n\0"
msg_second: .ascii "Wpisz druga liczbe:\n\0"
msg_operation: .ascii "Wybierz operacje:\n1-dodawanie, 2-odejmowanie, 3-mnozenie, 4-dzielenie\n\0"
msg_round: .ascii "Wybierz typ zaokraglania:\n1-najblizsze, 2-w gore, 3-w dol, 4-do zera\n\0"

najblizse: .short 0x000
wdol: .short 0x400
wgore: .short 0x800
obciecie: .short 0xC00


FPUControlWord: .short 0x037f

.text
	.globl main

main:
	call readData
	call doAction
	call finish

readData:
mov $0, %eax
mov $format_s, %edi
mov	$msg_first, %esi
call printf

mov $0, %eax
mov $format_f, %edi
mov $a, %esi
call scanf

mov $0, %eax
mov $format_s, %edi
mov	$msg_second, %esi
call printf

mov $0, %eax
mov $format_f, %edi
mov $b, %esi
call scanf

mov $0, %eax
mov $format_s, %edi
mov	$msg_operation, %esi
call printf

mov $0, %eax
mov $format_d, %edi
mov $operation, %esi
call scanf

mov $0, %eax
mov $format_s, %edi
mov	$msg_round, %esi
call printf

mov $0, %eax
mov $format_d, %edi
mov $round, %esi
call scanf
ret

doAction:
#finit
#fldcw FPUControlWord
#flds a
#fadds b

finish:
mov $0, %eax
call exit
