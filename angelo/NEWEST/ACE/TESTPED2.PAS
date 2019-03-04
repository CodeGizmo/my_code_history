uses crt,dos;
var
  sh,sm,ss,ss100,
  ch,cm,cs,cs100:word;
  dh,dm,ds,ds100:integer;
  esec:real;
  f:text;
const
  mycx=1024;

procedure testloop;
begin
  asm
    db 0fh
    db 08h
    pusha
    push  es
    mov   cx,mycx
  @looper:
      push  cx
      mov   cx,0
    @looper2:
{      jmp   @here}
{      nop}
{      nop
      mov   ax,ax}
    @here:
      loop  @looper2
      pop   cx
    loop  @looper
    pop   es
    popa
  end;
end;

procedure testnop;
begin
  asm
    db 0fh
    db 08h
    pusha
    push  es
    mov   cx,mycx
  @looper:
      push  cx
      mov   cx,0
    @looper2:
{      jmp   @here}
      nop
{       mov ax,es:[di+50]
       mov word ptr es:[di+50],ax
       inc di
       dec di}
       {jmp @here}
{      nop
      mov   ax,ax}
    @here:
      loop  @looper2
      pop   cx
    loop  @looper
    pop   es
    popa
  end;
end;

procedure testmul;
begin
  asm
    db 0fh
    db 08h
    pusha
    push  es
    mov   cx,mycx
  @looper:
      push  cx
      mov   cx,0
    @looper2:
{      jmp   @here}
{      nop}
{      nop
      mov   ax,ax}
      mul ax
    @here:
      loop  @looper2
      pop   cx
    loop  @looper
    pop   es
    popa
  end;
end;

procedure testmov;
begin
  asm
    db 0fh
    db 08h
    pusha
    push  es
    mov   cx,mycx
  @looper:
      push  cx
      mov   cx,0
    @looper2:
{      jmp   @here}
{      nop}
{      nop}
      mov   ax,ax
    @here:
      loop  @looper2
      pop   cx
    loop  @looper
    pop   es
    popa
  end;
end;

procedure testmemmov;
begin
  asm
    db 0fh
    db 08h
    pusha
    push  es
    mov   cx,mycx
  @looper:
      push  cx
      mov   cx,0
    @looper2:
{      jmp   @here}
{      nop}
{      nop}
      mov   ax,[bx+80]
    @here:
      loop  @looper2
      pop   cx
    loop  @looper
    pop   es
    popa
  end;
end;

procedure testbytexfer;
var
  p:pointer;
begin
  getmem(p,65535);
  asm
    db 0fh
    db 08h
    pusha
    push  es
    pushf
    cld

    mov   cx,1024d
    mov   si,0
    les   di,p
  @looper:
      push  cx
      mov   cx,65535
      rep   movsb
      pop   cx
    loop  @looper
    popf
    pop   es
    popa
  end;
  freemem(p,65535);
end;

procedure testwordxfer;
var
  p:pointer;
begin
  getmem(p,65535);
  asm
    db 0fh
    db 08h
    pusha
    push  es
    pushf
    cld
    les   di,p
    mov   si,0
    mov   cx,mycx
  @looper:
      push  cx
      mov   cx,32767
      rep   movsw
      pop   cx
    loop  @looper
    popf
    pop   es
    popa
  end;
  freemem(p,65535);
end;

procedure testbytestore;
var
  p:pointer;
begin
  getmem(p,65535);
  asm
    db 0fh
    db 08h
    pusha
    push  es
    pushf
    cld
    les   di,p
    mov   cx,mycx
  @looper:
      push  cx
      mov   cx,65535
      rep   stosb
      pop   cx
    loop  @looper
    popf
    pop   es
    popa
  end;
  freemem(p,65535);
end;

procedure testbyteload;
begin
  asm
    db 0fh
    db 08h
    push  es
    pushf
    cld
    mov   si,0
    mov   cx,mycx
  @looper:
      push  cx
      mov   cx,65535
      rep   lodsb
      pop   cx
    loop  @looper
    popf
    pop   es
  end;
end;

var
  looptime:real;
procedure endproc;
begin
  gettime(ch,cm,cs,cs100);
  dh:=ch-sh;
  dm:=cm-sm;
  ds:=cs-ss;
  ds100:=cs100-ss100;
  esec:=dh*60*60+dm*60+ds+ds100/100;
  looptime:=esec;
end;

procedure endproc2;
begin
  gettime(ch,cm,cs,cs100);
  dh:=ch-sh;
  dm:=cm-sm;
  ds:=cs-ss;
  ds100:=cs100-ss100;
  esec:=dh*60*60+dm*60+ds+ds100/100-looptime;
