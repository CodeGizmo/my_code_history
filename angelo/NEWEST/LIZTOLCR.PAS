uses crt,dos,vgaliza3,rolfazil;
var pi,po,buffer:pointer;
    f:file;
    dirinfo,dirinfo2:searchrec;
    dt,dt2:datetime;
    c:byte;
    showing:byte;

procedure show;
begin
  {writeln('percent complete:',(upos/uncom)*100:3:2,'%');}
{  yeyan(upos,159,upos)}
{  memw[$a000:0]:=cpos; }
end;

var
  installed:boolean;
  oldo,olds,segg,ofss:word;
procedure gotomyint1c;
begin
  showing:=0;
  if not(installed)then
  begin
    oldo:=memw[0:$1c*4];
    olds:=memw[0:$1c*4+2];
    asm
          jmp  @mover
      @a:
          cmp  showing,0
          ja   @wagna
          mov  showing,1
          pusha
          pushf
          call show
          popf
          popa
      @wagna:
          mov  showing,0
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
    memw[0:$1c*4]:=ofss;
    memw[0:$1c*4+2]:=segg;
    asm
      sti
    end;
    installed:=true;
  end;
end;{gotomyint1c}

procedure goaway;
begin
  if installed then
  begin
    asm
      cli
    end;
    memw[0:$1c*4]:=oldo;
    memw[0:$1c*4+2]:=olds;
    asm
      sti
    end;
    installed:=false;
  end;
end;{goaway}

begin
  installed:=false;
  gotomyint1c;
  directvideo:=false;
  getmem(pi,65535);
  getmem(po,65535);
  vgamode(1);
  findfirst('pictures\*.liz',archive,dirinfo);
  if doserror=0 then
    while doserror=0 do
    begin
      aload('pictures\'+dirinfo.name,pi^);
      uncompress(pi^,ptr($a000,0)^);
      move(ptr($a000,0)^,pi^,64000);

      slidewc(pi^,ptr($a000,0)^,64000,10);
      move(ptr($a000,0)^,pi^,compresssize);

      slidewc(pi^,ptr($a000,0)^,compresssize,8);
      move(ptr($a000,0)^,pi^,compresssize);

      huffmanc(pi^,ptr($a000,0)^,compresssize);
      move(ptr($a000,0)^,po^,compresssize);
      assign(f,'pictures\'+copy(dirinfo.name,1,pos('.',dirinfo.name)-1)+'.lc6');
      rewrite(f,1);
      blockwrite(f,po^,compresssize);
      close(f);
      unpacktime(dirinfo.time,dt);
      writeln(dirinfo.name:12,dirinfo.size:8,' ',dt.month,'/',dt.day,'/',dt.year,' ',dt.hour,':',dt.min,':',dt.sec);
      findnext(dirinfo);
    end
  else writeln('no more files.');
  goaway;
  asm
    int 1ch
  end;
  vgamode(mtext);
  findfirst('pictures\*.lc6',archive,dirinfo);
  findfirst('pictures\*.lc5',archive,dirinfo2);
  c:=0;
  if doserror=0 then
    while doserror=0 do
    begin
      unpacktime(dirinfo.time,dt);
      writeln(dirinfo.name:12,dirinfo.size:8,' ',dt.month,'/',dt.day,'/',dt.year,' ',dt.hour,':',dt.min,':',dt.sec);
      findnext(dirinfo);
      unpacktime(dirinfo2.time,dt);
      writeln(dirinfo2.name:12,dirinfo2.size:8,' ',dt.month,'/',dt.day,'/',dt.year,' ',dt.hour,':',dt.min,':',dt.sec);
      findnext(dirinfo2);
      inc(c);
      if c>11 then begin readkey;c:=0;end;
    end
  else writeln('no more files.');
  readkey;
end.