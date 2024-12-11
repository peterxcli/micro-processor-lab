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

void __interrupt(high_priority)H_ISR(){
    
    //step4
    int value = ADRESH<<2;
    value=value|((ADRESL>>6));
    
    //do things
    int state=value>>7;
    
    switch(state){
        case 0:
            LATC=7;
            break;
        case 1:
            LATC=4;
            break;
        case 2:
            LATC=1;
            break;
        case 3:
            LATC=1;
            break;
        case 4:
            LATC=4;
            break;
        case 5:
            LATC=7;
            break;
        case 6:
            LATC=5;
            break;
        case 7:
            LATC=2;
            break;
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