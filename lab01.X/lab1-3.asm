List p=18f4520
    #include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 

start:
    ; Initialize values
    MOVLW b'10000001' ; Load WREG with initial value (example input for [0x000])
    MOVWF 0x000       ; Store in [0x000]

    MOVLW 0x05        ; Load WREG with initial value (example input for [0x010])
    MOVWF 0x010       ; Store in [0x010]

    ; Store original value of [0x000] to compare later
    MOVF 0x000, W     ; Load [0x000] into WREG
    MOVWF 0x020       ; Store it in [0x020] (backup of original value)

loop_start:
    ; Check if [0x000] is a multiple of 4
    MOVF 0x000, W     ; Load [0x000] into WREG
    ANDLW b'00000011' ; Mask the last 2 bits (check if divisible by 4)
    CPFSEQ 0x030       ; Check if result is 0 (divisible by 4)
    GOTO check_div_2    ; If not, check if divisible by 2
    ; If divisible by 4
    INCF 0x010, F     ; Increment [0x010] by 1
    INCF 0x010, F     ; Increment [0x010] by another 1 (total +2)
    GOTO rotate_and_check

check_div_2:
    ; Check if [0x000] is a multiple of 2
    MOVF 0x000, W     ; Load [0x000] into WREG again
    ANDLW b'00000001' ; Mask the last bit (check if divisible by 2)
    CPFSEQ 0x030       ; Check if result is 0 (divisible by 2)
    GOTO subtract1    ; If not divisible by 2, subtract 1
    ; If divisible by 2
    INCF 0x010, F     ; Increment [0x010] by 1
    GOTO rotate_and_check

subtract1:
    ; If not divisible by 2 or 4, subtract 1 from [0x010]
    DECF 0x010, F     ; Decrement [0x010] by 1

rotate_and_check:
    ; Right rotate the value at [0x000]
    RRNCF 0x000, F    ; Right rotate [0x000]
    
    ; Compare rotated value with original value
    MOVF 0x000, W     ; Load the rotated value of [0x000] into WREG
    XORWF 0x020, W    ; Compare with the original value
    BZ loop_end        ; If they're the same, exit loop
    GOTO loop_start    ; Otherwise, repeat the loop

loop_end:

end
