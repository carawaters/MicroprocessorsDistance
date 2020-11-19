#include <xc.inc>

global  ultra_setup, ultra_send, ultra_receive, ultra_int_hi, timer_low1, timer_high1 
extrn   sixteen_by_eight
    
psect	udata_acs   ; reserve data space in access ram    
delay_count: ds 1   ; reserve 1 byte for delay length
delay2_count: ds 1
timer_low1: ds 1
timer_high1: ds 1
	
psect	detect_code,class=CODE

ultra_setup:
    clrf    TRISE, A    ; set PORTE as output
    banksel CCPTMRS2
    bcf     C10TSEL0
    movlw   00000100B   ; set CCP10 to falling edge
    movwf   CCP10CON, A
    return

ultra_send:
    clrf    TRISE, A
    setf    PORTE, A    ; start pulse
    movlw   0x18        ; 5 us delay for sent pulse width
    movwf   delay2_count, A
    call    delay2
    clrf    PORTE, A
    setf    TRISE, A    ; set PORTE as input
    banksel PIE4
    bsf     CCP10IE  ; enable CCP10 interrupt
    return

ultra_receive:
    movlw   0x2F        ; 750 us delay for hold off time
    movwf   delay_count, A
    call    delay
    movlw   00110011B   ; start TIMER1
    movwf   T1CON, A
    goto    $
    
ultra_post_int:
    movlw   0x0C        ; 200 us delay before sending next pulse
    movwf   delay_count, A
    call    delay
    return
    
ultra_int_hi:
    btfss   CCP10IF     ; check for CCP10 interrupt
    retfie  f           ; if not CCP10, return
    movff   TMR1, timer_low1, A
    movff   TMR1H, timer_high1, A
    movlw   00110010B   ; stop TIMER1
    movwf   T1CON, A
    clrf    TMR1, A
    clrf    TMR1H, A
    bcf     CCP10IF
    bcf     PIE4, 7, A  ; disable CCP10 interrupt
    goto    ultra_post_int
    
delay:
    movlw   0xFF
    movwf   delay2_count, A
    call    delay2
    decfsz  delay_count, A	; decrement until zero
    bra	    delay
    return
    
delay2:
    decfsz  delay2_count, A	; decrement until zero
    bra	    delay2
    return