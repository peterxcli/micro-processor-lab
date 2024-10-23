#include "xc.inc"
GLOBAL _mygcd
PSECT mytest,local,class=CODE,reloc=2

_swap macro aa_l, aa_h, bb_l, bb_h
    MOVFF aa_l, WREG
    MOVFF bb_l, aa_l
    MOVFF WREG, bb_l
    MOVFF aa_h, WREG
    MOVFF bb_h, aa_h
    MOVFF WREG, bb_h
    ENDM 

#define al 0x020
#define ah 0x021
#define bl 0x022
#define bh 0x023

_mygcd:
    movff 0x01, al
    movff 0x02, ah
    movff 0x03, bl
    movff 0x04, bh

gcd_loop:
    MOVF bl, W
    IORWF bh, W
    BZ end_gcd
    
    MOVF bh, W
    SUBWF ah, W
    BC a_b_greater
    BRA swap_a_b

a_b_greater:
    btfsc STATUS,2
    GOTO compare_low ; if ah == bh, compare low
    GOTO proceed_division

compare_low:
    MOVF bl,W
    SUBWF al, W
    BC proceed_division
    BRA swap_a_b

proceed_division:
    MOVFF al, 0x024
    MOVFF ah, 0x025

subtract_b:
    MOVF bl, W
    SUBWF 0x024, F
    MOVF bh, W
    SUBWFB 0x025, F
    ;check if temp>=b
    MOVF bh, W
    SUBWF 0x025, W
    BC continue_subtract
    BRA division_done

continue_subtract:
    BTFSC STATUS, 2
    GOTO check_temp_low
    BRA subtract_b

check_temp_low:
    MOVF bl, W
    SUBWF 0x024, W
    BC subtract_b
    BRA division_done

division_done:
    ; Now, a = b, b = temp
    MOVFF bl, al
    MOVFF bh, ah
    MOVFF 0x024, bl  ; b = temp
    MOVFF 0x025, bh
    BRA gcd_loop

swap_a_b:
    ; Swap a and b
    MOVFF al, 0x024
    MOVFF ah, 0x025
    MOVFF bl, al
    MOVFF bh, ah
    BRA gcd_loop

end_gcd:
	MOVFF al, 0x001
	MOVFF ah, 0x002
	RETURN
