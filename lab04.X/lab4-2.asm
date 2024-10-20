List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 

    #define A1 0x10
    #define A2 0x11
    #define A3 0x12
    #define B1 0x13
    #define B2 0x14
    #define B3 0x15
    #define C1 0x20
    #define C2 0x21
    #define C3 0x22
    #define tmp1 0x16
    #define tmp2 0x17
    
main:
    movlw 0x01
    movwf A1
    movlw 0x03
    movwf A2
    movlw 0x06
    movwf A3
    movlw 0x02
    movwf B1
    movlw 0x03
    movwf B2
    movlw 0x05
    movwf B3
    
    rcall cross
    goto finish

cross:
        ; Store the cross product of a and b in to c1 (0x020), c2 (0x021), c3 (0x022)
        ; C1 = a2 * b3 - a3 * b2
        MOVFF A2, WREG
        MULWF B3
        MOVFF PRODL, tmp1
        MOVFF A3, WREG
        MULWF B2
        MOVFF PRODL, tmp2

        MOVFF tmp2, WREG
        SUBWF tmp1, W
        MOVFF WREG, C1

        ; C2 = a3 * b1 - a1 * b3
        MOVFF A3, WREG
        MULWF B1
        MOVFF PRODL, tmp1
        MOVFF A1, WREG
        MULWF B3
        MOVFF PRODL, tmp2

        MOVFF tmp2, WREG
        SUBWF tmp1, W
        MOVFF WREG, C2

        ; C3 = a1 * b2 - a2 * b1
        MOVFF A1, WREG
        MULWF B2
        MOVFF PRODL, tmp1
        MOVFF A2, WREG
        MULWF B1
        MOVFF PRODL, tmp2

        MOVFF tmp2, WREG
        SUBWF tmp1, W
        MOVFF WREG, C3

    return

    
finish:
    end
