#include <xc.inc>

global   warn_setup, warn_buzzer, warn_LED
extrn    result_1, result_2, result_3   

psect	udata_acs   ; reserve data space in access ram         
    
warn_setup:
    clrf   TRISJ, A
    return
    
warn_buzzer:
    movlw   0x17 
    cpfsgt  result_1, A ; compare if greater than 1.5m
    bra     buzzer_on
    return
    
warn_LED:
    movlw   0x1F
    cpfsgt  result_1, A ; compare if greater than 2m
    goto    LED_on
    clrf    PORTJ, A    ; clear PORTJ if greater
    return
    
LED_on:
    setf    PORTJ, A    ; turn on or keep on PORTJ if less than
    return
    
buzzer_on:
    return