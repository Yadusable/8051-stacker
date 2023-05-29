; --- INFO ---
; To start the game, first load the keyboard and matrix configuration files
;
; Keyboard port: P2
; Matrix port: P0, P1

START:
	MOV	P0, P1		; initialize P0 and P1
	MOV	R0, #010h	;R0 is the layer counter, 0x10=lowest
	MOV	B, #0ffh	;all positions are valid for first layer
	MOV	R2, #128d	;R2 is the round counter, 0001 0000 = 4. round

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
	JNB	P2.0, ONCLICK_1
	CALL	DISP_MATRIX
	CALL 	DISP_HEAD
	JMP	CYCLE

PRESS:				; when button released, execute game logic
	JB	P2.0, ONCLICK_2
	CALL	DISP_MATRIX
	CALL 	DISP_HEAD
	JMP	PRESS


; --- ON CLICK LOGIC ---
ONCLICK_1:			; jump in PRESS loop
	CALL 	DISP_HEAD
	JMP	PRESS

ONCLICK_2:			; call gamelogic
	CALL 	DISP_HEAD
	CALL	GAME_STEP
	RET

; --- DISPLAY DRIVING LOGIC ---
DISP_MATRIX:
	MOV 	P0, #00h
	MOV	R7, A
	MOV	R1, #10h
	MOV	A, #80h
	MOV	P1, A
	CALL	DISP_MATRIX_LOOP
	RET

DISP_MATRIX_LOOP:
	MOV	P0, @R1
	MOV	P1, A
	INC	R1
	RR	A
	CJNE	@R1, #00h, DISP_MATRIX_LOOP
	MOV	A, R7
	CALL 	DISP_HEAD
	RET

DISP_HEAD:
	MOV 	P0, #00h
	MOV 	P1, R2
	MOV 	P0, A
	RET

; --- PREPARE REGISTERS FOR NEXT LEVEL ---
GAME_STEP:
	; Calculate new row
	ANL	B, A
	MOV	A, B
	; Check loss condotion
	JZ	END
	; store old layer
	MOV	A, R0
	MOV	@R0, B
	; Increment Round counter in 0x00 by one
	ADD	A, #01d
	MOV	R0, A
	; Right-rotate R2
	MOV	A, R2
	RR	A
	MOV	R2, A
	; Reset A to #000h
	MOV	A, #000h
	; Return
	RET

END:
	JMP	END

