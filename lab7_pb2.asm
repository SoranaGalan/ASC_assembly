bits 32 ; assembling for the 32 bits architecture

; A string of quadwords is given. Extract in string d all words containing an odd number of bits equal to 1 (in binary representation).
;EG. s dq 1020304050607080h
;then d will be 3040h because this is the only word with odd number of 1 in binary representation.

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
     s dq 1020304050607080h, 1020304050607080h, 1020304050607080h
     lens equ ($-s)/8 ;  1 quad = 8 bytes ; 3 elem in s
     d times lens * 4  dw -1 
     copy dd 0
     two db 2

; our code starts here
segment code use32 class=code
    start:
        ; ...
    mov esi, 0 ; s
    mov edi, 0 ; d
    mov ecx, lens*4 ; all words from a quadword
    
    repeat1:
        mov ax, word[s+esi] 
        mov [copy], ecx
        mov ecx, 16 ; for second repeat
        ; in bx the number of bits =1 from ax
        mov bx, 0
        repeat2:
            shl ax, 1
            adc bx, 0 ; in bx the number of bits =1 from ax
        loop repeat2
        
        ; check if bx is odd/even
        mov ax, bx
       idiv byte [two]
        cmp ah, 0
            JE evenbx
            JNE oddbx
                evenbx:
                    add esi, 2 ; go to next word from mem
                
                    jmp end_rep1
                oddbx:
                    mov ax, word[s+esi]
                    mov [d+edi], ax
                    add esi, 2 ; go to next word from mem
                    add edi, 2 ; go to next free position form d
         
         end_rep1:
            mov ecx, [copy]
            loop repeat1
                
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
