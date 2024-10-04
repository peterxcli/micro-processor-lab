List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00

; task: get floor(log_2(x))
    #define x1 0x000
    #define x2 0x001

    #define bit_count 0x010
    #define temp 0x011
    #define result 0x002
setup:
    CLRF TRISA
    CLRF STATUS
    CLRF bit_count
    CLRF result
    CLRF x1
    CLRF x2
    CLRF temp

test_cases:
    ; test case 1, => 0x06
;    MOVLW 0x00
;    MOVWF x1
;    MOVLW 0x40
;    MOVWF x2

    ; test case 2, => 0x07
;     MOVLW 0x00
;     MOVWF x1
;     MOVLW 0x41
;     MOVWF x2

    ; test case 3, => 0x0E
;     MOVLW 0x2A
;     MOVWF x1
;     MOVLW 0x41
;     MOVWF x2

    ; test case 4, => 0x01
;     MOVLW 0x00
;     MOVWF x1
;     MOVLW 0x02
;     MOVWF x2

; test case 5, => 0x10
     MOVLW 0xFF
     MOVWF x1
     MOVLW 0xF1
     MOVWF x2

; x1, x2 are 16-bit numbers
; use loop to continous shift right, 
main:
    GOTO check_x1_zero

loop:
    ; if last bit of x2 is 1, then add 1 to bit_count
    BTFSC x2, 0
    INCF bit_count

    ; shift x1 and x2 right
    RRCF x1
    RRCF x2

    ; if x1 is 0, then end loop
    INCF result
    GOTO check_x1_zero
    NOP

check_x1_zero:
    TSTFSZ x1
    GOTO loop
    GOTO check_x2_zero

check_x2_zero:
    TSTFSZ x2
    GOTO loop
    GOTO end_loop

end_loop:
    ; if bit_count is 1, then subtract 1 from result
    MOVLW 0x01
    MOVWF temp
    MOVF bit_count, W
    CPFSEQ temp
    GOTO end_of_program
    DECF result

end_of_program:
    NOP

end
