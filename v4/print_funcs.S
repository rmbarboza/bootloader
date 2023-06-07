; Writes char in AL
biosWriteChar:
	mov ah, 0xE		; Subfunction 0xe of int 10h (video teletype output)
	mov bx, 9		; Set bh (page nr) to 0, and bl (attribute) to white (9)
	int 0x10		; call BIOS interrupt.
	ret

biosWriteCRLF:
	mov al,13
	call biosWriteChar
	mov al,10
	call biosWriteChar
	ret

; Write contents of register ex
; Input: edx
biosWriteHex:
	mov cx,8
.loop:
	rol edx,4
	mov eax,edx
	and ax,0x0F
	add al,48
	cmp al,57
	jle .L1
	add al,7
.L1:
	call biosWriteChar
	dec cx
	cmp cx,0
	jne .loop
	ret

;INPUT DS:SI
;Print char until 0 is found
WriteString:
	lodsb	 		; load byte at ds:si into al (advancing si)
	or al,al 		; test if character is 0 (end)
	jz WriteString_done 	; jump to end if 0.
	call biosWriteChar

	jmp WriteString 	; Repeat for next character.

WriteString_done:
	call biosWriteCRLF
	retw

