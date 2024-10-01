List p=18f4520
    #include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 

setup1:
    ; Set Bank 1
    MOVLB 0x1

    ; Store 0x00 in [0x100]
    MOVLW 0x01
    MOVWF 0x00, 1

    ; Store 0x01 in [0x116]
    MOVLW 0x00
    MOVWF 0x16, 1

    LFSR 0, 0x100 ; FSR0 points to 0x100
    LFSR 1, 0x116 ; FSR1 points to 0x116

    ; Initialize loop counter
    MOVLW 0x06
    MOVWF 0x00

loop1:
    ; Set [INDF0 + 1] = [INDF0] + [INDF1]
    MOVF POSTINC0, W ; Load [INDF0] into W and increment FSR0
    ADDWF INDF1, W ; Add [INDF1] to W
    MOVWF INDF0 ; Store result in [INDF0] and increment FSR0

    ; INDF0++ (already done by POSTINC0 above)

    ; Set [INDF1] = [INDF0] + [INDF1]
    MOVF INDF0, W ; Load [INDF0] into W
    ADDWF POSTDEC1, W ; Add [INDF1] to W
    MOVWF INDF1 ; Store result in [INDF1]
    
    ; INDF1-- (already done by POSTDEC1 above)

    ; Decrement loop counter
    DECFSZ 0x000
    GOTO loop1

end
