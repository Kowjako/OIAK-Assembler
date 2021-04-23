all: kalkulator

kalkulator: kalkulator.o
	ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -o kalkulator -lc kalkulator.o

kalkulator.o: kalkulator.s
	as --32 -o kalkulator.o kalkulator.s
	
clean:
	rm kalkulator.o kalkulator