clearScreen	db	0x1b, '[2J', 0x1b, '[H', 0

%ifndef TABLE_WIDTH
%define		TABLE_WIDTH 	 10
%endif

%ifndef TABLE_HEIGHT
%define 	TABLE_HEIGHT	 10
%endif

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

%macro print_num 3 ; number ; string buffer ; buffer length
	push 	eax
	push 	ebx
	push 	ecx
	push 	edx
	push 	edi

	mov 	eax, %1
	mov	edi, %2 + %3 - 1 
	mov	ebx, 0

.convert:
	dec 	edi
	xor 	edx, edx
	mov	ecx, 10 ; division by 10
	div	ecx
	add 	dl, '0'
	mov	[edi], dl
	test	eax, eax
	jnz 	.convert

	mov	eax, 4
	mov	ebx, 1
	mov	ecx, edi
	mov	edx, %3	

	pop 	edi
	pop	edx
	pop	ecx
	pop	ebx
	pop	eax
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

