.data
hello_msg: .ascii "Hello world!\n"
hello_len = . - hello_msg

.text

.global encoder

encoder:

push %ebp
mov %esp, %ebp

#pobieramy ze stosu nasze parametry z funkcji C#

mov 8(%ebp), %esi 	#w eax adres gdzie zaczyna sie tablica pixeli
mov 12(%ebp), %edi	#zapisujemy nasza liczbe pixeli
mov 16(%ebp), %ebx  #pobieramy nasz tekst
mov 20(%ebp), %eax  #dlugosc tekstu

finish:
pop %ebp
ret