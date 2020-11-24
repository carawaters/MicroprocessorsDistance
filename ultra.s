#include <xc.inc>

global  ultra_setup, ultra_send, ultra_receive, timer_low1, timer_high1 
extrn   sixteen_by_eight, result_1, result_2, result_3
    
psect	udata_acs   ; reserve data space in access ram    
delay_count: ds 1   ; reserve 1 byte for delay length
delay2_count: ds 1
delay3_count: ds 1
timer_low1: ds 1
timer_high1: ds 1
	
psect	detect_code,class=CODE

ultra_setup:
    clrf    TRISE, A    ; set PORTE as output
    bcf     CCPTMRS2, 4, B
    movlw   00000100B   ; set CCP10 to falling edge
    banksel CCP10CON
    movwf   CCP10CON, B      
    bsf     INTCON, 7, A   ; enable global high priority interrupt
    bsf     INTCON, 6, A   ; enable peripheral interrupt
    bsf     PIE1, 2, A  ; enable timer1 interrupt
    bcf     PIR4, 7, A  ; clear CCP10 interrupt
    return

ultra_send:
    clrf    TRISE, A
    setf    PORTE, A    ; start pulse
    movlw   0x18        ; 5 us delay for sent pulse width
    movwf   delay3_count, A
    call    delay3
    clrf    PORTE, A
    setf    TRISE, A    ; set PORTE as input
    bsf     PIE4, 7, A  ; enable CCP10 interrupt
    return

ultra_receive:
    movlw   0x0F        ; 750 us delay for hold off time
    movwf   delay2_count, A
    call    delay2
    movlw   00111111B   ; start TIMER1
    movwf   T1CON, A
    movlw   0x03        ; 18.6 ms delay for t_IN-MAX
    movwf   delay_count, A
    call    delay
    movf    CCPR10, W, B  ; measure timer low byte
    movwf   timer_low1, A
    movf    CCPR10H, W, B ; measure timer high byte
    movwf   timer_high1, A
    movlw   00111110B   ; stop TIMER1
    movwf   T1CON, A
    clrf    TMR1, A     ; reset times to measure again
    clrf    TMR1H, A
    clrf    CCPR10, A
    clrf    CCPR10H, A
    bcf     PIR4, 7, A      ; clear CCP10 interrupt
    bcf     PIE4, 7, A      ; disable CCP10 interrupt
    
ultra_calc:
    movlw   0x53            ; factor to multiply by
    call    sixteen_by_eight
    return
    
delay:
    movlw   0x80
    movwf   delay2_count, A
    call    delay2
    decfsz  delay_count, A	; decrement until zero
    bra	    delay
    return

delay2:
    movlw   0xFF
    movwf   delay3_count, A
    call    delay3
    decfsz  delay2_count, A	; decrement until zero
    bra	    delay2
    return
    
delay3:
    decfsz  delay3_count, A	; decrement until zero
    bra	    delay3
    return