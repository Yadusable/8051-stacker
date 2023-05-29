; --- INFO ---
; To start the game, first load the keyboard and matrix configurations
;
; Keyboard port: P2
; Matrix port: <bitte eintragen @Niklas>

START:
	mov	P0, P1
	MOV	R0, #000h
	MOV	B, #0ffh

	CALL	INS3
	CALL	LOOP_1

; --- INSERT 3x1 INTO A ---
INS3:
	ORL	A, #01d
	RL	A
	ORL	A, #01d
	RL	A
	ORL	A, #01d
	RET

; --- INSERT 2x1 INTO A ---
INS2:
	ORL	A, #01d
	RL	A
	ORL	A, #01d
	RET

; --- INSERT 1x1 INTO A ---
INS1:
	ORL	A, #01d
	RET


; --- GAME LOOP ---
LOOP_1:
	RL	A
	JNB	P2.0, ONCLICK_1
	jmp	DISP_MATRIX_1

LOOP_2:
	RL	A
	JB	P2.0, ONCLICK_2
	JMP	DISP_MATRIX_2


; --- ON CLICK ---
ONCLICK_1:
	; <implement onClick logic here>
	MOV	P3, A		; TEST: Wenn P3 mit einem LED Panel verbunden ist, kann man das sehen.
	JMP 	DISP_MATRIX_1

ONCLICK_2:
	; <implement onClick logic here>
	MOV	P3, A		; TEST: Wenn P3 mit einem LED Panel verbunden ist, kann man das sehen.
	JMP 	DISP_MATRIX_2
	JMP	LOOP_1

DISP_MATRIX_1:
	MOV R1, A
	MOV R0, #10h
	MOV A, #80h
	MOV P1, A
	CALL DISP_MATRIX_LOOP
	JMP LOOP_2

DISP_MATRIX_2:
	MOV R1, A
	MOV R0, #10h
	MOV A, #80h
	MOV P1, A
	CALL DISP_MATRIX_LOOP
	JMP LOOP_1

DISP_MATRIX_LOOP:
	MOV P0, @R0
	MOV P1, A
	INC R0
	RR A
	CJNE @R0, #00h, DISP_MATRIX_LOOP
	MOV A, R1
	RET

; --- PREPARE REGISTERS FOR NEXT LEVEL ---
; Calculate new row
; store old layer
; Increment Round counter in 0x00 by one
; Reset A to #000h
PREPREG:
	anl	B, A
	MOV	A, R0
	MOV	@R0, B
	ADD	A, #01d
	MOV	R0, A
	MOV	A, #000h
	RET
