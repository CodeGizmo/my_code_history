program Drawing_Kit;
uses newint09,vgaliz,crt;
var
  dumbyte,dumbyte2              :byte;
  dumword,dumword2              :word;
  c,lcc,paint                   :byte;
  x,y,lx,ly,x1,y1,x2,y2         :integer;
{  miny,maxy,minx,maxx           :word;}
  ch                            :byte;
  p,pen,boxp,getp               :pointer;
  boxseg,boxofs                 :word;
  bigx,bigy                     :word;

procedure beep;
begin
{  sound(500);
  delay(100);
  nosound;}
end;{beep}

var cur_pos:word;
procedure boxsave(x1,y1,x2,y2:word);
begin
  cur_pos:=0;
  if x1>x2 then begin dumword:=x1;x1:=x2;x2:=dumword end;
  if y1>y2 then begin dumword:=y1;y1:=y2;y2:=dumword end;
  for dumword:=x1 to x2 do begin
    mem[boxseg:boxofs+cur_pos]:=yeyun(dumword,y1);
    inc(cur_pos); end;
  for dumword:=y1 to y2 do begin
    mem[boxseg:boxofs+cur_pos]:=yeyun(x2,dumword);
    inc(cur_pos); end;
  for dumword:=x2 downto x1 do begin
    mem[boxseg:boxofs+cur_pos]:=yeyun(dumword,y2);
    inc(cur_pos); end;
  for dumword:=y2 downto y1 do begin
    mem[boxseg:boxofs+cur_pos]:=yeyun(x1,dumword);
    inc(cur_pos); end;
end;{boxsave}

procedure boxrestore(x1,y1,x2,y2:word);
begin
  cur_pos:=0;
  if x1>x2 then begin dumword:=x1;x1:=x2;x2:=dumword end;
  if y1>y2 then begin dumword:=y1;y1:=y2;y2:=dumword end;
  for dumword:=x1 to x2 do begin
    yeyan(dumword,y1,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos); end;
  for dumword:=y1 to y2 do begin
    yeyan(x2,dumword,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos); end;
  for dumword:=x2 downto x1 do begin
    yeyan(dumword,y2,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos); end;
  for dumword:=y2 downto y1 do begin
    yeyan(x1,dumword,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos); end;
end;{boxrestore}

var cur_cpat    :word;
    cur_fc      :byte;
    cur_dot     :shortint;
procedure boxer(x1,y1,x2,y2:word);
begin
  cur_cpat:=cur_fc shl 2;
  cur_pos:=0;
  if (cur_dot>3)or(cur_dot<0)then cur_dot:=0;
  if x1>x2 then begin dumword:=x1;x1:=x2;x2:=dumword end;
  if y1>y2 then begin dumword:=y1;y1:=y2;y2:=dumword end;
  for dumword:=x1 to x2 do
  begin
    if(cur_cpat and 3)=cur_dot then yeyan(dumword,y1,cur_cpat shr 2)
      else yeyan(dumword,y1,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos);
    inc(cur_cpat);
  end;
  for dumword:=y1 to y2 do
  begin
    if(cur_cpat and 3)=cur_dot then yeyan(x2,dumword,cur_cpat shr 2)
      else yeyan(x2,dumword,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos);
    inc(cur_cpat);
  end;
  for dumword:=x2 downto x1 do
  begin
    yeyan(dumword,y2,cur_cpat shr 2);
    if(cur_cpat and 3)=cur_dot then yeyan(dumword,y2,cur_cpat shr 2)
      else yeyan(dumword,y2,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos);
    inc(cur_cpat);
  end;
  for dumword:=y2 downto y1 do
  begin
    yeyan(x1,dumword,cur_cpat shr 2);
    if(cur_cpat and 3)=cur_dot then yeyan(x1,dumword,cur_cpat shr 2)
      else yeyan(x1,dumword,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos);
    inc(cur_cpat);
  end;
  if cur_dot=0 then
  begin
    inc(cur_fc);
    cur_dot:=3;
  end else dec(cur_dot);
end;{boxer}

