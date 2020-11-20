#include <xc.inc>

global sixteen_by_eight, result_1, result_2, result_3
extrn  timer_low1, timer_high1
    
psect	udata_acs   ; reserve data space in access ram    
result_1: ds 1 ; most sig
result_2: ds 1 ; mid sig
result_3: ds 1 ; least sig
mid: ds 1
dec_1: ds 1
dec_2: ds 1
    
sixteen_by_eight:
    mulwf  timer_low1, A  ; need the 8 bit number in W
    movff  PROD, result_3, A
    movff  PRODH, mid, A
    mulwf  timer_high1, A
    movf   PROD, W, A
    addwf  mid, W, A
    movwf  result_2, A
    movlw  0
    addwfc PRODH, W, A
    movwf  result_1, A
    return
    
hex_to_dec:
    movlw  0x0A
    mulwf  result_1, A
    movff  PRODH, dec_1, A
    mulwf  PRODH, A