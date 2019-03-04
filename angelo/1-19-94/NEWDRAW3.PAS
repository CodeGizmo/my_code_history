program Drawing_Kit{version 1.01};
uses newint09,vgaliz,crt;
var
  dumbyte,dumbyte2              :byte;
  dumword,dumword2              :word;
  c,lcc,paint                   :byte;
  x,y,lx,ly,x1,y1,x2,y2         :integer;
{  miny,maxy,minx,maxx           :word;}
  ch                            :byte;
  p,pen,boxp,getp,largesave     :pointer;
  boxseg,boxofs                 :word;
  bigx,bigy                     :integer;
  largeleft                     :boolean;
  good_to_enlarge               :boolean;

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
@a1:cmp  x,0
    jge  @a2
    mov  x,0
@a2:cmp  y,199
    jle  @a3
    mov  y,199
    jmp  @a4
@a3:cmp  y,0
    jge  @a4
    mov  y,0
@a4:
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
  aload(f,p^);
  putthis(0,0,p^,0);
  gotomyint9;
end;{obeyload}

procedure obeysave;
begin
  goaway;
  getthis(0,0,319,199,p^);
  gotoxy(1,1);write('filename ');
  readln(f);
  asave(f,p^,65000);
  putthis(0,0,p^,0);
  gotomyint9;
end;{obeysave}

procedure zipperns;
begin
  goaway;
  compress(ptr(pseg,pofs)^,p^);
  gotoxy(1,1);write('filename ');
  readln(f);
  lizsave(f,p^);
  uncompress(p^,ptr(pseg,pofs)^);
  gotomyint9;
end;{zipperns}

procedure unzipperns;
begin
  goaway;
  gotoxy(1,1);write('filename ');
  readln(f);
  aload(f,p^);
  uncompress(p^,ptr(pseg,pofs)^);
  gotomyint9;
end;{unzipperns}

procedure zipperns2;
begin
  goaway;
  implode(ptr(pseg,pofs)^,p^);
  gotoxy(1,1);write('filename ');
  readln(f);
  lizsave(f,p^);
  explode(p^,ptr(pseg,pofs)^);
  gotomyint9;
end;{zipperns}

procedure unzipperns2;
begin
  goaway;
  gotoxy(1,1);write('filename ');
  readln(f);
  aload(f,p^);
  explode(p^,ptr(pseg,pofs)^);
  gotomyint9;
end;{unzipperns}

procedure getspace;
begin
  repeat
    addmousemove;
    showpos;
    giveme;
    if l then
    begin
      while bot<>0 do giveme;
      x1:=x;y1:=y;
      boxsave(x1,y1,x,y);
      repeat
        addmousemove;
        showpos;
        giveme;
        if(x<>lx)or(y<>ly)then
        begin
          boxrestore(x1,y1,lx,ly);
          boxsave(x1,y1,x,y);
        end;
        boxer(x1,y1,x,y);
      until(l)or(r);
      if l then x2:=x;y2:=y;
      boxrestore(x1,y1,x,y);
      while r do giveme;
    end;
  until(key=1)or(r)or(l);
  while bot<>0 do giveme;
  if x1>x2 then begin dumword:=x1;x1:=x2;x2:=dumword end;
  if y1>y2 then begin dumword:=y1;y1:=y2;y2:=dumword end;
end;{getspace}

procedure bigyeyan(x,y:word;c:byte);
begin
  for dumword2:=0 to 3 do
    for dumbyte2:=0 to 3 do
      if (dumword2<>3)and(dumbyte2<>3)then
        yeyan(dumword2+(x shl 2),dumbyte2+(y shl 2),yeyun(bigx+x+2,bigy+y))
        else yeyan(dumword2+(x shl 2),dumbyte2+(y shl 2),0);
end;{bigyeyan}

procedure bigline(x1,y1,x2,y2,c:integer);
var
  dx,dy,e,tmp : integer;

