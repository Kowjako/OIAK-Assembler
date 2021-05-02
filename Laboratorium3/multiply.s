.data

msg1: .ascii "Podaj pierwsza liczbe\n\0"
msg2: .ascii "Podaj druga liczbe\n\0"

str1: .space 100 #dopuszczalne 200 znakow HEX, 2 znaki HEX = 1 bajt
str2: .space 100 #dopuszczalne 200 znakow HEX, 2 znaki HEX = 1 bajt
liczba1: .space 100 #bo .space 4 bajty wystarczy do 8 znakow 0xCAFF1234
liczba2: .space 100 #bo .space 4 bajty wystarczy do 8 znakow 0xCAFF1234
result: .space 200 #na wynik potrzebujemy n1+n2 liczb 

format_s: .ascii "%s\0"
format_h: .ascii "%x\0"
newline: .ascii "\n"

outputIterator1: .int 0 #ile longow wczytano dla pierwszej
outputIterator2: .int 0 #ile longow wczytano dla drugiej
length1: .int 0
length2: .int 0

.text

.global main
#Wczytanie pierwszej liczby#
main:
	pushl $msg1
	call printf		#prosimy o podanie 1 liczby
	pushl $str1
	pushl $format_s
	call scanf		#wczytujemy liczbe do liczba1
	movl $0, %ecx	#rejestr indeksujacy nasza liczbe koncowa
	movl $0, %ebx	#rejestr indeksujacy kolejne symbole tekstu
firstNum:
	movl $0, %eax
	movb str1(,%ebx,1), %al #pobieramy symbol
	cmpb $0x0A, %al #sprawdzamy czy koniec linii (ascii 10 - znak konca linii)
	jl finish #jezeli rowna sie to koniec wczytywania
	incl %ebx	#przechodzimy do kolejnego symbolu
	cmpb $0x30, %al #jezeli wartosc ASCII jest mniejsza niz 30 to znaczy mniejsze od symbolu '0'
	jb end

	#sprawdezanie malych liter#
	cmpb $0x46, %al
	jbe duze
	cmpb $0x66, %al
	jbe malalitera

duze:
	subb $0x30, %al #odejmujemy 30 aby dostac liczbe z kodu ASCII
	cmpb $0x0A, %al #jezeli mneijsza niz 10 to jest liczba
	jb cyfra
	subb $0x07, %al #przypadek gdy mamy litere
cyfra:
	shll $4, liczba1(,%ecx,4) #przesuwamy w lewo o 4 pozycje zeby umiescic jeden symbol tekstowy
	addl %eax, liczba1(,%ecx,4) #wstawiamy symbol tekstowy
	movl $0, %edx #wyzerwoanie reszty
	mov %ebx, %eax	#zapisujemy ebx jako dzielnik w eax w ebx ilosc symboli wczytanych
	mov $8, %esi	# dzielna w ebp dzielmy razy 8 aby wiedziec ile longow wczytalismy
	div %esi	#dzielimy reszta w edx
	cmp $0, %edx	#jezeli reszta 0 znaczy wczytano caly long
	je end
	jmp firstNum
end:
	cmpl $100, %ecx	#sprawdzamy czy wpisalismy 100 longow bo 200 znakow ascii HEX to 100 long)
	je finish
	cmpb $0x0a, str1(,%ebx,1) #jezeli symbol po 8 kolejnych jest spacja nie zwiekszamy ilosc longow (outputIterator)
	jl finish
	add $1, outputIterator1 #iterator pokazuje ile liczb wczytalismy calkowicie
	incl %ecx  #zwiekszamy indeks rejestru indeksujacego liczbe
	jmp firstNum #skok do powtorzenia

finish:
	mov $0, %eax
	cmp $0, outputIterator1	#jezeli wpisano mniej niz 8 znakow to trzeba zwiekszyc o 1 ilosc liczb do wypisania
	je addIterator1
	add $1, outputIterator1	#jezeli kolejny symbol po 8 symbolach nie jest spacja to znaczy jeszcze jeden long

	mov %ebx, length1 #zapisanie dlugosci liczby 1


#Wczytanie drugiej liczby#
step:
	pushl $msg2
	call printf		#prosimy o podanie 2 liczby
	pushl $str2
	pushl $format_s
	call scanf		#wczytujemy liczbe do liczba2
	movl $0, %ecx	#rejestr indeksujacy nasza liczbe koncowa
	movl $0, %ebx	#rejestr indeksujacy kolejne symbole tekstu
