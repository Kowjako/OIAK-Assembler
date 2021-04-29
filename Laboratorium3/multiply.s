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
	cmpb $0x30, %al
	jb end
	subb $0x30, %al
	cmpb $0x0A, %al
	jb cyfra
	subb $0x7, %al
cyfra:
	shll $4, liczba(,%ecx,4)
	addl %eax, liczba(,%ecx,4)
	incl %ebx
	cmpl $8, %ebx	#wczytane pierwsze 4 bajty, bo jezeli mamy 8 symboli i dwa symbole HEX to bajt , to 8 symboli daje 4 bajty
	je end
	jmp st
end:
	cmpl $2, %ecx	
	je finish
	incl %ecx
	jmp st

finish:

	mov $0, %eax
	movl liczba(,%eax,4), %ebx
	push %edx
	push %edx
	pushl %ebx
	pushl $format_h
	call printf

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