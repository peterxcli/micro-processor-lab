List p=18f4520
    #include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 

    outer_count equ 0x300
    inner_count equ 0x301

init:
    LFSR 0, 0x100
    
    MOVLW 0xFF
    MOVWF POSTINC0 
    MOVLW 0xFE
    MOVWF POSTINC0 
    MOVLW 0xFD
    MOVWF POSTINC0 
    MOVLW 0xFC
    MOVWF POSTINC0 
    MOVLW 0xFB 
    MOVWF POSTINC0 
    MOVLW 0xFA 
    MOVWF POSTINC0 
    MOVLW 0xF9
    MOVWF POSTINC0 

    MOVLW 0x07       ; Load the number of elements - 1 (for bubble sort)
    MOVWF outer_count      ; Store in COUNT (number of passes)

main:
    LFSR 0, 0x100; j
    LFSR 1, 0x101; j + 1
    MOVLW 0x00
    ADDWF outer_count,w
    MOVWF inner_count
    DECFSZ outer_count
    GOTO outer_loop
    GOTO end_sort

outer_loop:
    DECFSZ inner_count
    GOTO inner_loop
    GOTO main

inner_loop:
    MOVLW 0x00
    ADDWF INDF0,w
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
