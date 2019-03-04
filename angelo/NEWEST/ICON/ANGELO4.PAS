uses crt,printer;
var myofs,fontsize,xinc,code,
    xf,yf,xp,yp,linespace,linenum       :word;
    f                                   :file;
    filename                            :string;
    p                                   :pointer;
    d,nosl                              :boolean;
    size,seekpos,sizeremain,sizetoread  :longint;
    sl                                  :word;


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

procedure loadnext;forward;

procedure print;
var n:word;
    parenthesis:integer;
begin
  repeat
  xp:=xf; yp:=yf;
  if nosl or (linenum>=sl) then
  begin
    writeln(lst,'/Helvetica-Bold findfont');
   {  if d then writeln('/Helvetica findfont');}
    writeln(lst,wtos(fontsize),' scalefont setfont');
   {  if d then writeln(wtos(fontsize),' scalefont setfont');}
    writeln(lst,wtos(xf),' ',wtos(yf),' moveto');
   {  if d then writeln(wtos(xf),' ',wtos(yf),' moveto');}
  end;
{  repeat}
{  repeat}
    if nosl or (linenum>=sl) then
    write(lst,'( ',wtos(linenum):3,']   ');
    parenthesis:=0;
    if d then write('(',wtos(linenum):3,']   ');
    inc(linenum);
    while (myptr(p^)[myofs]<>13)and(myofs<size) do
    begin
      if char(myptr(p^)[myofs])='('then inc(parenthesis)
        else if char(myptr(p^)[myofs])=')'then
        begin
          if parenthesis=0 then
          begin if nosl or (linenum>sl) then write(lst,'(') end
            else dec(parenthesis);
        end;
      if nosl or (linenum>sl) then
      write(lst,char(myptr(p^)[myofs]));
      if d then write(char(myptr(p^)[myofs]));
      inc(myofs);
    end;
    inc(myofs,2);
{    delay(100);}
    if nosl or (linenum>sl) then
    begin
      if parenthesis>0 then for parenthesis:=1 to parenthesis do write(lst,')');
      writeln(lst,') show');
    end;
    if d then writeln(') show');
    yp:=yp-linespace;
    if (myofs<size)and(yp>=30)then
    begin
      if nosl or (linenum>sl) then
      writeln(lst,wtos(xp),' ',wtos(yp),' moveto');

{      if d then writeln(wtos(xp),' ',wtos(yp),' moveto');}
    end;
    if (myofs>=sizetoread)and(sizeremain>0)then begin loadnext;myofs:=0;end;
{  until (yp<40+fontsize)or(myofs>=sizetoread);}
  yp:=yf;
  xp:=xp+xinc;
{  until (xp+xinc>580)or(myofs>=sizetoread);}
  xp:=xf;
  if nosl or (linenum>sl) then  writeln(lst,'showpage');
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
  if size>65530 then
  begin
    sizetoread:=65530;
    sizeremain:=size-sizetoread;
    blockread(f,p^,sizetoread);
  end else
  begin
    sizeremain:=0;
    blockread(f,p^,size);
    close(f);
  end;
end;

procedure loadnext;
begin
  if sizeremain>65530 then
  begin
    sizetoread:=65530;
    sizeremain:=sizeremain-sizetoread;
    blockread(f,p^,sizetoread);
  end else
  begin
    blockread(f,p^,sizeremain);
    close(f);
    sizeremain:=0;
  end;
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
    if paramcount>3 then begin nosl:=false;val(paramstr(4),sl,code);end else nosl:=true;
    pinit;
    print;
  end;
  clrscr;
end.

