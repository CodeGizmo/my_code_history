UNIT Graphstr;{GRAPHICS_STRING_MANIPULATION;}
uses vgaliza;
var winx1,winx2,winy1,winy2     :integer;
var framemode:word;
var
  charw,charh:word;
  textx,texty:word;
  charinstalled:boolean;
  mychar:array[0..255]of pointer;
var tempptr:pointer;
procedure putchar(c:byte);
begin
  if charinstalled then
  begin
    case c of
      8:begin
          if textx=winx1 then
          begin
            texty:=texty-charh;
            textx:=((winx2+1) div charw)*charw;
          end;
          textx:=textx-charw;
          putthis(textx,texty,mychar[20]^,0);
        end;
    else repeat
           putthis(textx,texty,mychar[c]^,0);
           textx:=textx+charw;
           if (textx+charw-1>winx2){or(c=13)}then
           begin
             textx:=winx1;
             texty:=texty+charh;
             if (texty+charh-1>winy2)then
             begin
               {if memavail>((winx2-winx1+1)*(winy2-winy1+1)+4)then
               begin
                 getmem(tempptr,(winx2-winx1+1)*(winy2-winy1+1)+4);
                 getthis(winx1,winy1+charh,winx2,winy2,tempptr^);
                 putthis(winx1,winy1,tempptr^,0);
                 freemem(tempptr,(winx2-winx1+1)*(winy2-winy1+1)+4);
               end;
               begin
               end;
               texty:=texty-charh;}
               texty:=winy1;
             end;
           end;
         until (c<>13)or(textx=winx1);
    end;
  end;
end;

procedure putchar2(c:byte);
begin
  if charinstalled then
  begin
    repeat
      putthis(textx,texty,mychar[c]^,0);
      textx:=textx+charw;
      if textx+charw-1>winx2 then
      begin
        textx:=winx1;
        texty:=texty+charh;
      end;
    until (c<>13)or(textx=winx1);
  end;
end;

procedure putstring(s:string);
begin
  for a:=1 to byte(s[0])do
  begin
    if s[a]=#13 then
    begin
      while textx>winx1 do putchar(byte(' '))
    end else putchar(byte(s[a]));
  end;
end;

procedure loadchar(s:string);
var f:file;
begin
  if s='' then
  begin
    s:='mychar.chr';
  end;
  if charinstalled then for a:=0 to 255 do freemem(mychar[a],(charw)*(charh)+2);
  assign(f,s);
  reset(f,1);
  blockread(f,charw,2);
  charh:=charw div 256;
  charw:=charw mod 256;
  if charh*charw<256 then
  for a:=0 to 255 do
  begin
    getmem(mychar[a],charw*charh+2);
    blockread(f,ptr(seg(mychar[a]^),ofs(mychar[a]^)+2)^,charw*charh);
    memw[seg(mychar[a]^):ofs(mychar[a]^)]:=320*(charh-1)+charw-1;
  end;
  close(f);
  charinstalled:=true;
end;

procedure savechar(s:string);
var f:file;
    equiv:word;
begin
  if charw*charh<256 then
  begin
    assign(f,s);
    rewrite(f,1);
    equiv:=charh*256+charw;
    blockwrite(f,equiv,2);
    for a:=0 to 255 do
    begin
      blockwrite(f,ptr(seg(mychar[a]^),ofs(mychar[a]^)+2)^,charw*charh);
    end;
    close(f);
  end;
end;

procedure renewchar(w,h:byte);
begin
  if w*h<256 then
  begin
    for a:=0 to 255 do
    begin
      if charinstalled then freemem(mychar[a],charw*charh+2);
      getmem(mychar[a],w*h+2);
      memw[seg(mychar[a]^):ofs(mychar[a]^)]:=(charh shl 8)+charw;
    end;
    charw:=w;charh:=h;
  end;
  charinstalled:=true;
end;

