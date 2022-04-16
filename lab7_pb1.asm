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
    a db 200
    b dw -2
    c dw -100
    d db 20
    e dq 12345678h
    aux dw 0
    aux2 dd 0

; our code starts here
segment code use32 class=code
    start:
      ; Write the code to compute a / b + c *(-d) + e, a-byte, b – word, c – word, d-byte, e – quadword (signed numbers)
      
      ; a / b
      ; byte / word = > doubleword/word
      mov al, [a]
      cbw  ; ax = a   ; movsx ax, al
      cwd ; dx:ax = a
      idiv word [b] ; ax - quotient 
      
      mov [aux], ax
      
      ; c *(-d)
      ; word * byte = > word * word
      mov al, 0
      mov bl, [d]
      sub al, bl  ; al = -d
      cbw  ; ax = -d  ; movsx ax, al
      imul word [c] ; dx:ax = c*(-d)
      
      ; a / b + c *(-d)
      ;  aux  + dx:Ax
      ;   word   doubleword
      
      ; transfer dx:ax  into aux2
      mov [aux2+0], ax
      mov [aux2+2], dx   ; aux2 = c *(-d) 
      
      ; take aux in ax for conversion
      mov ax, [aux]
      cwd   ; dx:ax = a / b
      
      ; transfer aux2 in cx:bx
      mov bx, [aux2+0]
      mov cx, [aux2+2]
      
      ; add dx:ax
      ;     cx:bx
      
      add ax, bx
      adc dx, cx   ; dx:ax = a / b + c *(-d)
      
      
      ; a / b + c *(-d) + e
      ;           dx:ax  + e
      ;            dd      quad
      
      ; trasnfer dx:ax into EAX 
      mov [aux2+0], ax
      mov [aux2+2], dx
      mov eax, [aux2]
      ; convert eax into edx:eax
      
      cdq  ; convert doubleword to quadword
      ; edx:eax = a / b + c *(-d)
      
      ; save variab e in ecx:ebx
      mov ebx, [e+0]
      mov ecx, [e+4]
      
      ; add edx:eax+
      ;     ecx:ebx
      
      add eax, ebx
      adc edx, ecx   
        ; edx:eax = a / b + c *(-d) + e
      
      
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
