List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00

; task: x1x2 * y1y2 = z1z2z3z4
    #define x1 0x000
    #define x2 0x001
    #define y1 0x010
    #define y2 0x011

    #define z1 0x020
    #define z2 0x021
    #define z3 0x022
    #define z4 0x023
   
setup:
    CLRF z1
    CLRF z2
    CLRF z3
    CLRF z4

test_cases:
    ; test case 1, => 00, AD, 07, 07
;    MOVLW 0x12
;    MOVWF x1
;    MOVLW 0xCB
;    MOVWF x2
;
;    MOVLW 0x09
;    MOVWF y1
;    MOVLW 0x35
;    MOVWF y2

    ; test case 2, => 02, 02, A0, 6C
;    MOVLW 0x20
;    MOVWF x1
;    MOVLW 0x24
;    MOVWF x2
;
;    MOVLW 0x10
;    MOVWF y1
;    MOVLW 0x03
;    MOVWF y2

    ; test case 3, => 28, 59, F9, C8
    MOVLW 0x77
    MOVWF x1
    MOVLW 0x77
    MOVWF x2

    MOVLW 0x56
    MOVWF y1
    MOVLW 0x78
    MOVWF y2
main:
    ; z4 = low of x2 * y2
    MOVF x2, W
    MULWF y2

    MOVFF PRODL, z4 ; z4 += low of x2 * y2
    MOVFF PRODH, z3 ; z3 += high of x2 * y2

    ; z3 = low of x2 * y1 + low of x1 * y2 + high of x2 * y2
    MOVF x2, W
    MULWF y1

    MOVF PRODL, W
    ADDWF z3 ; z3 += low of x2 * y1
    MOVF PRODH, W
    ADDWFC z2 ; z2 += high of x2 * y1 + carry of z3

    ; z2 = high of x2 * y1 + high of x1 * y2 + low if x1 * y1 + carry of x2 * y1 + carry of x1 * y2
    MOVF x1, W
    MULWF y2

    MOVF PRODL, W
    ADDWF z3, F ; z3 += low of x1 * y2
    MOVF PRODH, W
    ADDWFC z2, F ; z2 += high of x1 * y2 + carry of z3


    ; z1 = high of x1 * y1
    MOVF x1, W
    MULWF y1

    MOVF PRODH, W
    ADDWFC z1 ; z1 += high of x1 * y1 + carry of z2
    MOVF PRODL, W
    ADDWFC z2 ; z2 += low of x1 * y1

    ; unknown
    MOVLW 0x00
    ADDWFC z1

end
