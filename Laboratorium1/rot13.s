SYSEXIT32 = 1
SYSREAD = 3
SYSWRITE = 4
STDIN = 0       		#deskryptor SYSREAD
STDOUT = 1				#deskryptor SYSWRITE
SYSCALL = 0x80
SUCCESSEDEXIT = 0

input_length = 100

.global _start

.bss
input: .space input_length #zarezerwowanie w pamieci ciagu pustego o dlugosci 100

.data
msg_start: .ascii "Podaj zdanie: "
msg_start_length = . - msg_start

msg_rot13: .ascii "Rot13: "
msg_rot13_length = . - msg_rot13

.text

_start:
mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $msg_start, %ecx
mov $msg_start_length, %edx
int $SYSCALL

mov $SYSREAD, %eax
mov $STDIN, %ebx
mov $input, %ecx
mov $input_length, %edx
int $SYSCALL

mov %eax, %edi  #SYSREAD zwraca wartosc gdzie skonczylismy pisac wiec zapisujemy ja w rejestrze edi
dec %edi 	   	#po SYSREAD jest znak nowej linij wiec usuwamy go poprzez dekrementacje
xor %ebp, %ebp  #zerowanie rejestru ebp jezeli zawartosc jednakowa

petla:

cmpl $0, %edi					#sprawdzanie czy dlugosci wynosi 0
jz done 						#jezeli 0 skok w koniec

cmpb $65, input(%ebp)          	#sprawdzanie w porownaniu do A
jb not_letter           		#jezeli mneijsza niz 65 to nie litera

cmpb $90, input(%ebp)			#sprawdaznie w porownaniu do Z
ja not_big_letter       		#jezeli wieksza od 90 to moze byc mala litera

not_big_letter:


cmpb $122, input(%ebp)			#sprawdzanie w porownaniu do z
ja not_letter           		#jezeli wieksza niz 122 to nie litera

addb $0x0D, input(%ebp)   	    #dodanie 13 w kodzie ASCII (zalozenia rot13)
cmpb $90, input(%ebp)	      	#sprawdzenie w porownaniu do 90 (koniec duzych liter)
jbe no_correction   			#jezeli wartosc mniejsza od 90
cmpb $122, input(%ebp)
jbe no_correction				#jezeli wartosc mniejsza od 122

subb $26, input(%ebp)			#rowniez uwzgledniana pozyczka

no_correction:
				 
not_letter:
inc %ebp				 #inkrementacja jako przejscie do nastepnej pozycji w input

cmp %edi, %ebp			 #sprawdzanie czy koniec petli
jl petla				 #skok jezeli nie koniec petli

mov %eax, %edx			#pamietamy ze w eax pozostala dlugosc wczytanego tekstu po SYSREAD
mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $input, %ecx
int $SYSCALL

done:
mov $SYSEXIT32, %eax
mov $SUCCESSEDEXIT, %ebx
int $SYSCALL
