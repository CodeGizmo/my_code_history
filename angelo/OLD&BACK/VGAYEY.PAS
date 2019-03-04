unit vgayey;{Version 1}
interface
var
  fillmethod,cc :byte;
  a,gseg,b,pseg,c,gofs,pofs,cp :word;

procedure vgamode(gm:byte);
procedure clear;
procedure yeyan(x,y:word;c:byte);
procedure moveyey(x,y:word);
procedure horline(x,y,l:integer;c:byte);
procedure vertline(x,y,l:integer;c:byte);
procedure movehorline(x,y,l:integer;c:byte);
procedure hiyey(x,y:word;c:byte);
function  yeyun(x,y:word):byte;
procedure myup(pix,red,grn,blu:byte);
procedure mygetdac(pix:byte;var rd,gr,bl:byte);
procedure getdac(what:word;var red,green,blue:byte);
procedure setactivepage(p:byte);
procedure Plot(px,py,pc:WORD);
function getplot(x,y:word):byte;
function agetplot(px,py:word):word;
procedure line(x1,y1,x2,y2,c:integer);
procedure circle(x0,y0,r,c:integer);
procedure sphere(x0,y0,r,c:integer);
procedure movesphere(x2,y2,r,x0,y0:integer);
procedure ellipse ( x0,y0,a0,b0,c:integer);
procedure oval(x,y,x0,y0:integer;c:byte);
procedure mix(p1,p2,r1,r2,g1,g2,b1,b2:byte);
procedure fillthis(x,y:word;pc,c0:byte);
procedure filler(x,y:word;pc:byte);
procedure bar(x1,y1,x2,y2:word;c:byte);
procedure movebar(x1,y1,x2,y2,x3,y3:word);
procedure box(x1,y1,x2,y2:word;c:byte);
procedure getthis(x1,y1,x2,y2:word;var buf);
procedure putthis(x,y:word;var buf;meth:byte);
procedure aload(filename:string;var buf);
procedure asave(filename:string;var buf);
procedure lizsave(filename:string;var buf);
procedure compress(var gbuf,pbuf);
procedure uncompress(var gbuf,pbuf);
procedure implode(var gbuf,pbuf);
procedure explode(var gbuf,pbuf);
procedure retr;
procedure retrb;

implementation

procedure vgamode(gm:byte);
begin
  asm
    cmp  gm,255
    je   @rest
    cmp  gm,4
    je   @cga
    cmp  gm,1
    ja   @othermodes
    and  gm,1
    add  gm,18
    mov  ah,0
    mov  al,gm
    jmp  @e
@rest:
    mov  al,3
    jmp  @e
@cga:
    mov  al,4
    jmp  @e
@othermodes:
    mov  al,gm
@e:
    mov  ah,0
    int  10h
  end;
end;{vgamode}

procedure clear;
begin
  asm
    mov ax,pseg
    mov es,ax
    mov di,0
    mov cx,32000
    mov al,cc
    mov ah,al
    rep stosw
  end;
end;{clear}

procedure yeyan(x,y:word;c:byte);
begin
  asm
	 mov  es,pseg
    mov  ax,320
    mul  y
    add  ax,x
    mov  di,ax
    mov  al,c
    stosb
  end;
end;{yeyan}

procedure moveyey(x,y:word);
begin
  asm
	 mov  es,pseg
    mov  cx,ds
    mov  ds,gseg
    mov  ax,320
    mul  y
    add  ax,x
    mov  di,ax
    mov  si,ax
    movsb
    mov  ds,cx
  end;
end;{moveyey}

procedure horline(x,y,l:integer;c:byte);
begin
  if l>0 then
  asm
	 mov  es,pseg
    mov  ax,320
    mul  y
    add  ax,x
    mov  di,ax
    mov  al,c
    dec  l
    mov  cx,l
    rep stosb
  end;
end;{horline}

procedure vertline(x,y,l:integer;c:byte);
begin
  if l>0 then
  asm
	 mov  es,pseg
    mov  ax,320
    mul  y
    add  ax,x
    mov  di,ax
    mov  al,c
    dec  l
	 mov  cx,l
  @looper:
	 stosb
	 add  di,319
	 loop @looper
  end;
end;{vertline}

procedure movehorline(x,y,l:integer;c:byte);
begin
  if l>0 then
  asm
	 mov  es,pseg
    mov  ax,320
    mul  y
    add  ax,x
    mov  di,ax
    mov  si,di
    add  si,gofs
    mov  al,c
    dec  l
    mov  cx,l
    mov  ax,ds
    mov  ds,gseg
    rep  movsb
    mov  ds,ax
  end;
end;{movehorline}

procedure hiyey(x,y:word;c:byte);
begin
  asm
    push ds
    mov  al,c
    mov  ah,0
    mov  bx,0
    mov  cx,x
    mov  dx,y
    xchg cx,bx
    mov  cl,bl
    shr  bx,1
    shr  bx,1
    shr  bx,1
    or   ch,ch
    jne  @t1