end;
var
  runs:integer;
  s:string;

begin
  clrscr;
  runs:=0;
  assign(f,'runs.all');
  {$I-}
  reset(f);
  {$I+}
  if ioresult=0 then
  begin
    readln(f,runs);
    close(f);
  end;
  inc(runs);
  str(runs,s);
  assign(f,'test'+s+'.all');
  rewrite(f);
  readkey;
  gettime(sh,sm,ss,ss100);
  testloop;
  endproc;
  writeln(65536*mycx:6,' loops in',esec:6:2,' Sec.');
  writeln('Loop rate is',65536*mycx/esec:12:2,' loops per Sec.');
  writeln(f,65536*mycx:6,' loops in',esec:6:2,' Sec.');
  writeln(f,'Loop rate is',65536*mycx/esec:12:2,' loops per Sec.');




  gettime(sh,sm,ss,ss100);
  testnop;
  endproc2;
  writeln(65536*mycx:6,' nops in',esec:6:2,' Sec.');
  writeln('Loop rate is',65536*mycx/esec:12:2,' loops per Sec.');
  writeln(f,65536*mycx:6,' nops in',esec:6:2,' Sec.');
  writeln(f,'Loop rate is',65536*mycx/esec:12:2,' loops per Sec.');

  gettime(sh,sm,ss,ss100);
  testmul;
  endproc2;
  writeln(65536*mycx:6,' muls in',esec:6:2,' Sec.');
  writeln('Loop rate is',65536*mycx/esec:12:2,' loops per Sec.');
  writeln(f,65536*mycx:6,' muls in',esec:6:2,' Sec.');
  writeln(f,'Loop rate is',65536*mycx/esec:12:2,' loops per Sec.');

  gettime(sh,sm,ss,ss100);
  testmov;
  endproc2;
  writeln(65536*mycx:6,' movs in',esec:6:2,' Sec.');
  writeln('Loop rate is',65536*mycx/esec:12:2,' loops per Sec.');
  writeln(f,65536*mycx:6,' movs in',esec:6:2,' Sec.');
  writeln(f,'Loop rate is',65536*mycx/esec:12:2,' loops per Sec.');

  gettime(sh,sm,ss,ss100);
  testmov;
  endproc2;
  writeln(65536*mycx:6,' memmovs in',esec:6:2,' Sec.');
  writeln('Loop rate is',65536*mycx/esec:12:2,' loops per Sec.');
  writeln(f,65536*mycx:6,' memmovs in',esec:6:2,' Sec.');
  writeln(f,'Loop rate is',65536*mycx/esec:12:2,' loops per Sec.');
          

  gettime(sh,sm,ss,ss100);
  testbytexfer;
  endproc;
  writeln(65535{*mycx}:6,' byte transfered in',esec:6:2,' Sec.');
  writeln('byte transfer rate is',65535*1024/esec:12:2,' bytes per Sec.');
  writeln(f,65535*mycx:6,' byte transfered in',esec:6:2,' Sec.');
  writeln(f,'byte transfer rate is',65535*1024/esec:12:2,' bytes per Sec.');


  gettime(sh,sm,ss,ss100);
  testwordxfer;
  endproc;
  writeln(65535*mycx:6,' byte transfered in',esec:6:2,' Sec.');
  writeln('Word transfer rate is',65534*mycx/esec:12:2,' bytes per Sec.');
  writeln(f,65535*mycx:6,' byte transfered in',esec:6:2,' Sec.');
  writeln(f,'Word transfer rate is',65534*mycx/esec:12:2,' bytes per Sec.');

  gettime(sh,sm,ss,ss100);
  testbytestore;
  endproc;
  writeln(65535*mycx:6,' bytes stored in',esec:6:2,' Sec.');
  writeln('Store rate is',65536*mycx/esec:12:2,' bytes per Sec.');
  writeln(f,65535*mycx:6,' bytes stored in',esec:6:2,' Sec.');
  writeln(f,'Store rate is',65536*mycx/esec:12:2,' bytes per Sec.');

  gettime(sh,sm,ss,ss100);
  testwordxfer;
  endproc;
  writeln(65535*mycx:6,' bytes loaded in',esec:6:2,' Sec.');
  writeln('Load transfer rate is',65536*mycx/esec:12:2,' bytes per Sec.');
  writeln(f,65535*mycx:6,' bytes loaded in',esec:6:2,' Sec.');
  writeln(f,'Load transfer rate is',65536*mycx/esec:12:2,' bytes per Sec.');
  close(f);

  assign(f,'runs.all');
  rewrite(f);
  write(f,runs);
  close(f);

end.