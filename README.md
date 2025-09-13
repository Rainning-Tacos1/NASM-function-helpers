# NASM-function-helpers

This project provides macros for function calling/prologue/epilogue and also some extra defenitions

Calling convention: Pascall; Args are pushed onto the stack from left to right; callee cleans the stack

(It made things easier to implement ;_;)


### WARNING!
These macros were made for 16 bit x86 but can be adapted for 32bit

## How to use Use:
include the macros once!
```asm
%include "macros.s"
```
#### Declare a function:
```asm
foo:
    PROLOGUE X
    ; code
	EPILOGUE
	ret

```
where `X` is the number of bytes allocated for funtion variables

#### Call the function:
```asm
call foo, [BYTE/WORD], [value/reg/label] ...
```
The macro overrides the keyword call. You can pass multiple arguments by specifying the type and then the argument itself.
Internally all arguments are aligned to 16 bits.
The macro uses `dx` to align the arguments and push them onto the stack

**(SAVE OR DO NOT USE `dx`)**

### Ex:
```
call foo, BYTE, 0x10, WORD, message, BYTE, al
```

#### Use the arguments passed to a function:
```asm
foo:
    PROLOGUE 0
    ; the macro name just defines the type of the argument
    ; Internally they both point to the same address
    mov al, ARG8(1)  ; 1st argument: BYTE, 0x10
    mov bx, ARG16(2) ; 2nd argument: WORD, message
    mov cl, ARG8(3)  ; 3rd argument: BYTE, al
	EPILOGUE
	ret
```

### Declare variables inside a function:
```asm
foo:
    PROLOGUE 5
    mov V8(1), al      ; first 8 bits
    mov V16(1, 1), ax  ; first 16 bit var, skiping 1 byte
    mov V16(2, 1), bx  ; second 16 bits var, skiping 1 byte

    ; Can't mix ARG and V in the same instruction
    mov V8(1), ARG8(1)

	EPILOGUE
	ret
```

#### String:
```asm
string my_label_for_str, "Hello, world!", CR, LF
```