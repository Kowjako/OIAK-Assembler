.data

tekst: .ascii "CAFF1234BBCCFFAA11111111\0" #.space 8 = 16*4 = 64
liczba: .space 12 #bo .space 4 bajty wystarczy do 8 znakow 0xCAFF1234
format_h: .ascii "%x\0"
newline: .ascii "\n"

.text

.global main

main:
	movl $0, %ecx	#rejestr indeksujacy nasza liczbe koncowa
	movl $0, %ebx	#rejestr indeksujacy kolejne symbole tekstu
st:
	movl $0, %eax
	movb tekst(,%ebx,1), %al #pobieramy symbol
	cmpb $0x30, %al #jezeli wartosc ASCII jest mniejsza niz 30 to znaczy mniejsze od symbolu '0'
	jb end
	subb $0x30, %al #odejmujemy 30 aby dostac liczbe z kodu ASCII
	cmpb $0x0A, %al #jezeli mneijsza niz 10 to jest liczba
	jb cyfra
	subb $0x07, %al #tu bedziemy jezeli mamy znak a nie liczbe
cyfra:
	shll $4, liczba(,%ecx,4) #przesuwamy w lewo o 4 pozycje zeby umiescic jeden symbol tekstowy
	addl %eax, liczba(,%ecx,4) #wstawiamy symbol tekstowy
	incl %ebx	#przechodzimy do kolejnego symbolu tekstowego
	cmpl $8, %ebx	#czy wczytane pierwsze 4 bajty, bo jezeli mamy 8 symboli HEX i dwa symbole HEX to bajt , to 8 symboli daje 4 bajty
	je end
	jmp st
end:
	#movl $0, %ebx
	cmpl $2, %ecx	#sprawdzamy czy wpisalismy 3 longi (0,1,2)
	je finish
	incl %ecx  #zwiekszamy indeks rejestru indeksujacego liczbe
	jmp st #skok do powtorzenia

finish:

	#mov $0, %eax
	#movl liczba(,%eax,4), %ebx
	#push %edx
	#push %edx
	#pushl %ebx
	#pushl $format_h
	#call printf

	#mov $1, %eax
	#movl liczba(,%eax,4), %ebx
	#push %edx
	#push %edx
	#pushl %ebx
	#pushl $format_h
	#call printf


	pushl $newline
	call printf
	call exit