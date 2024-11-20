List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
#define temp1 0x20
#define temp2 0x21

;arithmetic_right_shift
ars macro src, dest
    BCF STATUS, 0
    MOVFF src, dest
    RRCF dest
    ; if bit 7 is 1, then set bit 0 to 1
    BTFSC dest, 6
    BSF dest, 7
    BTFSS dest, 6
    BCF dest, 7
    NOP

endm
    
;spilt_and_multi
sam macro src, dest
    MOVFF src, WREG
    ANDLW 0b00001111
    MOVFF WREG, 0x20
    MOVFF src, WREG
    ANDLW 0b11110000
    MOVFF WREG, 0x21
    BCF STATUS, 0
    RRCF 0x21
    RRCF 0x21
    RRCF 0x21
    RRCF 0x21

    
    MOVFF 0x20, WREG
    MULWF 0x21
    
    MOVFF PRODL, dest
    NOP
endm
     
    MOVLW 0x5F
    MOVWF 0x00
    
    MOVFF 0x00, 0x01
    BCF STATUS, 0
    RLCF 0x01
    BCF STATUS, 0
    RLCF 0x01

    ars 0x01, 0x02
    ars 0x02, 0x02
    ars 0x02, 0x02
   
    MOVFF 0x02, 0x03
    BCF STATUS, 0
    RLCF 0x03
    BCF STATUS, 0
    RLCF 0x03
    
    sam 0x01, 0x11
    sam 0x02, 0x12
    sam 0x03, 0x13

end