@t3:
	 mov  ch,al
    mov  ax,80d
    mul  dx
    add  bx,ax
    mov  dx,03ceh
    xor  ax,ax
    out  dx,ax
    mov  ax,0f01h
    out  dx,ax
    and  cl,07
    mov  ax,8008h
    shr  ah,cl
    out  dx,ax
	 mov  ds,pseg
    or   ch,ch
    js   @t2
    or   [bx],al
    mov  ah,ch
    out  dx,ax
    or   [bx],al
@t4:
    mov  ax,0ff08h
    out  dx,ax
    xor  ax,ax
    out  dx,ax
    inc  al
    out  dx,ax
    mov  al,ch
    mov  ah,0ch
    jmp  @ok
@t1:
    push 0c000h
    pop  es
    add bx,es:[044ch]
    dec  ch
    jne  @t1
    jmp  @t3
@t2:
    mov  ax,1803h
    out  dx,ax
    mov  ah,ch
    xor  al,al
    out  dx,ax
    or   [bx],al
    mov  ax,0003
    out  dx,ax
    jmp  @t4
@ok:
    pop  ds
  end;
end;{hiyey}

function yeyun(x,y:word):byte;
var c:byte;
begin
  asm
	 mov  cx,ds
	 mov  ds,gseg
    mov  ax,320
    mul  y
    add  ax,x
    mov  si,ax
    lodsb
    mov  c,al
	 mov  ds,cx
  end;
  yeyun:=c;
end;{yeyun}

procedure myup(pix,red,grn,blu:byte);
begin
  asm
    pushf
    cli
    mov  dx,03c8h
    mov  al,pix
    out  dx,al
    inc  dx
    mov  al,red
    out  dx,al
    mov  al,grn
    out  dx,al
    mov  al,blu
    out  dx,al
    popf
  end;
end;{myup}

procedure mygetdac(pix:byte;var rd,gr,bl:byte);
var red,grn,blu:byte;
begin
  asm
    pushf
    cli
	 mov  dx,03c7h
	 mov  al,pix
    out  dx,al
	 add  dx,2
	 in   al,dx
	 mov  red,al
	 in   al,dx
	 mov  grn,al
	 in   al,dx
	 mov  blu,al
	 popf
  end;
  rd:=red;
  gr:=grn;
  bl:=blu;
end;{mygetdac}

procedure getdac(what:word;var red,green,blue:byte);
var
  r,g,b:byte;
begin
  asm
    mov ax,1015h
    mov bx,what
    int 10h
    mov r,dh
    mov g,ch
    mov b,cl
  end;
  red:=r;
  green:=g;
  blue:=b;
end;{getdac}

procedure setactivepage(p:byte);
begin
  asm
    mov  ah,05
    mov  al,p
    int  10h
  end;
end;{setactivepage}

procedure Plot(px,py,pc:WORD);
BEGIN
asm
        MOV   ES,PSEG
        MOV   SI,PX
        CMP   SI,639
        JA    @END_PLOT
        MOV   DI,SI
        shr   di,1
        shr   di,1
        MOV   DL,BYTE PTR PY
        CMP   DL,199
        JA    @END_PLOT
        MOV   DH,DL
        SHR   DH,1
        shr   dh,1
        MOV   AL,160
        MUL   DH
        ADD   DI,AX
        MOV   Cx,3
        and   dx,cx
        ROR   DX,1
        ROR   DX,1
        ROR   DX,1
        ADD   DI,DX
        and   si,cx
        sub   cx,si
        add   cl,cl
        mov   bl,byte ptr pc
        mov   bh,bl
        shr   bh,1
        shr   bh,1
        and   bx,1100000011b
        mov   al,11111100b
        rol   al,cl
        shl   bx,cl
        AND   ES:BYTE PTR [DI],AL
        AND   ES:BYTE PTR 32768[DI],AL
        OR    ES:BYTE PTR [DI],Bl
        OR    ES:BYTE PTR 32768[DI],Bh
@END_PLOT:
end;
END;{plot}

function getplot(x,y:word):byte;
var
  g:byte;
begin
  asm
    mov  ah,0dh
    mov  cx,x
    mov  dx,y
    int  10h
    mov  g,al
  end;
  getplot:=g;
end;{getplot}

function agetplot(px,py:word):word;
var
    pc:byte;
BEGIN
asm
        MOV   ES,gSEG
        MOV   SI,PX
        CMP   SI,639
        JA    @END_PLOT
        MOV   DI,SI
        shr   di,1
        shr   di,1
        MOV   DL,BYTE PTR PY
        CMP   DL,199
        JA    @END_PLOT
        MOV   DH,DL
        SHR   DH,1
        shr   dh,1
        MOV   AL,160
        MUL   DH
        ADD   DI,AX
        MOV   Cx,3
        and   dx,cx
        ROR   DX,1
        ROR   DX,1
        ROR   DX,1
        ADD   DI,DX
        and   si,cx
        sub   cx,si
        add   cl,cl
        mov   bl,es:byte ptr[di]
        mov   bh,es:byte ptr 32768[di]
        mov   ax,1100000011b
        shl   ax,cl
        and   bx,ax
        shr   bx,cl
        shl   bh,1
        shl   bh,1
        add   bl,bh
        mov   bh,0
        mov   word ptr pc,bx