procedure putpen;
begin
  if x<160 then
  if y<100 then
  begin
    yeyan(x,y,15);
    line(x+1,y+1,x+4,y+4,c);
    line(x+1,y,x+6,y+5,14);
    line(x,y+1,x+5,y+6,14);
    line(x+4,y+5,x+5,y+4,12);
    line(x+5,y+6,x+6,y+5,12);
    yeyan(x+5,y+5,12);
  end else
  begin
    yeyan(x,y,15);
    line(x+1,y-1,x+4,y-4,c);
    line(x+1,y,x+6,y-5,14);
    line(x,y-1,x+5,y-6,14);
    line(x+4,y-5,x+5,y-4,12);
    line(x+5,y-6,x+6,y-5,12);
    yeyan(x+5,y-5,12);
  end else if y>100 then
  begin
    yeyan(x,y,15);
    line(x-1,y-1,x-4,y-4,c);
    line(x-1,y,x-6,y-5,14);
    line(x,y-1,x-5,y-6,14);
    line(x-4,y-5,x-5,y-4,12);
    line(x-5,y-6,x-6,y-5,12);
    yeyan(x-5,y-5,12);
  end else
  begin
    yeyan(x,y,15);
    line(x-1,y+1,x-4,y+4,c);
    line(x-1,y,x-6,y+5,14);
    line(x,y+1,x-5,y+6,14);
    line(x-4,y+5,x-5,y+4,12);
    line(x-5,y+6,x-6,y+5,12);
    yeyan(x-5,y+5,12);
  end;
end;{putpen}

var l,m,r,ll,lm,lr              :boolean;
    bot,lbot,botcount           :byte;
    mybot                       :array[0..255]of byte;
    cancel                      :boolean;
procedure giveme;
begin
  if bot=0 then botcount:=0;
  lbot:=bot;
  ll:=l;lm:=m;lr:=r;
  asm
    mov  ax,3
    int  33h
    mov  bot,bl
  end;
  l:=bot and 1=1;
  r:=bot and 2=2;
  m:=bot and 4=4;

  if (lbot<>bot)and(botcount<250)then
  begin
    if (ll<>l)and l then
    begin
      inc(botcount);
      mybot[botcount]:=1;
    end;
    if (lm<>m)and m then
    begin
      inc(botcount);
      mybot[botcount]:=2;
    end;
    if (lr<>r)and r then
    begin
      inc(botcount);
      mybot[botcount]:=3;
    end;

    if (bot=0)and(lr=true)then cancel:=true else cancel:=false;
  end;
end;

procedure addmousemove;
begin
  lx:=x;ly:=y;
  asm
    mov  ax,0bh
    int  33h
    add  x,cx
    add  y,dx
    cmp  x,319
    jle  @a1
    mov  x,319
    jmp  @a2
@a1:cm;
      end;
      if (lr<>r)and r then
      begin
        inc(botcount);
        mybot[botcount]:=3;
      end;

      if (bot=0)and(lr=true)then cancel:=true else cancel:=false;
    end;
  end;
end;

procedure addmousemove;
const miceres=5;
begin
  if mouseon then
  begin
    lx:=x;ly:=y;
    asm
      mov  ax,0bh
      int  33h
      add  micex,cx
      add  micey,dx
      cmp  micex,319*miceres
      jle  @a1
      mov  micex,319*miceres
      jmp  @a2
  @a1:cmp  micex,0
      jge  @a2
      mov  micex,0
  @a2:cmp  micey,399*miceres
      jle  @a3
      mov  micey,399*miceres
      jmp  @a4
  @a3:cmp  micey,0
      jge  @a4
      mov  micey,0
  @a4:
    end;
    x:=micex div miceres;
    y:=micey div miceres;
  end;
end;{addmousemove}

var showposmeth:byte;
procedure showpos;
var
  a,c:byte;
begin
  if showposmeth=1 then
  begin
        if x<160 then
          if y<100 then getthis(x,y,x+6,y+6,pen^)
          else getthis(x,y-6,x+6,y,pen^)
        else if y>100 then getthis(x-6,y-6,x,y,pen^)
          else getthis(x-6,y,x,y+6,pen^);
        putpen;
        delay(10);
        if x<160 then
          if y<100 then putthis(x,y,pen^,0)
          else putthis(x,y-6,pen^,0)
        else if y>100 then putthis(x-6,y-6,pen^,0)
          else putthis(x-6,y,pen^,0);
  end else
  if showposmeth=2 then
  begin
    lcc:=yeyun(x,y);
    for dumbyte:=0 to 255  do
    begin
      inc(lcc);
      yeyan(x,y,lcc);
    end;
  end;
