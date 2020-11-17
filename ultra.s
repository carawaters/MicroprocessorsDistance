#include <xc.inc>

global  ultra_setup, ultra_send, ultra_receive, timer_low, timer_high   
extrn   sixteen_by_eight
    
psect	udata_acs   ; reserve data space in access ram    
delay_count: ds 1   ; reserve 1 byte for delay length
delay2_count: ds 1
timer_low: ds 1
timer_high: ds 1
	
psect	detect_code,class=CODE

ultra_setup:
    clrf   TRISD, A    ; set PORTD as output
    return

ultra_send:
    clrf   TRISD, A
    setf   PORTD, A    ; start pulse
    movlw  0x18        ; 5 us delay for sent pulse width
    movwf  delay2_count, A
    call   delay2
    clrf   PORTD, A
    return

ultra_receive:
    setf   TRISD, A    ; set PORTD as input
    movlw  0x00
    call   check_pin
    movlw  10000111B
    movwf  T0CON, A
    movlw  0x01
    call   check_pin
    movff  TMR0, timer_low, A
    movff  TMR0H, timer_high, A
    movlw  00000111B
    movwf  T0CON, A
    clrf   TMR0, A
    clrf   TMR0H, A
    movlw  0x0C
    movwf  delay_count, A
    call   delay
    return
    
check_pin:
    cpfseq PORTD, A
    return
    bra    check_pin
    
delay:
    movlw  0xFF
    movwf  delay2_count, A
    call   delay2
    decfsz delay_count, A	; decrement until zero
    bra	   delay
    return
    
delay2:
    decfsz delay2_count, A	; decrement until zero
    bra	   delay2
    return