procedure window(x1,y1,x2,y2:word);
var dum:integer;
begin
  if x1>x2 then begin dum:=x1;x1:=x2;x2:=dum;end;
  if y1>y2 then begin dum:=y1;y1:=y2;y2:=dum;end;
  begin
    if x1<minx then x1:=minx;
    if x2>maxx then x2:=maxx;
    if y1<miny then y1:=miny;
    if y2>maxy then y2:=maxy;
  end;
  winx1:=x1;
  winx2:=x2;
  winy1:=y1;
  winy2:=y2;
  textx:=x1;
  texty:=y1;
end;{window}


procedure frame(x1,y1,x2,y2:integer;th,tv,c1,c2,c3:byte);
var lym:byte;
    dum:integer;
begin
  if x1>x2 then begin dum:=x1;x1:=x2;x2:=dum;end;
  if y1>y2 then begin dum:=y1;y1:=y2;y2:=dum;end;
  if yeymode>127 then
  begin
    if x1<minx then x1:=minx;
    if x2>maxx then x2:=maxx;
    if y1<miny then y1:=miny;
    if y2>maxy then y2:=maxy;
  end;
  lym:=yeymode;
  yeymode:=yeymode or 128;
  bar (x1  -tv,y1  -th,x2  +tv,y2  +th,c2);
  if framemode>0 then
  begin
    line(x1-1-tv,y1-1-th,x2  +tv,y1-1-th,c1);
    line(x1-1-tv,y1-1-th,x1-1-tv,y2  +th,c1);
    line(x1-1-tv,y2+1+th,x2+1+tv,y2+1+th,c3);
    line(x2+1+tv,y1-1-th,x2+1+tv,y2+1+th,c3);
  end;
  if framemode>1 then
  begin
    line(x1-2,y1-2,x2+2,y1-2,c3);
    line(x1-2,y2+2,x2+1,y2+2,c1);
    line(x2+2,y1-2,x2+2,y2+2,c1);
    line(x1-2,y1-2,x1-2,y2+1,c3);
  end;
  if framemode>2 then
  begin
    line(x1-1,y1-1,x2+1,y1-1,c1);
    line(x1-1,y2+1,x2+1,y2+1,c3);
    line(x2+1,y1-1,x2+1,y2+1,c3);
    line(x1-1,y1-1,x1-1,y2  ,c1);
  end;
  yeymode:=lym;
end;{frame}

{*********************************************}

function extostr(x:extended):string;
var s:string;
begin
  str(x,s);
  extostr:=s;
end;

procedure centerwrite(y:integer;s:string);
begin
  gotoxy(40-(length(s)-1)div 2,y);
  write(s)
end;

procedure centerread(y:integer;var x:extended);
var s:string;
    d:integer;
begin
  s:='';
  frameout(36,y,45,y);
  centerwrite(y,s);
  ch:=readkey;
  while ch<>#13 do
  begin
    if (ch=#8)and(length(s)>0)then
      begin
        frameclear(40-(length(s)-1)div 2,y,40+length(s)div 2,y);
        delete(s,length(s),1)
      end
      else if (length(s)<76)and((ch in['0'..'9'])or((ch='.')and(pos('.',s)=0)))then s:=s+ch;
    if length(s)>10 then frameout(40-(length(s)-1)div 2,y,40+length(s)div 2,y)
      else  frameout(36,y,45,y);
    centerwrite(y,s);
    ch:=readkey;
  end;
  val(s,x,d);
end;

procedure printscreen(s:string);
var f:file;
    p:pointer;
    a,b:integer;
type
  myptr=array[0..5000]of byte;
begin
  getmem(p,4000);
  assign(f,s);
  rewrite(f,1);
  for a:=0 to 24 do
  begin
    for b:=0 to 79 do
    begin
      myptr(p^)[b]:=mem[$b800:b*2+a*160];
    end;
    myptr(p^)[80]:=13;
    myptr(p^)[81]:=10;
    blockwrite(f,p^,82);
  end;
  close(f);
end;


