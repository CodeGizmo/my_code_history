uses crt,vgaliza3,mouse2,rolfazil;
var
  px,py,d1,d2,d3,d4,
  x,y,lx,ly,c,lc                        :integer;
  exit, showed                          :boolean;
  ch                                    :char;
  posmeth,under,lposmeth                :byte;
  image,buffer,pen                      :pointer;
  red,green,blue,lred,lgreen,lblue      :array[0..255]of byte;
  dac                                   :array[0..2,0..255]of byte;

procedure showpos;
var lyey:byte;
begin
  px:=x;
  py:=y;
  lyey:=yeymode;
  case posmeth of
    0:begin
        yeymode:=1;
        yeyan(x,y,15);
      end;
    1:begin
        yeymode:=3;
        for d1:=0 to 255 do yeyan(x,y,15);
      end;
    2:begin
        yeymode:=1;
        line(x,miny,x,maxy,0);
        line(minx,y,maxx,y,0);
      end;
    3:begin
        yeymode:=1;
        circle(x,y,5,0);
      end;
    4:begin
        yeymode:=1;
        line(x-5,y+5,x+5,y+5,0);
        line(x-5,y-5,x+5,y-5,0);
        line(x+5,y-5,x+5,y+5,0);
        line(x-5,y-5,x-5,y+5,0);
      end;
    5:begin
        if x<(maxx+minx) shr 1 then
        if y<(maxy+miny) shr 1 then
        begin
          getthis(x,y,x+6,y+6,pen^);
          yeyan(x,y,15);
          line(x+1,y+1,x+4,y+4,c);
          line(x+1,y,x+6,y+5,14);
          line(x,y+1,x+5,y+6,14);
          line(x+4,y+5,x+5,y+4,12);
          line(x+5,y+6,x+6,y+5,12);
          yeyan(x+5,y+5,12);
        end else
        begin
          getthis(x,y-6,x+6,y,pen^);
          yeyan(x,y,15);
          line(x+1,y-1,x+4,y-4,c);
          line(x+1,y,x+6,y-5,14);
          line(x,y-1,x+5,y-6,14);
          line(x+4,y-5,x+5,y-4,12);
          line(x+5,y-6,x+6,y-5,12);
          yeyan(x+5,y-5,12);
        end else if y>(maxy+miny)shr 1 then
        begin
          getthis(x-6,y-6,x,y,pen^);
          yeyan(x,y,15);
          line(x-1,y-1,x-4,y-4,c);
          line(x-1,y,x-6,y-5,14);
          line(x,y-1,x-5,y-6,14);
          line(x-4,y-5,x-5,y-4,12);
          line(x-5,y-6,x-6,y-5,12);
          yeyan(x-5,y-5,12);
        end else
        begin
          getthis(x-6,y,x,y+6,pen^);
          yeyan(x,y,15);
          line(x-1,y+1,x-4,y+4,c);
          line(x-1,y,x-6,y+5,14);
          line(x,y+1,x-5,y+6,14);
          line(x-4,y+5,x-5,y+4,12);
          line(x-5,y+6,x-6,y+5,12);
          yeyan(x-5,y+5,12);
        end;
      end;
  end;
  yeymode:=lyey;
  showed:=true;
end;{showpos}

procedure hidepos;
var lyey:byte;
begin
  if showed then
  begin
    lyey:=yeymode;
    case posmeth of
    0:begin
        yeymode:=1;
        yeyan(px,py,15);
      end;
    1:begin
        yeymode:=3;
        for d1:=0 to 255 do yeyan(px,py,15);
      end;
    2:begin
        yeymode:=1;
        line(px,miny,px,maxy,0);
        line(minx,py,maxx,py,0);
      end;
    3:begin
        yeymode:=1;
        circle(px,py,5,0);
      end;
    4:begin
        yeymode:=1;
        line(px-5,py+5,px+5,py+5,0);
        line(px-5,py-5,px+5,py-5,0);
        line(px+5,py-5,px+5,py+5,0);
        line(px-5,py-5,px-5,py+5,0);
      end;
    5:begin
        if px<(maxx+minx) shr 1 then
          if py<(maxy+miny) shr 1 then putthis(px,py,pen^,0)
          else putthis(px,py-6,pen^,0)
        else if py>(maxy+miny)shr 1 then putthis(px-6,py-6,pen^,0)
          else putthis(px-6,py,pen^,0);
      end;
    end;
    yeymode:=lyey;
  end;
  showed:=false;
end;{hidepos}

