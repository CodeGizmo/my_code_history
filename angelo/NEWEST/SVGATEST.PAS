uses crt,vgaliza3;
var
   m:word;
   x,y:word;
   ch:char;

procedure mymem(x:integer;c:byte;p:byte);
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




procedure myplot(x, y:word; b, g, r:byte);
begin
  asm
    mov ax,$a000
    mov es,ax
    mov di,word ptr x
    mov ax,640
    mul word ptr y
    add di,ax
    adc dx,0
    shl dx,2
    shl di,1
    mov ax,0
    adc ax,0
    add dx,ax
    add dx,ax
    shl di,1
    adc dx,0

    mov ax,$4f05
    push bx
    mov bx,0
    int $10
    pop bx

    mov ah,1
    mov al,2
    mov dx,$3c4
    out dx,ax
    mov al,byte ptr b
    stosb

    shl ah,1
    mov al,2
    out dx,ax
    mov al,byte ptr g
    stosb

    shl ah,1
    mov al,2
    out dx,ax
    mov al,byte ptr r
    stosb
  end;
end;

procedure myhor(x, y, w:word;b,g,r:byte);
begin
  asm
    mov ax,$a000
    mov es,ax
    mov di,word ptr x
    mov ax,640
    mul word ptr y
    add di,ax
    adc dx,0
    shl dx,2
    shl di,1
    mov ax,0
    adc ax,0
    add dx,ax
    add dx,ax
    shl di,1
    adc dx,0

    push dx

    mov ax,$4f05
    push bx
    mov bx,0
    int $10
    pop bx

    mov ah,1
    mov al,2
    mov dx,$3c4
    out dx,ax
    mov al,byte ptr b

    mov si,di
    mov cx,word ptr w

@looperB:
    stosb
    add di,3
    jc  @nextbankB


    pop  dx
    push dx
    push ax
    mov  ax,$4F05

    push bx
    mov  bx,0
    int  $10
    pop  bx
    pop  ax



@backB:
    loop @looperB

    shl ah,1
    mov al,2
    mov dx,$3c4
    out dx,ax
    mov al,byte ptr g

    inc si
    mov di,si
    mov cx,word ptr w

@looperG:
    stosb
    add di,3
    jc  @nextbankG


    pop  dx
    push dx
    push ax
    mov  ax,$4F05

    push bx
    mov  bx,0
    int  $10
    pop  bx
    pop  ax


@backG:
    loop @looperG

    shl ah,1
    mov al,2
    mov dx,$3c4
    out dx,ax
    mov al,byte ptr r

    inc si
    mov di,si
    mov cx,word ptr w

@looperR:
    stosb
    add di,3
    jc  @nextbankR
@backR:
    loop @looperR
    jmp @last

@nextbankB:
    pop  dx
    push dx
    inc  dx
    push ax
    mov  ax,$4F05

    push dx
    mov  bx,0
    int  $10
    pop  bx
    pop  ax
    jmp  @backB

@nextbankG:
    pop  dx
    push dx
    inc  dx
    push ax
    mov  ax,$4F05

    push bx
    mov  bx,0
    int  $10
    pop  bx
    pop  ax
    jmp  @backG

@nextbankR:
    pop  dx
    push dx
    inc  dx
    push ax
    mov  ax,$4F05

    push bx
    mov  bx,0
    int  $10
    pop  bx
    pop  ax
    jmp  @backR
@last:
    pop  dx
  end;
end;





var
  hc,lc:byte;
  xx,yy:word;
begin
 m:=274;
  directvideo:=false;
  repeat
    svgamode(m);
    for y:=0 to 399 do
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
    for yy:=0 to 479 do
    begin
        y:=yy;
      for xx:=0 to 639 do
      begin
{        y:=yy;
        mymem((yy*640+xx)*4  ,255-xx,0);
        mymem((yy*640+xx)*4+1,xx,1);
        mymem((yy*640+xx)*4+2,yy*10,2);
        mymem((yy*640+xx)*4+3,xx,3);}
        myplot(xx,yy,255-xx,xx,yy);
      end;
    end;
    for yy:=0 to 479 do
      myhor(0,yy,639,yy,yy,yy);
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
    mymem(0,255,0);
    mymem(1,255,1);
    mymem(2,255,3);
    mymem(3,255,4);

    mymem(8,255,0);
    mymem(9,255,1);
    mymem(10,255,2);
    mymem(11,255,3);

    mymem(512*4  ,255,0);
    mymem(512*4+1,255,1);
    mymem(512*4+2,255,2);
    mymem(512*4+3,255,3);
    inc(m);
    ch:=readkey;
  until ch=#27;
{  svgamode(266);
  gotoxy(0,0);
  writeln(m:8);
  readkey;}
end.