@END_PLOT:
end;
        agetplot:=pc;
END;{agetplot}

procedure line(x1,y1,x2,y2,c:integer);
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
      mem[pseg:y1*320+x1]:=c;
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
        mem[pseg:y1*320+x1]:=c;
      end;
    end else
    begin
      mem[pseg:y1*320+x1]:=c;
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
        mem[pseg:y1*320+x1]:=c;
      end;
    end;
  end else
  begin
    dy := (y1-y2);
    if dx >= dy then
    begin
      mem[pseg:y1*320+x1]:=c;
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
        mem[pseg:y1*320+x1]:=c;
      end;
    end else
    begin
      mem[pseg:y1*320+x1]:=c;
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
        mem[pseg:y1*320+x1]:=c;
      end;
    end;
  end;
end;{line}

procedure circle(x0,y0,r,c:integer);
var
  e,x,y : integer;

begin
  x := r; y := 0; e := 0;
  while y <= x do
  begin
    yeyan(x0+x,y0+y,c);
    yeyan(x0-x,y0+y,c);
    yeyan(x0+x,y0-y,c);
    yeyan(x0-x,y0-y,c);
    yeyan(x0+y,y0+x,c);
    yeyan(x0-y,y0+x,c);
    yeyan(x0+y,y0-x,c);
    yeyan(x0-y,y0-x,c);
    inc(y);
    inc(e,(y shl 1)-1);
    if e > x then
    begin
      dec(x);
      dec(e,(x shl 1)+1);
    end;
  end;
end;{circle}

procedure sphere(x0,y0,r,c:integer);
var
  e,x,y : integer;

begin
  x := r; y := 0; e := 0;
  while y <= x do
  begin
    horline(x0-x,y0+y,(x shl 1)+2,c);
    horline(x0-x,y0-y,(x shl 1)+2,c);
    horline(x0-y,y0+x,(y shl 1)+2,c);
    horline(x0-y,y0-x,(y shl 1)+2,c);
    inc(y);
    inc(e,(y shl 1)-1);
    if e > x then
    begin
      dec(x);
      dec(e,(x shl 1)+1);
    end;
  end;
end;{sphere}

procedure movesphere(x2,y2,r,x0,y0:integer);
var
  e,x,y,xx,xxx,yy,yyy : integer;
begin
  gofs:=y2*320+x2-(y0*320+x0);
  x := r; y := 0; e := 0;
  while y <= x do
  begin
    movehorline(x0-x,y0+y,(x shl 1)+2,c);
    movehorline(x0-x,y0-y,(x shl 1)+2,c);
    movehorline(x0-y,y0+x,(y shl 1)+2,c);
    movehorline(x0-y,y0-x,(y shl 1)+2,c);
    inc(y);
    inc(e,(y shl 1)-1);
    if e > x then
    begin
      dec(x);
      dec(e,(x shl 1)+1);
    end;
  end;
  gofs:=0;
end;{movesphere}

procedure ellipse ( x0,y0,a0,b0,c:integer);
var
  x,y :integer;
  a,b,asq,asq2,bsq,bsq2,d,dx,dy:longint;
begin
  x := 0 ;
  y := b0 ;
  a := a0 ;
  b := b0 ;
  asq := a*a ;
  asq2 := asq*2 ;
  bsq := b*b ;
  bsq2 := bsq*2 ;
  d := bsq-(asq*b)+(asq shr 2) ;
  dx := 0 ;
  dy := asq2*b ;
  while dx<dy do
  begin
    {if fill then}
    yeyan(x0+x,y0+y,c) ;
    yeyan(x0-x,y0+y,c) ;
    yeyan(x0+x,y0-y,c) ;
    yeyan(x0-x,y0-y,c) ;
    if d>0 then
    begin
      dec(y) ;
      dec(dy,asq2) ;
      dec(d,dy) ;
    end ;
    inc(x) ;
    inc(dx,bsq2) ;
    inc(d,bsq+dx) ;
  end;
  inc(d,(3*(asq-bsq)DIV 2-(dx+dy))DIV 2) ;
  while y>=0 do
  begin
    {IF fill THEN
      HLine(x0-x,y0+y,x0+x,c);
      HLine(x0-x,y0-y,x0+x,c);
    ELSE}
    yeyan(x0+x,y0+y,c) ;
    yeyan(x0-x,y0+y,c) ;
    yeyan(x0+x,y0-y,c) ;
    yeyan(x0-x,y0-y,c) ;
    if d<0 then
    begin
      inc(x) ;
      inc(dx,bsq2) ;
      inc(d,dx) ;
    end;
    dec(y) ;
    dec(dy,asq2) ;
    inc(d,asq-dy) ;
  end ;
