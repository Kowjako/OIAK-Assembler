.data

percentage: .int 400


.text
.globl pencil

pencil:
push %ebp
mov %esp, %ebp

mov 8(%ebp), %eax 	#4 bajty pixeli, bo bede zapisywal na dwoch najmlodszych bitach.

mov %al, %bl 		#zapisujemy blue
mov %ah, %bh 		#zapisujemy green

shr $16, %eax       #AA BB xx xx -> xx xx AA BB
mov %al, %cl   		#zapisujemy red

mov $0, %eax
mov %bl, %al
addb %bh, %al
adcb $0, %ah
addb %cl, %al
adcb $0, %ah 

cmp percentage, %eax
jg black
jmp white


black:
mov $0, %eax
jmp finish

white:
mov $255, %al
mov $255, %ah
shl $8, %eax
mov $255, %al
jmp finish


finish:
mov %ebp, %esp
pop %ebp
ret
