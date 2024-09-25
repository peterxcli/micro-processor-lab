List p=18f4520
    #include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 
    
    MOVLW 0x01; WREG := A
    MOVWF 0x000 ; [0X000] := WREG 
   
    MOVLW 0x02; WREG := B
    MOVWF 0x001 ; [0x001] := B
    
    ADDWF 0x000, W; ; [WREG] := A + B
    MOVWF 0x002; [0x002] := WREG (A1)
    
    MOVLW 0x04    ; WREG := C
    MOVWF 0x010   ; [0x010] := WREF

    MOVLW 0x03 ; WREG := D
    MOVWF 0x011 ; [0x011] := WREG 

    MOVF 0x011, W ; WREG := D 
    SUBWF 0x010, W ; WREG := WREG - C (D - C)
    MOVWF 0x012; A2 := WREG
    
 CPFSEQ 0x002 ; if WREG == A1, skip next line
    GOTO greater
    MOVLW 0xBB; A1 == A2, DO [0x020] := 0xAA 
    MOVWF 0x020
    GOTO final

greater: ; check if A1 > A2
    CPFSGT 0x002; if A1 > A2, skip next line
    GOTO less
    MOVLW 0xAA; A1 > A2, DO [0x020] := 0xAA
    MOVWF 0x020
    GOTO final

less: ; check if A1 < A2
    MOVLW 0xCC ; A1 < A2, DO [0x020] := 0xCC 
    MOVWF 0x020

final:
    
end