procedure obeykey;
begin
  ch:=readkey;
  if ch=#0 then
  begin
    ch:=readkey;
    if ch in[#71,#72,#73,#79,#80,#81,#75,#77]then begin lx:=x;ly:=y;end;
    if ch in[#71,#72,#73]then dec(y);
    if ch in[#79,#80,#81]then inc(y);
    if ch in[#71,#75,#79]then dec(x);
    if ch in[#73,#77,#81]then inc(x);
    if y<miny then y:=miny;
    if y>maxy then y:=maxy;
    if x<minx then x:=minx;
    if x>maxx then x:=maxx;
  end else
  begin
    case under of
      0:begin
          if ch=#27 then exit:=true;
        end;
    end;
  end;
end;{obeykey}

procedure obeymouse;
begin
  if bot=0 then
      begin
        if (botcount=1) and (mybot[1]=2)then c:=yeyun(x,y);
        if (botcount=2) and (mybot[1]=1)and(mybot[2]=3)then ;
        if (botcount=3) and (mybot[1]=3)and(mybot[2]=2)and(mybot[3]=1)then clear;
        if (botcount=2) and (mybot[1]=3)and(mybot[2]=1)then {getcolorcommand};
        if (botcount=2) and (mybot[1]=2)and(mybot[2]=3)then {yeyan_method:=(yeyan_method+1)mod 3;{obeyget}
        begin
          inc(posmeth);
          if posmeth>5 then posmeth:=0;
        end;
        if (botcount=2) and (mybot[1]=2)and(mybot[2]=1)then
        begin
          getthis(0,0,319,199,image^);
          vgamode(((gmis+1)mod 3)+1){obeyput};
          setmiceres(maxx,maxy,1);
          putthis(0,0,image^,0);
        end;
        if (botcount=2) and (mybot[1]=3)and(mybot[2]=2)then {centeron:=not(centeron);{obeyenlarge};
      end;
  case under of
    0:begin
        if(bot=1)and((lx<>x)or(ly<>y))and(botcount=1)then line(lx,ly,x,y,c)
          else if (botcount=1)and(bot=0)and(lbot=1)then yeyan(x,y,c);
        if(botcount=2)and((lx<>x)or(ly<>y))and(mybot[1]=1)and(mybot[2]=2)then
          myfill(x,y,c)else if(botcount=2)and(mybot[1]=1)and(mybot[2]=2)
                              and(bot=0)then myfill(x,y,c);
      end;
    1:begin
        if l then else
      end;
  end;
end;{obeymouse}

procedure initialize;
begin
  vgamode(2);
  getmem(image,65535);
  getmem(buffer,65535);
  getmem(pen,258);
  exit:=false;
  x:=maxx shr 1;
  y:=maxy shr 1;
  c:=15;
  lx:=x;
  ly:=y;
  under:=0;
{  initmouse;}
{  maxmicey:=399;}
  setmiceres(maxx,maxy,1);
end;{initialize}

procedure intro;
var mouseok:byte;
begin
  aload('pictures\myicons2.liz',buffer^);
  for d3:=0 to 255 do
    mygetdac(d3,red[d3],green[d3],blue[d3]);
  for d1:=0 to 5 do
  begin
    d2:=d1*13*maxy div 399;
    frame(20+d2,20+d2,299-d2,maxy-20-d2,10,10,98+d1,100+d1,102+d1);
  end;
  d2:=d2+13;
  frame(20+d2,20+d2,299-d2,maxy-20-d2,10,10,31-5+d1,29-5+d1,27-5+d1);
  window(20+d2,20+d2,299-d2,maxy-20-d2);
  putstring('Hi! I''m Angelo Lanuza'#13);
  putstring('The new generation.');
  mouseok:=0;
  repeat
    retr;
    for d3:=98 to 107 do
      myup(107-d3+98,red[16+(d3+d4) and 255],green[16+(d3+d4) and 255],blue[16+(d3+d4)and 255]);
    delay(50);
    dec(d4);
    giveme;
  until keypressed or (bot>0);
  for d3:=0 to 255 do
    myup(d3,red[d3],green[d3],blue[d3]);
  uncompress(buffer^,myptr(image^)[2]);
  myptr(image^)[0]:=63999 and 255;
  myptr(image^)[1]:=63999 shr 8;
  putthis(0,0,image^,0);
end;{intro}

procedure closingremarks;
begin
end;{closing remarks}

procedure unini;
begin
end;{unini}


BEGIN
  initialize;
  intro;
{  ch:=readkey;}
  repeat
    addmousemove(lx,ly,x,y);
    giveme;
    showpos;
    while not(keypressed)and(lx=x)and(ly=y)and(lbot=bot)do
    begin
      if posmeth in[1,3,4] then begin
                                lposmeth:=posmeth;
                                posmeth:=1;
                                showpos;
                                posmeth:=lposmeth;
                              end;
      addmousemove(lx,ly,x,y);
      giveme;
    end;
    hidepos;
    if keypressed then obeykey;
    obeymouse;
  until exit;
  closingremarks;
  unini;
END.