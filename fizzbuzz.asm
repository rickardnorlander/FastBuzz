global _main
extern  GetStdHandle
extern  WriteFile
extern  ExitProcess

section .text
_main:
	STD_OUTPUT_HANDLE equ -11
	NEWLINE equ 10
	NUMSIZE equ 12
	FLUSH_THRESHOLD equ 50000
	BUFFERSIZE equ 100000

	NUMBERS_TO_PRINT equ 100

	push    STD_OUTPUT_HANDLE
	call    GetStdHandle
	mov [hstdout], eax

	mov ebp, 1
	mov ebx, NUMBERS_TO_PRINT
	mov edi, buffer
	mov ah, 0
	mov edx, curnumber+NUMSIZE-1

start_loop:
	test ah,ah
	jp fizzorbuzz

	normal:
	mov ecx, ebp
	mov esi, edx
	rep movsb

dotheincrement:

	mov ecx,curnumber + NUMSIZE-1

fix:
	inc byte [ecx]
	cmp byte [ecx],'9'
	jbe endfix
	sub byte [ecx], 10
	loop fix

endfix:

	cmp ecx, edx
	jae skip
	dec edx
	inc ebp
skip:

	mov byte [edi], NEWLINE
	inc edi
	dec ah

	cmp edi, FLUSH_THRESHOLD + buffer
	ja flushbuffer

end_loop:

	dec ebx
	jnz start_loop

	sub edi, buffer
	push    0
	push dummy
	push dword edi
	push dword buffer
	push dword [hstdout]
	call WriteFile

	push    0
	call    ExitProcess


flushbuffer:
	push eax
	push edx

	sub edi, buffer
	push    0
	push dummy
	push dword edi
	push dword buffer
	push dword [hstdout]
	call WriteFile

	mov edi, buffer
	pop edx
	pop eax
	jmp end_loop

fizzorbuzz:
	jz fizzbuzz

	mov al,ah
	shl al,2
	test al,ah
	jnz buzz
fizz:
	mov dword [edi], 'fizz'
	add edi,4
	jmp dotheincrement
fizzbuzz:
	mov dword [edi], 'fizz'
	mov dword [edi+4], 'buzz'
	add edi,8
	mov ah, 15
	jmp dotheincrement
buzz:
	mov dword [edi], 'buzz'
	add edi,4
	jmp dotheincrement

section .data
	curnumber: times NUMSIZE db '0'
section .bss
	hstdout: resb 4
	buffer: resb BUFFERSIZE
	dummy: resb 4
