.data
hello_msg: .ascii "Hello world!\n"
hello_len = . - hello_msg

.text

.global encoder

encoder:

push %ebp
mov %esp, %ebp

mov 8(%ebp), %eax 	#w eax adres gdzie zaczyna sie tablica pixeli, w edx ilosc pixeli naszego bmp
mov %edx, %esi		#zapisujemy nasza liczbe pixeli

finish:
pop %ebp
ret