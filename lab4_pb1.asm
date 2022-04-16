bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
;-------------------
; 1. A string of bytes S is given in data segment and a constant k. Add constant k at each element from string S and store the new string in variable D.
; S = 2, 5, 10, k=5 => D = 7, 10, 15
;-------------------
    
  s db 1, 2,3, 0101b, 1ah
  lens equ $ -s 
  k db 5
  d resb lens ; se aloca in mem lens bytes
  ;our code starts here
segment code use32 class=code
    start:
    
    ; exemplu pentru OF
        ; 600 / 2 
        ; mov ax, 600
        ; mov bl, 2
        ; div bl  ; 300 > val maxima a unui byte 0-255
        
        ; mov ax, 600
        ; mov dx, 0
        ; mov bx, 2
        ; div bx  
        
        ; mov ax, 9000h
        ; mov bx, 100h
        ; mul bx  ; dx:ax = ax*bx  seteaza of
        
        ; mov ax, 90h
        ; mov bx, 100h
        ; mul bx  ; dx:ax = ax*bx  nu seteze of
        
        ; mov esi, 0 ; pentru a parcurge s
        ; mov edi, 0; d
        ; mov ecx, lens
        ; repeta:
            ; mov al, [s+esi]  ; primul elem din s in al
            ; add al, k ; adunam const k
            ; mov [d+edi], al
            ; inc esi 
            ; inc edi
        
        ; loop repeta
        
        mov esi, 0 ; pentru a parcurge s
        ;mov edi, 0; d
        mov ecx, lens
        repeta:
            mov al, [s+esi]  ; primul elem din s in al
            add al, [k] ; adunam const k
            mov [d+esi], al
            inc esi 
           ; inc edi
        
        loop repeta
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
