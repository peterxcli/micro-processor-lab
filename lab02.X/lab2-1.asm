List p=18f4520
    #include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 

setup1:
    ; Store 0x00 in [0x100]
    MOVLW 0x00
    MOVWF 0x100

    ; Store 0x01 in [0x116]
    MOVLW 0x01
    MOVWF 0x116

    LFSR 0, 0x100 ; FSR0 points to 0x100
    LFSR 1, 0x116 ; FSR1 points to 0x116

loop1:
    ; Check if INDF0 equals 0x106
    MOVLW 0x106
    CPFSEQ INDF0
    GOTO continue_loop
    GOTO loop1_end

continue_loop:
    ; Set [INDF0 + 1] = [INDF0] + [INDF1]
    MOVF POSTINC0, W ; Load [INDF0] into W and increment FSR0
    ADDWF INDF1, W ; Add [INDF1] to W
    MOVWF POSTINC0 ; Store result in [INDF0] and increment FSR0

    ; INDF0++ (already done by POSTINC0 above)

    ; Set [INDF1] = [INDF0] + [INDF1]
    MOVF INDF0, W ; Load [INDF0] into W
    ADDWF POSTDEC1, W ; Add [INDF1] to W
    MOVWF INDF1 ; Store result in [INDF1]
    
    ; INDF1-- (already done by POSTDEC1 above)

    GOTO loop1

loop1_end:

end
