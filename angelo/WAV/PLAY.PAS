uses crt;
var
  f:file;
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
  fader,fade:byte;
  outcomevol,beat,counter,pos:word;

procedure tring;
begin
  for pos:=0 to max do
  begin
    for a:=0 to mydelay shr 1 do
    begin
      outcomevol:=myptr(p^)[pos]shr rapid shl (mydelay shr 1);
      port[$61]:=on;
      for beat:=0 to outcomevol do;
      port[$61]:=off;
      for beat:=outcomevol to 256 shr rapid shl (mydelay shr 1) do;
    end;
    if (pos and $1ff)=$1ff then
    begin
      for x:=0 to outcomevol shr 2 do
        mem[$b800:x shl 1]:=byte('o');
      for x:=x+1 to 80 do
        mem[$b800:x shl 1]:=byte(' ');
    end;
  end;
end;

var code:integer;
begin
  clrscr;
  if paramcount>0 then
  begin
    rapid:=0;
    mydelay:=0;
    if paramcount>1 then val(paramstr(2),mydelay,code);
    if paramcount>2 then val(paramstr(3),rapid,code);
    on:=port[$61]or 2;
    off:=port[$61]and not(3);
    getmem(p,65535);
    assign(f,paramstr(1));
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
    writeln('note: delay - decreases the speed by x[delay].');
    writeln('              default is 0.');
    writeln('      rapid - increases the speed by 2 raised to [rapid].');
    writeln('              default is 0.');
    writeln;
    writeln('     Wave files are usually played only on a PC that has a sound card.');
    writeln('But, using this software of mine can let you play the wave files in an');
    writeln('ordinary PC speaker.');
  end;
end.
