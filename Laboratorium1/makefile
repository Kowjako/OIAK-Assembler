all: rot13

rot13: rot13.o
	ld rot13.o -o rot13

rot13.o: rot13.s
	as rot13.s -o rot13.o

clean:
	rm rot13.o rot13 