%include "lib.inc"

section .data
	tableWidth	equ 10
	tableHeight	equ 10
	tableSize	equ tableWidth * tableHeight + tableHeight 
	eaterXPos	db 1
	eaterYPos	db 1
section .bss 
	table 		resb tableSize
	inputChar	resb 1
section .text 
global _start
_start:
game:
	mov 	r8d, 1
	clear_term 
	mov	edi, [eaterXPos]
	mov	esi, [eaterYPos]
	fill_table table, tableWidth, tableHeight, edi, 1 

	print_str table, tableSize
	
input:
	read_char inputChar
	mov	eax, [inputChar]
	cmp	[inputChar], byte 10
	je 	input	
	cmp	[inputChar], byte 'q'
	jne	game	
end:
	FINISH

		
