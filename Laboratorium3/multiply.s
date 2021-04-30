.data

msg1: .ascii "Podaj pierwsza liczbe\n\0"
msg2: .ascii "Podaj druga liczbe\n\0"

liczba1: .space 200 #dopuszczalne 200 znakow max #"CAFF1234BBCCFFAA11111111\0" #.space 8 = 16*4 = 64
liczba: .space 100 #bo .space 4 bajty wystarczy do 8 znakow 0xCAFF1234

format_s: .ascii "%s\0"
format_h: .ascii "%x\0"
newline: .ascii "\n"

outputIterator: .int 0

.text

.global main

main:
	pushl $msg1
	call printf		#prosimy o podanie 1 liczby

	pushl $liczba1
	pushl $format_s
	call scanf		#wczytujemy liczbe do liczba1

	movl $0, %ecx	#rejestr indeksujacy nasza liczbe koncowa
	movl $0, %ebx	#rejestr indeksujacy kolejne symbole tekstu
st:
	movl $0, %eax
	movb liczba1(,%ebx,1), %al #pobieramy symbol
	incl %ebx	#przechodzimy do kolejnego symbolu
	cmpb $0x30, %al #jezeli wartosc ASCII jest mniejsza niz 30 to znaczy mniejsze od symbolu '0'
	jb end
	subb $0x30, %al #odejmujemy 30 aby dostac liczbe z kodu ASCII
	cmpb $0x0A, %al #jezeli mneijsza niz 10 to jest liczba
	jb cyfra
	subb $0x07, %al #tu bedziemy jezeli mamy znak a nie liczbe
cyfra:
	shll $4, liczba(,%ecx,4) #przesuwamy w lewo o 4 pozycje zeby umiescic jeden symbol tekstowy
	addl %eax, liczba(,%ecx,4) #wstawiamy symbol tekstowy
	cmpl $8, %ebx	#czy wczytane pierwsze 4 bajty, bo jezeli mamy 8 symboli HEX i dwa symbole HEX to bajt , to 8 symboli daje 4 bajty
	je end
	cmpl $16, %ebx
	je end
	cmpl $24, %ebx
	je end
	jmp st
end:
	cmpl $2, %ecx	#sprawdzamy czy wpisalismy 3 longi (0,1,2)
	je finish
	incl %ecx  #zwiekszamy indeks rejestru indeksujacego liczbe
	jmp st #skok do powtorzenia

finish:

	mov $0, %eax
nextlong:
	cmp $3, %eax
	je endprogram
	movl liczba(,%eax,4), %ebx
	push %eax	#odkladamy na stos zeby nie zepsuc wartosc
	push %edx	#rezerwajca miejsca zeby wypisac long
	push %edx
	pushl %ebx	#push liczby do wykorzystania printf
	pushl $format_h	#push formatu
	call printf
	pop %eax	#pobieramy odlozone wartosci ze stosu
	pop %eax
	pop %eax
	pop %eax
	pop %eax	#pobiearmy wartosc ze stosu eax
	inc %eax
	jmp nextlong

endprogram:
	pushl $newline
	call printf
	call exit