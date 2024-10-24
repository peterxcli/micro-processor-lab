#include <xc.inc>

PSECT mytext,local,class=CODE,reloc=2

GLOBAL _mysqrt

_mysqrt:
    ; parameter from WREG, assume input in WREG, store it in 0x020
    MOVFF   WREG, 0x020        ; Save input into 0x020

    CLRF    0x021              ; Clear register for result (sqrt)
    CLRF    0x022              ; Temporary variable for comparison

sqrt_loop:
    INCF    0x021, F           ; Increment potential sqrt value
    MOVFF   0x021, WREG        ; Move sqrt candidate to WREG
    MULWF   0x021              ; Square the value (WREG * WREG)
    MOVFF   PRODH, 0x022       ; Get the higher byte of the result into 0x022
    MOVFF   PRODL, WREG        ; Get the lower byte of the result into WREG

    ; check if overflow
    __check_overflow:
        TSTFSZ 0x022
        GOTO sqrt_done
        GOTO __subtract_input

    __subtract_input:
        SUBWF   0x020, W        ; Subtract input value from the square

        BNC     sqrt_done          ; If the square is greater than input, stop

        BRA     sqrt_loop          ; Otherwise, continue incrementing sqrt candidate

sqrt_done:
    DECF    0x021, F           ; Decrement by 1
    MOVFF   0x021, WREG        ; Move decremented value to WREG
    MULWF   0x021              ; Square the value (WREG * WREG)
    MOVFF   PRODH, 0x024       ; Get the higher byte of the result into 0x024
    MOVFF   PRODL, WREG        ; Get the lower byte of the result into WREG
    CPFSEQ  0x020              ; Compare with input value, skip if equal
    INCF    0x021, F           ; Adjust back to the correct integer sqrt value
    MOVFF   0x021, WREG        ; Move result back to WREG
    RETURN
