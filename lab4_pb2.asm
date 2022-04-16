bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions



; -------------------------
; 2. A string of integer bytes S is given. ESI
; Create two new strings a and b:  
; a - consists in negative values from S EDI
; b - consists in positive and divisible with 7 from S EBP
; S = 14, 7, -1, -2, 3
; a = -1, -2
; b= 14, 7

;-----varianta 1 cu inc esi pe fiec ramura

; -------------------------
segment data use32 class=data
    s db 14, 7, -1, -2, 3
    lens equ $-s
    a resb lens  ; -1, -2 ; ff fe
    b resb lens; 14, 7 0e 0f
    sapte db 7

; our code starts here
segment code use32 class=code
    start:
        mov esi, 0
        mov edi, 0 ; a
        mov ebp, 0; b
        mov ecx, lens
        repeta:
            mov bl, [s+esi]
            cmp bl, 0 
            JGE pozitiv
            JL negativ
            
                pozitiv:
                    mov al, bl
                    mov ah, 0
                    div byte[sapte]  ;al cat si ah rest
                    cmp ah, 0
                    JE divizibil
                    JNE nedivizibil
                        divizibil:
                            mov [b+ebp], bl
                            inc ebp
                            inc esi
                        
                        JMP end_repeta
                        
                        nedivizibil:
                            inc esi
                    
                    
                
                JMP end_repeta
                
                negativ:
                    mov [a+edi], bl
                    inc edi
                    inc esi
            
        
            end_repeta:
        loop repeta
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
