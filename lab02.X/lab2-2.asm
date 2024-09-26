List p=18f4520
    #include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 


OUTER_COUNTER   EQU 0x300       ; Variable to store count of passes
INNER_COUNTER   EQU 0x301       ; Variable to store count of passes
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
    MOVWF OUTER_COUNTER      ; Store in COUNT (number of passes)

outer_loop:
    LFSR 0, 0x100; i
    LFSR 1, 0x101; j
    MOVLW OUTER_COUNTER
    MOVWF INNER_COUNTER
    DECFSZ INNER_COUNTER
    GOTO outer_loop_con
    GOTO end_sort

outer_loop_con:
    DECFSZ INNER_COUNTER
    GOTO inner_loop
    GOTO outer_loop

inner_loop:
    MOVF INDF0, W
    CPFSGT INDF1
    GOTO swap_elements

swap_elements:
    MOVF INDF0, W
    XORWF INDF1, W
    XORWF INDF1
    XORWF POSTINC1,W
    MOVWF POSTINC0

    GOTO outer_loop_con

end_inner_loop:
    ADDWF POSTINC0, W ; i++
    ADDWF POSTINC1, W ; j++

    GOTO outer_loop_con

end_sort:

end
