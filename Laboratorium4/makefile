all: main

main: main.c encoder.s
	gcc encoder.s decoder.s main.c -o main -g -m32 

clean:
	rm main