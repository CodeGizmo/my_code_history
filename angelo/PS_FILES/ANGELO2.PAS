uses crt,printer;
var size,myofs,fontsize,xinc,code,
    xf,yf,xp,yp,linespace,linenum       :word;
    f                                   :file;
    filename                            :string;
    p                                   :pointer;
    d                                   :boolean;

type myptr=array[0..65000]of byte;

procedure message;
begin
  textcolor(8);
  gotoxy(67,25);write('by: A. L. L.');
  textcolor(14);gotoxy(1,1);
  write('Welcome to my wondered printing program for ');
  textcolor(10);
  writeln('LaserWriter Select.');
  textcolor(14);
  writeln('Created on Sun, May 29, 1994 at about 7:31 PM');
  gotoxy(1,25);
end;

function wtos(w:word):string;
var s:string;
    r:byte;
begin
  s:='';
  repeat
    r:=w mod 10;
    if w>0 then
    begin
      s:=char(r+ord('0'))+s;
      w:=w div 10;
    end;
  until w=0;
  wtos:=s;
end;

procedure print;
var n:word;
begin
  repeat
  xp:=xf; yp:=yf;

  writeln(lst,'/Helvetica findfont');
{  if d then writeln('/Helvetica findfont');}
  writeln(lst,wtos(fontsize),' scalefont setfont');
{  if d then writeln(wtos(fontsize),' scalefont setfont');}
  writeln(lst,wtos(xf),' ',wtos(yf),' moveto');
{  if d then writeln(wtos(xf),' ',wtos(yf),' moveto');}
  repeat
  repeat
    write(lst,'(',wtos(linenum):3,']   ');
    if d then write('(',wtos(linenum):3,']   ');
    inc(linenum);
    while (myptr(p^)[myofs]<>13)and(myofs<size) do
    begin
      write(lst,char(myptr(p^)[myofs]));
      if d then write(char(myptr(p^)[myofs]));
      inc(myofs);
    end;
    inc(myofs,2);
{    delay(100);}
    writeln(lst,') show');
    if d then writeln(') show');
    yp:=yp-linespace;
    if (myofs<size)and(yp>=30)then
    begin
      writeln(lst,wtos(xp),' ',wtos(yp),' moveto');
{      if d then writeln(wtos(xp),' ',wtos(yp),' moveto');}
    end;
  until (yp<40+fontsize)or(myofs>=size);
  yp:=yf;
  xp:=xp+xinc;
  until (xp+xinc>580)or(myofs>=size);
  xp:=xf;
  writeln(lst,'showpage');
{  if d then writeln('showpage');}
  until (myofs>=size)or(xf+xinc>580);
end;

procedure pinit;
begin
  xf:=30;
  xp:=xf;
  yf:=758;
  yp:=yf;
  myofs:=0;
  linespace:=fontsize+1;
  linenum:=1;
  xinc:=45*fontsize;
end;

procedure load(filename:string);
begin
  assign(f,filename);
  reset(f,1);
  size:=filesize(f);
  blockread(f,p^,size);
  close(f);
end;

begin
  if paramcount>=1 then
  begin
    clrscr;
    message;
    if paramcount=1 then fontsize:=12 else val(paramstr(2),fontsize,code);
    getmem(p,65535);
    load(paramstr(1));
    if paramcount>2 then d:=paramstr(3)='d';
    pinit;
    print;
  end;
  clrscr;
end.

