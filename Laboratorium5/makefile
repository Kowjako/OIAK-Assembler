all: main

main: main.c blackwhite.s negative.s
	gcc blackwhite.s negative.s main.c -o main -g -m32 

clean:
	rm main