end;{ellipse}

procedure oval(x,y,x0,y0:integer;c:byte);
begin
  ellipse(x,y,round(abs(x0-x)*1.414213562),round(abs(y0-y)*1.414213562),c);
end;{oval}

procedure mix(p1,p2,r1,r2,g1,g2,b1,b2:byte);
var
  dp,rd,gd,bd:real;
  dr,dg,db:integer;
  p,r,g,b:byte;
begin
  r1:=r1 and 63;r2:=r2 and 63;g1:=g1 and 63;g2:=g2 and 63;b1:=b1 and 63;b2:=b2 and 63;
  dp:=p2-p1;
  if dp=0 then dp:=0.00000001;
  dr:=r2-r1;
  dg:=g2-g1;
  db:=b2-b1;
  rd:=dr/dp;
  gd:=dg/dp;
  bd:=db/dp;
  for p:=0 to round(dp) do
  begin
    r:=r1+round(rd*p);
    g:=g1+round(gd*p);
    b:=b1+round(bd*p);
    myup(p+p1,r,g,b);
  end;
end;{mix}

procedure fillthis(x,y:word;pc,c0:byte);
var
  ru,rd:boolean;
  ar:word;
  r:array[0..4096]of word;
begin
  if fillmethod=0 then
  begin
    c0:=yeyun(x,y);
    if c0<>pc then
    begin
      ar:=0;
      repeat
        ru:=true;
        rd:=true;
        while(x>0)and(yeyun(x-1,y)=c0)do dec(x);
        yeyan(x,y,pc);
        if yeyun(x,y-1)=c0 then begin
          if ru then begin
            inc(ar);
            r[ar]:=y*320+x-320;
            ru:=false;
          end;end else ru:=true;
        if yeyun(x,y+1)=c0 then begin
          if rd then begin
            inc(ar);
            r[ar]:=y*320+x+320;
            rd:=false;
          end;end else rd:=true;

        if(y>0)and(y<199)then
        while(x<319)and(yeyun(x+1,y)=c0)do begin
          inc(x);
          yeyan(x,y,pc);
          if yeyun(x,y-1)=c0 then begin
            if ru then begin
              inc(ar);
              r[ar]:=y*320+x-320;
              ru:=false;
            end;
          end else ru:=true;
          if yeyun(x,y+1)=c0 then begin
            if rd then begin
              inc(ar);
              r[ar]:=y*320+x+320;
              rd:=false;
            end;end else rd:=true;
        end else if y=0 then
        while(x<319)and(yeyun(x+1,y)=c0)do
        begin
          inc(x);
          yeyan(x,y,pc);
          if yeyun(x,y+1)=c0 then begin
            if rd then begin
              inc(ar);
              r[ar]:=y*320+x+320;
              rd:=false;
            end;end else rd:=true;
        end else
        while(x<319)and(yeyun(x+1,y)=c0)do begin
          inc(x);
          yeyan(x,y,pc);
          if yeyun(x,y-1)=c0 then begin
            if ru then begin
              inc(ar);
              r[ar]:=y*320+x-320;
              ru:=false;
            end;end else ru:=true;
        end;
      y:=r[ar]div 320;
      x:=r[ar]mod 320;
      dec(ar);
      until ar>4096;
    end;
  end else





  begin
    ar:=0;
    repeat
      ru:=true;
      rd:=true;
      while(x>0)and(not(yeyun(x-1,y)in[c0,pc]))do dec(x);
      yeyan(x,y,pc);
      if not(yeyun(x,y-1)in[c0,pc])then begin
        if ru then begin
          inc(ar);
          r[ar]:=y*320+x-320;
          ru:=false;
        end;end else ru:=true;
      if not(yeyun(x,y+1)in[c0,pc])then begin
        if rd then begin
          inc(ar);
          r[ar]:=y*320+x+320;
          rd:=false;
        end;end else rd:=true;

      if(y>0)and(y<199)then
      while(x<319)and(not(yeyun(x+1,y)in[c0,pc]))do begin
        inc(x);
        yeyan(x,y,pc);
        if not(yeyun(x,y-1)in[c0,pc])then begin
          if ru then begin
            inc(ar);
            r[ar]:=y*320+x-320;
            ru:=false;
          end;
        end else ru:=true;
        if not(yeyun(x,y+1)in[c0,pc])then begin
          if rd then begin
            inc(ar);
            r[ar]:=y*320+x+320;
            rd:=false;
          end;end else rd:=true;
      end else if y=0 then
      while(x<319)and(not(yeyun(x+1,y)in[c0,pc]))do
      begin
        inc(x);
        yeyan(x,y,pc);
        if not(yeyun(x,y+1)in[c0,pc])then begin
          if rd then begin
            inc(ar);
            r[ar]:=y*320+x+320;
            rd:=false;
          end;end else rd:=true;
      end else
      while(x<319)and(not(yeyun(x+1,y)in[c0,pc]))do begin
        inc(x);
        yeyan(x,y,pc);
        if not(yeyun(x,y-1)in[c0,pc])then begin
          if ru then begin
            inc(ar);
            r[ar]:=y*320+x-320;
            ru:=false;
          end;end else ru:=true;
      end;
    y:=r[ar]div 320;
    x:=r[ar]mod 320;
    dec(ar);
    until ar>4096;
  end;
