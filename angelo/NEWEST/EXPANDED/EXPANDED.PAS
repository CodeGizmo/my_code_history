uses crt;
var
  bdummy        :byte;
  wdummy        :word;
  availpages,
  totalpages    :word;
  availblocks,
  totalblocks   :word;
  availexp,
  totalexp      :longint;
  availext,
  totalext      :longint;
  expseg        :word;

procedure getexpandedinfo;
begin
  asm
    mov ah,41h
    int 67h
    mov expseg,bx
    mov ah,42h
    int 67h
    mov availpages,bx
    mov totalpages,dx

    mov ax,0800h
    int 2fh
    mov availblocks,ax
    mov totalblocks,dx
  end;
  availexp:=longint(availpages)*16384;
  totalexp:=longint(totalpages)*16384;
  availext:=longint(availblocks)*1024;
  totalext:=longint(totalblocks)*1024;
end;

function to_base(d,N:word):string;
var s,base:string;
begin
  if (n>16)or(n<=1)then to_base:='invalid base'
  else
  begin
    s:='';
    base:='0123456789ABCDEF';
    repeat
      s:=base[1+(d mod n)]+s;
      d:=d div n;
    until d=0;
    to_base:=s;
  end;
end;

procedure showexpandedinfo;
begin
  getexpandedinfo;
  writeln('Available pages:',availpages:6);
  writeln('Total pages    :',totalpages:6);
  writeln;
  writeln('Available blocks:',availblocks:6);
{  writeln('Total blocks    :',totalblocks:6);}
  writeln;
  writeln('Available expanded memory:',availexp:10,' bytes');
  writeln('Total expanded memory    :',Totalexp:10,' bytes');
  writeln;
  writeln('Available extended memory:',availext:10,' bytes');
{  writeln('Total extended memory    :',Totalext:10,' bytes');}
  writeln;
  writeln('Page Frame Segment Address: ',to_base(expseg,16));
  readkey;
end;

begin
  clrscr;
  showexpandedinfo;
end.