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
	mov	esi, 1	
	mov	edi, 1
game:
	clear_term
	fill_table table, tableWidth, tableHeight, edi, esi 

	print_str table, tableSize
	
input:
	read_char inputChar

	inc	edx	
	cmp	[inputChar], byte 10
	je 	input	
	
	cmp	[inputChar], byte 'h'
	je	go_left	

	cmp	[inputChar], byte 'j'
	je	go_down

	cmp	[inputChar], byte 'k'
	je	go_up

	cmp	[inputChar], byte 'l'
	je	go_right

	cmp	[inputChar], byte 'q'
	je	end

	jmp 	game

go_left:
	dec	edi
	jmp 	game
go_right:
	inc	edi
	jmp	game
go_up:
	dec	esi
	jmp	game
go_down:
	inc	esi
	jmp	game

end:
	FINISH

		
