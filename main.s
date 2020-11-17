	#include <pic18_chip_select.inc>
	#include <xc.inc>

extrn   ultra_setup, ultra_send, ultra_receive   	

psect	udata_acs   ; reserve data space in access ram    
delay_count: ds 1   ; reserve 1 byte for delay length	
	
psect	code, abs
	
main:
	org	0x0
	goto	start
	org	0x100		    ; Main code starts here at address 0x100
start:

measure:
	call    ultra_send
	call    ultra_receive
        ;movlw   0xFF
	;movwf   delay_count, A
	bra     measure

delay:
        decfsz  delay_count, A	; decrement until zero
        bra	delay
        return