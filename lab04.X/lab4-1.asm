List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 

    #define XH 0x20
    #define XL 0x21
    #define YH 0x22
    #define YL 0x23
    
    sub_mul macro xh, xl, yh, yl
        movff yl, WREG
        subwf xl, W
        movwf 0x01
        movff yh, WREG
        subwfb xh, W
        movwf 0x00
        movff 0x00, WREG
        mulwf 0x01
        movff PRODH, 0x02
        movff PRODL, 0x03
	
	endm
	
    movlw 0x03
    movwf XH
    movlw 0xA5
    movwf XL
    movlw 0x02
    movwf YH
    movlw 0xA7
    movwf YL
    
    sub_mul XH, XL, YH, YL
    
finish:
    end