end;{fillthis}

procedure filler(x,y:word;pc:byte);
var
  c0:byte;
  nx,ny,orx,olx,upos1,upos2,dpos1,dpos2:word;
  u1,u2,d1,d2,wu1,wu2,wd1,wd2:array[0..256]of word;
begin
  c0:=yeyun(x,y);
  yeyan(x,y,pc);
  if c0<>pc then
  begin
    upos1:=0;
    upos2:=1;
    dpos1:=1;
    dpos2:=0;
    nx:=x;
    while(nx>0)and(yeyun(nx-1,y)=c0)do begin dec(nx);yeyan(nx,y,pc);end;
    u2[1]:=y*320+nx;
    d1[1]:=y*320+nx;
    while(x<319)and(yeyun(x+1,y)=c0)do begin inc(x);yeyan(x,y,pc);end;
    wu2[1]:=x;
    wd1[1]:=x;

    repeat
      while(upos2>0)and(upos2<255)do
      begin
        y:=(u2[upos2]div 320);
        olx:=u2[upos2]mod 320;
        orx:=wu2[upos2];
        dec(upos2);
        if y>0 then
        for x:=olx to orx do
        begin
			 if mem[gseg:y*320+x-320]{ yeyun(x,y-1)}=c0 then
          begin
            ny:=y-1;
            nx:=x;
            yeyan(nx,ny,pc);
            while(nx>0)and(yeyun(nx-1,ny)=c0)do
            begin
              dec(nx);
              yeyan(nx,ny,pc);
            end;
            inc(upos1);
            u1[upos1]:=ny*320+nx;
            if(nx+1)<olx then begin
              inc(dpos1);
              d1[dpos1]:=u1[upos1];
              wd1[dpos1]:=olx-2;
            end;
            nx:=x;
            while(nx<319)and(yeyun(nx+1,ny)=c0)do
            begin
              inc(nx);
              yeyan(nx,ny,pc);
            end;
            wu1[upos1]:=nx;
            if nx>(orx+1) then begin
              inc(dpos1);
              d1[dpos1]:=ny*320+orx+2;
              wd1[dpos1]:=nx;
            end;
          end;
        end;
      end;




      while(dpos1>0)and(dpos1<255)do
      begin
        y:=(d1[dpos1]div 320);
        olx:=d1[dpos1]mod 320;
        orx:=wd1[dpos1];
        dec(dpos1);
        if y<199 then
        for x:=olx to orx do
        begin
          if yeyun(x,y+1)=c0 then
          begin
            ny:=y+1;
            nx:=x;
            yeyan(nx,ny,pc);
            while(nx>0)and(yeyun(nx-1,ny)=c0)do
            begin
              dec(nx);
              yeyan(nx,ny,pc);
            end;
            inc(dpos2);
            d2[dpos2]:=ny*320+nx;
            if(nx+1)<olx then begin
              inc(upos1);
              u1[upos1]:=d2[dpos2];
              wu1[upos1]:=olx-2;
            end;
            nx:=x;
            while(nx<319)and(yeyun(nx+1,ny)=c0)do
            begin
              inc(nx);
              yeyan(nx,ny,pc);
            end;
            wd2[dpos2]:=nx;
            if nx>(orx+1) then begin
              inc(upos1);
              u1[upos1]:=ny*320+orx+2;
              wu1[upos1]:=nx;
            end;
          end;
        end;
      end;




      while(upos1>0)and(upos1<255)do
      begin
        y:=(u1[upos1]div 320);
        olx:=u1[upos1]mod 320;
        orx:=wu1[upos1];
        dec(upos1);
        if y>0 then
        for x:=olx to orx do
        begin
          if yeyun(x,y-1)=c0 then
          begin
            ny:=y-1;
            nx:=x;
            yeyan(nx,ny,pc);
            while(nx>0)and(yeyun(nx-1,ny)=c0)do
            begin
              dec(nx);
              yeyan(nx,ny,pc);
            end;
            inc(upos2);
            u2[upos2]:=ny*320+nx;
            if(nx+1)<olx then begin
              inc(dpos2);
              d2[dpos2]:=u2[upos2];
              wd2[dpos2]:=olx-2;
            end;
            nx:=x;
            while(nx<319)and(yeyun(nx+1,ny)=c0)do
            begin
              inc(nx);
              yeyan(nx,ny,pc);
            end;
            wu2[upos2]:=nx;
            if nx>(orx+1) then begin
              inc(dpos2);
              d2[dpos2]:=ny*320+orx+2;
              wd2[dpos2]:=nx;
            end;
          end;
        end;
      end;




      while(dpos2>0)and(dpos2<255)do
      begin
        y:=(d2[dpos2]div 320);
        olx:=d2[dpos2]mod 320;
        orx:=wd2[dpos2];
        dec(dpos2);
        if y<199 then
        for x:=olx to orx do
        begin
          if yeyun(x,y+1)=c0 then
          begin
            ny:=y+1;
            nx:=x;
            yeyan(nx,ny,pc);
            while(nx>0)and(yeyun(nx-1,ny)=c0)do
            begin
              dec(nx);
              yeyan(nx,ny,pc);
            end;
            inc(dpos1);
            d1[dpos1]:=ny*320+nx;
            if(nx+1)<olx then begin
              inc(upos2);
              u2[upos2]:=d1[dpos1];
              wu2[upos2]:=olx-2;
            end;
            nx:=x;
            while(nx<319)and(yeyun(nx+1,ny)=c0)do
            begin
              inc(nx);
              yeyan(nx,ny,pc);
            end;
            wd1[dpos1]:=nx;
            if nx>(orx+1) then begin
              inc(upos2);
              u2[upos2]:=ny*320+orx+2;
              wu2[upos2]:=nx;
            end;
          end;
        end;
      end;
    until((upos1=0)or(upos1>254))and((upos2=0)or(upos2>254))
         and((dpos1=0)or(dpos1>254))and((dpos2=0)or(dpos2>254));
  end;
