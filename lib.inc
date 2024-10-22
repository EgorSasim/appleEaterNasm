clearScreen	db	0x1b, '[2J', 0x1b, '[H', 0

%macro print_str 2 ; %1: string address. %2: string length 
	push 	eax
	push 	ebx
	push 	ecx
	push 	edx

	mov	eax, 4
	mov	ebx, 1
	mov	ecx, %1
	mov	edx, %2
	int	0x80

	pop 	edx
	pop 	ecx
	pop 	ebx
	pop 	eax
%endmacro

%macro read_char 1; buffer address
	push 	eax
	push	ebx
	push 	ecx
	push	edx	

	mov	eax, 3
	mov	ebx, 0
	mov	ecx, %1
	mov	edx, 1
	int	0x80

	pop 	edx
	pop 	ecx
	pop 	ebx
	pop 	eax
%endmacro

;%macro fill_table 5 ; table adress, tableWidth, tableHeight 
;		    ; eaterWidthPos, eaterHeightPos 
;	push 	eax
;	push 	ebx
;	push 	ecx
;	push 	edx
;	push	esi 
;	push	edi 
;
;	xor	esi, esi
;	xor 	edi, edi
;	xor	ebx, ebx
;
;
;;ebx - index to go through table string
;;edi, esi - indexes to go throgh "row" and "column" of table
;
;top_line:
;	mov 	eax, [table_char] ; prevent mem to mem 
;	mov	[%1 + ebx], eax	  ; transition
;	inc	ebx		  ; table address counter
;	inc	edi		  ; table width counter
;	cmp	edi, %2
;	jne	top_line
;
;	mov 	eax, [new_line_char] 
;	mov	[%1 + ebx], eax
;
;center:
;	inc	ebx
;	mov	eax, [table_char]
;	mov 	[%1 + ebx], eax
;	xor	edi, edi
;
;space_line:
;	inc	ebx
;
;	xor	eax, eax
;	mov	eax, %5 - 1
;	cmp	eax, esi
;	jne	space
;	xor	eax, eax
;	mov	eax, %4 - 1
;	cmp	eax, edi
;	jne	space
;	mov	eax, [eater_char]
;	jmp	cont
;
;space:
;	mov	eax, [space_char]
;
;cont:
;	mov 	[%1 + ebx], eax
;
;	inc	edi
;	cmp 	edi, %2 - 2
;	jne	space_line
;
;	inc	ebx
;	mov	eax, [table_char]
;	mov 	[%1 + ebx], eax
;
;	inc	ebx
;	mov	eax, [new_line_char]
;	mov 	[%1 + ebx], eax
;
;	inc	esi
;	cmp	esi, %3 - 2
;	jne	center
;
;	xor	edi, edi
;	inc	ebx
;	mov	eax, [new_line_char]
;	mov 	[%1 + ebx], eax
;bottom_line:
;	mov 	eax, [table_char] 
;	mov	[%1 + ebx], eax	  
;	inc	ebx		  
;	inc	edi		  
;	cmp	edi, %2
;	jne	bottom_line
;
;	mov 	eax, [new_line_char] 
;	mov	[%1 + ebx], eax
;
;	pop	edi
;	pop	esi
;	pop 	edx
;	pop 	ecx
;	pop 	ebx
;	pop 	eax
;%endmacro
	

%macro clear_term 0
	push 	eax
	push 	ebx
	push 	ecx
	push 	edx

	mov	eax, 4
	mov	ebx, 1
	mov	ecx, clearScreen
	mov	edx, 8
	int	0x80

	pop 	edx
	pop 	ecx
	pop 	ebx
	pop 	eax
%endmacro

%macro FINISH 0 ; finish program
	mov 	eax, 1
	xor	ebx, ebx
	int	0x80
%endmacro

