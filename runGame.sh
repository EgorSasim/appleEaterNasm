if [ $# -eq 2 ]; then
	if [ $1 -ge 3 -a $2 -ge 3 ]; then
		nasm -f elf -dTABLE_WIDTH=$1 -dTABLE_HEIGHT=$2 appleEater.asm
	else 
		echo "Height and width should be more than or equal 3"
		exit 1	
	fi
elif [ $# -eq 1 ]; then
	if [ $1 -ge 3 ]; then
		nasm -f elf -dTABLE_WIDTH=$1 appleEater.asm
	else 
		echo "Height and width should be more than or equal 3"
		exit 1
	fi	
else 
	nasm -f elf appleEater.asm
fi
ld -m elf_i386 appleEater.o -o eater
./eater

