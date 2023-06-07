[bits 16]

[org 0x7c00]

LOAD_SEGMENT equ 0x1000
disk_retries equ 4

main:
	jmp short start
	nop

%include "bootsector.S"

start:
	; Setup segments:
	cli
	mov  [iBootDrive], dl  ; save what drive we booted from (should be 0x0)
	mov  ax, cs          ; CS = 0x0, since that's where boot sector is (0x07c00)
	mov  ds, ax          ; DS = CS = 0x0
	mov  es, ax          ; ES = CS = 0x0
	mov  ss, ax          ; SS = CS = 0x0
	mov  sp, 0x9000      ; Stack grows down from offset 0x9000, way beyond 0x7C00.
	sti  

	; Display "loading" message:
	lea  si, [loadmsg]
	call WriteString

	; Reset disk system.
	; Jump to bootFailure on error.
	mov  dl, [iBootDrive]  ; drive to reset
	xor  ax, ax          ; subfunction 0
	int  0x13            ; call interrupt 13h
	jc   bootFailure     ; display error message if carry set (error)  

	; Here stage2 is not reachable. Remember that BIOS only loads the first sector of the bootloader.
	; So we nead to read data from disk to memory
	;call stage2

	; Reads 1 sector from out bootloader and loads into ES:BX (0x0000:0x7C00)
	mov bx,0x7E00
	mov ax,1
	call ReadSector

	mov bx,[stage2_magic]
	cmp bx,stage2_signature ; compare the signature
	jne Stage2Failure

	jmp 0:stage2 

Reboot:
	lea si, [rebootmsg] ; Load address of reboot message into si
	call WriteString  ; print the string
	xor ax, ax        ; subfuction 0
	int 0x16          ; call bios to wait for key
	db 0xEA          ; machine language to jump to FFFF:0000 (reboot)
	dw 0x0000
	dw 0xFFFF

bootFailure:
	lea  si, [diskerror]
	call WriteString
	call Reboot

Stage2Failure:
	lea  si, [stage2failure]
	call WriteString
	call Reboot

%include "print_message.S"
%include "disk.S"

; PROGRAM DATA
loadmsg db "Loading OS...",0
diskerror db "Disk error. ",0
rebootmsg db "Press any key to reboot.",0
stage2failure db "Failed to load stage 2.",0

times 510-($-$$) db 0 	; Pad with nulls up to 510 bytes (excl. boot magic)
dw 0xAA55     		; magic word for BIOS

stage2_signature equ 0xabcd

stage2_magic:
	dw stage2_signature

stage2:
	lea si,[Welcome2Stage]
	call WriteString
	call Reboot

Welcome2Stage db "Welcome to 2 stage...",0

times 512 db 0 	; Pad with nulls up to 512 bytes 
times 512 db 0 	; Pad with nulls up to 512 bytes 
times 512 db 0 	; Pad with nulls up to 512 bytes 
times 512 db 0 	; Pad with nulls up to 512 bytes 
