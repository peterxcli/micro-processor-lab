/*
 * File:   main.c
 * Author: peter.li
 *
 * Created on October 23, 2024, 10:43 AM
 */


#include <xc.h>
extern unsigned char mysqrt(unsigned char a);
extern unsigned int mygcd(unsigned int a, unsigned int b);
extern unsigned int multi_signed(unsigned char a, unsigned char b);

void main(void) {
    volatile unsigned char sqrt_result = mysqrt(16);
    volatile unsigned int gcd_result = mygcd(1200, 180);
    volatile unsigned int multi_signed_result = multi_signed(127, -6);
    while(1);
    return;
}
