; Program to encrypt a string
;
;   Objective: Encrypting a string with the given encoding
;       input digit : 0 1 2 3 4 5 6 7 8 9
;       encryption  : X Y Z A B C D E F 0
;
;   Input: A string input until user enters 'y' to terminate the program.
;   Output: The encrypted string for each input.

%include "io.mac"

.DATA
msg_str     db  'Enter a string to encrypt: ',0
msg_stro    db  'The encrypted string is: ',0
msg_term    db  'Do you want to terminate the program? Enter y/n : ',0
msg_exit    db  'Do you want to quit? (Y/N): ',0

.UDATA
stri        resb 51

.CODE
    .STARTUP

take_inp:
    PutStr  msg_str
    GetStr  stri,51             ; Read input char string
    PutStr  msg_stro
    mov     EBX, stri           ; EBX = Pointer to stri

encrypt:
    mov     AL, [EBX]           ; move the char to AL
    cmp     AL,0                ; if it null character
    je      redo
    cmp     AL, '0'             ; not a numeric digit
    jl      disp
    cmp     AL, '9'             ; not a numeric digit
    jg      disp
    cmp     AL, '9'             ; if digit is 9
    je      case9
    cmp     AL, '3'             
    jge     bw_3_and_8          ; if digit between 3 and 8
    jl      bw_0_and_2          ; if digit is between 0 and 2

case9:
    mov     AL, '0'             ; display 0 if 9
    jmp     disp

bw_0_and_2:
    add     AL, 'X'-'0'         ; if digit between 0 and 2
    jmp     disp

bw_3_and_8:
    add     AL, 'F'-'8'         ; if digit between 3 and 8
    jmp     disp

disp:
    PutCh   AL                  ; display AL
    inc     EBX                 ; EBX points to next char
    jmp encrypt

redo:
    nwln
    PutStr  msg_exit            ; confirmation for exit
    GetCh   CL
    cmp     CL,'Y'              ; exit if y or Y
    je      done
    cmp     CL,'y'
    je      done
    jmp     take_inp            ; take another input string for any other char

done:
    .EXIT