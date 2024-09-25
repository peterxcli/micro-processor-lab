List p=18f4520
    #include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 

setup1
    ; Store 0x00 in [0x100]
    MOVLW 0x00
    MOVWF 0x100

    ; Store 0x01 in [0x116]
    MOVLW 0x01
    MOVWF 0x116

    LFSR 0, 0x101 ; FSR0 point to 0x10
    LFSR 1, 0x115

start:
    ; Use at least one type of indirect addressing

loop1:
    ; until INDF0 equal to 0x106, GOTO loop1_end

    ; In each loop:
    ; set [INDF0] = [INDF0-1] + [INDF1+1], 100, 116
    ; set [INDF1] = [INDF0] + [INDF1+1], 101, 116
    ; then INDF0++
    ; then INDF1--
    

loop1_end:

end
