; --- INFO ---
; To start the game, first load the keyboard and matrix configurations
;
; Keyboard port: P2
; Matrix port: <bitte eintragen @Niklas>

START:
	mov	P0, P1
	MOV	R0, #010h	;R0 is the layer counter, 0x10=lowest
	MOV	B, #0ffh	;all positions are valid for first layer

	CALL	INS3
	CALL	CYCLE
	CALL	INS3
	CALL	CYCLE
	CALL	INS3
	CALL	CYCLE

	CALL	INS2
	CALL	CYCLE
	CALL	INS2
	CALL	CYCLE
	CALL	INS2
	CALL	CYCLE

	CALL	INS1
	CALL	CYCLE
	CALL	INS1
	CALL	CYCLE
	JMP	END

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
CYCLE:
	RL	A
	MOV	P3, A	; display instruction, later to be replaced by method call
	JNB		P2.0, ONCLICK_1
	CALL	DISP_MATRIX
	jmp		CYCLE

PRESS:		; when button released execute game logic
	JB		P2.0, ONCLICK_2
	CALL	DISP_MATRIX
	JMP		PRESS


; --- ON CLICK LOGIC ---
ONCLICK_1:	; jump in PRESS Part
	MOV	P3, A		; TEST: Wenn P3 mit einem LED Panel verbunden ist, kann man das sehen.
	CALL 	DISP_MATRIX
	JMP		PRESS

ONCLICK_2:	; execute gamelogic
	MOV	P3, A		; TEST: Wenn P3 mit einem LED Panel verbunden ist, kann man das sehen.
	CALL 	DISP_MATRIX
	JMP		LOOP_1
	CALL 	GAME_STEP
	RET

DISP_MATRIX:
	MOV R1, A
	MOV R0, #10h
	MOV A, #80h
	MOV P1, A
	CALL DISP_MATRIX_LOOP
	RET

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
GAME_STEP:
	anl	B, A
	mov 	A, B
	JZ	END
	MOV	A, R0
	MOV	@R0, B
	ADD	A, #01d
	MOV	R0, A
	MOV	A, #000h
	RET

END:
	JMP	END

