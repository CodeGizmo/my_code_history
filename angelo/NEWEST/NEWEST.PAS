{$I-}
{S-}
uses vgaliza3,mouse,crt,mystring,dos;
var
  x,y,lx,ly                     :integer;
  c,lc,lgmis                    :byte;
  d1,d2,d3,d4                   :word;
  ch,ch2                        :char;
  exit                          :boolean;
  yeyan_method                  :byte;
  picsize                       :word;
  f                             :file;
  s                             :string;
  p                             :array[0..9] of pointer;{}{{ }
  p1,p2                            :pointer;{{{{{{{{{{{{}
  red,grn,blu                   :array[0..255]of byte;
  enter                         :boolean;
  centeron                      :boolean;
  DirInfo                       :SearchRec;

procedure showpos2;
begin
{    d2:=yeyun(x,y);}
    yeymode:=1;
    line(x-5,y-7,x+5,y+7,0);
    line(x-5,y+7,x+5,y-7,0);
{    for d1:=0 to 255 do
    begin
      yeyan(x,y,d1);
    end;}
    line(x-5,y+7,x+5,y-7,0);
    line(x-5,y-7,x+5,y+7,0);
    yeymode:=0;
{    yeyan(x,y,d2);}
end;

procedure showpos;
begin
  case yeyan_method of
    0:begin
        if centeron then
        begin
          yeymode:=1;
          line(x,y,x,maxy,c);
          line(x,y,maxx,y,c);
          line(x,y,minx,y,c);
          line(x,y,x,miny,c);
          yeymode:=0;
        end;
        showpos2;
        d2:=yeyun(x,y);
        for d1:=0 to 255 do
        begin
          yeyan(x,y,d1);
        end;
        yeyan(x,y,d2);
        showpos2;
      end;
    1:begin
        if centeron then
        begin
          yeymode:=1;
          line(x,y,x,maxy,c);
          line(x,y,maxx,y,c);
          line(x,y,minx,y,c);
          line(x,y,x,miny,c);
          yeymode:=0;
        end;
        showpos2;
        yeymode:=1;
        line(x,y,lx,ly,c);
        yeymode:=0;
        showpos2;
      end;
    2:begin
        yeymode:=1;
        oval(lx,ly,x,y,c);
          line(x,y,x,y+5,c);
          line(x,y,x+3,y,c);
          line(x,y,x-3,y,c);
          line(x,y,x,y-5,c);
        yeymode:=0;
      end;
  end;
end;

procedure obeymove;
begin
  if ch in[#71..#73]then begin dec(y);if y<miny then y:=miny;end;
  if ch in[#79..#81]then begin inc(y);if y>maxy then y:=maxy;end;
  if ch in[#71,#75,#79]then begin dec(x);if x<minx then x:=minx;end;
  if ch in[#73,#77,#81]then begin inc(x);if x>maxx then x:=maxx;end;
  xmic:=x*miceres;ymic:=y*miceres;
end;

procedure getmove;
begin
  enter:=false;
  if keypressed then
  begin
    ch:=readkey;
    if ch=#0 then
    begin
      ch:=readkey;
      if ch in[#71,#72,#73,#75,#77,#79,#80,#81]then obeymove;
    end;
    if ch=#13 then enter:=true;
  end;
end;

procedure colorado;
var a,b:word;lym:byte;
begin
  centeron:=false;
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
      for d1:=1 to 6 do
      for d2:=1 to 6 do
        yeyan(d1+a shl 3,d2+b shl 3,b*32+a);
      line(a shl 3,b shl 3,a shl 3+7,b shl 3,7);
      line(a shl 3,b shl 3,a shl 3,b shl 3+7,7);
      line(a shl 3+7,b shl 3,a shl 3+7,b shl 3+7,8);
      line(a shl 3,b shl 3+7,a shl 3+7,b shl 3+7,8);
    end;
  lym:=yeyan_method;
  yeyan_method:=0;
  repeat
    giveme;
    xmic:=x;ymic:=y;
    showpos;
    addmousemove;
    x:=xmic;y:=ymic;
    getmove;
    if l or enter then
    begin
      if (x<256)and(y<64)then
      begin
        if not(gmis in[2,3])then
        begin
          box(a shr 3 shl 3,b shr 3 shl 3,a shr 3 shl 3+7,b shr 3 shl 3+7,0);
          box(x shr 3 shl 3,y shr 3 shl 3,x shr 3 shl 3+7,y shr 3 shl 3+7,8{x shr 3+(y shr 3)*32});
        end else
        begin
          line(a shr 3 shl 3  ,b shr 3 shl 3  ,a shr 3 shl 3+7,b shr 3 shl 3,7);
          line(a shr 3 shl 3  ,b shr 3 shl 3  ,a shr 3 shl 3  ,b shr 3 shl 3+7,7);
          line(a shr 3 shl 3+7,b shr 3 shl 3  ,a shr 3 shl 3+7,b shr 3 shl 3+7,8);
          line(a shr 3 shl 3  ,b shr 3 shl 3+7,a shr 3 shl 3+7,b shr 3 shl 3+7,8);
          line(x shr 3 shl 3  ,y shr 3 shl 3  ,x shr 3 shl 3+7,y shr 3 shl 3,8);
          line(x shr 3 shl 3  ,y shr 3 shl 3  ,x shr 3 shl 3  ,y shr 3 shl 3+7,8);
          line(x shr 3 shl 3+7,y shr 3 shl 3  ,x shr 3 shl 3+7,y shr 3 shl 3+7,7);
          line(x shr 3 shl 3  ,y shr 3 shl 3+7,x shr 3 shl 3+7,y shr 3 shl 3+7,7);
        end;
        a:=x;b:=y;
        c:=x shr 3+(y shr 3)*32;
      end;
    end;
    showpos;
  until(ch=#27)or(r);
  yeyan_method:=lym;
end;{colorado}

procedure getcolorcommand;
begin
  getthis(0,0,319,199,p2^);
  colorado;
  putthis(0,0,p2^,0);
end;{getcolorcommand}

procedure obeykey;
begin
  ch:=readkey;
  case ch of
    #0:begin
         ch:=readkey;
         case ch of
           #71,#72,#73,#75,#77,#79,#80,#81:
             begin
               case yeyan_method of
                 0:begin
                     lx:=x;ly:=y;
                     obeymove;
                     {yeyan(x,y,c);}
                   end;
                 1,2:begin
                     obeymove;
                   end;
               end;
             end;
           #45:exit:=true;
         end;
       end;
    's','S':begin
          if ch='s' then
          begin
            textxy(0,0);
            putstring('Enter Name:                                                     ');
            textxy(12*5,0);
            s:=readstring;
            if pos('.',s)=0 then s:=s+'.all';
          end else s:='logs.all';
          assign(f,s);
          rewrite(f,1);
          blockwrite(f,gmis,1);
          if gmis in[2,3] then
          begin
            if gmis=3 then picsize:=32000 else picsize:=16000;
            portw[$3ce]:=$0004;
            blockwrite(f,ptr($a000,0)^,picsize);
            portw[$3ce]:=$0104;
            blockwrite(f,ptr($a000,0)^,picsize);
            portw[$3ce]:=$0204;
            blockwrite(f,ptr($a000,0)^,picsize);
            portw[$3ce]:=$0304;
            blockwrite(f,ptr($a000,0)^,picsize);
          end else
          begin
            blockwrite(f,ptr($a000,0)^,64000);
          end;

          for d1:=0 to 255 do
          begin
            mygetdac(d1,red[d1],grn[d1],blu[d1]);
          end;
          blockwrite(f,red[0],768);
          close(f);

        end;
    'd':begin
          getthis(0,0,319,199,p2^);
          get(0,200,319,399,p1^);
          FindFirst('*.all', Archive, DirInfo);
          while DosError = 0 do
          begin
            putstring(DirInfo.Name+#13);
            FindNext(DirInfo);
          end;
          while not(keypressed)and(bot=0)do giveme;
          putthis(0,0,p2^,0);
          put(0,200,p1^);
        end;
    'l','L':begin
          if ch='L' then
          begin
            textxy(0,0);
            putstring('Enter Name:                                                     ');
            textxy(12*5,0);
            s:=readstring;
            if pos('.',s)=0 then s:=s+'.all';
          end else s:='logs.all';
          if gmis in[2,3]then
          begin
            assign(f,s);
            reset(f,1);
            blockread(f,lgmis,1);
            if lgmis in[2,3]then
            begin
              portw[$3c4]:=$102;
              blockread(f,p2^,32000);
              move(p2^,ptr($a000,0)^,32000);
              portw[$3c4]:=$202;
              blockread(f,p2^,32000);
              move(p2^,ptr($a000,0)^,32000);
              portw[$3c4]:=$402;
              blockread(f,p2^,32000);
              move(p2^,ptr($a000,0)^,32000);
              portw[$3c4]:=$802;
              blockread(f,p2^,32000);
              move(p2^,ptr($a000,0)^,32000);
              blockread(f,red[0],768);
            end
            else begin
              blockread(f,p2^,64000);
              portw[$3c4]:=$102;
              for d1:=0 to 16385 do begin mem[$a000:d1]:=mem[seg(p2^):ofs(p2^)+(d1 shl 2)]end;
              portw[$3c4]:=$202;
              for d1:=0 to 16385 do begin mem[$a000:d1]:=mem[seg(p2^):ofs(p2^)+(d1 shl 2)+1]end;
              portw[$3c4]:=$402;
              for d1:=0 to 16385 do begin mem[$a000:d1]:=mem[seg(p2^):ofs(p2^)+(d1 shl 2)+2]end;
              portw[$3c4]:=$802;
              for d1:=0 to 16385 do begin mem[$a000:d1]:=mem[seg(p2^):ofs(p2^)+(d1 shl 2)+3]end;
            end;
              for d1:=0 to 255 do
              begin
                myup(d1,red[d1],grn[d1],blu[d1]);
              end;
            close(f);
          end else
          begin
            assign(f,s);
            reset(f,1);
            blockread(f,lgmis,1);
            if lgmis in[2,3]then
            begin
              blockread(f,p2^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+0]:=mem[seg(p2^):ofs(p2^)+d1];
              blockread(f,p2^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+1]:=mem[seg(p2^):ofs(p2^)+d1];
              blockread(f,p2^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+2]:=mem[seg(p2^):ofs(p2^)+d1];
              blockread(f,p2^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+3]:=mem[seg(p2^):ofs(p2^)+d1];
            end;
            close(f);
          end;
        end;
    '`':begin
          inc(yeyan_method);
          if yeyan_method>2 then yeyan_method:=0;
        end;
    '2':begin
          centeron:=not(centeron);
        end;
    '1':begin
          lx:=x; ly:=y;
        end;
    #13:begin{********************************************************}
          if yeyan_method<>2 then
          begin
            line(lx,ly,x,y,c);
            lx:=x;
            ly:=y;
          end else oval(lx,ly,x,y,c);
        end;
    'c':getcolorcommand;
    'h':begin
          getthis(0,0,319,199,p2^);
          textxy(0,0);
          putstring('Left Button(alone) will enable the user to:'#13);
          putstring('  put pixel   (in mode 0)'#13);
          putstring('  put line    (in mode 1)'#13);
          putstring('  put ellipse (in mode 2)'#13);
          putstring(#13);
          putstring('Left + Middle Buttons will let the user paint a portion'#13);
          putstring(#13);
          putstring('Middle Button(alone) will get the color of the current position'#13);
          putstring(#13);
          putstring('Middle + Right will change the mode of the left button'#13);
          putstring(#13);
          putstring('Right + Middle will enable or disable the grid lines'#13);
          putstring(#13);
          putstring('Right + Left will let you change the current color'#13);
          putstring(#13);
          putstring('Right Button(alone) is used for changing position'#13);
          putstring('                    or exiting the window of color changer'#13);
          putstring('Right + Middle + Left Buttons Will Erase the whole screen'#13);
          putstring(#13'For keyboard functions:'#13);
          putstring('pressing <`> will change from a plot mode to line mode to          ellipse mode'#13);
          putstring('pressing <1> will change the last location to the new location'#13);
          putstring('pressing <2> will enable/disable grid location'#13);
          putstring('pressing <ENTER> will plot or make a line or make an ellipse'#13);
          putstring('pressing <p> will let you paint at current posintion'#13);
          putstring('pressing <l> will load the logo'#13);
          putstring('pressing <SHIFT-L> will let you load a picture'#13);
          putstring('pressing <s> will let you save what you have drawn'#13);
          putstring('pressing <c> will let you change the color'#13);
          putstring('pressing <d> will let you the files you can load'#13);
          putstring('pressing <ALT-X> will exit from this program.'#13);
          ch:=readkey;
          putthis(0,0,p2^,0);
        end;
    'p':myfill(x,y,c);
  end;
end;

procedure fetchmouse;
begin
  if mouseon and mouseinstalled then
  begin
    giveme;
    addmousemove;
    x:=xmic div miceres;y:=ymic div miceres;
    if (lxmic<>xmic)or(lymic<>ymic)or(bot<>lbot) then
    begin
      if yeyan_method=0 then
      begin
        lx:=lxmic div miceres;
        ly:=lymic div miceres;
      end;

      case yeyan_method of
        0:begin
            if(bot=1)and((lx<>x)or(ly<>y))and(botcount=1)then line(lx,ly,x,y,c)
              else if (botcount=1)and(bot=0)and(lbot=1)then yeyan(x,y,c);
            if(botcount=2)and((lx<>x)or(ly<>y))and(mybot[1]=1)and(mybot[2]=2)then
              myfill(x,y,c)else if(botcount=2)and(mybot[1]=1)and(mybot[2]=2)
                                  and(bot=0)then myfill(x,y,c);
          end;
        1:begin
             if (botcount=1)and(lbot=1)then
             begin
               line(x,y,lx,ly,c);
               lx:=x;ly:=y;
             end;
             if (botcount=1)and(lbot=2)then begin lx:=x;ly:=y;end;
             if(botcount=2)and((lx<>x)or(ly<>y))and(mybot[1]=1)and(mybot[2]=2)then
              myfill(x,y,c)else if(botcount=2)and(mybot[1]=1)and(mybot[2]=2)
                                  and(bot=0)then myfill(x,y,c);
          end;
        2:begin
             if (botcount=1)and(lbot=1)and(bot=0)then
             begin
               oval(lx,ly,x,y,c);
        {       lx:=x;ly:=y;}
             end;
             if (botcount=1)and(lbot=2)then begin lx:=x;ly:=y;end;
             if(botcount=2)and((lx<>x)or(ly<>y))and(mybot[1]=1)and(mybot[2]=2)then
               myfill(x,y,c)else if(botcount=2)and(mybot[1]=1)and(mybot[2]=2)
                                  and(bot=0)then myfill(x,y,c);
          end;
      end;
      if bot=0 then
      begin
        if (botcount=1) and lm then c:=yeyun(x,y);
        if (botcount=2) and (mybot[1]=1)and(mybot[2]=3)then ;
        if (botcount=3) and (mybot[1]=3)and(mybot[2]=2)and(mybot[3]=1)then clear;
        if (botcount=2) and (mybot[1]=3)and(mybot[2]=1)then getcolorcommand;
        if (botcount=2) and (mybot[1]=2)and(mybot[2]=3)then yeyan_method:=(yeyan_method+1)mod 3;{obeyget};
        if (botcount=2) and (mybot[1]=2)and(mybot[2]=1)then {obeyput};
        if (botcount=2) and (mybot[1]=3)and(mybot[2]=2)then centeron:=not(centeron);{obeyenlarge};
      end;
    end;
  end;
end;

procedure getactions;
begin
  if keypressed then obeykey;
  fetchmouse;
  if yeyan_method=1 then
  begin
  end;
end;

procedure print;
var ypos:word;
begin
  if gmis in[1,2]then ypos:=194 else ypos:=394;
  putthis(0,ypos,p[lx div 100]^,0);
  putthis(5,ypos,p[(lx mod 100)div 10]^,0);
  putthis(10,ypos,p[lx mod 10]^,0);

  putthis(25,ypos,p[ly div 100]^,0);
  putthis(30,ypos,p[(ly mod 100)div 10]^,0);
  putthis(35,ypos,p[ly mod 10]^,0);

  putthis(50,ypos,p[x div 100]^,0);
  putthis(55,ypos,p[(x mod 100)div 10]^,0);
  putthis(60,ypos,p[x mod 10]^,0);

  putthis(80,ypos,p[y div 100]^,0);
  putthis(85,ypos,p[(y mod 100)div 10]^,0);
  putthis(90,ypos,p[y mod 10]^,0);
end;

procedure doactions;
begin
{  if (x<>lx)or(y<>ly)then obeymove;}
  showpos;
  print;
  showpos;
end;

procedure openremarks;
begin
  for d1:=1 to 9 do
  begin
    getmem(p[d1],32);
    getthis(5*(d1+25)+1,0,5*(d1+25)+5,5,p[d1]^);
  end;
  getmem(p[0],32);
  getthis(5*(35)+1,0,5*(35)+5,5,p[0]^);
  clear;
  loadchar('mychar.chr');
          s:='logs.all';
          if gmis in[2,3]then
          begin
            assign(f,s);
            reset(f,1);
            blockread(f,lgmis,1);
            if lgmis in[2,3]then
            begin
              portw[$3c4]:=$102;
              blockread(f,p2^,32000);
              move(p2^,ptr($a000,0)^,32000);
              portw[$3c4]:=$202;
              blockread(f,p2^,32000);
              move(p2^,ptr($a000,0)^,32000);
              portw[$3c4]:=$402;
              blockread(f,p2^,32000);
              move(p2^,ptr($a000,0)^,32000);
              portw[$3c4]:=$802;
              blockread(f,p2^,32000);
              move(p2^,ptr($a000,0)^,32000);
              blockread(f,red[0],768);
            end
            else begin
              blockread(f,p2^,64000);
              portw[$3c4]:=$102;
              for d1:=0 to 16385 do begin mem[$a000:d1]:=mem[seg(p2^):ofs(p2^)+(d1 shl 2)]end;
              portw[$3c4]:=$202;
              for d1:=0 to 16385 do begin mem[$a000:d1]:=mem[seg(p2^):ofs(p2^)+(d1 shl 2)+1]end;
              portw[$3c4]:=$402;
              for d1:=0 to 16385 do begin mem[$a000:d1]:=mem[seg(p2^):ofs(p2^)+(d1 shl 2)+2]end;
              portw[$3c4]:=$802;
              for d1:=0 to 16385 do begin mem[$a000:d1]:=mem[seg(p2^):ofs(p2^)+(d1 shl 2)+3]end;
            end;
              for d1:=0 to 255 do
              begin
                myup(d1,red[d1],grn[d1],blu[d1]);
              end;
            close(f);
          end else
          begin
            assign(f,s);
            reset(f,1);
            blockread(f,lgmis,1);
            if lgmis in[2,3]then
            begin
              blockread(f,p2^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+0]:=mem[seg(p2^):ofs(p2^)+d1];
              blockread(f,p2^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+1]:=mem[seg(p2^):ofs(p2^)+d1];
              blockread(f,p2^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+2]:=mem[seg(p2^):ofs(p2^)+d1];
              blockread(f,p2^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+3]:=mem[seg(p2^):ofs(p2^)+d1];
            end;
            close(f);
          end;
  bot:=0;
  repeat
    if mouseinstalled then giveme;
  until keypressed or (bot<>0);
  clear;
  putstring('Angelo L. Lanuza');
end;

procedure closeremarks;
begin

end;

procedure exitprog;
begin
  vgamode(mtext);
end;

procedure initialize;
begin
  vgamode(1);
  getmem(p2,65535);
  getmem(p1,65535);
  aload('pictures\letters.all',ptr($a000,0)^);
  getthis(0,0,319,199,p2^);
  vgamode(3);
  putthis(0,0,p2^,0);
{  ch:=readkey;}
  x:=maxx shr 1;
  y:=maxy shr 1;
  exit:=false;
  s:='logs.all';
  yeyan_method:=0;
  initmouse;
  maxmicey:=maxy;
  mouseon:=true;
  c:=15;
  setmiceres(maxx,maxy,4);
  directvideo:=false;
end;


begin
  initialize;
  openremarks;
  repeat
    getactions;
    doactions;
    textx:=0;texty:=0;
    putstring('Angelo L. Lanuza                                                ');
(*    putstring('`0123456789-=\~!@#$%^&*()_+|qwertyuiop[]asdfghjkl;''zxcvbnm,./QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?');*)
  until exit;
  closeremarks;
  exitprog;
end.