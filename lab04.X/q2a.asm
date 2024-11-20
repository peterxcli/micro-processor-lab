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
    MOVLB 0x3
    LFSR 0, 0x300

    MOVLW 0x65
    MOVWF POSTINC0
    MOVLW 0x06
    MOVWF POSTINC0
    MOVLW 0x03
    MOVWF POSTINC0
    MOVLW 0x65
    MOVWF POSTINC0
    MOVLW 0x0C
    MOVWF POSTINC0
    MOVLW 0x04
    MOVWF POSTINC0
    MOVLW 0xF7
    MOVWF POSTINC0
    MOVLW 0x32
    MOVWF POSTINC0
    MOVLW 0x50
    MOVWF POSTINC0
    MOVLW 0x00
    MOVWF POSTINC0
    
    MOVLW 0x06
    MOVWF head
    MOVLW 0x08
    MOVWF tail
    
    LFSR 0, 0x300 // base = 0
    LFSR 1, 0x300
    LFSR 2, 0x300
    
;    MOVFF head, WREG
;    MOVFF PLUSW0, WREG
;    LFSR 1, PLUSW0 // left pointer = base + head
;    MOVFF tail, WREG
;    LFSR 2, PLUSW0 // left pointer = base + head

for_init:
    ; calculate n = tail - head + 1
    MOVFF head, WREG
    SUBWF tail, W
    ADDLW 0x01
    
    MOVFF WREG, cnt
    
    ; if cnt = 1, go to finish
    MOVLW 0x01
    CPFSGT cnt
    GOTO finish
    
    MOVLW 0x00
    CPFSGT head
    GOTO for_loop_fsr2
    
for_loop_fsr1:
    MOVFF POSTINC1, WREG
    DECFSZ head
    GOTO for_loop_fsr1
    
for_loop_fsr2:
    MOVFF POSTINC2, WREG
    DECFSZ tail
    GOTO for_loop_fsr2
    
    ; cnt /= 2
    RRCF cnt
    
for_loop:
    swap INDF1, INDF2
    MOVFF POSTINC1, WREG
    MOVFF POSTDEC2, WREG
    
    DECFSZ cnt
    GOTO for_loop

finish:
end
