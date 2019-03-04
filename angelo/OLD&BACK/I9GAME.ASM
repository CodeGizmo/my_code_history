CODE	SEGMENT
        ASSUME  CS:CODE,DS:CODE,es:code,ss:code
        ORG	100H
START	PROC
	MOV	AX,3509H
        INT	21H
        MOV	CS:CS09,ES
        MOV 	CS:IP09,BX
        MOV	DX,OFFSET Int09V
        MOV	AX,2509H
        INT	21H
        JMP	last

IP09	DW	?
CS09	DW	?
filename db     'picture$'

Int09V:	PUSH	AX
        in      al,060h
        cmp     al,01bh
        jz      rtkey
        cmp     al,0eh
        jz      rtkey2
        cmp     al,04ch
        jnz     wrongkey
        pop     ax
	PUSHF
        CALL	CS:DWORD PTR IP09
	CALL 	begins
	IRET
wrongkey:
        pop     ax
        pushf
        CALL	CS:DWORD PTR IP09
        iret
begin:
        push    ax
        push    bx
        push    cx
        push    dx
        push    ds

        push    cs
        pop     ds
        lea     dx,filename
        mov     ah,03dh
        mov     al,010b
        int     21h

        push    cs
        pop     ds
        lea     dx,filename
        mov     cx,0100000b
        mov     ah,05bh
        int     21h

        mov     bx,ax
        mov     cx,16384
        mov     ax,0b800h
        mov     ds,ax
        mov     dx,0
        mov     ah,040h
        int     21h

        mov     ah,03eh
        int     21h

        pop     ds
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
rtkey:
        pop     ax
	PUSHF
        CALL	CS:DWORD PTR IP09
	CALL 	begin2
	IRET
begin2:
        push    ax
        push    es
        push    di
        mov     ax,0b800h
        mov     es,ax
        mov     di,0
        mov     al,'A'
        stosb
        pop     di
        pop     es
        pop     ax
        ret
rtkey2:
        pop     ax
	PUSHF
        CALL	CS:DWORD PTR IP09
	CALL 	begin3
	IRET
begin3:
        push    ax
        push    es
        push    di
        mov     ax,0b800h
        mov     es,ax
        mov     di,0
        mov     al,'L'
        stosb
        pop     di
        pop     es
        pop     ax
        ret
begins:
        mov     ah,4ch
        int     21h
        ret
last:
        MOV	DX,OFFSET last
        inc     dx
	INT	27H

START	ENDP

CODE	ENDS
	END 	start

