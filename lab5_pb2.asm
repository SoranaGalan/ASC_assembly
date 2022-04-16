bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; reverse a string of chracters
    ; A string S of characters is given in data segment.
    ; Reverse the string and save the result in string D.
    a db 'axbc' ; the res cbxa
    la equ $-a 
    d times la db -1 

; our code starts here
segment code use32 class=code
    start:
        mov edi, 0 ; d
        mov esi, la-1
        myrep:
            mov al, [a+esi]
            mov [d+edi], al
            dec esi ; to go to next position from right to left
            inc edi
              
        loop myrep
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program