begin
  if x1 > x2 then
  begin
    tmp := x1; x1 := x2; x2 := tmp;
    tmp := y1; y1 := y2; y2 := tmp;
  end;
  dx := x2-x1;
  e  := 0;
  if y1 <= y2 then
  begin
    dy := (y2-y1);
    if dx >= dy then
    begin
      bigyeyan(x1,y1,c);
      while x1<x2 do
      begin
        inc(x1);
        inc(e,dy);
        inc(e,dy);
        IF e > dx then
        begin
          DEC(e,dx);
          DEC(e,dx);
          INC(y1);
        END;
        bigyeyan(x1,y1,c);
      end;
    end else
    begin
      bigyeyan(x1,y1,c);
      while y1<y2 do
      begin
        inc(y1);
        inc(e,dx);
        inc(e,dx);
        if e > dy then
        begin
          dec(e,dy);
          dec(e,dy);
          inc(x1);
        end;
        bigyeyan(x1,y1,c);
      end;
    end;
  end else
  begin
    dy := (y1-y2);
    if dx >= dy then
    begin
      bigyeyan(x1,y1,c);
      while x1<x2 do
      begin
        inc(x1);
        inc(e,dy);
        inc(e,dy);
        if e > dx then
        begin
          dec(e,dx);
          dec(e,dx);
          dec(y1);
        end;
        bigyeyan(x1,y1,c);
      end;
    end else
    begin
      bigyeyan(x1,y1,c);
      while y1>y2 do
      begin
        dec(y1);
        inc(e,dx);
        inc(e,dx);
        if e > dy then
        begin
          dec(e,dy);
          dec(e,dy);
          inc(x1);
        end;
        bigyeyan(x1,y1,c);
      end;
    end;
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
    good_to_enlarge:=true;
    bigx:=x;bigy:=y;
    while good_to_enlarge do
    begin
      good_to_enlarge:=false;
      gseg:=seg(p^);
      gofs:=2;

      for dumword:=0 to 79 do
      for dumbyte:=0 to 49 do
      for dumword2:=0 to 3 do
      for dumbyte2:=0 to 3 do
        if (dumword2<>3)and(dumbyte2<>3)then
          yeyan(dumword2+(dumword shl 2),dumbyte2+(dumbyte shl 2),yeyun(bigx+dumword+2,bigy+dumbyte))
          else yeyan(dumword2+(dumword shl 2),dumbyte2+(dumbyte shl 2),0);
      if x>160 then
      begin
        gseg:=$a000;
        getthis(0,0,79,49,largesave^);
        gseg:=seg(p^);
        largeleft:=true;
        movebar(0,0,79,49,bigx,bigy);
      end else
      begin
        gseg:=$a000;
        getthis(240,0,240+79,49,largesave^);
        gseg:=seg(p^);
        largeleft:=false;
        movebar(240,0,240+79,49,bigx,bigy);
      end;

  {    gseg:=$a000;
      repeat
        addmousemove;
        giveme;
        if(bot=1)and((lx<>x)or(ly<>y))and(botcount=1)then bigline(lx,ly,x,y,c)
          else if (botcount=1)and(bot=0)and(lbot=1)then bigyeyan(x,y,c);
        showpos;
      until r;}
      repeat
        addmousemove;
        giveme;
        if (x=319)and(bigx+79<319) then   {********}
        begin
          if bigx+79+40<319 then begin bigx:=bigx+40;x:=160 end
           else begin dumbyte:=319-79-bigx;bigx:=319-79;x:=x-(dumbyte shl 2)end;
          good_to_enlarge:=true;
        end;
{********}
        if (x=0)and(bigx>0) then   {********}
        begin
          if bigx-40>0 then begin bigx:=bigx-40;x:=160 end
           else begin dumbyte:=bigx;bigx:=0;x:=(dumbyte shl 2)end;
          good_to_enlarge:=true;
        end;
{********}
        if (y=199)and(bigy+49<199) then   {********}
        begin
          if bigy+49+25<199 then begin bigy:=bigy+25;y:=100 end
           else begin dumbyte:=199-49-bigy;bigy:=199-49;y:=y-(dumbyte shl 2)end;
          good_to_enlarge:=true;
        end;
{********}
        if (y=0)and(bigy>0) then   {********}
        begin
          if bigy-25>0 then begin bigy:=bigy-25;y:=100 end
           else begin dumbyte:=bigy;bigy:=0;y:=(dumbyte shl 2)end;
          good_to_enlarge:=true;
        end;
{********}
        if x>160 then
        begin
          if not(largeleft)then
          begin
            putthis(240,0,largesave^,0);
            gseg:=$a000;
            getthis(0,0,79,49,largesave^);
            gseg:=seg(p^);
            largeleft:=true;
            movebar(0,0,79,49,bigx+2,bigy);
          end;
        end else
        begin
          if largeleft then
          begin
            putthis(0,0,largesave^,0);
            gseg:=$a000;
            getthis(240,0,240+79,49,largesave^);
            gseg:=seg(p^);
            largeleft:=false;
            movebar(240,0,240+79,49,bigx+2,bigy);
          end;
        end;
            if l then
            begin
              pseg:=seg(p^);
              yeyan(bigx+(x shr 2)+2,bigy+(y shr 2),c);
              pseg:=$a000;
              if largeleft then yeyan((x shr 2),y shr 2,c)else yeyan(240+(x shr 2),y shr 2,c);
            end;
            if m then
            begin
              pseg:=seg(p^);
              yeyan(bigx+(x shr 2)+2,bigy+(y shr 2),0);
              pseg:=$a000;
              if largeleft then yeyan((x shr 2),y shr 2,c)else yeyan(240+(x shr 2),y shr 2,0);
            end;

        if l then
        for dumword2:=0 to 3 do
          for dumbyte2:=0 to 3 do
            if (dumword2<>3)and(dumbyte2<>3)then
              yeyan(dumword2+(x shr 2 shl 2),dumbyte2+(y shr 2 shl 2),c);
        if m then
        for dumword2:=0 to 3 do
          for dumbyte2:=0 to 3 do
            if (dumword2<>3)and(dumbyte2<>3)then
              yeyan(dumword2+(x shr 2 shl 2),dumbyte2+(y shr 2 shl 2),0);

        gseg:=$a000;
        showpos;
        gseg:=seg(p^);
      until (r or good_to_enlarge);
      if largeleft then putthis(0,0,largesave^,0)else putthis(240,0,largesave^,0);

    end;
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



{var
  width,height:integer;
procedure makeicon;
begin
  getthis(0,0,319,199,p^);
  write('Input the width you desire: ');
  readln(width);
  write('input the height you desire: ');
  readln(height);

  putthis(0,0,p^,0);
end;}{makeicon}




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
  getmem(largesave,4100);
end;

begin
  clrscr;
{  gotoxy(1,5);
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

  ch:=ord(readkey);}
  initialize;
  vgamode(1);
  gotomyint9;




  begin
    f:='newbunny.liz';
    aload(f,p^);
    uncompress(p^,ptr(pseg,pofs)^);
  end;{unzipperns}



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














