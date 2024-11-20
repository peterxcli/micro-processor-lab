List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 
    
sub_16 macro xh, xl, yh, yl
    movff yl, WREG
    subwf xl, F
    movwf 0x01
    movff yh, WREG
    subwfb xh, F	
endm

    ; A/B
    #define AH 0x10
    #define AL 0x11
    #define BH 0x12
    #define BL 0x13
    #define QH 0x20
    #define QL 0x21
    #define R  0x22
    
    MOVLW 0x11
    MOVWF AH
    MOVLW 0x45
    MOVWF AL
    MOVLW 0x00
    MOVWF BH
    MOVLW 0x14
    MOVWF BL
    
    CLRF QH
    CLRF QL
    
    __div: ; do "substract b" till (AH, AL) less than (BH, BL)

    __div_loop:
	__sub:
	    sub_16 AH, AL, BH, BL

    __div_continue:
	__incr_q:
	    MOVLW 0x01	    
	    ADDWF QL
	    MOVLW 0x00
	    ADDWFC QH

	__check_continue:
	    MOVLW 0x00
	    CPFSGT AH; if AH > 0, skip, checklow
	    GOTO compare_low
	    GOTO __div_loop
	    
compare_low:
    MOVF BL, W
    SUBWF AL, W
    bc __div_loop
    bra finish
	    
finish:
    ; move (AH, AL) to (RH, RL)
    MOVFF AL, R
    end
