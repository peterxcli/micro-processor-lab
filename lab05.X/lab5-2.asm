#include"xc.inc"
GLOBAL _mygcd
PSECT mytext,local,class=CODE,reloc=2

#define al 0x020
#define ah 0x021
#define bl 0x022
#define bh 0x023

_mygcd:
    movff 0x001, al
    movff 0x002, ah
    movff 0x003, bl
    movff 0x004, bh

gcd_loop:
    MOVF bl,W
    iorwf bh,W
    bz end_gcd
    
    movf bh,W
    subwf ah,W
    bc a_b_greater
    bra swap_a_b

a_b_greater:
    btfsc STATUS,2
    goto compare_low
    goto proceed_division

compare_low:
    movf bl,W
    subwf al,W
    bc proceed_division
    bra swap_a_b

proceed_division:
    movff al,0x024
    movff ah,0x025

subtract_b:
    movf bl, W
    subwf 0x024, F
    movf bh, W
    subwfb 0x025, F
    //check if temp>=b
    movf bh, W
    subwf 0x025, W
    bc continue_subtract
    bra division_done

continue_subtract:
    btfsc STATUS, 2
    goto check_temp_low
    bra subtract_b

check_temp_low:
    movf    bl, W
    subwf   0x024, W
    bc     subtract_b
    bra     division_done

division_done:
    ; Now, a = b, b = temp
    movff   bl, al    ; a = b
    movff   bh, ah
    movff   0x024, bl  ; b = temp
    movff   0x025, bh
    bra     gcd_loop

swap_a_b:
    ; Swap a and b
    movff   al, 0x024
    movff   ah, 0x025
    movff   bl, al
    movff   bh, ah
    movff   0x024, bl
    movff   0x025, bh
    bra     gcd_loop

end_gcd:
	movff al, 0x001
	movff ah,0x002
	RETURN
