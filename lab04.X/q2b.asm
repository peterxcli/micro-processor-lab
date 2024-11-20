List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00

#define head 0x320
#define tail 0x321
#define cnt 0x322
#define temp 0x323
 
swap macro p1, p2
    MOVFF p1, temp
    MOVFF p2, p1
    MOVFF temp, p2
    NOP
endm
 
setup:
    LFSR 0, 0x300

    MOVLW 0x08
    MOVWF 0x20
    MOVLW 0x09
    MOVWF 0x21
    MOVLW 0x02
    MOVWF 0x22

    MOVLW 0x02
    MOVWF 0x30
    MOVLW 0x03
    MOVWF 0x31
    MOVLW 0x04
    MOVWF 0x32
    
    ; 1-1
    
    

finish:
end
