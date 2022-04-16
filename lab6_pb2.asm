; Read a string of characters from the keyboard. 
;Compute the number of vowels and then print this number on screen.
; if we insert from keyboard "I have a book". The number of vowels = 5

bits 32 
global start        
extern exit              
import exit msvcrt.dll    
extern printf, scanf , gets             
import printf msvcrt.dll  
import scanf msvcrt.dll  
import gets msvcrt.dll  

; our data is declared here (the variables needed by our program)
segment data use32 class=data
s resb 30
formatstring db '%s', 0
msgstart db 'Insert a string with spaces: ', 0
vowels db 'aeoiuAEIOU', 0
lvowels equ $ - vowels-1
nov dd 0
copy dd 0 ; save an interm ecx
formatprintres db ' The number of vowels = %d', 0



; our code starts here
segment code use32 class=code
    start:
        push dword msgstart
        call [printf]
        add esp, 4*1
        
        ; gets (String)
        push dword s
        call [gets]
        add esp, 4*1 
        
        ; print the content from s
        push dword s
        push dword formatstring
        call [printf]
        add esp, 4*2
        
        ; processing the string S to compute the number of vowels
        mov ecx, 20 ; the max length for s
        mov esi, 0; s
        myrep:
            mov al, [s+esi]
            mov [copy], ecx
            mov edi, 0 ; vowels
            mov ecx, lvowels 
                repvowels:
                    mov bl, [vowels+edi]
                    cmp al, bl 
                    JE contvowels
                    JNE nocounting
                            contvowels:
                                inc dword [nov]
                                inc edi
                                jmp end_repvowels
                            nocounting:
                                inc edi
                end_repvowels:
                loop repvowels
                mov ecx, [copy]
                inc esi
        
        loop myrep
        
        ; print the res formatprintres db ' The number of vowels = %d', 0
        push dword[nov]
        push dword formatprintres
        call [printf]
        add esp, 4*2
       
       
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