end;{showpos}

var f:string;
procedure obeyload;
begin
  goaway;
  gotoxy(1,1);write('filename ');
  readln(f);
  aload('pictures\'+f,p^);
  putthis(0,0,p^,0);
  gotomyint9;
end;{obeyload}

procedure obeysave;
begin
  goaway;
  getthis(0,0,319,199,p^);
  gotoxy(1,1);write('filename ');
  readln(f);
  asave('pictures\'+f,p^,65000);
  putthis(0,0,p^,0);
  gotomyint9;
end;{obeysave}

var mygmis:byte;
procedure zipperns;
begin
  goaway;
  compress(ptr(pseg,pofs)^,p^);
  gotoxy(1,1);write('filename ');
  readln(f);
  lizsave('pictures\'+f,p^);
  uncompress(p^,ptr(pseg,pofs)^);
  if gmis in[2,3] then
  begin
    mygmis:=gmis;
    gmis:=1;
    get(0,0,319,199,p^);
    gmis:=mygmis;
    put(0,0,p^);
  end;
  gotomyint9;
end;{zipperns}

procedure unzipperns;
begin
  goaway;
  gotoxy(1,1);write('filename ');
  readln(f);
  aload('pictures\'+f,p^);
  uncompress(p^,ptr(pseg,pofs)^);
  if gmis in[2,3] then
  begin
    mygmis:=gmis;
    gmis:=1;
    getthis(0,0,319,199,p^);
    gmis:=mygmis;
    putthis(0,0,p^,0);
  end;
  gotomyint9;
end;{unzipperns}

procedure zipperns2;
begin
  goaway;
  implode(ptr(pseg,pofs)^,p^);
  gotoxy(1,1);write('filename ');
  readln(f);
  lizsave('pictures\'+f,p^);
  explode(p^,ptr(pseg,pofs)^);
  if gmis in[2,3] then
  begin
    mygmis:=gmis;
    gmis:=1;
    get(0,0,319,199,p^);
    gmis:=mygmis;
    put(0,0,p^);
  end;
  gotomyint9;
end;{zipperns}

procedure unzipperns2;
begin
  goaway;
  gotoxy(1,1);write('filename ');
  readln(f);
  aload('pictures\'+f,p^);
  explode(p^,ptr(pseg,pofs)^);
  if gmis in[2,3] then
  begin
    mygmis:=gmis;
    gmis:=1;
    get(0,0,319,199,p^);
    gmis:=mygmis;
    put(0,0,p^);
  end;
  gotomyint9;
end;{unzipperns}

var
  script:array[1..255]of byte;
  firstfilm,lastfilm:byte;
  xsize,ysize:byte;
  direction:boolean;
  xinc,yinc:integer;
  xbpos,ybpos:integer;

procedure obey_editani;{***********************************}
begin
  goaway;
  getthis(0,0,319,199,p^);
  repeat
    gotoxy(1,1);clreol;
    write('what? ');
    readln(f);
    if f='h'then
    begin
      gotoxy(1,1);
      writeln('h - for help');
      writeln('f - for firstfilm');
      writeln('l - for lastfilm');
      writeln('d - for delay');

    end;
    if f='f'then
    begin
      gotoxy(1,1);clreol;
      write('Enter firstfilm');
      readln(firstfilm);
      if firstfilm>160 then firstfilm:=160;
      if firstfilm>lastfilm then direction:=false else direction:=true;
    end;
    if f='l'then
    begin
      gotoxy(1,1);clreol;
      write('Enter lastfilm');
      readln(lastfilm);
      if firstfilm>lastfilm then direction:=false else direction:=true;
    end;
    if f='d'then
    begin
      gotoxy(1,1);clreol;
      write('Starting from what film');
      readln(dumbyte);
      write('Ending at what film');
      readln(dumbyte2);
      write('How much delay do you want?(a delay is 1/1000 of a second) ');
      readln(dumword);
      for dumword2:=dumbyte to dumbyte2 dod;
  end;
end;{line}

procedure obeyenlarge;
begin
  getthis(0,0,319,199,p^);
  boxsave(x,y,79+x,49+y);
  boxer(x,y,79+x,49+y);
  repeat
    addmousemove;
    if x+79>maxx then x:=maxx-79;
    if y+49>maxy then y:=maxy-49;
    giveme;
    if(lx<>x)or(ly<>y)then
    begin
      boxrestore(lx,ly,79+lx,49+ly);
      boxsave(x,y,79+x,49+y);
    end;
    boxer(x,y,x+79,y+49);
  until l or r;
  boxrestore(lx,ly,x+79,y+49);

  if l then
  begin
    gseg:=seg(p^);
    gofs:=2;
    bigx:=x;bigy:=y;
    for dumword:=0 to 79 do
    for dumbyte:=0 to 49 do
    for dumword2:=0 to 3 do
    for dumbyte2:=0 to 3 do
      if (dumword2<>3)and(dumbyte2<>3)then
        yeyan(dumword2+(dumword shl 2),dumbyte2+(dumbyte shl 2),yeyun(bigx+dumword+2,bigy+dumbyte))
        else yeyan(dumword2+(dumword shl 2),dumbyte2+(dumbyte shl 2),0);
    movebar(0,0,79,49,bigx,bigy);
    gseg:=$a000;
    repeat
{      addmousemove;}
      giveme;
{      if(bot=1)and((lx<>x)or(ly<>y))and(botcount=1)then bigline(lx,ly,x,y,c)
        else if (botcount=1)and(bot=0)and(lbot=1)then bigyeyan(x,y,c);
      showpos;}
    until r;
  while bot<>0 do giveme;
  gseg:=$a000;
  putthis(0,0,p^,0);
  end;
end;{obeyenlarge}

procedure obeyget;
begin
  getspace;
  if ll=true then getthis(x1,y1,x2,y2,getp^);
end;{obeyget}

procedure obeyput;
begin
  getthis(0,0,319,199,p^);
  putthis(x,y,getp^,0);
  repeat
    addmousemove;
    giveme;
    if(lx<>x)or(ly<>y)then begin putthis(0,0,p^,0);putthis(x,y,getp^,0)end;
  until l or r;
  if r then putthis(0,0,p^,0);
  while bot<>0 do giveme;
end;{obeyput}

procedure getcolorcommand;
var a,b:word;
begin
  getthis(0,0,319,199,p^);
  for a:=0 to 31 do
    for b:=0 to 7 do
    begin
      bar(1+a shl 3,1+b shl 3,a shl 3+6,b shl 3+6,b*32+a);
      box(a shl 3,b shl 3,a shl 3+7,b shl 3+7,0);
    end;
  repeat
    giveme;
    addmousemove;
    if l then
    begin
      if (x<256)and(y<64)then
      begin
        box(a shr 3 shl 3,b shr 3 shl 3,a shr 3 shl 3+7,b shr 3 shl 3+7,0);
        a:=x;b:=y;
        box(x shr 3 shl 3,y shr 3 shl 3,x shr 3 shl 3+7,y shr 3 shl 3+7,8{x shr 3+(y shr 3)*32});
        c:=x shr 3+(y shr 3)*32;
      end;
    end;
    showpos;
  until(key=1)or(r);
  key:=0;
  putthis(0,0,p^,0);
end;{getcolorcommand}

procedure getmovecommand;
begin
  asm
    cli
  end;
  if(mykey[$47]or mykey[$48]or mykey[$49])<>0 then begin dec(y);rkey:=0;
          if y<miny then begin y:=miny;beep end end;
  if(mykey[$4f]or mykey[$50]or mykey[$51])<>0 then begin inc(y);rkey:=0;
          if y>maxy then begin y:=maxy;beep end end;
  if(mykey[$47]or mykey[$4b]or mykey[$4f])<>0 then begin dec(x);rkey:=0;
          if x<minx then begin x:=minx;beep end end;
  if(mykey[$49]or mykey[$4d]or mykey[$51])<>0 then begin inc(x);rkey:=0;
          if x>maxx then begin x:=maxx;beep end end;
  asm
    sti
  end;
end;{getmovecommand}

var
  rcount:byte;
procedure fetchmouse;
begin
  addmousemove;
  giveme;
  if(bot=1)and((lx<>x)or(ly<>y))and(botcount=1)then line(lx,ly,x,y,c)
    else if (botcount=1)and(bot=0)and(lbot=1)then yeyan(x,y,c);
  if(botcount=2)and((lx<>x)or(ly<>y))and(mybot[1]=1)and(mybot[2]=2)then
    filler(x,y,c)else if(botcount=2)and(mybot[1]=1)and(mybot[2]=2)
                        and(bot=0)then filler(x,y,c);
  if bot=0 then
  begin
    if (botcount=1) and lm then c:=yeyun(x,y);
    if (botcount=3) and (mybot[1]=3)and(mybot[2]=2)and(mybot[3]=1)then clear;
    if (botcount=2) and (mybot[1]=3)and(mybot[2]=1)then getcolorcommand;
    if (botcount=2) and (mybot[1]=2)and(mybot[2]=3)then obeyget;
    if (botcount=2) and (mybot[1]=2)and(mybot[2]=1)then obeyput;
    if (botcount=2) and (mybot[1]=3)and(mybot[2]=2)then obeyenlarge;
  end;
end;{fetchmouse}

procedure pleasehelp;
begin
  getthis(0,0,319,199,p^);
  vgamode(3);
  gotoxy(1,1);
  writeln('For the keyboard:');
  writeln('< - this lets you draw lines as you move cursor key');
  writeln('C - this lets you change the paint color');
  writeln('L - this lets you load a saved drawing');
  writeln('S - this lets you save your drawing');
  writeln('Z - this saves your drawing for small amount of memory only in method 1');
  writeln('U - this unload your drawing which has been save from method 1');
  writeln('I - this saves your drawing for small amount of memory only in method 2');
  writeln('E - this unload your drawing which has been save from method 2');
  writeln('H - puts you in this window');
  writeln;
  writeln('For mouse button:');
  writeln('left button(only) lets you draw while you move the cursor');
  writeln('middle button(only) lets you get the color where you point the pen');
  writeln('left+middle button lets you paint the space where you where');
  writeln('middle+right buttons lets you cut a certain portion');
  writeln('middle+left buttons lets you put the cut portion where you want');
  writeln('right+middle+left buttons lets you erase the whole page');
  writeln('right+middle buttons lets you enlarge a certain portion you want');
  writeln('right+left buttons lets you choose a color for your pen');
  writeln;
  writeln('inside a cut,put,enlarge or others you use this buttons:');
  writeln('right button is always use when cancelling');
  writeln('left button is almost use in affirming or choosing');
  ch:=myreadkey;
  vgamode(1);
  putthis(0,0,p^,0);
end;{pleasehelp}

procedure getkeycommand;
begin
  ch:=myreadkey;
  if ch=$2e then getcolorcommand;
  if ch=$26 then obeyload;
  if ch=$1f then obeysave;
  if ch=$2c then zipperns;
  if ch=$16 then unzipperns;
  if ch=$17 then zipperns2;
  if ch=$12 then unzipperns2;
  if ch=$23 then pleasehelp;
  if ch=$30 then getspace;
end;{getkeycommand}

procedure initialize;
begin
  miny:=0;
  maxy:=199;
  minx:=0;
  maxx:=319;
  l:=false;
  m:=false;
  r:=false;
  c:=15;
  x:=maxx shr 1;
  y:=maxy shr 1;
  asm
    mov ax,0
    int 33h
  end;
  getmem(p,65535);
  getmem(pen,51);
  directvideo:=false;
  showposmeth:=1;
  getmem(boxp,1200);
  boxseg:=seg(boxp^);
  boxofs:=ofs(boxp^);
  botcount:=0;
  getmem(getp,65535);
end;

begin
  clrscr;
  gotoxy(1,5);
  writeln('                   Angelo Lian Lanuza',char(39),'s Drawing Kit');
  writeln;
  writeln('                             Submitted to:   ');
  writeln;
  writeln('                  Junior Philippine Computer Society');
  writeln('                     Mapua Institute of Technology');
  gotoxy(1,15);
  writeln('                             Submitted by:');
  writeln;
  writeln('                           LANUZA, Angelo L.');
  writeln('                                 ECE-3');

  ch:=ord(readkey);
  initialize;
  vgamode(1);
  gotomyint9;
  repeat
    fetchmouse;
    if (mykeypressed)or(tot_keys>2)then
    begin
      getmovecommand;
      if (mykey[$33]<>0)then begin yeyan(x,y,c);rkey:=0;end;
      if mykeypressed then getkeycommand;
    end;
    showpos;
  until(mykey[$38]<>0)and(mykey[$2d]<>0);
  goaway;
  vgamode(3);
  beep;
  freemem(p,65535)
end.














