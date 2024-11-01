#include "xc.inc"
GLOBAL _multi_signed
PSECT mytest,local,class=CODE,reloc=2

#define in_a 0x01
#define in_b 0x03
#define n 0x20

_multi_signed:
    ; 8-bit signed integer 'a'
    ; 4-bit signed integer 'b'
    ; The output will be a 16-bit result. The result should be stored in an unsigned integer variable

    CLRF 0x05 ; a sign; 0 = positive, 1 = negative
    CLRF 0x10 ; result sign, 0 = positive, 1 = negative

    ; check if b is 0
    TSTFSZ in_b
    GOTO __input
    GOTO __b_zero_finish
    
    __b_zero_finish:
	CLRF in_a
	RETURN

    __input:
        MOVFF in_a, in_b
        MOVFF WREG, in_a

    __check_sign_a:
        BTFSC in_a, 7 ; check if a is negative
	    GOTO __mark_a_negative ; if negative, mark as negative
        GOTO __check_sign_b ; if positive, check b

    __mark_a_negative:
	    NEGF in_a ; make a = -a
        INCF 0x05

    __check_sign_b:
        BTFSC in_b, 7 ; check if b is negative
        GOTO __mark_b_negative ; if negative, mark as negative
        GOTO __mark_b_positive ; if positive, mark as positive

    __mark_b_positive:
        TSTFSZ 0x05 ; skip if a = 0 ( a is positive )
        GOTO __mark_result_negative ; if a is positive, mark result as negative
        GOTO __mark_result_positive ; if a is zero, mark result as positive

    __mark_b_negative:
	    NEGF in_b ; make b = -b

        TSTFSZ 0x05 ; skip if a = 0 ( a is positive )
        GOTO __mark_result_positive ; if a is positive, mark result as positive
        GOTO __mark_result_negative ; if a is zero, mark result as negative

    __mark_result_positive:
        GOTO __multiply

    __mark_result_negative:
        INCF 0x10 ; result is negative
        GOTO __multiply

    __multiply: ; do "add a" b times
        MOVFF in_b, n ; temp n 
        MOVFF in_a, 0x21 ; copy of 0x01
        DECF n ; temp n --

    __multiply_loop:
        MOVFF 0x21, WREG
        ADDWF 0x01
        BTFSC STATUS, 0
        INCF 0x02 ; increase high byte of result(0x02) if carry

    __multiply_continue:
        DECFSZ n, 1, 1
        GOTO __multiply_loop

        ; check result neg, pos
        TSTFSZ 0x10
        GOTO __toggle_result_negative
	    GOTO __finish

    __toggle_result_negative:
	    COMF 0x01
	    COMF 0x02

	    ; increase high byte of result(0x02) if carry
	    INCF 0x01
        BTFSC STATUS, 0
        INCF 0x02

    __finish:
	    RETURN
