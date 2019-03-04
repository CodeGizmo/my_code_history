uses vgayey,crt;
var vga_segment:word;
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

procedure supervga;
begin
  vga_segment:=$a000;
  asm
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

	mov  ax,VGA_SEGMENT
	mov  es,ax
	sub  di,di
	mov  ax,di
	mov  cx,8000h
	cld
	rep  stosw

	mov  dx,CRTC_INDEX
	mov  al,MAX_SCAN_LINE
	out  dx,al
	inc  dx
	in   al,dx
	and  al,not 1fh
	out  dx,al
	dec  dx

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
  end;
end;{supervga}

procedure syeyan(x,y:word;c:byte);
begin
  asm
     pusha
     mov        cx,x
     mov        dx,y
     mov        bl,c
                 mov   ax,VGA_SEGMENT
                 mov   es,ax
                 mov   ax,SCREEN_WIDTH/4

                 mul   dx
                 push  cx
                 shr   cx,1
                 shr   cx,1
                 add   ax,cx
                 mov   di,ax
                 pop   cx
                 and   cl,3
                 mov   ah,1
                 shl   ah,cl
                 mov   al,map_mask
                 mov   dx,sc_index
                 out   dx,ax
                 mov   es:[di],bl
                 popa
  end;
end;{syeyan}

procedure superpage(page1,page2:byte);
begin
  asm
    cli
    mov  ah,page1
    mov  al,0ch
    mov  dx,3d4h
    out  dx,ax
    mov  ah,page2
    mov  al,0dh
    out  dx,ax
    sti
  end;
end;{superpage}

procedure sline(x1,y1,x2,y2,c:integer);
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
      syeyan(x1,y1,c);
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
        syeyan(x1,y1,c);
      end;
    end else
    begin
      syeyan(x1,y1,c);
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
        syeyan(x1,y1,c);
      end;
    end;
  end else
  begin
    dy := (y1-y2);
    if dx >= dy then
    begin
      syeyan(x1,y1,c);
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
        syeyan(x1,y1,c);
      end;
    end else
    begin
      syeyan(x1,y1,c);
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
        syeyan(x1,y1,c);
      end;
    end;
  end;
end;{line}

var
  x,y,c,p:word;
  pp:pointer;
begin
  supervga;
  getmem(pp,65535);
  aload('newbunny.all',pp^);
  gseg:=seg(pp^);
  for x:=0 to 319 do
  for y:=0 to 199 do
  begin
    vga_segment:=$a000;
  syeyan(x,y,yeyun(x+2,y));
    vga_segment:=$a800;
  syeyan(x,y,yeyun(x+2,y));
  end;
  p:=0;
  for x:=0 to 256 do
  for y:=0 to 256 do
  begin
    retr;
    superpage(x,y);
  end;
  repeat
    retr;
    superpage(hi(p),lo(p));
    p:=p xor $8000;
  until keypressed;
  vgamode(1);
  vgamode(3);
  freemem(pp,65535);
end.













