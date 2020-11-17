#include <xc.inc>

global  ultra_setup, ultra_send, ultra_receive   
    
psect	udata_acs   ; reserve data space in access ram    
delay_count: ds 1   ; reserve 1 byte for delay length
delay2_count: ds 1
	
psect	detect_code,class=CODE

ultra_setup:
    clrf   TRISD, A    ; set PORTD as output
    return

ultra_send:
    clrf   TRISD, A
    setf   PORTD, A    ; start pulse
    movlw  0x0F
    movwf  delay2_count, A
    call   delay2
    clrf   PORTD, A
    return

ultra_receive:
    clrf   TRISD, A    ; set PORTD as input
    movlw  0xFF
    movwf  delay_count, A
    call   delay
    return
    
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