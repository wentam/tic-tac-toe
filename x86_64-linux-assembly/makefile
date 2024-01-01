all:
	nasm -f elf64 ttt.asm
	ld -s -o ttt ttt.o -z noseparate-code
	strip -s ttt
