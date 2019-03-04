uses crt;
var
  f,fout:file;
  p:pointer;
  o,s:word;
  a,b,c,d:word;
  max,x,y:word;
  mydelay,rapid:byte;
type
  myptr=array[0..65500]of byte;

var
  on,off:byte;
  qualvol:array[0..8192]of byte;
  fader,fade,outcomevol:byte;
  beat,counter,pos:word;

procedure tring;
begin
  for pos:=0 to max shr 2do
  begin
    for a:=0 to mydelay do
    begin
      outcomevol:=myptr(p^)[pos shl 2+1]shr rapid;
      port[$61]:=on;
      for beat:=0 to outcomevol do;
      port[$61]:=off;
      for beat:=outcomevol to 256shr rapid  do;
    end;
{    blockwrite(fout,myptr(p^)[pos shl 2+1],1);}
{    if (pos and $ff)=$ff then
    begin
      gotoxy(1,y);
      for x:=1 to outcomevol shr 2 do write('o');
      for x:=outcomevol shr 2  to 80 do write(' ');
    end;}
  end;
end;

var code:integer;
begin
  if paramcount>0 then
  begin
    y:=wherey;
    rapid:=0;
    mydelay:=0;
    if paramcount>1 then val(paramstr(2),mydelay,code);
    if paramcount>2 then val(paramstr(3),rapid,code);
    on:=port[$61]or 2;
    off:=port[$61]and not(3);
    getmem(p,65535);
    assign(f,'he.wav'{paramstr(1)});
{    assign(fout,'he.wav');
    rewrite(fout,1);}
    reset(f,1);
    max:=64000;
    if filesize(f)<64000 then max:=filesize(f);
    repeat
      blockread(f,p^,max);
      tring;
      if (filesize(f)-filepos(f))<max then
      begin
        max:=filesize(f)-filepos(f);
      end;
    until (keypressed)or(filepos(f)>=filesize(f));
    close(f);
{    close(fout);}
  end else
  begin
    clrscr;
    Writeln('Wave Player Version 1.00');
    writeln('Created by: Angelo Lian Lanuza');
    writeln('Created on: Thursday, November 24, 1994');
    writeln('My Address: 234 Purple Rd., Canaynay Court Subd., Las Pinas, M.M.');
    writeln;
    writeln('Syntax:   WAVEPLAY filename [delay] [rapid]');
    writeln;
    writeln('Example:  WAVEPLAY voice.wav 0 1');
    writeln('          WAVEPLAY new.wav');
    writeln('          WAVEPLAY new2.wav 1');
    writeln;
    writeln('note: delay - decreases the speed by 2 raised to [delay].');
    writeln('              default is 0.');
    writeln('      rapid - increases the speed by 2 raised to [rapid].');
    writeln('              default is 0.');
    writeln;
    writeln('     Wave files are usually played only on a PC that has a sound card.');
    writeln('But, using this software of mine can let you play the wave files in an');
    writeln('ordinary PC speaker.');
  end;
end.