end;{filler}

procedure bar(x1,y1,x2,y2:word;c:byte);
var
  ddx,dy,ddi,dum,ad:word;
begin
  if x1>x2 then begin dum:=x1;x1:=x2;x2:=dum;end;
  if y1>y2 then begin dum:=y1;y1:=y2;y2:=dum;end;
  ddx:=x2-x1+1;
  ad:=320-ddx;
  dy:=y2-y1+1;
  ddi:=y1*320+x1;
  asm
	 mov  es,pseg
    mov  di,ddi
    mov  cx,dy
    mov  si,ddx
    mov  al,c
  @looper:
    mov  dx,cx
    mov  cx,si
    rep  stosb
    add  di,ad
    mov  cx,dx
    loop @looper
  end;
end;{bar}

procedure movebar(x1,y1,x2,y2,x3,y3:word);
var
  start,dummy:word;
begin
  if x1>x2 then begin dummy:=x2;x2:=x1;x1:=dummy end;
  if y1>y2 then begin dummy:=y2;y2:=y1;y1:=dummy end;
  start:=y1*320+x1;
  gofs:=(y3*320+x3)-start;
  asm
    cld
    push ds
    push bx
    mov  ax,x2
    inc  ax
    sub  ax,x1
    mov  cx,y2
    inc  cx
    sub  cx,y1
    mov  dx,320
    sub  dx,ax
    mov  di,start
    mov  si,di
    add  si,gofs
    mov  es,pseg
    mov  ds,gseg

  @looper:
    mov  bx,cx
    mov  cx,ax
    rep  movsb
    add  di,dx
    add  si,dx
    mov  cx,bx
    loop @looper

    pop  bx
    pop  ds
  end;
  gofs:=0;
end;{movebar}

procedure box(x1,y1,x2,y2:word;c:byte);
var
  ddx,dy,di1,di2,dum,ad:word;
begin
  if x1>x2 then begin dum:=x1;x1:=x2;x2:=dum;end;
  if y1>y2 then begin dum:=y1;y1:=y2;y2:=dum;end;
  ddx:=x2-x1+1;
  dy:=y2-y1;
  di1:=y1*320+x1;
  di2:=y2*320+x1;
  asm
	 mov  es,pseg
    mov  di,di1
    mov  al,c
    mov  cx,ddx
    rep  stosb
    mov  di,di1
    mov  cx,dy
  @looper1:
    stosb
    add  di,319
    loop @looper1
    mov  di,di1
    add  di,ddx
    dec  di
    mov  cx,dy
  @looper2:
    stosb
    add  di,319
    loop @looper2
    mov  di,di2
    mov  cx,ddx
    rep  stosb
  end;
end;{box}

procedure getthis(x1,y1,x2,y2:word;var buf);
var
  dex,dey,pos,m,n,leaper,dummy:word;
