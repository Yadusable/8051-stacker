START:
	MOV	R0, #000h
	MOV	B, #0ffh

	CALL	INS3
	CALL	CNP

;--- INSERT 3x1 INTO A ---
INS3:
	ORL	A, #01d
	RL	A
	ORL	A, #01d
	RL	A
	ORL	A, #01d
	RET

;--- INSERT 2x1 INTO A ---
INS2:
	ORL	A, #01d
	RL	A
	ORL	A, #01d
	RET

;--- INSERT 1x1 INTO A ---
INS1:
	ORL	A, #01d
	RET

;--- CLICK AND PLACE ---
CNP:
	RL	A
	RL	A
	RL	A
	RL	A
	call	PREPREG
	;jmp	CNP


;--- PREPARE REGISTERS FOR NEXT LEVEL ---
;
;
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
