.data

.text
.globl negative

negative:
push %ebp
mov %esp, %ebp

mov 8(%ebp), %eax 	#4 bajty pixeli, bo bede zapisywal na dwoch najmlodszych bitach.

mov %al, %bl 		#zapisujemy red
mov %ah, %bh 		#zapisujemy green

shr $16, %eax       #AA BB xx xx -> xx xx AA BB
mov %al, %cl   		#zapisujemy blue

#Teraz musiymy od 255 odjac kazdy kolor

mov $0, %eax
mov $255, %al
subb %cl, %al

mov $255, %ah
subb %bh, %ah

shl $8, %eax

mov $255, %al
subb %bl, %al


finish:
mov %ebp, %esp
pop %ebp
ret