%include "macros.s"

BITS 16
ORG 0x7c00

start:
	xor ax, ax
	mov ss, ax
    mov ds, ax
	mov sp, 0x7bff

	call puts, WORD, message
	jmp $


puts: ; WORD string
	PROLOGUE 0
	cld
	mov si, ARG16(1)
.loop_char:
	lodsb ; char in al
	cmp al, 0
	je .puts_exit

	call putc, BYTE, al
	jmp .loop_char

.puts_exit:
	EPILOGUE
	ret

putc: ; BYTE character
	PROLOGUE 0
	mov al, ARG8(1) ; character
	mov ah, 0x0e
	mov bh, 0x00
	int 0x10
	EPILOGUE
	ret

string message, "Hello, world!", CRLF