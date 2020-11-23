	#include <pic18_chip_select.inc>
	#include <xc.inc>

extrn   ultra_setup, ultra_send, ultra_receive
extrn   result_1, result_2, result_3
extrn   warn_setup, warn_LED, warn_buzzer

psect	udata_acs   ; reserve data space in access ram    
delay_count: ds 1   ; reserve 1 byte for delay length	
counter:    ds 1    ; reserve one byte for a counter variable
	
psect	code, abs
	
main:
	org	0x0
	goto	start
	
	org	0x100		    ; Main code starts here at address 0x100

start:
        call    ultra_setup
	call    warn_setup

measure:
	call    ultra_send
	call    ultra_receive
	call    warn_LED
	movlw   0xFF
	movwf   delay_count, A
	call    delay
	bra     measure

delay:
        decfsz  delay_count, A	; decrement until zero
        bra	delay
        return