#define RA0 PORTA,0
#define RA1 PORTA,1
#define RA2 PORTA,2
#define RA3 PORTA,3
#define RA4 PORTA,4
#define RB0 PORTB,0
#define RB1 PORTB,1
#define RB2 PORTB,2
#define RB3 PORTB,3
#define RB4 PORTB,4
#define RB5 PORTB,5
#define RB6 PORTB,6
#define RB7 PORTB,7
;***************************************************************************
;                                                                     
;       Memory select macros for PIC 16XXXX
;       ==================================
;
;***************************************************************************


bank0   macro
        bcf     STATUS,RP0
        endm

bank1   macro
        bsf     STATUS,RP0
        endm




;***************************************************************************
;                                                                     
;      
;       ==================================
;
;***************************************************************************
digbyte macro arg0
	local Pon0
	local Exit1
	local Exit2
	local Pozitiv

	clrf Dig1
	clrf Dig2
	clrf Dig3
Pozitiv	
	movf arg0,w
	movwf Digtemp
	movlw .100
Pon0	
	incf Dig1,f
	subwf Digtemp,f
	btfsc STATUS,C
	goto Pon0
	decf Dig1,f
	addwf Digtemp,f
Exit1	movlw .10
	incf Dig2,f
	subwf Digtemp,f
	btfsc STATUS,C
	goto Exit1
	decf Dig2,f
	addwf Digtemp,f
Exit2
	movf Digtemp,w
	movwf Dig3
	endm

;***************************************************************************
;                                                                     
;      
;       ==================================
;
;***************************************************************************
pausems macro arg1
local Loop1
local dechi
local Delay1ms
local Loop2
local Kraj
	ifndef OSC
	#define OSC 4
	endif 

	movlw high (arg1*OSC/4)
	movwf HIcnt
	movlw low (arg1*OSC/4)
	movwf LOcnt
Loop1
	movf LOcnt,f
	btfsc STATUS,Z
	goto dechi	
	call Delay1ms
	decf LOcnt,f
	goto Loop1	
dechi
	movf HIcnt,f
	btfsc STATUS,Z
	goto Kraj
	call Delay1ms
	decf HIcnt,f
	decf LOcnt,f

	goto  Loop1
	
	

Delay1ms:

	movlw .100
	movwf LOOPcnt
Loop2:
	nop		
	nop 
	nop
	nop	
	nop 
	nop
	nop
	
	decfsz LOOPcnt,f
	goto Loop2

	return

Kraj
endm
;***************************************************************************
;                                                                     
;      
;       ==================================
;
;***************************************************************************
push macro
	movwf Wtemp
endm


pop macro
	movf Wtemp,w
endm
;***************************************************************************
;                                                                     
;      
;       ==================================
;
;***************************************************************************
;
callz macro label
local Exit
	bnz Exit
	call label
Exit
endm

callnz macro label
local Exit
	bz Exit
	call label
Exit
endm
callc macro label
local Exit
	bnc Exit
	call label
Exit
endm

callnc macro label
local Exit
	bc Exit
	call label
Exit
endm



;***************************************************************************
;                                                                     
;      
;       ==================================
;
;***************************************************************************
input macro dsport,dsbit
	bsf STATUS,RP0
	bsf dsport,dsbit
	bcf STATUS,RP0	
endm

output macro dsport,dsbit
	bsf STATUS,RP0
	bcf dsport,dsbit
	bcf STATUS,RP0	
endm	

;***************************************************************************
;                                                                     
;      
;       ==================================
;
;***************************************************************************
ifbit macro arg1,arg2,arg3
	btfsc arg1,arg2
	goto arg3
endm

ifnotbit macro arg1,arg2,arg3
	btfss arg1,arg2
	goto arg3
endm


;***************************************************************************
;                                                                     
;      
;       ==================================
;
;***************************************************************************
multiply macro arg1, arg2, dest_hi, dest_lo, temp
 local i = 0 
 movf arg1 ,w 
 movwf temp 
 movf arg2,w 
 clrf dest_hi 
 clrf dest_lo 
 bcf STATUS, C  
 while i < 8 
 btfsc temp, i 
 addwf dest_hi, F  
 rrf dest_hi, F   
 rrf dest_lo, F  
 i += 1 
 endw 
endm   

;***************************************************************************
;                                                                     
;      
;       ==================================
;
;***************************************************************************

