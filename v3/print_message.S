;INPUT DS:SI
;Print char until 0 is found
WriteString:
	lodsb	 		; load byte at ds:si into al (advancing si)
	or al,al 		; test if character is 0 (end)
	jz WriteString_done 	; jump to end if 0.
	mov ah, 0xe		; Subfunction 0xe of int 10h (video teletype output)
	mov bx, 9		; Set bh (page nr) to 0, and bl (attribute) to white (9)
	int 0x10		; call BIOS interrupt.

	jmp WriteString 	; Repeat for next character.

WriteString_done:
	retw

