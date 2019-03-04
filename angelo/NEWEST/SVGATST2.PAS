uses crt,vgaliza3;
var
   m:word;
   x,y:word;
   ch:char;

procedure mymem(x:word;c:byte;p:byte);
begin
  asm
    mov   ax,$a000
    mov   es,ax
    mov   di,x
    mov   cl,p
    mov   ah,1
    shl   ah,cl
    mov   al,2
    mov   dx,3c4h
    out   dx,ax
    mov   al,c
    stosb
  end;
end;{syeyan}
var
  hc,lc:byte;
  xx,yy:word;
begin
 m:=530;
  directvideo:=false;
  repeat
    svgamode(m);
{    for y:=0 to 399 do
    for x:=0 to 319 do
    begin
      syeyan2(x,y,x);
    end;
    for y:=0 to 32767 do mem[$a000:y]:=y;
    {mem[$a000:0]:=127;
    mem[$a000:8]:=255;}
(*    for yy:=0 to 80 do
    for xx:=0 to 7 do
{    for y:=0 to 15 do}
    begin
      y:=yy * 320 + xx;
      hc:=y shr 8;
      lc:=y and 255;
      mymem(y*2    , hc , 0+(y and 1)*2);
      mymem(y*2 + 1, lc , 1+(y and 1)*2);
    end;*)
    for x:=0 to 14 do
    begin
      asm
        mov   ax,4f05h
        mov   bx,0
        mov   dx,x
        int   10h
      end;
      for yy:=0 to 31 do
      begin
          y:=yy;
        for xx:=0 to 639 do
        begin
          y:=yy;
          mymem((yy*2048)+(xx)*3+2,255-((longint(xx)*255) div 639),(xx*3+2)and 3);
          mymem((yy*2048)+(xx)*3+0,(longint(xx)*255) div 639,((xx*3)+0)and 3);
          mymem((yy*2048)+(xx)*3+1,(x*32+yy)*100 div 187,((xx*3)+1)and 3);
         { mymem((yy*512+xx)*4+3,0,3);}
        end;
      end;
    end;
(*    for y:=0 to 25 do
    for x:=0 to 639 do
    begin
{      yy:=x and 3;         }
      asm
        mov   cl,0
        mov   ah,1
        shl   ah,cl
        mov   al,2
        mov   dx,3c4h
        out   dx,ax
      end;
      mem[$a000:x+y*2560]:=y*10;
{      yy:=x and 3;         }
      asm
        mov   cl,1
        mov   ah,1
        shl   ah,cl
        mov   al,2
        mov   dx,3c4h
        out   dx,ax
      end;
      mem[$a000:x+y*2560]:=x;
    end;*)
{    mymem(0,255,0);
    mymem(1,255,1);
    mymem(2,255,3);}
{    mymem(3,255,4);}

    mymem(6,255,2);
    mymem(7,255,3);
    mymem(8,255,0);
{    mymem(9,255,1);
    mymem(10,255,2);
    mymem(11,255,3);}

    mymem(512*4  ,255,0);
    mymem(512*4+1,255,1);
    mymem(512*4+2,255,2);
 {   mymem(512*4+3,255,3);}

    mymem(65530,255,0);
    mymem(65531,255,1);
    mymem(65532,255,2);
    inc(m);
    ch:=readkey;
  until ch=#27;
{  svgamode(266);
  gotoxy(0,0);
  writeln(m:8);
  readkey;}
end.