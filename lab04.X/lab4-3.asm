List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 

    #define N 0x20
    #define ah 0x21
    #define al 0x22
    #define bh 0x23
    #define bl 0x24
    #define ch 0x00
    #define cl 0x01
    

	
setup:
    MOVLW 0x01
    MOVWF N
    MOVLW 0x00
    MOVWF al
    MOVLW 0x00
    MOVWF ah
    MOVLW 0x00
    MOVWF bh
    MOVLW 0x01
    MOVWF bl
    MOVLW 0x00
    MOVWF ch
    MOVLW 0x01
    MOVWF cl

    ; Edge case: N = 0
    MOVLW 0x00
    CPFSGT N
    goto n_0

    ; N--
    DECFSZ N, F
    rcall fib
    goto finish

n_0:
    MOVLW 0x00
    MOVWF ch
    MOVLW 0x00
    MOVWF cl
    goto finish


fib:
    ; c = a + b = f(n) = f(n-2) + f(n-1)
    MOVFF al, WREG
    ADDWF bl, W
    MOVFF WREG, cl
    MOVFF ah, WREG
    ADDWFC bh, W
    MOVFF WREG, ch

    ; a = b , f(n-2) = f(n-1)
    MOVFF bh, ah
    MOVFF bl, al

    ; b = c , f(n-1) = f(n)
    MOVFF ch, bh
    MOVFF cl, bl

    DECFSZ N, F
    rcall fib
    return

finish:
    end
