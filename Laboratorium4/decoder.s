.data
hellomsg: .ascii "Hello world!\n"
msg_length = . - hellomsg

.text
.globl decoder

decoder:
push %ebp
mov %esp, %ebp

mov 8(%ebp), %eax 	#4 bajty pixeli, bo bede zapisywal na dwoch najmlodszych bitach.

#pierwszy bajt dekodujemy
mov %al, %bl
and $0b00000011, %bl	#zerujemy najstarsze oprocz dwoch ostatnich bo tam zakodowana informacja
mov %bl, %al

#drugi bajt dekodujemy
mov %ah, %bl
and $0b00000011, %bl	#zerujemy kolejne
mov %bl, %ah

#Nastepne 2 bajty
mov %ax, %bx			#zapisujemy zakodowane pierwsze 2 bajty
shr $16, %eax			#AA BB XX XX -> 00 00 AA BB
mov %ax, %dx			#zapisujemy drugie 2 bajty
mov %bx , %ax
shl $16, %eax
mov %dx , %ax			#mamy teraz zamienione czesci LOW i HIGH rejestru EAX

#trzeci bajt dekodujemy
mov %al, %bl
and $0b00000011, %bl	#zerujemy dwa najmlodze bity
mov %bl, %al

#czwarty bajt dekodujemy
mov %ah, %bl
and $0b00000011, %bl	#zerujemy dwa najmlodze bity
mov %bl, %ah

#Powracamy miejscami HIGH I LOW
mov %ax, %bx			#zapisujemy zakodowane pierwsze 2 bajty
shr $16, %eax			#AA BB XX XX -> 00 00 AA BB
mov %ax, %dx			#zapisujemy drugie 2 bajty
mov %bx , %ax			#wstawiamy pierwsze 2 bajty
shl $16, %eax  			#presuwamy na odpowiednia pozycje
mov %dx , %ax			#mamy teraz zamienione czesci LOW i HIGH rejestru EAX


finish:
mov %ebp, %esp
pop %ebp
ret