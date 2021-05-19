.text

.global encoder


encoder:

push %ebp
mov %esp, %ebp

#pobieramy ze stosu nasze parametry z funkcji C

mov 8(%ebp), %eax 	#4 bajty pixeli, bo bede zapisywal na dwoch najmlodszych bitach.
mov 12(%ebp), %ecx	#zapisujemy nasza litere

#pierwszy bajt kodujemy
mov %al, %bl
and $0b11111100, %bl	#zerujemy dwa najmlodze bity
mov %cl, %dl
and $0b00000011, %dl	#bierzemy pierwsze dwa bity naszej litery od prawej
add	%dl, %bl			#dodajemy na pozycje wyzerowanych bitow
mov %bl, %al

#drugi bajt kodujemy
mov %ah, %bl
and $0b11111100, %bl	#zerujemy dwa najmlodze bity
mov %cl, %dl
and $0b00001100, %dl	#bierzemy drugie dwa bity naszej litery od prawej
shr $2, %dl				#przesuwamy w prawo xx xx 11 xx -> xx xx xx 11
add	%dl, %bl			#dodajemy na pozycje wyzerowanych bitow
mov %bl, %ah

#Nastepne 2 bajty
shr $16, %eax			#AA BB XX XX -> 00 00 AA BB

#pierwszy bajt kodujemy
mov %al, %bl
and $0b11111100, %bl	#zerujemy dwa najmlodze bity
mov %cl, %dl
and $0b00110000, %dl	#bierzemy trzecie dwa bity naszej litery od prawej
shr $4, %dl				#przesuwamy w prawo xx 11 xx xx -> xx xx xx 11
add	%dl, %bl			#dodajemy na pozycje wyzerowanych bitow
mov %bl, %al

#drugi bajt kodujemy
mov %ah, %bl
and $0b11111100, %bl	#zerujemy dwa najmlodze bity
mov %cl, %dl
and $0b11000000, %dl	#bierzemy czwarte dwa bity naszej litery od prawej
shr $6, %dl				#przesuwamy w prawo 11 xx xx xx -> xx xx xx 11
add	%dl, %bl			#dodajemy na pozycje wyzerowanych bitow
mov %bl, %ah



finish:
pop %ebp
ret