secondNum:
	movl $0, %eax
	movb str2(,%ebx,1), %al #pobieramy symbol
	cmpb $0x0A, %al #sprawdzamy czy koniec linii (ascii 10 - znak konca linii)
	jl finish2 #jezeli rowna sie to koniec wczytywania
	incl %ebx	#przechodzimy do kolejnego symbolu
	cmpb $0x30, %al #jezeli wartosc ASCII jest mniejsza niz 30 to znaczy mniejsze od symbolu '0'
	jb end2

	#sprawdezanie malych liter#
	cmpb $0x46, %al
	jbe duze2
	cmpb $0x66, %al
	jbe malalitera2

duze2:	
	subb $0x30, %al #odejmujemy 30 aby dostac liczbe z kodu ASCII
	cmpb $0x0A, %al #jezeli mneijsza niz 10 to jest liczba
	jb cyfra2
	subb $0x07, %al #przypadek gdy mamy litere
cyfra2:
	shll $4, liczba2(,%ecx,4) #przesuwamy w lewo o 4 pozycje zeby umiescic jeden symbol tekstowy
	addl %eax, liczba2(,%ecx,4) #wstawiamy symbol tekstowy
	movl $0, %edx #wyzerwoanie reszty
	mov %ebx, %eax	#zapisujemy ebx jako dzielnik w eax w ebx ilosc symboli wczytanych
	mov $8, %esi	# dzielna w ebp dzielmy razy 8 aby wiedziec ile longow wczytalismy
	div %esi	#dzielimy reszta w edx
	cmp $0, %edx	#jezeli reszta znaczy wczytano caly long
	je end2
	jmp secondNum
end2:
	cmpl $100, %ecx	#sprawdzamy czy wpisalismy 100 longow bo 200 znakow ascii HEX to 100 long)
	je finish2
	cmpb $0x0a, str2(,%ebx,1) #jezeli symbol po 8 kolejnych jest spacja nie zwiekszamy ilosc longow (outputIterator)
	jl finish2
	add $1, outputIterator2 #iterator pokazuje ile liczb wczytalismy calkowicie
	incl %ecx  #zwiekszamy indeks rejestru indeksujacego liczbe
	jmp secondNum #skok do powtorzenia

finish2:
	mov $0, %eax
	cmp $0, outputIterator2	#jezeli wpisano mniej niz 8 znakow to trzeba zwiekszyc o 1 ilosc liczb do wypisania
	je addIterator2
	add $1, outputIterator2	#jezeli kolejny symbol po 8 symbolach nie jest spacja to znaczy jeszcze jeden long
	mov %ebx, length2


multiply:
	clc #wyczyszczenie flag
	pushf #odlozenie czystych flag na stos
	push outputIterator1 #do pobrania do esi
	push $0 

outerLoop:
	pop %edi #index wyniku
	inc %edi 
	pop %esi #licznik outerLoop
	cmp $0,%esi 
	jz showresult 
	dec %esi 
	movl liczba1(,%esi, 4), %eax #wpisujemy aktualny fragment luczby
	push %esi #licznik na stos
	push %edi #index wyniku na stos
	mov outputIterator2, %esi #dlugosc liczba2 = licznik wewnetrznej petli
 
innerLoop: 
	push %eax #frament liczby1 na stos
	dec %esi 
	dec %edi 
	movl liczba2(,%esi, 4), %ebx  #wycinam fragment liczby2 i wkladam do ebx
	mull %ebx #ebx*eax = edx|eax
	addl %eax,result(,%edi,4) #dodanie eax do wyniku
	inc %edi 
	jc overflow1 #sprawdzanie nadmiaru
back1: 
	addl %edx,result(,%edi,4) #dodanie drugiej porcji iloczynu po mull 
	inc %edi 
	jc overflow2 #czy jest nadmiar
back2: 
	pop %eax 
	cmp $0,%esi #czy koniec wewnetrznej petli
	jz outerLoop 
	jmp innerLoop 

overflow1:
	adcl $0,result(,%edi,4) #dodanie nadmiaru
	clc 
	jmp back1 

overflow2:
	adcl $0,result(,%edi,4) #dodanie nadmiaru
	clc
	jmp back2 


#Wypisanie wyniku#
showresult:
	decl %edi
	mov %edi, %eax

nextresult:
	cmp $-1, %eax
	je endprogram
	movl result(,%eax,4), %ebx
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
	dec %eax
	jmp nextresult


endprogram:
	pushl $newline
	call printf
	call exit

addIterator1:
	mov %ebx, length1
	add $1, outputIterator1
	jmp step

addIterator2:
	mov %ebx, length2
	add $1, outputIterator2
	jmp multiply

malalitera:
	subb $0x50, %al
	cmpb $0x0A, %al
	jb cyfra
	subb $0x07, %al
	jmp cyfra

malalitera2:
	subb $0x50, %al
	cmpb $0x0A, %al
	jb cyfra2
	subb $0x07, %al
	jmp cyfra2