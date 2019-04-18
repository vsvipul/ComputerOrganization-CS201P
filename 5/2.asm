; Program to print roll number of students who got maximum marks
; in each subject
;
;   Objective: Assume that you have marks obtained by N students 
;              in M subjects. Write an assembly language programe 
;              to find the Roll no. Of students who got maximum 
;              mark in each subject.

%include "io.mac"

MAX_SIZE_STU    EQU     20
MAX_SIZE_SUB    EQU     20

.DATA
    row_prompt  db  "Enter number of students : ",0
    col_prompt  db  "Enter number of subjects : ",0
    stu_prompt  db  "for roll number ",0
    sub_prompt  db  "Enter marks in subject ",0
    tmp_prompt  db  " : ",0
    tmq_prompt  db  "Roll number ",0
    res_prompt  db  " has the highest marks in subject ",0

.UDATA
    stu_size  resd    1
    sub_size  resd    1

.CODE
    .STARTUP
    
read_input:
    PutStr      row_prompt
    GetLInt     [stu_size]             ; take number of students
    PutStr      col_prompt
    GetLInt     [sub_size]             ; take number of subjects
    nwln
    xor         EDI, EDI               ; stores subject pos
    xor         ESI, ESI               ; stores student pos
    mov         EBX, -1                ; stores max position
    mov         EDX, -1                ; stores max value

subject_loop:
    PutStr      sub_prompt
    PutLInt     EDI                  
    nwln

student_loop:
    PutStr      stu_prompt
    PutLInt     ESI
    PutStr      tmp_prompt
    GetLInt     EAX                    ; take marks one by one for each student subject-wise
    cmp         EAX, EDX
    jg          update_new_max         ; if get a new greater value, update max pos and max val
    jmp         iter_stu

update_new_max:
    mov         EBX, ESI               ; change max value pos
    mov         EDX, EAX               ; change max value

iter_stu:
    inc         ESI
    cmp         ESI, [stu_size]        ; stopping condition for student loop
    jne         student_loop

iter_sub:
    PutStr      tmq_prompt
    PutLInt     EBX
    PutStr      res_prompt
    PutLInt     EDI
    nwln
    nwln
    xor         ESI, ESI               ; student pos
    mov         EBX, -1                ; max position
    mov         EDX, -1                ; max value
    inc         EDI
    cmp         EDI, [sub_size]        ; stopping condition for subject loop
    jne         subject_loop

done:
    .EXIT

