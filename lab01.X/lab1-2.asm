List p=18f4520
    #include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 
    
start:
    ; Step 1: Initialize values in [0x000] and [0x001]
    MOVLW 0xFF       ; Load 0xFF
    MOVWF 0x000      ; Store it in [0x000]

    MOVLW 0x1E       ; Load 0x1E
    MOVWF 0x001      ; Store it in [0x001]

    ; Step 2: Combine the first 4 bits of [0x000] with the last 4 bits of [0x001]
    MOVF 0x000, W    ; Load [0x000] into WREG
    ANDLW b'11110000'; Mask upper 4 bits
    MOVWF 0x004      ; Store the result in tmp [0x004]

    MOVF 0x001, W    ; Load [0x001] into WREG
    ANDLW b'00001111'; Mask lower 4 bits

    ADDWF 0x004, W   ; Combine the nibbles
    MOVWF 0x002      ; Store the result in [0x002]

    ; Step 3: Count the number of 0 bits in the value at [0x002]
    CLRF 0x003       ; Clear the counter at [0x003]

    MOVF 0x002, W    ; Load [0x002] into WREG
    MOVWF 0x004      ; Store it into tmp [0x004]

    CLRF WREG        ; Clear WREG
    MOVLW D'0'       ; Initialize counter to 0
    MOVWF 0x005      ; Store in [0x005]

count_zeros:
    BTFSS 0x004, 0   ; Check if bit 0 is 1 (if 1, skip next)
    INCF 0x003, F    ; If bit 0 is 0, increment the counter
    RRNCF 0x004, F   ; Right shift [0x004] to check the next bit
    INCF 0x005, F    ; Increment the bit counter

    MOVLW D'8'       ; We want to check all 8 bits
    CPFSEQ 0x005     ; Compare [0x005] to 8
    GOTO count_zeros ; If not all bits are checked, loop again

end:

end
