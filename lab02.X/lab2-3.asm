List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 ;PC = 0x00
    
setup:
    MOVLW 0xFE
    MOVWF 0x09
    
    MOVLW 0x00
    MOVWF 0x11
    
    MOVLW 0x7F
    MOVWF 0x16
    
    LFSR 0, 0x000
    
    MOVLW 0x28
    MOVWF POSTINC0 
    MOVLW 0x34
    MOVWF POSTINC0 
    MOVLW 0x7A
    MOVWF POSTINC0 
    MOVLW 0x80
    MOVWF POSTINC0 
    MOVLW 0xA7
    MOVWF POSTINC0 
    MOVLW 0xD1
    MOVWF POSTINC0 
    MOVLW 0xFE
    MOVWF POSTINC0 
    
    MOVLW 0x10
    
    LFSR 0, 0x000; l
    LFSR 1, 0x006; r
    LFSR 2, 0x003; mid

    
main:
    MOVF FSR0L,W
    CPFSLT FSR1L
    GOTO checker
    GOTO finish
    

checker:
    MOVFf INDF2, 0x22
    MOVF INDF2,w
    CPFSEQ 0x09
    GOTO not_found
    GOTO found
    
    
not_found:
    MOVF INDF2,w
    CPFSGT 0x09
    GOTO left
    GOTO right

right:
    INCF FSR2L
    MOVFf FSR2L,FSR0L
    MOVF  FSR0L,W
    addwf FSR1L,W
    
    GOTO divide
    
 left:
    DECF FSR2L
    MOVFf FSR2L,FSR1L
    MOVF  FSR0L,W
    addwf FSR2L,W
    
    GOTO divide
    
divide:
    RRNCF WREG
    ANDWF 0x16, w
    MOVWF 0x18
    
    MOVWF FSR2L
    GOTO main
  
found:
    MOVLW 0xFF 
    MOVWF 0x11
finish:
    
end
