%include "lib.inc"

section .data
	tableWidth	equ 10
	tableHeight	equ 10
	tableSize	equ tableWidth * tableHeight + tableHeight 
	table_char	db	'#'
	eater_char	db	'@'
	new_line_char	db	10
	space_char	db 	' ' 
	eaterXPos	db	1
	eaterYPos	db	1
section .bss 
	table 		resb tableSize
	inputChar	resb 1
section .text 
global _start
_start:
game:
	clear_term
	call fill_table 

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
	dec	byte [eaterXPos]
	jmp 	game
go_right:
	inc	byte [eaterXPos]
	jmp	game
go_up:
	dec	byte [eaterYPos]	
	jmp	game
go_down:
	inc	byte [eaterYPos]
	jmp	game

end:
	FINISH

		
fill_table: 
	push 	eax
	push 	ebx
	push 	ecx
	push 	edx
	push	esi 
	push	edi 

	xor	esi, esi
	xor 	edi, edi
	xor	ebx, ebx

top_line:
	mov 	eax, [table_char] ; prevent mem to mem 
	mov	[table + ebx], eax	  ; transition
	inc	ebx		  ; table address counter
	inc	edi		  ; table width counter
	cmp	edi, tableWidth
	jne	top_line

	mov 	eax, [new_line_char] 
	mov	[table + ebx], eax

check_eater_pos:
	cmp	byte [eaterXPos], 0 
	je	min_x_pos
	cmp	byte[eaterXPos], tableWidth - 1 
	je	max_x_pos
	cmp	byte [eaterYPos], 0
	je	min_y_pos
	cmp	byte[eaterYPos], tableHeight - 1 
	je	max_y_pos
	jmp center


min_x_pos:
	mov	byte [eaterXPos], tableWidth - 2
	jmp	center
max_x_pos:
	mov	byte [eaterXPos], 1
	jmp	center
min_y_pos:
	mov	byte [eaterYPos], tableHeight - 2
	jmp	center
max_y_pos:
	mov	byte [eaterYPos], 1
	jmp 	center

center:
	inc	ebx
	mov	eax, [table_char]
	mov 	[table + ebx], eax
	xor	edi, edi

space_line:
	inc	ebx

	xor	eax, eax
	mov	al, byte [eaterYPos] 
	dec	eax
	cmp	eax, esi
	jne	space
	xor	eax, eax
	mov	al, byte [eaterXPos]
	dec	eax
	cmp	eax, edi
	jne	space
	mov	eax, [eater_char]
	jmp	cont

space:
	mov	eax, [space_char]

cont:
	mov 	[table + ebx], eax

	inc	edi
	cmp 	edi, tableWidth - 2
	jne	space_line

	inc	ebx
	mov	eax, [table_char]
	mov 	[table + ebx], eax

	inc	ebx
	mov	eax, [new_line_char]
	mov 	[table + ebx], eax

	inc	esi
	cmp	esi, tableHeight - 2
	jne	center

	xor	edi, edi
	inc	ebx
	mov	eax, [new_line_char]
	mov 	[table + ebx], eax
bottom_line:
	mov 	eax, [table_char] 
	mov	[table + ebx], eax	  
	inc	ebx		  
	inc	edi		  
	cmp	edi, tableWidth
	jne	bottom_line

	mov 	eax, [new_line_char] 
	mov	[table + ebx], eax
	pop	edi
	pop	esi
	pop 	edx
	pop 	ecx
	pop 	ebx
	pop 	eax
	ret
;
