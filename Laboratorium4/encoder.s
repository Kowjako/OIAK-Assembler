.text

.global encoder


encoder:

push %ebp
mov %esp, %ebp

#pobieramy ze stosu nasze parametry z funkcji C

mov 8(%ebp), %esi 	#w esi adres gdzie zaczyna sie tablica pixeli
mov 12(%ebp), %edi	#zapisujemy nasza liczbe pixeli



encoder_loop:




finish:
pop %ebp
ret