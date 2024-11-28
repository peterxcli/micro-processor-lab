#include <xc.h>
#include <pic18f4520.h>
#define _XTAL_FREQ 1000000

#pragma config OSC = INTIO67    // Oscillator Selection bits
#pragma config WDT = OFF        // Watchdog Timer Enable bit 
#pragma config PWRT = OFF       // Power-up Enable bit
#pragma config BOREN = ON       // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF        // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF        // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)

/*
Pulse Width: 500 ~ 2400 µs (-90° ~ 90°, 1450 µs ? 0°)

-90°:  500 µs ? 0x04, 0b00
  0°: 1450 µs ? 0x0b, 0b01
 90°: 2400 µs ? 0x13, 0b11

*/

void turn_with_delay_clockwise(){
    __delay_ms(3);
    if(CCP1CONbits.DC1B == 0b11){ // carry
        CCP1CONbits.DC1B =0b0;
        CCPR1L++;
    }else{
        CCP1CONbits.DC1B++ ;
    }
}

void turn_with_delay_counter_clockwise(){
//    __delay_ms(5);
    if(CCP1CONbits.DC1B == 0b0){
        CCP1CONbits.DC1B =0b11;
        CCPR1L--;
    }else{
        CCP1CONbits.DC1B-- ;
    }
}

int get_current_angle(){
    if(CCPR1L == 0x04&&CCP1CONbits.DC1B == 0b00){
        return -90;
    }
    else if(CCPR1L == 0x0b&&CCP1CONbits.DC1B == 0b01){
        return 0;
    }
    else if(CCPR1L == 0x13&&CCP1CONbits.DC1B == 0b11){
        return 90;
    }
    else{
        return 9999;
    }
}

void __interrupt(high_priority) H_ISR(){
    if(INTCONbits.INT0IF!=1){
        return;
    }
    // -90 --> 90
    while(get_current_angle() != 90){
        turn_with_delay_clockwise();
    }
    // 90 --> -90
    while(get_current_angle() != -90){
        turn_with_delay_counter_clockwise();
    }
    // Clear interrupt flag
    INTCONbits.INT0IF=0;
}

void init_interrupt(){
    /* init interrupt */
    INTCONbits.INT0IF =0;   // clear Interrupt flag bit
    INTCONbits.GIE =0b1;    // open Global interrupt enable bit
    INTCONbits.INT0IE =0b1; // open interrupt0 enable bit 
}

void main(void)
{
    init_interrupt();

    /*init CCP*/
    // Timer2 -> On, prescaler -> 4
    T2CONbits.TMR2ON = 0b1;
    T2CONbits.T2CKPS = 0b01;

    // Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 µs
    OSCCONbits.IRCF = 0b001;
    // PWM mode, P1A, P1C active-high; P1B, P1D active-high
    CCP1CONbits.CCP1M = 0b1100;
    
    //RB0 -> Input
    TRISB = 1;
    // CCP1/RC2 -> Output
    TRISC = 0;
    LATC = 0;
    
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
     * = (0x9b + 1) * 4 * 8µs * 4
     * = 0.019968s ~= 20ms
     */
    PR2 = 0x9b;
    
    /**
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x0b*4 + 0b01) * 8µs * 4
     * = 0.00144s ~= 1450µs
     */
    CCPR1L = 0x04;
    CCP1CONbits.DC1B = 0b00;
    
    while(1);
    return;
}