all: boot.bin

%.bin:
	nasm -f bin -l boot.lst -o boot.bin boot.asm

clean:
	rm -f *.bin *.o
