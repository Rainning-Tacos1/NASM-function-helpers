%macro PROLOGUE 1
	push bp
	mov bp, sp
	%if %1 != 0
		sub sp, %1
	%endif
%endmacro

%macro EPILOGUE 0
	leave
	;mov sp, bp
	;pop bp
%endmacro

%macro POP_ARGS 1
	add sp, %1*2
%endmacro

%macro SET_ARGS 1-*
	%if %0 == 0
		%exitmacro
	%endif
	; push arguments onto the stack
	%rotate -2
	%rep %0/2
		;mov dx, 0
		%ifidni %1, BYTE
			mov dl, %2
			movzx dx, dl
		%elifidni %1, WORD
			mov dx, %2
		%endif
		push dx
		%rotate -2 ; shift all arguments twice to the right, %2 = %1, %3 = %2, etc
	%endrep 
%endmacro

%macro call 1-*
	%if %0 == 1
		call %1
		%exitmacro
	%endif  

	SET_ARGS %{2:-1}
	call %1
	POP_ARGS (%0-1)/2
	
%endmacro

%define ARG8(n) BYTE [bp+2+(2*n)]
%define ARG16(n) WORD [bp+2+(2*n)]

%define V8(n) BYTE [bp-n]
%define V16(n) WORD [bp-(2*n)]
%define V8(n, m) BYTE [bp-(2*n)-m]
%define V16(n, m) WORD [bp-(2*n)-m]

%define NL 0xA
%define LF NL
%define CR 0xD

%define CRLF CR, LF

%macro string 2-*
	%1 db %2
	%if %0 >= 3
		db %{3:-1} 
	%endif 
%endmacro