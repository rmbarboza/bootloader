bootsector:
	iOEM 	   db "DevOS   "	; OEM String
	iSectSize  dw 0x200		; bytes per sector
 	iClustSize db  1             	; sectors per cluster
	iResSect   dw  1             	; #of reserved sectors
	iFatCnt	   db  2 		; #of FAT copies
	iRootSize  dw  224 		; size of root directory
	iTotalSect dw  2880 		; total # of sectors if over 32 MB
	iMedia	   db  0xF0 		; media Descriptor
	iFatSize   dw  9 		; size of each FAT
	iTrackSect dw  9 		; sectors per track
	iHeadCnt   dw  2 		; number of read-write heads
	iHiddenSect dw 0 		; number of hidden sectors
	iSect32    dw  0 		; # sectors for over 32 MB
	iBootDrive db  0 		; holds drive that the boot sector came from
	iReserved  db  0 		; reserved, empty
	iBootSign  db  0x29 		; extended boot sector signature
	iVolID     db  "seri" 		; disk serial
	acVolumeLabel db "MYVOLUME   " 	; volume label
	acFSType   db "FAT16   " 	; file system type

