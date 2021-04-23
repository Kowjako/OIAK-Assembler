cut1: .short 0x03F #najblizsze
cut2: .short 0x43F #dol
cut3: .short 0x83F #gora
cut4: .short 0xC3F #obciecie

.macro print_s string
    pushl $\string
    call printf
.endm

.macro add_d			#makro do wykonania dodawania FPU
   fld first_d
   fld second_d
   faddp
   push %eax
   push %eax
   fstpl (%esp)
   pushl $output
   call printf
   pushl $0
.endm

.macro sub_d			#makro do wykonania odejmowania FPU
    fld first_d
    fld second_d
    fsubp
    push %eax
    push %eax
    fstpl (%esp)
    pushl $output
    call printf
    pushl $0
.endm

.macro mult_d			#makro do wykonania mnozenia FPU
    fld first_d
    fld second_d
    fmulp
    push %eax
    push %eax
    fstpl (%esp)
    pushl $output
    call printf
    pushl $0
.endm

.macro div_d			#makro do wykonania dzielenia FPU
    fld first_d
    fld second_d
    fdivp
    push %eax
    push %eax
    fstpl (%esp)
    pushl $output
    call printf
    pushl $0
.endm


.macro set_round_cut    #zaokraglanie przez obciecie
    fldcw cut4
.endm

.macro set_round_up		#zaokraglenie do +inf
    fldcw cut3
.endm

.macro set_round_down	#zaokraglenie do -inf
    fldcw cut2
.endm

.macro set_round_nearest	#zaokraglenie do najblizszej
    fldcw cut1
.endm

.data
    msg1: .ascii "Podaj pierwsza liczbe\n\0"
    msg2: .ascii "Podaj druga liczbe\n\0"
    menu: .ascii "Wybierz typ operacji\n1. Dodawanie\n2. Odejmowanie\n3. Dzielenie\n4. Mnozenie\n\0"
    control: .ascii "Typ zaokraglania\n1. Do zera\n2. W gore\n3. W dol\n4. Do najblizszej\n\0"
    output: .ascii "Wynik %f\n\0"

    first_d: .float 0.0
    second_d: .float 0.0
    operation: .int 0			#zmienna dla przechowywania wybranej operacji
    control_operation: .int 0	#zmienna dla przechowywania wybranego zaokraglania

    format_d: .ascii "%f\0"	    #format wypisywania double
    format_i: .ascii "%i\0"		#format wypisywania calkowitej liczby


.text
.globl _start

_start:
	finit				#inicjalizacja jednostki FPU

    print_s msg1
   	pushl $first_d
   	pushl $format_d
   	call scanf


    print_s msg2
    pushl $second_d
   	pushl $format_d
   	call scanf

    print_s menu
    pushl $operation
   	pushl $format_i
   	call scanf

    print_s control
    pushl $control_operation
   	pushl $format_i
   	call scanf

    cmpb $1, control_operation
    je cut
    cmpb $2, control_operation
    je up
    cmpb $3, control_operation
    je down
    cmpb $4, control_operation
    je nearest

cut:
    set_round_cut
    je rounding_set
up:
    set_round_up
    je rounding_set
down:
    set_round_down
    je rounding_set
nearest:
    set_round_nearest
    je rounding_set

rounding_set:
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
    call exit