{CODE	SEGMENT
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
        cmp     al,04ch
        jnz     wrongkey
        pop     ax
	PUSHF}
var ip09:word;
    cs09:word;
begin
  asm
        CALL	CS:DWORD PTR IP09
  end;
end.
{	CALL 	begins
	IRET
wrongkey:
        pop     ax
        pushf
        CALL	CS:DWORD PTR IP09
        iret
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
	END 	start}

