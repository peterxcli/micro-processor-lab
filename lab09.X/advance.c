#include <xc.h>
#include <pic18f4520.h>
#include<stdlib.h>
#include <time.h>
#define _XTAL_FREQ 1000000
#pragma config OSC = INTIO67 // Oscillator Selection bits
#pragma config WDT = OFF     // Watchdog Timer Enable bit
#pragma config PWRT = OFF    // Power-up Enable bit
#pragma config BOREN = ON    // Brown-out Reset Enable bit
#pragma config PBADEN = OFF  // Watchdog Timer Enable bit
#pragma config LVP = OFF     // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF     // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)

// Use four LEDs to indicate odd or even numbers based on the voltage 
// level of a variable resistor. As the resistor is rotated, the ADC measures the 
// voltage, and the LEDs light up in binary to represent the numbers. When the 
// voltage increases, the LEDs will display odd numbers (1, 3, 5, 7, 9, 11, 13, 
// 15). When the voltage decreases, the LEDs will display even numbers (0, 2, 
// 4, 6, 8, 10, 12, 14).
void __interrupt(high_priority)H_ISR(){
    static int prev_value = 0;
    static int is_increasing = 1;  // 1 for increasing, 0 for decreasing
    
    //step4
    int value = ADRESH<<2;
    value = value|((ADRESL>>6));
    
    
    // Determine direction of voltage change
    if (value > prev_value) {
        is_increasing = 1;
    } else if (value < prev_value) {
        is_increasing = 0;
    }
    prev_value = value;
    
    // Get state (0-7)
    int state = value>>7;
    
    // Display odd numbers when increasing, even numbers when decreasing
    if (is_increasing) {
        switch(state) {
            case 0: LATC = 1;  break;  // 1
            case 1: LATC = 3;  break;  // 3
            case 2: LATC = 5;  break;  // 5
            case 3: LATC = 7;  break;  // 7
            case 4: LATC = 9;  break;  // 9
            case 5: LATC = 11; break;  // 11
            case 6: LATC = 13; break;  // 13
            case 7: LATC = 15; break;  // 15
        }
    } else {
        switch(state) {
            case 0: LATC = 0;  break;  // 0
            case 1: LATC = 2;  break;  // 2
            case 2: LATC = 4;  break;  // 4
            case 3: LATC = 6;  break;  // 6
            case 4: LATC = 8;  break;  // 8
            case 5: LATC = 10; break;  // 10
            case 6: LATC = 12; break;  // 12
            case 7: LATC = 14; break;  // 14
        }
    }
    
    //clear flag bit
    PIR1bits.ADIF = 0;
    
    
    //step5 & go back step3
    /*
    delay at least 2tad
    ADCON0bits.GO = 1;
    */
    __delay_us(4);
    ADCON0bits.GO = 1;
    return;
}

void main(void) 
{
    //configure OSC and port
    OSCCONbits.IRCF = 0b100; //1MHz
    TRISAbits.RA0 = 1;       //analog input port
    TRISC = 0b0;              //RC0~RC3 output
    LATC = 0b0;              //initial light bulbs
    //step1
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 ?analog input,???? digital
    ADCON0bits.CHS = 0b0000;  //AN0 ?? analog input
    ADCON2bits.ADCS = 0b000;  //????000(1Mhz < 2.86Mhz)
    ADCON2bits.ACQT = 0b001;  //Tad = 2 us acquisition time?2Tad = 4 > 2.4
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 0;    //left justified 
    
    
    //step2
    PIE1bits.ADIE = 1;
    PIR1bits.ADIF = 0;
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;


    //step3
    ADCON0bits.GO = 1;
    
    while(1);
    
    return;
}