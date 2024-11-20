List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00

setup:
    CLRF TRISA

test_cases:
	; test case 1
;	MOVLW 0x5F
;	MOVWF TRISA

	; ; test case 2
;	 MOVLW 0x49
;	 MOVWF TRISA

	; ; test case 3
;	 MOVLW 0x93
;	 MOVWF TRISA

	; ; test case 4
	 MOVLW 0xC8
	 MOVWF TRISA

logical_right_shift:
    RLCF TRISA

arithmetic_right_shift:
    RRCF TRISA
    ; if bit 7 is 1, then set bit 0 to 1
    BTFSC TRISA, 6
    BSF TRISA, 7
    BTFSS TRISA, 6
    BCF TRISA, 7
    NOP

end
