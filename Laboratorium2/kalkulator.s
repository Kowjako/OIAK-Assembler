.global main

.macro endl
    print_s endline
.endm

.macro print_s string
    mov $0, %eax
    mov $format_s, %edi
    mov	$\string, %esi
    call printf
.endm

.macro print_d double
    subq $8, %rsp
    mov $1, %eax
    mov $format_d, %edi
    movsd \double, %xmm0
    call printf
    addq $8, %rsp
    endl
.endm

.macro scan_d register
    subq $8, %rsp
    mov $0, %eax
    mov $format_d, %edi
    mov $\register, %esi
    call scanf
    addq $8, %rsp
.endm

.macro scan_i register
   subq $8, %rsp
   mov $0, %eax
   mov $format_i, %edi
   mov $\register, %esi
   call scanf
   addq $8, %rsp
.endm

.macro add_d			#makro do wykonania dodawania FPU
   fldl first_d
   faddl second_d
.endm

.macro sub_d			#makro do wykonania odejmowania FPU
    fldl first_d
    fsubl second_d
.endm

.macro mult_d			#makro do wykonania mnozenia FPU
    fldl first_d
    fmull second_d
.endm

.macro div_d			#makro do wykonania dzielenia FPU
    fldl first_d
    fdivl second_d
.endm

.macro take_d double	#makro do pobierania wyniku po operacji FPU
    fstl \double
.endm

.data
    msg1: .ascii "Podaj pierwsza liczbe\n\0"
    msg2: .ascii "Podaj druga liczbe\n\0"
    menu: .ascii "Wybierz typ operacji\n1. Dodawanie\n2. Odejmowanie\n3. Dzielenie\n4. Mnozenie\n\0"
    control: .ascii "Typ zaokraglania\n1. Do zera\n2. W gore\n3. W dol\n4. Do najblizszej\n\0"
    output: .ascii "Your output\n\0"

    first_d: .double 1.0
    second_d: .double 2.0
    output_d: .double 0.0

    operation: .int 0			#zmienna dla przechowywania wybranej operacji
    control_operation: .int 0	#zmienna dla przechowywania wybranego zaokraglania

    format_d: .ascii "%lf\0"	#format wypisywania double
    format_s: .ascii "%s\0"		#format wypisywania string
    format_i: .ascii "%i\0"		#format wypisywania calkowitej liczby

    control_word: .short 0x037f #standardowa wartosc z instrukcji
    endline: .ascii "\n\0"
.text
main:
	finit				#inicjalizacja jednostki FPU

    print_s msg1
    scan_d first_d

    print_s msg2
    scan_d second_d

    print_s menu
    scan_i operation

    print_s control
    scan_i control_operation

    cmpb $1, operation
    je add
    cmpb $2, operation
    je sub
    cmpb $3, operation
    je div
    cmpb $4, operation
    je mult
add:
    add_d
    jmp end
sub:
    sub_d
    jmp end
div:
    div_d
    jmp end
mult:
    mult_d
    jmp end
end:
    take_d output_d
    print_s output
    print_d output_d