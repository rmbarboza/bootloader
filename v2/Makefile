all: boot.bin

%.bin:
	nasm -f bin -o boot.bin boot.asm

clean:
	rm -f *.bin *.o
