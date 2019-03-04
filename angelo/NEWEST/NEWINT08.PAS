uses crt;
var
  segg,ofss,oldo,olds           :word;
  key,rkey,bkey                 :byte;
  mykey                         :array[0..255]of byte;
  installed8                    :boolean;
  repeatcount                   :word;
  freshkeys,freshrelease,contkey:byte;
  dumbyte,dumbyte2              :byte;
  passcount                     :byte;
  beepon                        :boolean;
  counter                       :word;
{$F+}
procedure printcount;
begin
  mem[$b800:2]:=counter shr 8;
  mem[$b800:4]:=counter and 255;
  inc(counter);
end;

procedure runinint8(var p);
begin
  {runinint8(addr(printcount)^);}
  asm
    call dword ptr p
  end;
end;
{$F-}

procedure gotomyint8;
begin
  if not(installed8)then
  begin
    oldo:=memw[0:32];
    olds:=memw[0:34];
    asm
          push ds
          push ax
          push dx
          mov  ax,0
          mov  ds,ax
          mov  ax,[32]
          mov  dx,[34]
          mov  word ptr cs:@oldvec,ax
          mov  word ptr cs:@oldvec+2,dx
          pop  dx
          pop  ax
          pop  ds
          jmp  @mover
      @oldvec:
          dw   0
          dw   0
      @c:
          dw   0
      @a:
          pushf
          call dword ptr cs:@oldvec
          pushf
          cli
          push ds
          push es
          push ax
          mov  ax,0b800h
          mov  es,ax
          mov  ax,word ptr cs:@c
          mov  es:[0],al
          add  word ptr cs:@c,1
          pop  ax
          pop  es
          pop  ds
          pusha
          push ds
          push es
          push ss
          pushf
          call printcount
          popf
          pop  ss
          pop  es
          pop  ds
          popa
          popf
          iret
      @mover:
          mov  ax,seg(@a)
          mov  cx,offset(@a);
          mov  segg,ax
          mov  ofss,cx
    end;
    asm
      cli
    end;
    memw[0:32]:=ofss;
    memw[0:34]:=segg;
    asm
      sti
    end;
    installed8:=true;
  end;
  key:=0;
end;{gotomyint9}

procedure goaway;
begin
  if installed8 then
  begin
    asm
      cli
    end;
    memw[0:32]:=oldo;
    memw[0:34]:=olds;
    asm
      sti
    end;
    installed8:=false;
  end;
end;{goaway}

var x,y:longint;

begin
  clrscr;
  gotomyint8;
  repeat
    mem[$b800:0]:=random(256);
  until keypressed and(readkey=#27);
  goaway;
end.