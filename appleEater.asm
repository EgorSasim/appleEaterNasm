%include "lib.inc"


section .data
	tableSize	equ TABLE_WIDTH * TABLE_HEIGHT + TABLE_HEIGHT
	bufferSize	equ 5
	total_count_str	db	"TOTAL COUNT: "
	total_count_len equ	$ - total_count_str
	table_char	db	'#'
	apple_char	db	'*'
	eater_char	db	'@'
	new_line_char	db	10
	space_char	db 	' ' 
	eaterXPos	db	1
	eaterYPos	db	1
	appleXPos	db	0
	appleYPos	db	0
	appleGenerated	db	0
	total_count	db	0
section .bss 
	table 		resb tableSize
	inputChar	resb 1
	buffer		resb bufferSize
section .text 
global _start
_start:
game:
	clear_term

	cmp	byte [appleGenerated], 0
	je	apple_draw

check_eater_and_apple_coords:
	mov	al, [eaterXPos]
	cmp	al, [appleXPos]
	jne	table_draw
	mov	al, [eaterYPos]
	cmp	al, [appleYPos]
	jne	table_draw
	jmp 	apple_draw

apple_draw:
	call setRandAppleValues
	mov	byte [appleGenerated], 1

table_draw:
	call fill_table 

	print_str table, tableSize 
	print_str new_line_char, 1
	print_str total_count_str, total_count_len
	print_num [total_count], buffer, bufferSize
	print_str new_line_char, 1
	
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
	cmp	edi, TABLE_WIDTH
	jne	top_line

	mov 	eax, [new_line_char] 
	mov	[table + ebx], eax

check_eater_pos:
	cmp	byte [eaterXPos], 0 
	je	min_x_pos
	cmp	byte[eaterXPos], TABLE_WIDTH - 1 
	je	max_x_pos
	cmp	byte [eaterYPos], 0
	je	min_y_pos
	cmp	byte[eaterYPos], TABLE_HEIGHT - 1 
	je	max_y_pos
	jmp center


min_x_pos:
	mov	byte [eaterXPos], TABLE_WIDTH - 2
	jmp	center
max_x_pos:
	mov	byte [eaterXPos], 1
	jmp	center
min_y_pos:
	mov	byte [eaterYPos], TABLE_HEIGHT - 2
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
	jne	apple
	xor	eax, eax
	mov	al, byte [eaterXPos]
	dec	eax
	cmp	eax, edi
	jne	apple
	mov	eax, [eater_char]
	jmp	cont

apple:
	xor	eax, eax
	mov	al, byte [appleYPos] 
	dec	eax
	cmp	eax, esi
	jne	space
	xor	eax, eax
	mov	al, byte [appleXPos]
	dec	eax
	cmp	eax, edi
	jne	space	
	mov	eax, [apple_char]
	inc	byte [total_count]
	jmp	cont

space:
	mov	eax, [space_char]

cont:
	mov 	[table + ebx], eax

	inc	edi
	cmp 	edi, TABLE_WIDTH - 2
	jne	space_line

	inc	ebx
	mov	eax, [table_char]
	mov 	[table + ebx], eax

	inc	ebx
	mov	eax, [new_line_char]
	mov 	[table + ebx], eax

	inc	esi
	cmp	esi, TABLE_HEIGHT - 2
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
	cmp	edi, TABLE_WIDTH
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



setRandAppleValues:
	push	eax
	push	ebx
	push 	edx

	rdtsc			;get TSC value into eax 
	and	eax, 0x7FFFFFFF	;left only 31 bit
	mov	ebx, TABLE_WIDTH - 2
	xor	edx, edx
	div	ebx
	inc	edx		;get value from 1 to TABLE_WIDTH - 2
	mov	[appleXPos], edx


	rdtsc			
	and	eax, 0x7FFFFFFF
	mov	ebx, TABLE_WIDTH - 2
	xor	edx, edx
	div	ebx
	inc	edx	
	mov	[appleYPos], edx
	
	pop	edx
	pop	ebx
	pop	eax

	ret

