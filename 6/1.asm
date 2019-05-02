; Write a complete assembly language program to read two
; matrices A and B and display the result matrix C, which is the
; product of A and B. Your program should consist of a main
; procedure that calls the read_matrix procedure twice to read
; data for A and B. It should then call the matrix_add procedure,
; which receives pointers to A, B, C, and the size of the matrices.
; Note that both A and B should have the same size. The main
; procedure calls another procedure to display matrix (A B and C)

%include "io.mac"

.DATA
msg_dim     db  'Enter number of rows/columns of both matrices: ',0
msg_1       db  'Enter first matrix: ',0
msg_2       db  'Enter second matrix : ',0
msg_3       db  ' ',0
msg_4       db  'Result',0
msg_5       db  'First Matrix is: ',0
msg_6       db  'Second Matrix is: ',0

matrix1     TIMES   100   dw 0
matrix2     TIMES   100   dw 0
matrix3     TIMES   100   dw 0

.UDATA
m           resw    1
i           resw    1
j           resw    1

tmp1        resd    1
tmp2        resd    1
tmp3        resd    1

.CODE
    .STARTUP

    PutStr  msg_dim             
    nwln
    GetInt  [m]                     ; Get size of matrices
    nwln
    
    PutStr  msg_1                   ; Message to input first matrix
    nwln
    mov     CX, [m]                 ; Store matrix size in CX
    mov     EBX, matrix1            ; Store address of matrix1 in EBX
    call    read_matrix

    PutStr  msg_2                   ; Message to input second matrix
    nwln
    mov     CX, [m]
    mov     EBX, matrix2
    call    read_matrix

    mov     CX, [m]                 
    mov     EBX, matrix1
    PutStr  msg_5
    nwln
    call    print_matrix            ; Print first matrix

    mov     CX, [m]
    mov     EBX, matrix2
    PutStr  msg_6
    nwln
    call    print_matrix            ; Print second matrix

    mov     AX, [m]
    mov     EBX, matrix1
    mov     ECX, matrix2
    mov     EDX, matrix3
    call    mul_matrix              ; Multiply the two matrices

    PutStr  msg_4
    nwln
    mov     CX, [m]
    mov     EBX, matrix3
    call    print_matrix            ; Print the result matrix

done:
    .EXIT

read_matrix:                        ; Function to read the matrix
    mov     DX, CX
    loop1:
        PutStr msg_3
        nwln
        push    CX
        mov     CX, DX

        loop2:
            GetInt [EBX]
            add     EBX, 2
            dec     CX
            cmp     CX, 0
            jne     loop2

        pop     CX
        dec     CX
        cmp     CX, 0
        jne     loop1
    ret

print_matrix:                         ; Function to print matrix
    mov     DX, CX
    loop3:
        push    CX
        mov     CX, DX

        loop4:
            PutInt [EBX]
			PutStr msg_3
			add EBX,2
			dec CX
			cmp CX, 0
			jne loop4

        nwln
        pop CX
		dec CX
		cmp CX, 0
		jne loop3
		nwln
    ret

mul_matrix:
    mov [tmp1], EBX
    mov [tmp2], ECX
    mov [tmp3], EDX
    mov [m], AX
    sub ECX, ECX
    loop5:
        mov [i], CX
        sub EDX, EDX
        loop6:
            mov [j], DX
            sub CX, CX
            sub EDI, EDI
            loop7:
                mov AX, [i]                     ; Finding matrix1[i][k]     
                mul WORD [m]
                add AX, DI                      ; i*m + k
                mov SI, 2
                mul SI
                mov SI, AX
                mov EDX, [tmp1]
                mov BX, [EDX + ESI]

                mov AX, DI                      ; Finding matrix2[k][j]
                mul WORD [m]
                add AX, [j]                     ; k*m + j
                mov SI, 2
                mul SI
                mov SI, AX
                mov EDX, [tmp2]
                mov AX, [EDX + ESI] 
                
                mul BX
                add CX, AX                      ; matrix1[i][k]*matrix2[k][j]

                add DI, 1
                cmp DI, [m]
                jl loop7                        ; Loop over all values of k

            mov AX, [i]
            mul WORD [m]
            add AX, [j]                         ; i*m + j
            mov SI, 2
            mul SI
            mov SI, AX
            mov EDX, [tmp3]
            mov [EDX + ESI], CX                 ; matrix[i][j] = For all K (matrix[i][k]*matrix[k][j])
            
            mov DX, [j]
            add DX, 1
            cmp DX, [m]
            jl loop6                            ; Loop for columns of matrix2

        mov CX, [i]
        add CX, 1
        cmp CX, [m]
        jl loop5                                ; Loop for rows of matrix1
    ret