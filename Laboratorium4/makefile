all: main

main: main.c encoder.s
	gcc -m32 encoder.s main.c -o main -g

clean:
	rm main