begin
  if x2<x1 then begin dummy:=x1;x1:=x2;x2:=dummy;end;
  if y2<y1 then begin dummy:=y1;y1:=y2;y2:=dummy;end;
  dex:=x2-x1;
  dey:=y2-y1;
  pos:=y1*320+x1;
  m:=seg(buf);
  n:=ofs(buf);
  leaper:=319-dex;
  memw[m:n]:=dey*320+dex;
  inc(dey);
  inc(dex);
  inc(n,2);
  asm
    pushf
    push bx
    push ds
	 mov  ds,gseg
    mov  es,m
    mov  si,pos
    mov  di,n
    mov  ax,leaper
    mov  bx,dex
    mov  cx,dey
    cld
@looper:
    mov  dx,cx
    mov  cx,bx
    rep  movsb
    add  si,ax
    mov  cx,dx
    loop @looper
    pop  ds
    pop  bx
    popf
  end;
end;{getthis}

procedure putthis(x,y:word;var buf;meth:byte);
var
  dex,dey,pos,m,n,leaper,dummy:word;
begin
  pos:=y*320+x;
  m:=seg(buf);
  n:=ofs(buf);
  dey:=memw[m:n]div 320;
  dex:=memw[m:n]mod 320;
  leaper:=319-dex;
  inc(dey);
  inc(dex);
  inc(n,2);
  asm
    pushf
    push bx
    push ds
	 mov  es,pseg
    mov  dx,gseg
    mov  ds,m
    mov  di,pos
    mov  si,n
    mov  bx,leaper
    mov  cx,dey
    cld

    cmp  meth,0
    jne  @meth1
@looper0:
    mov  dx,cx
    mov  cx,dex
    rep  movsb
    add  di,bx
    mov  cx,dx
    loop @looper0
    jmp  @ending
@meth1:
    cmp  meth,1
    jne  @meth2
@looper1:
    mov  dx,cx
    mov  cx,dex
@looper01:
    lodsb
    not  al
    stosb
    loop @looper01
    add  di,bx
    mov  cx,dx
    loop @looper1
    jmp  @ending
@meth2:
    cmp  meth,2
    jne  @meth3
@looper2:
    mov  dx,cx
    mov  cx,dex
@looper02:
    xchg di,si
    lodsb
    mov  ah,al
    xchg di,si
    lodsb
    dec  di
    xor  al,ah
    stosb
    loop @looper02
    add  di,bx
    mov  cx,dx
    loop @looper2
    jmp  @ending
@meth3:
    cmp  meth,3
    jne  @meth4
@looper3:
    mov  dx,cx
    mov  cx,dex
@looper03:
    xchg di,si
    lodsb
    mov  ah,al
    xchg di,si
    lodsb
    dec  di
    or  al,ah
    stosb
    loop @looper03
    add  di,bx
    mov  cx,dx
    loop @looper3
    jmp  @ending
@meth4:
    cmp  meth,4
    jne  @meth5
@looper4:
    mov  dx,cx
    mov  cx,dex
@looper04:
    xchg di,si
    lodsb
    mov  ah,al
    xchg di,si
    lodsb
    dec  di
    and  al,ah
    stosb
    loop @looper04
    add  di,bx
    mov  cx,dx
    loop @looper4
    jmp  @ending
@meth5:
    mov  ds,dx
@looper5:
    mov  dx,cx
    mov  cx,dex
    rep  movsb
    add  di,bx
    mov  si,di
    mov  cx,dx
    loop @looper5
@ending:
    pop  ds
    pop  bx
    popf
  end;
end;{putthis}

procedure aload(filename:string;var buf);
var
  f:file;
begin
  assign(f,filename);
  reset(f,1);
  blockread(f,buf,filesize(f));
  close(f);
end;{aload}

procedure asave(filename:string;var buf);
var
  f:file;
begin
  assign(f,filename);
  rewrite(f,1);
  blockwrite(f,buf,64000);
  close(f);
end;{asave}

procedure lizsave(filename:string;var buf);
var
  f:file;
begin
  assign(f,filename);
  rewrite(f,1);
  blockwrite(f,buf,memw[seg(buf):0]);
  close(f);
end;{lizsave}

var
  pp,lastcp,x,y:word;
  t,t1,t2:byte;
  gsegpos:word;
  psegpos:word;
  maxsize:word;
procedure compress(var gbuf,pbuf);
begin
  gsegpos:=seg(gbuf);
  psegpos:=seg(pbuf);
  cp:=2;
  pp:=0;
  repeat
    if mem[gsegpos:pp]=mem[gsegpos:pp+1]then
    begin
      t:=1;
      while(mem[gsegpos:pp]=mem[gsegpos:pp+1])and((t<127)and(pp<maxsize))do
      begin
        inc(t);
        inc(pp);
      end;
      mem[psegpos:cp]:=t;
      inc(cp);
      mem[psegpos:cp]:=mem[gsegpos:pp];
      inc(cp);
      inc(pp);
    end else
    begin
      lastcp:=cp;
      t:=0;
      while(mem[gsegpos:pp]<>mem[gsegpos:pp+1])and((t<127)and(pp<maxsize))do
      begin
        inc(t);
        inc(cp);
        mem[psegpos:cp]:=mem[gsegpos:pp];
        inc(pp);
      end;
      mem[psegpos:lastcp]:=$80+t;
      inc(cp);
    end;
  until pp>=maxsize;
  memw[psegpos:0]:=cp;
