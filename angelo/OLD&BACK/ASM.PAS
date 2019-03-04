uses crt;
var
  oldip09,oldcs09:word;
  oldip092,oldcs092:word;
  a:array[0..100]of byte;
  count:word;
procedure getint09;
begin
{START	PROC}
  asm
	MOV	AX,3509H
        INT	21H
        MOV	DS:oldCS09,ES
        MOV 	DS:oldIP09,BX
  end;
end;

procedure getint092;
begin
{START	PROC}
  asm
	MOV	AX,3509H
        INT	21H
        MOV	DS:oldCS092,ES
        MOV 	DS:oldIP092,BX
  end;
end;

procedure moveint09;
begin
  asm
        push    ds
        mov     ax,seg @int09v
        mov     ds,ax
        MOV	DX,OFFSET @Int09V
        MOV	AX,2509H
        INT	21H
        pop     ds
        JMP	@last


@Int09V:{PUSH	AX
        in      al,060h
        cmp     al,04ch
        jnz     @wrongkey
        pop     ax}
        cli
        pusha
        mov     ax,0b800h
        mov     es,ax
        mov     di,0
        cld
        mov     cx,160
        mov     al,byte ptr count
        rep     stosb
        inc     count
        popa
	PUSHF
        CALL	DWORD PTR oldIP09
{	CALL 	@begins}
        sti
	IRET
@wrongkey:
        pop     ax
        pushf
        CALL	CS:DWORD PTR oldIP09
        iret
@begins:
        mov     ah,4ch
        int     21h
        ret
@last:
  end;
end;

procedure getbackint09;
begin
  asm
    mov ax,2509h
    mov dx,oldip09
    push ds
    mov ds,oldcs09
    int 21h
    pop ds
  end;
end;

var
  x,y:word;

begin
  clrscr;
  getint09;
  writeln('cs:',oldcs09);
  writeln('ip:',oldip09);
  count:=0;
  moveint09;

  getint092;
  writeln('cs:',oldcs092);
  writeln('ip:',oldip092);

{  readkey;}
  for x:=0 to 65535 do for y:=0 to 65*5do;
  getbackint09;

  getint092;
  writeln('cs:',oldcs092);
  writeln('ip:',oldip092);
  writeln('count:',count);
  readkey;
end.

