.data

.text
.globl blackwhite

blackwhite:
push %ebp
mov %esp, %ebp

mov 8(%ebp), %eax 	#4 bajty pixeli, bo bede zapisywal na dwoch najmlodszych bitach.

mov %al, %bl 		#zapisujemy blue
mov %ah, %bh 		#zapisujemy green

shr $16, %eax       #AA BB xx xx -> xx xx AA BB
mov %al, %cl   		#zapisujemy red

#Teraz musiymy zsumowac RGB i podzielic przez 3

mov $0, %eax
addb %bh, %bl
movb $0, %bh
adcb $0, %bh
 
addb %bl, %cl
adcb $0, %bh

mov %bh, %ch 

mov $0, %edx
mov %cx, %ax	#EDX:EAX = 0:SUM(R,G,B)

mov $3, %esi
div %esi

#Wstawiamy nasz szary kolor	na pozycje R, G , B
mov %eax, %ecx
mov $0, %eax
mov %cl, %al
mov %cl, %ah
shl $8, %eax
mov %cl, %al

finish:
mov %ebp, %esp
pop %ebp
ret