end;{compress}

procedure uncompress(var gbuf,pbuf);
begin
  psegpos:=seg(pbuf);
  gsegpos:=seg(gbuf);
  lastcp:=memw[gsegpos:0];
  cp:=2;
  pp:=0;
  repeat
    t:=mem[gsegpos:cp]and $7f;
    if(mem[gsegpos:cp]and $80)=0 then
    begin
      inc(cp);
      for x:=1 to t do
      begin
        mem[psegpos:pp]:=mem[gsegpos:cp];
        inc(pp);
      end;
      inc(cp);
    end else
    begin
      for x:=1 to t do
      begin
        inc(cp);
        mem[psegpos:pp]:=mem[gsegpos:cp];
        inc(pp);
      end;
      inc(cp);
    end;
  until cp>=lastcp;
end;{uncompress}

procedure implode(var gbuf,pbuf);
begin
  gsegpos:=seg(gbuf);
  psegpos:=seg(pbuf);
  cp:=2;
  pp:=0;
  repeat
    if(mem[gsegpos:pp]=mem[gsegpos:pp+1])then
    begin
      t1:=1;
      t2:=0;
      while(mem[gsegpos:pp]=mem[gsegpos:pp+1])and((pp<maxsize)and(t2<$ff))do
      begin
        while(mem[gsegpos:pp]=mem[gsegpos:pp+1])and((pp<maxsize)and(t1<63))do
        begin
          inc(t1);
          inc(pp);
        end;
        if(mem[gsegpos:pp]=mem[gsegpos:pp+1])and((pp<maxsize)and(t2<$ff))then
        begin
          inc(pp);
          inc(t2);
          t1:=1;
        end;
      end;
      if t2>0 then
      begin
        mem[psegpos:cp]:=64+t1;
        inc(cp);
        mem[psegpos:cp]:=t2;
        inc(cp);
      end else
      begin
        mem[psegpos:cp]:=t1;
        inc(cp);
      end;
      mem[psegpos:cp]:=mem[gsegpos:pp];
      inc(cp);
      inc(pp);
    end else
    begin
      lastcp:=cp;
      t:=0;
      while(mem[gsegpos:pp]<>mem[gsegpos:pp+1])and((t<127)and(pp<maxsize))do
      begin
        inc(t);
        inc(cp);
        mem[psegpos:cp]:=mem[gsegpos:pp];
        inc(pp);
      end;
      mem[psegpos:lastcp]:=$80+t;
      inc(cp);
    end;
  until pp>=maxsize;
  memw[psegpos:0]:=cp;
end;{implode}

procedure explode(var gbuf,pbuf);
begin
  gsegpos:=seg(gbuf);
  psegpos:=seg(pbuf);
  lastcp:=memw[gsegpos:0];
  cp:=2;
  pp:=0;
  repeat
    t:=mem[gsegpos:cp]and $7f;
    t1:=mem[gsegpos:cp]and $3f;
    t2:=mem[gsegpos:cp+1];
    if(mem[gsegpos:cp]and $80)=0 then
    begin
      if(mem[gsegpos:cp]and $40)=0 then
      begin
        inc(cp);
        for x:=1 to t1 do
        begin
          mem[psegpos:pp]:=mem[gsegpos:cp];
          inc(pp);
        end;
        inc(cp);
      end else
      begin
        inc(cp,2);
        y:=(t2 shl 6)+t1-t2;
        for x:=1 to y do
        begin
          mem[psegpos:pp]:=mem[gsegpos:cp];
          inc(pp);
        end;
        inc(cp);
      end;
    end else
    begin
      for x:=1 to t do
      begin
        inc(cp);
        mem[psegpos:pp]:=mem[gsegpos:cp];
        inc(pp);
      end;
      inc(cp);
    end;
  until cp>=lastcp;
end;{explode}

procedure retr;
begin
  asm
    mov  dx,3dah
    cli
    mov  ah,0
  @hindipa2:
    in   al,dx
    and  al,8
    jne   @hindipa2
  @hindipa1:
    in   al,dx
    and  al,8
    je   @hindipa1
    sti
  end;
end;{retr}

procedure retrb;
begin
  asm
    mov  dx,3dah
    cli
    mov  ah,0
  @hindipa1:
    in   al,dx
    and  al,8
    je   @hindipa1
  @hindipa2:
    in   al,dx
    and  al,8
    jne   @hindipa2
    sti
  end;
end;{retrb}

procedure initialize;
begin
  fillmethod:=0;
  gseg:=$a000;
  pseg:=$a000;
  gofs:=0;
  pofs:=0;
  maxsize:=$fc00;
  cc:=0;
end;

begin
  initialize;
end.