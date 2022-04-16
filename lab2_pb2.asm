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

    ;    Probl 1 - in unsigned representation  A/B – C*2 + D
;A BYTE
;B WORD
;C WORD
;D – DOUBLEWORD

a db 17
b dw 3
d dd 10
c dw 1
;A/B – C*2 + D

aux dw 0 ; sau aux resw 1
aux2 dd 0  ; sau aux2 resd 1

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        
        ; a/b
        ; byte/word  - byte a sa devina doubleword DX:Ax
        
        mov al, [a]
        mov ah, 0
        mov dx, 0 
          ; din cele 3 instr in dx:Ax avem var A
        div word [b]; a/b si in ax vom gasi cat si in dx restul 
        
        mov [aux], ax  ; aux = a/b
        
        ; C*2
        ; word * const 
        mov ax, 2
        mul word[c]  ; rez este in DX:AX
        
        ; aux - dx:ax  +   d
        
        ;  w -  comb reg  + doubleword
        
        ; aux - dx:ax
        ; var 1  - conversie aux la comb reg cx:bx
                mov bx, [aux]
                mov cx, 0       ; aux -> cx:bx
                  ; cx: bx - 
                  ; dx: ax
                 
                sub bx, ax
                sbb cx, dx   ; rez este in cx:bx
                
              
        ;
          
          ; daca continuam cu var 1 codul este:
          ; cx:bx  + d doubleword
          ; cx                        :  bx + 
          ; partea high din d             partea low din d 
            add bx, word[d+0]
            adc cx, word[d+2]  ; rez final in cx:bx
          
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
