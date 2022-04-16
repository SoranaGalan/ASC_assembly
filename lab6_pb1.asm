; A string of words S is given in data segment.
; For each word from string S extract the minimum byte and save in string D.
; if S = 1234h, 5623h, 4990h, 7651h then D = 12h, 23h, 49h, 51h


bits 32 ; assembling for the 32 bits architecture

global start        

extern exit    ,printf          
import exit msvcrt.dll    
import printf msvcrt.dll

                          
                          
; our data is declared here (the variables needed by our program)
segment data use32 class=data
s dw 1234h, 5623h, 4990h, 7651h  
ls equ ($-s) / 2 
d times ls db 0  
printhex db '%x ', 0

; our code starts here
segment code use32 class=code
    start:
        mov esi, 0 ; s
        mov edi, 0 ; d
        mov ecx, ls
        rep1:
            mov ax, [s+esi] ; ax = 1234h , ah = 12 and al = 34
            cmp al, ah
                JBE saveAL
                JA saveAH   
                    saveAL:
                        mov [d+edi], al
                        inc edi ; d is string of bytes
                        add esi, 2 ; s is string of words
                    
                    jmp end_rep1
                    saveAH:
                        mov [d+edi], ah
                        inc edi
                        add esi, 2 
                        
           end_rep1:
        loop rep1
        
        ; print on the screen the string D
        ; elements form d are values in hexadecimal
        
        ; print each element form string d
        mov esi, 0 ; d 
        repprint:
            mov bl, [d+esi]
            movzx ebx, bl ; convert bl to ebx because on stack we are allow to save ONLY dd
            
            push ebx
            push dword printhex
            call [printf]
            add esp, 4*2
            
            inc esi 
            cmp esi, ls
            JNE repprint
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
