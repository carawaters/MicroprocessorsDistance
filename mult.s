#include <xc.inc>

global sixteen_by_8 
    
psect	udata_acs   ; reserve data space in access ram    
timer_low: ds 1
timer_high: ds 1
result_1: ds 1 ; most sig
result_2: ds 1 ; mid sig
result_3: ds 1 ; least sig
mid: ds 1
    
sixteen_by_8:
    mulwf  timer_low, A
    movff  PROD, result_3, A
    movff  PRODH, mid, A
    mulwf  timer_high, A
    movff  PROD, W, A
    addwf  mid, W, A
    movwf  result_2, A
    movlw  0
    addwfc PRODH, W, A
    movwf  result_1, A
    return