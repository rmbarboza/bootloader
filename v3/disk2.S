; readSec: 
; 	Reads N sector using bios int 13h 42h
; 	AX:    Block count to read
; 	ES:BX: Destination address
; 	EDX:   LBA address
;
; readOneSec:
;	Same but reads just one sector

;
; From: https://wiki.osdev.org/Disk_access_using_the_BIOS_(INT_13h)
;
DataPacket:
		db	0x10		; Frame size: 16 bytes
		db	0		; Must be zero (convention)
.blocks:	dw	0		; number of blocks
.buffer:	dw	0x7e00		; Buffer address
.segment	dw	0		; Buffer Segment
.lba:		dd	1		; LBA block address
.notused	dd	0		; Linear memory address (not used)

readOneSec:	
		mov	ax, 1
readSec:
		push	ax
		mov	[DataPacket.buffer], bx
		mov	[DataPacket.segment], es
		mov	[DataPacket.lba], edx
		mov	cx, disk_retries
.retry:
		mov	[DataPacket.blocks], ax
		mov	si, DataPacket
		mov	ah, 0x42
		mov	dl, [iBootDrive]
		int	0x13
		jnc	short .ok
		mov	ax, [esp]
		loop	.retry

		pop	ax
		jmp	bootFailure
.ok:
		pop	ax
		ret
