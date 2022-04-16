bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
a db 2
b dw 0101b
c dd 11h
d dq 1122334455667788h
 







    
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        
; c + b – a + 1 + d    in unsigned

; b – a trebuie converttit a la word

movzx ax, [a]  ; ax = [a]
mov bx, [b]  ; bx [b]
sub bx, ax   ; bx  = b – a

; sau sub [b], ax  ; [b] = b- ax , adica se modifica direct in memorie

;c + b – a

movzx EBX, bx  ; conversie fara semn de la word bx la doubleword ebx, ebx = b – a

add ebx, [c]  ; ebx = c + b – a
; sau mov ecx, [c]
;      add ebx, ecx

add ebx, 1  ; ebx = c + b – a + 1

; transfer d in edx:eax  
; d in memorie, conf little-endian:
 ; 88   77   66   55   44  33    22   11
 ; d+0   +1   2    3    4    5   6   7
 
 ; d dq 11223344  55667788h
         ; EDX     : eax
   mov edx, dword[d+4]   ; dword = 4 bytes   ; mov edx, 4bytes[d+4]  mov dx, word[ d+6]  ; dx= 1122
   mov eax, dword[d+0]
   
   ; edx:eax +
         ;ebx
       ; trebuie ecx compl cu 0
    mov ecx, 0
    
    ; t
    ;edx: eax +
    ;ecx: ebx
    
    add eax, ebx 
    adc edx, ecx  
    ; rez in edx:eax
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
