unit newdraw;
{program Drawing_Kit{version 1.12};
interface
procedure getcolorcommand;
implementation
uses keyboard,vgaliza2,crt;
var
  micex,micey                   :word;
  dumbyte,dumbyte2              :byte;
  dumword,dumword2              :word;
  c,lcc,paint                   :byte;
  x,y,lx,ly,x1,y1,x2,y2         :integer;
  miny,maxy,minx,maxx           :word;
  ch                            :byte;
  p,pen,boxp,getp,largesave     :pointer;
  boxseg,boxofs                 :word;
  bigx,bigy,lbigx,lbigy         :integer;
  largeleft                     :boolean;
  good_to_enlarge               :boolean;

var
  rcount:byte;
  linelx,linely:integer;
  yeyan_method:byte;
  mouseon:boolean;

procedure beep;
begin
  sound(500);
  delay(50);
  nosound;
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
  if mouseon then
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
      for dumword2:=dumbyte to dumbyte2 do
        script[dumword2]:=dumword;
    end;
    if f='x'then
    begin
      gotoxy(1,1);clreol;
      write('Enter x-inc');
      readln(xinc);
    end;
    if f='y'then
    begin
      gotoxy(1,1);clreol;
      write('Enter y-inc');
      readln(yinc);
    end;
    if f='a'then
    begin
      gotoxy(1,1);clreol;
      write('Enter xpos');
      readln(xinc);
    end;
    if f='b'then
    begin
      gotoxy(1,1);clreol;
      write('Enter ypos');
      readln(ybpos);
    end;
  until f='q';
  putthis(0,0,p^,0);
  gotomyint9;
end;{obey_editani}

procedure getmovecommand;
begin
  asm
    cli
  end;
  if(mykey[$47]or mykey[$48]or mykey[$49])<>0 then begin dec(y);key:=0;
          if y<miny then begin y:=miny;beep end end;
  if(mykey[$4f]or mykey[$50]or mykey[$51])<>0 then begin inc(y);key:=0;
          if y>maxy then begin y:=maxy;beep end end;
  if(mykey[$47]or mykey[$4b]or mykey[$4f])<>0 then begin dec(x);key:=0;
          if x<minx then begin x:=minx;beep end end;
  if(mykey[$49]or mykey[$4d]or mykey[$51])<>0 then begin inc(x);key:=0;
          if x>maxx then begin x:=maxx;beep end end;
  asm
    sti
  end;
end;{getmovecommand}

procedure getspace;
begin
  repeat
    addmousemove;getmovecommand;
    showpos;
    giveme;
    if l then
    begin
      while bot<>0 do giveme;
      x1:=x;y1:=y;
      boxsave(x1,y1,x,y);
      repeat
        addmousemove;getmovecommand;
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

procedure colorado;
var a,b:word;
begin
  if not(gmis in[2,3])then
  for b:=0 to 7 do
    for a:=0 to 31 do
    begin
      bar(1+a shl 3,1+b shl 3,a shl 3+6,b shl 3+6,b*32+a);
      box(a shl 3,b shl 3,a shl 3+7,b shl 3+7,0);
    end else
  for b:=0 to 7 do
    for a:=0 to 31 do
    begin
      for dumbyte:=1 to 6 do
      for dumbyte2:=1 to 6 do
        yeyan(dumbyte+a shl 3,dumbyte2+b shl 3,b*32+a);
      line(a shl 3,b shl 3,a shl 3+7,b shl 3,0);
      line(a shl 3,b shl 3,a shl 3,b shl 3+7,0);
      line(a shl 3+7,b shl 3,a shl 3+7,b shl 3+7,0);
      line(a shl 3,b shl 3+7,a shl 3+7,b shl 3+7,0);
    end;
  repeat
    giveme;
    addmousemove;getmovecommand;
    if l then
    begin
      if (x<256)and(y<64)then
      begin
        if not(gmis in[2,3])then
        begin
          box(a shr 3 shl 3,b shr 3 shl 3,a shr 3 shl 3+7,b shr 3 shl 3+7,0);
          box(x shr 3 shl 3,y shr 3 shl 3,x shr 3 shl 3+7,y shr 3 shl 3+7,8{x shr 3+(y shr 3)*32});
        end else
        begin
          line(a shr 3 shl 3  ,b shr 3 shl 3  ,a shr 3 shl 3+7,b shr 3 shl 3,0);
          line(a shr 3 shl 3  ,b shr 3 shl 3  ,a shr 3 shl 3  ,b shr 3 shl 3+7,0);
          line(a shr 3 shl 3+7,b shr 3 shl 3  ,a shr 3 shl 3+7,b shr 3 shl 3+7,0);
          line(a shr 3 shl 3  ,b shr 3 shl 3+7,a shr 3 shl 3+7,b shr 3 shl 3+7,0);
          line(x shr 3 shl 3  ,y shr 3 shl 3  ,x shr 3 shl 3+7,y shr 3 shl 3,8);
          line(x shr 3 shl 3  ,y shr 3 shl 3  ,x shr 3 shl 3  ,y shr 3 shl 3+7,8);
          line(x shr 3 shl 3+7,y shr 3 shl 3  ,x shr 3 shl 3+7,y shr 3 shl 3+7,8);
          line(x shr 3 shl 3  ,y shr 3 shl 3+7,x shr 3 shl 3+7,y shr 3 shl 3+7,8);
        end;
        a:=x;b:=y;
        c:=x shr 3+(y shr 3)*32;
      end;
    end;
    showpos;
  until(key=1)or(r);
  key:=0;
end;{colorado}

procedure refresh_division;
begin
      for dumword2:=0 to 3 do
      for dumbyte2:=0 to 3 do
      for dumbyte:=0 to 49 do
      for dumword:=0 to 79 do
        if (dumword2=3)or(dumbyte2=3)then
          yeyan(dumword2+(dumword shl 2),dumbyte2+(dumbyte shl 2),0);
end;

procedure refresh_large;
begin
      for dumbyte:=0 to 49 do
      for dumword:=0 to 79 do
      for dumword2:=0 to 2 do
      for dumbyte2:=0 to 2 do
        yeyan(dumword2+(dumword shl 2),dumbyte2+(dumbyte shl 2),yeyun(bigx+dumword+2,bigy+dumbyte));
end;
procedure largeyeyan;
begin
  begin
    pseg:=seg(p^);
    pofs:=2;
    yeyan(bigx+(x shr 2),bigy+(y shr 2),c);
    pofs:=0;
    pseg:=$a000;
    if largeleft then yeyan((x shr 2),y shr 2,c)else yeyan(240+(x shr 2),y shr 2,c);
      for dumword2:=0 to 3 do
        for dumbyte2:=0 to 3 do
          if (dumword2<>3)and(dumbyte2<>3)then
            yeyan(dumword2+(x shr 2 shl 2),dumbyte2+(y shr 2 shl 2),c);
  end;
end;

var ctofill:byte;
procedure obeyenlarge;
begin
  getthis(0,0,319,199,p^);
  boxsave(x,y,79+x,49+y);
  boxer(x,y,79+x,49+y);
  repeat
    addmousemove;getmovecommand;
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
    while l do giveme;
    good_to_enlarge:=true;
    bigx:=x;bigy:=y;
    refresh_division;

    while good_to_enlarge do
    begin
      good_to_enlarge:=false;
      gseg:=seg(p^);
      gofs:=2;

      for dumbyte:=0 to 49 do
      for dumword:=0 to 79 do
      for dumword2:=0 to 2 do
      for dumbyte2:=0 to 2 do
        yeyan(dumword2+(dumword shl 2),dumbyte2+(dumbyte shl 2),yeyun(bigx+dumword,bigy+dumbyte));
      if x>160 then
      begin
        gseg:=$a000;
        gofs:=0;
        getthis(0,0,79,49,largesave^);
        gseg:=seg(p^);
        gofs:=2;
        largeleft:=true;
        movebar(0,0,79,49,bigx,bigy);
      end else
      begin
        gseg:=$a000;
        gofs:=0;
        getthis(240,0,240+79,49,largesave^);
        gseg:=seg(p^);
        gofs:=2;
        largeleft:=false;
        movebar(240,0,240+79,49,bigx,bigy);
      end;
      while bot<>0 do giveme;               {dagdag}
      repeat
        addmousemove;getmovecommand;
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
            gofs:=0;
            getthis(0,0,79,49,largesave^);
            gseg:=seg(p^);
            gofs:=2;
            largeleft:=true;
            movebar(0,0,79,49,bigx,bigy);   {tanggal 2 sa bigx}
          end;
        end else
        begin
          if largeleft then
          begin
            putthis(0,0,largesave^,0);
            gseg:=$a000;
            gofs:=0;
            getthis(240,0,240+79,49,largesave^);
            gseg:=seg(p^);
            gofs:=2;
            largeleft:=false;
            movebar(240,0,240+79,49,bigx,bigy);   {tanggal 2 sa bigx}
          end;
        end;
              if (lbigx<>bigx+(x shr 2))or(lbigy<>bigy+(y shr 2))then {tanggal 2 sa (x shr 2)}
              begin
                lbigx:=bigx+(x shr 2);
                lbigy:=bigy+(y shr 2);
                ctofill:=yeyun(bigx+(x shr 2),bigy+(y shr 2));{tanggal 2 sa (x shr 2)}
              end;
            if l and (botcount=1) then
            begin

              pseg:=seg(p^);
              pofs:=2;
              yeyan(bigx+(x shr 2),bigy+(y shr 2),c);
              pseg:=$a000;
              pofs:=0;
              if largeleft then yeyan((x shr 2),y shr 2,c)else yeyan(240+(x shr 2),y shr 2,c);
                for dumword2:=0 to 3 do
                  for dumbyte2:=0 to 3 do
                    if (dumword2<>3)and(dumbyte2<>3)then
                      yeyan(dumword2+(x shr 2 shl 2),dumbyte2+(y shr 2 shl 2),c);
            end;
            if (mybot[1]=1)and(mybot[2]=2)and(botcount=2)then
            begin
              pseg:=seg(p^);
              pofs:=2;
              yeyan(bigx+(x shr 2),bigy+(y shr 2),ctofill);
              myfill(bigx+(x shr 2),bigy+(y shr 2),c);
              pseg:=$a000;
              pofs:=0;
              good_to_enlarge:=true;
            end;
        gseg:=$a000;
        gofs:=0;
        showpos;
        gseg:=seg(p^);
        gofs:=2;
        if m then good_to_enlarge:=true;
      until (r or m or good_to_enlarge)or((botcount=2)and((lx<>x)or(ly<>y))and(mybot[1]=1)and(mybot[2]=2));
      if largeleft then putthis(0,0,largesave^,0)else putthis(240,0,largesave^,0);
      if m and (botcount=1)then begin gseg:=$a000;colorado;gseg:=seg(p^);refresh_division;end;
    end;
  while bot<>0 do giveme;
  gseg:=$a000;
  gofs:=0;
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
begin
  getthis(0,0,319,199,p^);
  colorado;
  putthis(0,0,p^,0);
end;{getcolorcommand}




procedure fetchmouse;
begin
  if mouseon then
  begin
    addmousemove;getmovecommand;
    giveme;

    case yeyan_method of

      0:begin
          if(bot=1)and((lx<>x)or(ly<>y))and(botcount=1)then line(lx,ly,x,y,c)
            else if (botcount=1)and(bot=0)and(lbot=1)then yeyan(x,y,c);
          if(botcount=2)and((lx<>x)or(ly<>y))and(mybot[1]=1)and(mybot[2]=2)then
            myfill(x,y,c)else if(botcount=2)and(mybot[1]=1)and(mybot[2]=2)
                                and(bot=0)then myfill(x,y,c);
        end;
      1:begin
          if l then
          begin
          end;
        end;
    end;
    if bot=0 then
    begin
      if (botcount=1) and lm then c:=yeyun(x,y);
      if (botcount=3) and (mybot[1]=3)and(mybot[2]=2)and(mybot[3]=1)then clear;
      if (botcount=2) and (mybot[1]=3)and(mybot[2]=1)then getcolorcommand;
      if (botcount=2) and (mybot[1]=2)and(mybot[2]=3)then obeyget;
      if (botcount=2) and (mybot[1]=2)and(mybot[2]=1)then obeyput;
      if (botcount=2) and (mybot[1]=3)and(mybot[2]=2)then obeyenlarge;
    end;
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
  ch:=untouchkey;
  if ch=$2e then getcolorcommand;
  if ch=$26 then obeyload;
  if ch=$1f then obeysave;
  if ch=$2c then zipperns;
  if ch=$16 then unzipperns;
  if ch=$17 then zipperns2;
  if ch=$12 then unzipperns2;
  if ch=$23 then pleasehelp;
  if ch=$30 then getspace;
  if ch=$1c then begin
                   for dumword:=0 to 65500 do
                   begin
                     if  mem[$a000:dumword]=8 then mem[$a000:dumword]:=0;
                     if  mem[$a000:dumword]=15 then mem[$a000:dumword]:=14;
                   end;
                 end;
  if (ch=30)and(mykey[56]=0) then obey_editani;
  if (ch=30)and(mykey[56]<>0)then
  begin
    getthis(0,0,319,199,p^);
    repeat
      if direction then
      begin
        for dumbyte2:=firstfilm to lastfilm do
        begin
          dumbyte:=dumbyte2-1;
          movebar(300+xbpos,180+ybpos,319+xbpos,199+ybpos,(dumbyte mod 16)*20,(dumbyte div 16)*20);
          xbpos:=xbpos+xinc;
          ybpos:=ybpos+yinc;
          delay(script[dumbyte]);
        end
      end
      else
      begin
        for dumbyte2:=firstfilm downto lastfilm do
        begin
          dumbyte:=dumbyte2-1;
          movebar(300+xbpos,180+ybpos,319+xbpos,199+ybpos,(dumbyte mod 16)*20,(dumbyte div 16)*20);
          xbpos:=xbpos+xinc;
          ybpos:=ybpos+yinc;
          delay(script[dumbyte]);
        end
      end
    until mykeypressed;
    for dumbyte:=0 to 255 do mykey[dumbyte]:=0;
    key:=0;
    putthis(0,0,p^,0);
  end;
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
{  asm
    mov ax,0
    int 33h
  end;}
  getmem(p,65535);
{  getmem(pen,51);
  directvideo:=false;
  showposmeth:=1;
  getmem(boxp,1200);
  boxseg:=seg(boxp^);
  boxofs:=ofs(boxp^);
  botcount:=0;
  getmem(getp,65535);
  getmem(largesave,4100);
  yeyan_method:=0;
  mouseon:=false;}
end;

begin
  initialize;
(* clrscr;
  vgamode(1);
  gotomyint9;




  begin
    f:='pictures\logo.liz';
    aload(f,p^);
    uncompress(p^,ptr(pseg,pofs)^);
    getthis(0,0,319,199,p^);
    myreadkey;
    vgamode(1);
    putthis(0,0,p^,0);
  end;{unzipperns}




  repeat
    fetchmouse;
    if (mykeypressed)or(mykey2[$4c]<>0){tot_keys>2)}then
    begin
      getmovecommand;
      if (mykey[$33]<>0)then begin yeyan(x,y,c);key:=0;end;
      if mykeypressed then getkeycommand;
      if tab then mouseon:=not(mouseon);
{      mykey2[$4c]:=0;}
    end;
    showpos;
  until(mykey[$38]<>0)and(mykey[$2d]<>0);
  goaway;
  for dumbyte2:=0 to 84 do
  for dumbyte:=0 to 15 do box(dumbyte+dumbyte2,dumbyte+dumbyte2,319-dumbyte-dumbyte2,199-dumbyte-dumbyte2,dumbyte+16);

  vgamode(mtext);
  beep;
{  freemem(p,65535)}*)
end.














