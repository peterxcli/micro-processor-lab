List p=18f4520
    #include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 

init:
    LFSR 0, 0x100
    
    MOVLW 0x08
    MOVWF POSTINC0 
    MOVLW 0x7C
    MOVWF POSTINC0 
    MOVLW 0x78 
    MOVWF POSTINC0 
    MOVLW 0xFE
    MOVWF POSTINC0 
    MOVLW 0x34 
    MOVWF POSTINC0 
    MOVLW 0x7A 
    MOVWF POSTINC0 
    MOVLW 0x0D
    MOVWF POSTINC0 

    ; Begin the sorting process
    MOVLW 0x07       ; Load the number of elements - 1 (for bubble sort)
    MOVWF 0x300      ; Store in COUNT (number of passes)

main:
    LFSR 0, 0x100; j
    LFSR 1, 0x101; j + 1
    MOVLW 0x300
    MOVWF 0x301
    DECFSZ 0x300
    GOTO outer_loop
    GOTO end_sort

outer_loop:
    DECFSZ 0x301
    GOTO inner_loop
    GOTO main

inner_loop:
    MOVF INDF0, W
    CPFSGT INDF1
    GOTO swap_elements
    GOTO end_inner_loop

swap_elements:
    XORWF INDF1, W
    XORWF INDF1
    XORWF POSTINC1,W
    MOVWF POSTINC0

    GOTO outer_loop

end_inner_loop:
    ADDWF POSTINC0, W ; i++
    ADDWF POSTINC1, W ; j++

    GOTO outer_loop

end_sort:

end
