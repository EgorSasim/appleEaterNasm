nasm -f elf appleEater.asm
ld -m elf_i386 appleEater.o -o eater
./eater

