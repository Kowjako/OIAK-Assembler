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

	cmpb $0x0A, %al #sprawdzamy czy koniec linii (ascii 10 - znak konca linii)
	jl finish #jezeli rowna sie to skok

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
	

	movl $0, %edx #wyzerwoanie reszty
	mov %ebx, %eax	#zapisujemy ebx jako dzielnik w eax w ebx ilosc symboli wczytanych
	mov $8, %esi	# dzielna w ebp dzielmy razy 8 aby wiedziec ile longow wczytalismy
	div %esi	#dzielimy reszta w edx
	cmp $0, %edx	#jezeli reszta znaczy wczytano caly long
	je end

	jmp st
end:
	cmpl $100, %ecx	#sprawdzamy czy wpisalismy 100 longow bo 200 znakow ascii HEX to 100 long)
	je finish

	cmpb $0x0a, liczba1(,%ebx,1) #jezeli symbol po 8 kolejnych jest spacja nie zwiekszamy ilosc longow (outputIterator)
	jl finish

	add $1, outputIterator #iterator pokazuje ile liczb wczytalismy calkowicie
	incl %ecx  #zwiekszamy indeks rejestru indeksujacego liczbe
	jmp st #skok do powtorzenia

finish:

	mov $0, %eax

	cmp $0, outputIterator	#jezeli wpisano mniej niz 8 znakow to trzeba zwiekszyc o 1 ilosc liczb do wypisania
	je addIterator

	add $1, outputIterator	#jezeli kolejny symbol po 8 symbolach nie jest spacja to znaczy jeszcze jeden long

nextlong:
	cmp outputIterator, %eax
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

addIterator:
	add $1, outputIterator
	jmp nextlong