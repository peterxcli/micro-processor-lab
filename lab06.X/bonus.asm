LIST p=18f4520
#include<pic18f4520.inc>

    CONFIG OSC = INTIO67 ; Set internal oscillator to 1 MHz
    CONFIG WDT = OFF     ; Disable Watchdog Timer
    CONFIG LVP = OFF     ; Disable Low Voltage Programming

    L1 EQU 0x14         ; Define L1 memory location
    L2 EQU 0x15         ; Define L2 memory location
    cnt EQU 0x20
    org 0x00            ; Set program start address to 0x00

; instrustion frequency = 1 MHz / 4 = 0.25 MHz
; instruction time = 1/0.25 = 4 mu s
; Total_cycles = 2 + (2 + 8 * num1 + 3) * num2 cycles
; num1 = 111, num2 = 70, Total_cycles = 62512 cycles	
; Total_delay ~= Total_cycles * instruction time = 0.25 s

MOVLF macro literal, FileReg
    MOVLW literal
    MOVWF FileReg
endm


DELAY macro num1, num2
    local LOOP1         ; Inner loop
    local LOOP2         ; Outer loop
    
    ; 2 cycles
    MOVLW num2          ; Load num2 into WREG
    MOVWF L2            ; Store WREG value into L2
    
    ; Total_cycles for LOOP2 = 2 cycles 
    LOOP2:
        MOVLW num1
        MOVWF L1
    
    ; Total_cycles for LOOP1 = 8 cycles
    LOOP1:
        BTFSS PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
        BRA button_click
        NOP                 ; busy waiting
        NOP
        NOP
        DECFSZ L1, 1
        BRA LOOP1           ; BRA instruction spends 2 cycles

        ; 3 cycles
        DECFSZ L2, 1        ; Decrement L2, skip if zero
        BRA LOOP2
endm
    
start:
int:
; let pin can receive digital signal
    MOVLW 0x0f          ; Set ADCON1 register for digital mode
    MOVWF ADCON1        ; Store WREG value into ADCON1 register
    CLRF PORTB          ; Clear PORTB
    BSF TRISB, 0        ; Set RB0 as input (TRISB = 0000 0001)
    CLRF LATA           ; Clear LATA
    BCF TRISA, 0        ; Set RA0 as output (TRISA = 0000 0000)
    BCF TRISA, 1        ; Set RA1 as output (TRISA = 0000 0000)
    BCF TRISA, 2        ; Set RA2 as output (TRISA = 0000 0000)
    CLRF cnt           ; Clear entire cnt register (instead of BCF cnt, 0)
    
; Button check
main:
    BTFSS PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
    GOTO button_click
    GOTO main
    

check_state_1:
    MOVLW 0x01         ; Load 1 into W
    CPFSEQ cnt       ; Compare state with 1, skip if equal
    BRA check_state_2  ; If not equal, check for state 2
    BRA state_1        ; If equal, go to state 1

check_state_2:
    MOVLW 0x02         ; Load 2 into W
    CPFSEQ cnt       ; Compare state with 2, skip if equal
    BRA check_state_3  ; If not equal, check for state 3
    BRA state_2        ; If equal, go to state 2
    
check_state_3:
    MOVLW 0x03         ; Load 3 into W
    CPFSEQ cnt         ; Compare state with 3, skip if equal
    BRA main           ; If not equal, go back to main (instead of state_1)
    CLRF cnt           ; Clear state (set to 0)
    BRA state_0        ; Go to state_0

button_click:
    DELAY 111, 70
    INCF cnt, 1; state++

    ; if cnt == 1
        ; GOTO state_1
    ; if cnt == 2
        ; GOTO state_2
    ;if cnt == 3
        ; set cnt = 0
        ; GOTO state_0
    MOVLW 0x00         ; Load 1 into W
    CPFSEQ cnt       ; Compare state with 1, skip if equal
    BRA check_state_1  ; If not equal, check for state 2
    BRA state_0        ; If equal, go to state 1

state_1:
    MOVLF 0b00000001, LATA
    DELAY 200, 117 // delay 0.5
    BTFSS PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
    BRA button_click

    MOVLF 0b00000010, LATA
    DELAY 200, 117 // delay 0.5
    BTFSS PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
    BRA button_click

    MOVLF 0b00000100, LATA
    DELAY 200, 117 // delay 0.5
    BTFSS PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
    BRA button_click

    GOTO state_1

state_2:
    MOVLF 0b00000001, LATA
    DELAY 200, 200 // delay 1
    BTFSS PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
    BRA button_click

    MOVLF 0b00000011, LATA
    DELAY 200, 200 // delay 1
    BTFSS PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
    BRA button_click

    GOTO state_2_3

state_2_3:
    MOVLF 0b00000100, LATA
    DELAY 200, 117 // delay 0.5
    BTFSS PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
    BRA button_click

    MOVLF 0b00000000, LATA
    DELAY 200, 117 // delay 0.5
    BTFSS PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
    BRA button_click

    MOVLF 0b00000100, LATA
    DELAY 200, 117 // delay 0.5
    BTFSS PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
    BRA button_click

    MOVLF 0b00000000, LATA
    DELAY 200, 117 // delay 0.5
    BTFSS PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
    BRA button_click

    MOVLF 0b00000100, LATA
    DELAY 200, 117 // delay 0.5
    BTFSS PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
    BRA button_click

    GOTO state_2

state_0:
    MOVLW 0
    MOVWF LATA
    
    GOTO main
end
