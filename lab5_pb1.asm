;A string of bytes - integer numbers is given in data segment.
;Create 2 new strings:
    ;1 string only with negative bytes
    ;1 string only with positive values and divisible with 7

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
  s db 10, 3, 4, 7, 14, -1, -2 ; esi
  ls equ $-s
  n times ls db 0 ; negative edi
  p times ls db -1; positive div cu 7 ebp
  sap db 7
; our code starts here
segment code use32 class=code
    start:
    mov ecx, ls
    mov esi, 0
    mov edi, 0
    mov ebp, 0
    myrep:
        mov bl, byte [s+esi]
        cmp bl, 0
        JGE positiv
        JL negativ
            positiv:
                mov al, bl
                mov ah, 0
                div byte[sap] ; ax/sap = ah remainder
                cmp ah, 0
                JE divisible
                JNE nedivisible
                    divisible:
                        mov [p+ebp], bl
                        inc ebp
                        inc esi
                        
                        jmp end_repeta
                        
                     nedivisible:
                        inc esi
               
               jmp end_repeta

               negativ:
                    mov [n+edi], bl
                    inc edi
                    inc esi
     end_repeta:  
    loop myrep
     
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
