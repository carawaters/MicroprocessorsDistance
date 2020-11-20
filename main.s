	#include <pic18_chip_select.inc>
	#include <xc.inc>

extrn   ultra_setup, ultra_send, ultra_receive
extrn   LCD_Setup, LCD_Write_Message, LCD_Write_Hex, LCD_Clear
extrn   result_1, result_2, result_3

psect	udata_acs   ; reserve data space in access ram    
delay_count: ds 1   ; reserve 1 byte for delay length	
counter:    ds 1    ; reserve one byte for a counter variable
    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data

psect	data    
	; ******* myTable, data in programme memory, and its length *****
myTable:
	db	'D','i','s','t','a','n','c','e',':',' ',' ',' ',0x0a
					; message, plus carriage return
	myTable_l   EQU	13	; length of data
	align	2
	
psect	code, abs
	
main:
	org	0x0
	goto	start
	
	org	0x100		    ; Main code starts here at address 0x100

start:
        call    ultra_setup
	call    LCD_Setup

measure:
	call    ultra_send
	call    ultra_receive
	call    LCD_Clear
	movf    result_1, W, A
	call    LCD_Write_Hex
	movf    result_2, W, A
	call    LCD_Write_Hex
	movf    result_3, W, A
	call    LCD_Write_Hex
	movlw   0xFF
	movwf   delay_count
	call    delay
	bra     measure

delay:
        decfsz  delay_count, A	; decrement until zero
        bra	delay
        return