unit vgaliza3;{Version 2.00}
{created by: LANUZA, Angelo Lian}
{Address: 234 Purple Rd., Gatchalian Subd., Las Pinas Metro Manila}
{Tel #: dial 109 for a cellular call to 079-27-30}
interface
var
  fillmethod,cc                    :byte;
  a,b,c,cp                         :word;
  gseg,gseg2,pseg,syaofs,sydofs    :word;
  pseghi1,pseghi2,gseghi1,gseghi2  :word;
  gofs,gofs2,pofs                  :word;
  winx1,winx2,winy1,winy2,
  towinx1,towinx2,towiny1,towiny2,
  minx,miny,maxx,maxy              :integer;
  maxsize                          :word;
  myfilesize                       :word;
  gmis                             :byte;
  yeymode                          :byte;
var
  framemode:word;
  fc1,fc2,fc3:byte;
var
  charw,charh:word;
  textx,texty:word;
  charinstalled:boolean;
  mychar:array[0..255]of pointer;

const mvga    = 1;
      mvga4   = 2;
      msvga   = 3;
      mvgahi  = 0;
      mtext   = 255;
      mtexthi = 13;
      mcga    = 4;

procedure vgamode(gm:byte);
procedure clear;
procedure yeyan(x,y:integer;c:byte);
procedure pset(x,y,c:integer);
procedure syeyan(x,y:integer;c:byte);
procedure syeyan2(x,y:integer;c:byte);
function syeyun(x,y:integer):byte;
function syeyun2(x,y:integer):byte;
procedure superpage(page:word);
procedure setdofs(myofs:word);
procedure moveyey(x,y:integer);
procedure horline(x,y,l:integer;c:byte);
procedure vertline(x,y,l:integer;c:byte);
procedure movehorline(x,y,l:integer;c:byte);
procedure hiyey(x,y:integer;c:byte);
function getplot(x,y:word):byte;
function yeyun(x,y:integer):byte;
function yeyun2(x,y:integer):byte;
procedure myup(pix,red,grn,blu:byte);
procedure mygetdac(pix:byte;var rd,gr,bl:byte);
procedure getdac(what:word;var red,green,blue:byte);
procedure setactivepage(p:byte);
procedure line(x1,y1,x2,y2,c:integer);
procedure linexor(x1,y1,x2,y2:word);
procedure circle(x0,y0,r,c:integer);
procedure sphere(x0,y0,r,c:integer);
procedure movesphere(x2,y2,r,x0,y0:integer);
procedure ellipse ( x0,y0,a0,b0,c:integer);
procedure oval(x,y,x0,y0:integer;c:byte);
procedure mix(p1,p2,r1,r2,g1,g2,b1,b2:byte);
procedure fillthis(x,y:word;pc,c0:byte);
procedure filler(x,y:word;pc:byte);
procedure myfill(px,py,pc:word);
procedure bar(x1,y1,x2,y2:integer;c:byte);
procedure movebar(x1,y1,x2,y2,x3,y3:word);
procedure box(x1,y1,x2,y2:word;c:byte);
procedure getthis(x1,y1,x2,y2:word;var buf);
procedure get(x1,y1,x2,y2:word;var buf);
procedure putthis(x,y:word;var buf;meth:byte);
procedure put(x,y:word;var buf);
procedure aload(filename:string;var buf);
procedure asave(filename:string;var buf;size:word);
procedure psave(filename:string;var buf);
procedure lizsave(filename:string;var buf);
procedure compress(var gbuf,pbuf);
procedure uncompress(var gbuf,pbuf);
procedure implode(var gbuf,pbuf);
procedure zip(var gbuf,pbuf);
procedure unzip(var gbuf,pbuf);
procedure explode(var gbuf,pbuf);
procedure retr;
procedure retrb;
procedure putchar(c:byte);
procedure putstring(s:string);
procedure loadchar(s:string);
procedure savechar(s:string);
procedure renewchar(w,h:byte);
procedure textxy(x,y:word);
procedure window(x1,y1,x2,y2:word);
procedure frame(x1,y1,x2,y2:integer;th,tv,c1,c2,c3:byte);
procedure framein(x1,y1,x2,y2:integer;th,tv,c1,c2,c3:byte);
procedure windin;
procedure lubog(x1,y1,x2,y2:integer);

implementation

const
SC_INDEX        = $3c4;       {  ;Sequence Controller Index register}
GC_INDEX        = $3ce;      {   ;Graphics Controller Index register }
CRTC_INDEX      = $3d4;
MAP_MASK        = 2;        {    ;Map Mask register index in SC }
MEMORY_MODE     = 4;
MAX_SCAN_LINE   = 9;
START_ADDRESS_HIGH = $0c;
UNDERLINE	  = $14;
MODE_CONTROL    = $17;
READ_MAP        = 4;          {  ;Read Map register index in GC}
GRAPHICS_MODE   = 5;
MISCELLANEOUS   = 6;
SCREEN_WIDTH    = 320;       {   ;# of pixels across screen }
SCREEN_HEIGHT   = 400;
WORD_OUTS_OK    = 0;        {    ;set to 0 to assemble for}

procedure vgamode(gm:byte);
begin
  gmis:=gm;
  case gmis of
    0:begin
       minx:=0;
       miny:=0;
       maxx:=639;
       maxy:=479;
      end;
    1,2:begin
          minx:=0;
          miny:=0;
          maxx:=319;
          maxy:=199;
        end;
    3:begin
        minx:=0;
        miny:=0;
        maxx:=319;
        maxy:=399;
      end;
  end;
  winx1:=0;
  winy1:=0;
  winx2:=maxx;
  winy2:=maxy;

  asm
    cmp  gm,255
    je   @rest
    cmp  gm,4
    je   @cga
    cmp  gm,2
    je   @supervga
    cmp  gm,3
    je   @supervga
    cmp  gm,1
    ja   @othermodes
    and  gm,1
    add  gm,18
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
    jmp  @endvgamode
@supervga:
    pusha
    mov  ax,0013h
    int  10h
    mov  dx,SC_INDEX
    mov  al,MEMORY_MODE
    out  dx,al
    inc  dx
    in   al,dx
    and  al,not 08h
    or   al,04h
    out  dx,al
    mov  dx,GC_INDEX
    mov  al,GRAPHICS_MODE
    out  dx,al
    inc  dx
    in   al,dx
    and  al,not 10h
    out  dx,al
    dec  dx

    mov  al,MISCELLANEOUS
    out  dx,al
    inc  dx
    in   al,dx
    and  al,not 02h
    out  dx,al

    {CONSTANT_TO_INDEXED_REGISTER SC_INDEX,MAP_MASK,0fh}
    mov  al,0fh
    mov  ah,map_mask
    mov  dx,sc_index
    out  dx,ax

    mov  ax,$a000
    mov  es,ax
    sub  di,di
    mov  ax,di
    mov  cx,8000h
    cld
    rep  stosw

    mov  dx,CRTC_INDEX
    cmp  gm,2
    je   @skip
    mov  al,MAX_SCAN_LINE
    out  dx,al
    inc  dx
    in   al,dx
    and  al,not 1fh
    out  dx,al
    dec  dx
@skip:

    mov  al,UNDERLINE
    out  dx,al
    inc  dx
    in   al,dx
    and  al,not 40h
    out  dx,al
    dec  dx
    mov  al,MODE_CONTROL
    out  dx,al
    inc  dx
    in   al,dx
    or   al,40h
    out  dx,al
    popa
@endvgamode:
  end;
end;{vgamode}

procedure clear;
begin
  if not(gmis in[2,3])then
  asm
    mov ax,pseg
    mov es,ax
    mov di,0
    mov cx,32000
    mov al,cc
    mov ah,al
    rep stosw
  end else
  asm
    mov ax,0a000h
    mov es,ax
    mov di,0
    mov cx,8000h
    cld

    mov dx,3c4h
    mov al,2
    mov ah,0fh
    out dx,ax

    mov al,cc
    mov ah,al
    rep stosw
  end;
end;{clear}

procedure hiyey(x,y:integer;c:byte);
begin
  c:=c div 16;
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

procedure syeyan(x,y:integer;c:byte);
begin
  asm
    mov   ax,$a000
    mov   es,ax
    mov   ax,80
    mul   y
    mov   cx,x
    add   cx,pofs
    mov   di,cx
    shr   di,1
    shr   di,1
    add   di,ax
    add   di,syaofs
    and   cl,3
    mov   ah,1
    shl   ah,cl
    mov   al,2
    mov   dx,3c4h
    out   dx,ax
    mov   al,c
    stosb
  end;
end;{syeyan}

procedure syeyan2(x,y:integer;c:byte);
begin
  if gmis=mvga4 then
  asm
    mov   es,pseg
    mov   ax,80
    mul   y
    mov   di,x
    ror   di,1
    ror   di,1
    add   di,ax
    add   di,pofs
    mov   al,c
    stosb
  end else
  asm
    mov   ax,pseghi1
    cmp   y,200
    jb    @skip
    mov   ax,pseghi2
    sub   y,200
  @skip:
    mov   es,ax
    mov   ax,160
    mul   y
    mov   di,x
    ror   di,1
    ror   di,1
    add   di,ax
    add   di,pofs
    mov   al,c
    stosb
  end;
end;{syeyan2}

procedure pset(x,y,c:integer);
begin
  asm
    mov ah,0ch
    mov al,byte(c)
    mov cx,x
    mov dx,y
    int 10h
  end;
end;

var saveseg,saveofs,savesize,savepos:word;
    saver:pointer;
procedure yeyan(x,y:integer;c:byte);
begin
  if c>127 then
  begin
    if (x>maxx)or(y>maxy)or(x<minx)or(y<miny)then exit;
    c:=c and $7f;
  end;
  case yeymode of
    0:;
    1:c:=128+yeyun(x,y);
    2:c:=not(yeyun(x,y));
    3:c:=yeyun(x,y)+1;
    4:begin
        if savepos<savesize then
        begin
          mem[saveseg:saveofs+savepos]:=yeyun(x,y);
          yeymode:=0;
          yeyan(x,y,c);
          yeymode:=4;
          inc(savepos);
        end;
      end;
    5:begin
        if savepos>0 then
        begin
          dec(savepos);
          yeymode:=0;
          yeyan(x,y,mem[saveseg:saveofs+savepos]);
          yeymode:=5;
        end;
      end;
  end;
  if (gmis=1)or(pseg<>$a000) then
  asm
    mov  es,pseg
    mov  ax,320
    mul  y
    add  ax,x
    add  ax,pofs
    mov  di,ax
    mov  al,c
    stosb
  end else if (gmis=2)or(gmis=3) then syeyan(x,y,c)
           else if gmis=0 then hiyey(x,y,c)else pset(x,y,c);
end;{yeyan}

procedure setsavesize(size:word);
begin
  freemem(saver,savesize);
  getmem(saver,size);
  {savesize:=size}
end;

function syeyun(x,y:integer):byte;
var c:byte;
begin
  asm
    mov   ax,80
    mul   y
    mov   si,x
    shr   si,1
    shr   si,1
    add   si,ax
    add   si,syaofs
    mov   ah,byte(x)
    and   ah,3
    mov   al,READ_MAP
    mov   dx,GC_INDEX
    out   dx,ax
    mov   cx,ds
    mov   ax,0a000h
    mov   ds,ax
    lodsb
    mov   ds,cx
    mov   c,al
  end;
  syeyun:=c;
end;{syeyun}

function syeyun2(x,y:integer):byte;
var c:byte;
begin
  if gmis=mvga4 then
  asm
    mov   ax,80
    mul   y
    mov   si,x
    ror   si,1
    ror   si,1
    add   si,ax
    add   si,gofs
    mov   cx,ds
    mov   ds,gseg
    lodsb
    mov   ds,cx
    mov   c,al
  end else
  asm
    mov   cx,gseghi1
    cmp   y,200
    jb    @skip
    mov   cx,gseghi2
    sub   y,200
  @skip:
    mov   ax,80
    mul   y
    mov   si,x
    ror   si,1
    ror   si,1
    add   si,ax
    add   si,gofs
    push  cx
    mov   ds,cx
    lodsb
    pop   ds
    mov   c,al
  end;
  syeyun2:=c;
end;{syeyun2}

procedure superpage(page:word);
begin
  asm
    cli
    mov  ax,page
    push ax
    mov  al,0ch
    mov  dx,3d4h
    out  dx,ax
    pop  ax
    mov  ah,al
    mov  al,0dh
    out  dx,ax
    sti
  end;
end;{superpage}

procedure setdofs(myofs:word);
begin
  port[$3d4]:=$c;
  port[$3d5]:=hi(myofs);
  port[$3d4]:=$d;
  port[$3d5]:=lo(myofs);
end;{setdofs}

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


function yeyun(x,y:integer):byte;
var c:byte;
begin
  if (gmis=1)or(gseg<>$a000) then
  asm
    mov  ax,320
    mul  y
    add  ax,x
    add  ax,gofs
    mov  cx,ds
    mov  ds,gseg
    mov  si,ax
    lodsb
    mov  c,al
    mov  ds,cx
  end else if (gmis=2)or(gmis=3) then c:=syeyun(x,y)else c:=getplot(x,y);
  yeyun:=c;
end;{yeyun}

function yeyun2(x,y:integer):byte;
var c:byte;
begin
  asm
    mov  ax,320
    mul  y
    add  ax,x
    add  ax,gofs2
    mov  cx,ds
    mov  ds,gseg2
    mov  si,ax
    lodsb
    mov  c,al
    mov  ds,cx
  end;
  yeyun2:=c;
end;{yeyun2}

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
  gseg2:=$a000;
  pseg:=$a000;
  gofs:=0;
  gofs2:=0;
  pofs:=0;
  syaofs:=0;
  sydofs:=0;
  maxsize:=$fc00;
  cc:=0;
  pseghi1:=$a000;
  pseghi2:=$a000;
  gseghi1:=$a000;
  gseghi2:=$a000;
  yeymode:=0;
  saveseg:=$a000;
  saveofs:=0;
  savepos:=0;
  savesize:=0;
  charw:=0;
  charh:=0;
  textx:=0;
  texty:=0;
  charinstalled:=false;
  framemode:=$ff;
end;

begin
  initialize;
  vgamode(3);
  loadchar('e:\angelo\newest\pictures\mychar.chr');
  frame(160-86,200-18,160+86,200+18,12,10,28,24,20);
  window(160-84,200-12,160+84,200+12);
  putstring('Hi! I''m Angelo Lian Lanuza.'#13'This is my graphics unit utility,'
            +'you are using now.');
  for a:=0 to 100 do retr;
  vgamode(mtext);
end.
