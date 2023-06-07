; buffer at ES:BX. This function uses interrupt 13h, subfunction ah=2.
ReadSector:
	xor     cx, cx                      ; Set try count = 0

readsect:
	push    ax                          ; Store logical block
	push    cx                          ; Store try number
	push    bx                          ; Store data buffer offset
	; Calculate cylinder, head and sector:
	; Cylinder = (LBA / SectorsPerTrack) / NumHeads
	; Sector   = (LBA mod SectorsPerTrack) + 1
	; Head     = (LBA / SectorsPerTrack) mod NumHeads
	mov     bx, [iTrackSect]            ; Get sectors per track
	xor     dx, dx
	div     bx                          ; Divide (dx:ax/bx to ax,dx)
	; Quotient (ax) =  LBA / SectorsPerTrack
	; Remainder (dx) = LBA mod SectorsPerTrack
	inc     dx                          ; Add 1 to remainder, since sector
	mov     cl, dl                      ; Store result in cl for int 13h call.

	mov     bx, [iHeadCnt]              ; Get number of heads
	xor     dx, dx
	div     bx                          ; Divide (dx:ax/bx to ax,dx)
	; Quotient (ax) = Cylinder
	; Remainder (dx) = head
	mov     ch, al                      ; ch = cylinder                      
	xchg    dl, dh                      ; dh = head number
	; Call interrupt 0x13, subfunction 2 to actually
	; read the sector.
	; al = number of sectors
	; ah = subfunction 2
	; cx = sector number
	; dh = head number
	; dl = drive number
	; es:bx = data buffer
	; If it fails, the carry flag will be set.
	mov     ax, 0x0201                  ; Subfunction 2, read 1 sector
	mov     dl, [iBootDrive]            ; from this drive
	pop     bx                          ; Restore data buffer offset.
	int     0x13
	jc      readfail

	; On success, return to caller.
	pop     cx                          ; Discard try number
	pop     ax                          ; Get logical block from stack
	ret

	; The read has failed.
	; We will retry four times total, then jump to boot failure.
readfail:   
	pop     cx                      ; Get try number             
	inc     cx                      ; Next try
	cmp     cx, 4              	; Stop at 4 tries
	je      bootFailure

	; Reset the disk system:
	xor     ax, ax
	int     0x13

	; Get logical block from stack and retry.
	pop     ax
	jmp     readsect
