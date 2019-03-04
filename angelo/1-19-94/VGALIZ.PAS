unit vgaliz;{Version 1}
interface
var
  fillmethod,cc                 :byte;
  a,gseg,b,pseg,c,gofs,pofs,cp  :word;
  minx,miny,maxx,maxy           :word;
  maxsize                       :word;
  myfilesize                    :word;
  gmis                          :byte;

procedure vgamode(gm:byte);
procedure clear;
procedure yeyan(x,y:word;c:byte);
procedure syeyan(x,y:word;c:byte);
procedure superpage(page:word);
procedure moveyey(x,y:word);
procedure horline(x,y,l:integer;c:byte);
procedure vertline(x,y,l:integer;c:byte);
procedure movehorline(x,y,l:integer;c:byte);
procedure hiyey(x,y:word;c:byte);
function yeyun(x,y:word):byte;
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
procedure filler2(x,y:word;pc:byte);
procedure bar(x1,y1,x2,y2:word;c:byte);
procedure movebar(x1,y1,x2,y2,x3,y3:word);
procedure box(x1,y1,x2,y2:word;c:byte);
procedure getthis(x1,y1,x2,y2:word;var buf);
procedure putthis(x,y:word;var buf;meth:byte);
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
  if gm=1 then begin
                 minx:=0;
                 miny:=0;
                 maxx:=319;
                 maxy:=199;
               end else
               begin
                 minx:=0;
                 miny:=0;
                 maxx:=639;
                 maxy:=479;
               end;
  asm
    cmp  gm,255
    je   @rest
    cmp  gm,4
    je   @cga
    cmp  gm,2
    je   @supervga
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
@endvgamode:
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
    {add  ax,pofs THIS IS TEMPORARY, I WILL ERASE THIS LATER}
    mov  di,ax
    mov  al,c
    stosb
  end;
end;{yeyan}

procedure syeyan(x,y:word;c:byte);
begin
  asm
    pusha
    mov        cx,x
    mov        dx,y
    mov        bl,c

    mov   ax,pseg
    mov   es,ax
    mov   ax,SCREEN_WIDTH/4
    mul   dx
    push ount);
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
          else getthis(x-6,y   asm
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
    end else
    begin
      for b:=0 to dey do
      for a:=0 to dex do
      begin
        {yeyan(x+a,y+b,mem[m:n]);}
        inc(n);
      end;
    end;
  end else put(x,y,buf);

end;{putthis}

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

begin
  swapvectors;
  exec('d:\scream\stmod.exe','d:\scream\ice-t.stm');
  swapvectors;

  directvideo:=false;
  writeln('pasok uno');
  getmem(p,16002);
  writeln('pasok getmem');
  vgamode(1);

  vgamode(1);
  writeln('pasok graph');
  while not(keypressed)do
  begin
    fs:='pictures\bounce.ani';
    assign(f,fs);
    reset(f,1);
    blockread(f,col,1);
    blockread(f,col,768);
    for a:=0 to 255 do
        myup(a,col[a,0],col[a,1],col[a,2]);
    for a:=0 to 29 do
    begin
      blockread(f,ptr(seg(p^),ofs(p^)+2)^,16000);
      memw[seg(p^):ofs(p^)]:=99*320+159;
      putthis(0,0,p^,0);
    end;
    close(f);

    fs:='pictures\waves.ani';
    assign(f,fs);
    reset(f,1);
    blockread(f,col,1);
    blockread(f,col,768);
    for a:=0 to 255 do
        myup(a,col[a,0],col[a,1],col[a,2]);
    for a:=0 to 29 do
    begin
      blockread(f,ptr(seg(p^),ofs(p^)+2)^,16000);
      memw[seg(p^):ofs(p^)]:=99*320+159;
      putthis(0,0,p^,0);
    end;
    close(f);

    fs:='pictures\sphrplan.ani';
    assign(f,fs);
    reset(f,1);
    blockread(f,col,1);
    blockread(f,col,768);
    for a:=0 to 255 do
        myup(a,col[a,0],col[a,1],col[a,2]);
    for a:=0 to 29 do
    begin
      blockread(f,ptr(seg(p^),ofs(p^)+2)^,16000);
      memw[seg(p^):ofs(p^)]:=99*320+159;
      putthis(0,0,p^,0);
    end;
    close(f);

    fs:='pictures\dna.ani';
    assign(f,fs);
    reset(f,1);
    blockread(f,col,1);
    blockread(f,col,768);
   
    begin
      blockread(f,ptr(seg(p^),ofs(p^)+2)^,16000);
      memw[seg(p^):ofs(p^)]:=99*320+159;
      putthis(0,0,p^,0);
    end;
    close(f);


  end;
  vgamode(255);
end.

      putthis(0,0,p^,0);
    end;
    close(f);


  end;
  vgamode(255);
end.

en begin y:=maxy;beep end end;
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
  for a:=0 to 31 do
    for b:=0 to 7 do
    begin
      bar(1+a shl 3,1+b shl 3,a shl 3+6,b shl 3+6,b*32+a);
      box(a shl 3,b shl 3,a shl 3+7,b shl 3+7,0);
    end else
  for a:=0 to 31 do
    for b:=0 to 7 do
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
           else begin dumbyte:=biWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?');*)
  until exit;
  closeremarks;
  exitprog;
end.****}
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
              filler2(bigx+(x shr 2),bigy+(y shr 2),c);
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
            filler(x,y,c)else if(botcount=2)and(mybot[1]=1)and(mybot[2]=2)
                                and(bot=0)then filler(x,y,c);
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
  yeyan_method:=0;
  mouseon:=false;
end;

begin
  clrscr;
  initialize;
  vgamode(1);
  gotomyint9;




  begin
    f:='pictures\logo.liz';
    aload(f,p^);
    uncompress(p^,ptr(pseg,pofs)^);
    getthis(0,0,319,199,p^);
    myreadkey;
    vgamode(3);
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
{  freemem(p,65535)}
end.














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














mtext);
  beep;
{  freemem(p,65535)}
end.














(ymic)else beep;end;
            #81:begin if xmic<319 then inc(xmic)else beep;if ymic<199 then inc(ymic)else beep;end;
            #73:begin if xmic<319 then inc(xmic)else beep;if ymic>0 then dec(ymic)else beep;end;
            #79:begin if xmic>0 then dec(xmic)else beep;if ymic<199 then inc(ymic)else beep;end;
            else checkright;
          end;
          if ch in[#72,#80,#75,#77,#71,#81,#73,#79]then if onplot then yeyan(xmic,ymic,pmic);
        end;
      end;
    end;
  end else
  begin
    if ch='z'then zipperns;
    if ch='u'then unzipperns;
    if ch='e'then unzipperns2;
    if ch='*'then onplot:=not(onplot);
    if ch='\'then
    begin
      inc(posmeth);
      if posmeth>2 then posmeth:=0;
      if posmeth=2 then
      begin
        if ymic>100 then
        begin
          getthis(0,0,319,7,forposition^);
          upper:=true;
        end else
        begin
          getthis(0,192,31pressed then getkeycommand;
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
{  freemem(p,65535)}
end.














  lx:=xmic;ly:=ymic;
  end else
  begin
    if l then line(lx,ly,xmic,ymic,pmic);
    if m then
    begin
      pmic:=yeyun(xmic,ymic);
      inc(minc);
      if minc>30 then begin checkright;choosecolor;minc:=0;end;
    end else minc:=0;
    lx:=xmic;
    ly:=ymic;
  end;
end;{fetchmouse}

procedure initialize;
begin
  asm
    mov ax,0
    int 33h
  end;
  posmeth:=1;
  myup(255,63,63,63);
  ch:=#0;
  minc:=0;
  getmem(p1,64002);
  getmem(p2,64002);
  getmem(p3,64002);
  directvideo:=false;
  getmem(pen,52);
  getthis(xmic,ymic,xmic+6,ymic+6,pen^);
  pmic:=1;
  bmic:=0;
  closethis:=false;
  getmem(luh,322);
  getmem(ldh,322);
  getmem(llv,202);
  getmem(lrv,202);
{  for x1:=0 to 15 do
  getmem(pt[x1],4002);}
  x1:=0;x2:=319;y1:=0;y2:=199;
  mydelay:=0;
  speed:=0;
  getmem(forposition,4096);
  onplot:=false;
end;{initialize}

begin
  vgamode(1);
  initialize;
  repeat
    getcount;
    fetchmouse;
    if keypressed then
    begin
      obeycommand;
      inc(speed);
      if speed>10 then speed:=5;
      slower:=0;
    end else
    begin
      inc(slower);
      if slower>10 then speed:=0;
    end;
    showposition;
  until ch=#27;
end.uses crt,vgaliza;
var
  on,off                    :byte;
  ch                        :char;
  a,b,c,d,a1,a2,a3,a4,loop  :word;
  counter                   :word;
  soundon                   :boolean;
  mytime                    :word;
  myvol                     :byte;
  mydur                     :word;
  pat                       :array[0..255]of byte;

procedure tring(time:word;vol:byte;dur:word);
var
  loops:word;
  tvol:byte;
begin
  if vol>time then vol:=time;
  loops:=(4860 div time)*dur;
  for loop:=0 to loops do
  begin
     tvol:=vol-vol*loop div loops;
     for a:=0 to time-tvol do; port[$61]:=on;
     for a:=0 to tvol  do; port[$61]:=off;
  end;
end;

procedure tring2(time:word;vol:byte;dur:word);
var
  loops:word;
  tvol:byte;
begin
  if vol>time then vol:=time;
  loops:=(4860 div time)*dur;
  for loop:=0 to loops do
  begin
     tvol:=vol-(pat[loop*255 div loops]*vol div 63)*loop div loops;
     for a:=0 to time-tvol do; port[$61]:=on;
     for a:=0 to tvol  do; port[$61]:=off;
  end;
end;

procedure trings(time:word;dur:word);
var
  loops:word;
  tvol:byte;
begin
  loops:=(4860 div time)*dur;
  for loop:=0 to loops do
  begin
     tvol:=255*loop div loops;
     for a:=0 to time-pat[tvol] do; port[$61]:=on;
     for a:=0 to pat[tvol] do; port[$61]:=off;
  end;
end;

procedure initialize;
begin
  on:=port[$61]or 2;
  off:=port[$61]and not(3);
  cou0s1440
                  { disk type }
               );
     restoretable;*)
end. to 255 do
    pat[a]:=63;
end;{initialize}

begin
  initialize;
  ch:=#0;
  readkey;
  repeat
    if keypressed then
    begin
      ch:=readkey;
      if ch='t' then tring(mytime,myvol,mydur);
      if ch='1' then trings(mytime,mydur);
      if ch='2' then tring2(mytime,myvol,mydur);
      if ch='s' then soundon:=not(soundon);
      if ch='+' then begin inc(myvol); if myvol>63 then myvol:=63; end;
      *Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*Â*‚Â*ÂBÂööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööööuses vgaliza,crt;
var
  s1, s2                  :array[0..1024]of integer;
  ex, sx                  :integer;
  pos1, pos2              :integer;
  ypos, yposu, yposd      :integer;
  line1, line2            :integer;
  minx, maxx, miny, maxy  :integer;
  pf                      :integer;

{procedure fill(px,py,pc:integer);
begin
  pf:=yeyun(px,py);
  yeyan(px,py,pc);
  pos1:=0;
  pos2:=0;
  minx:=0;
  miny:=0;
  maxx:=319;
  maxy:=199;
            sx:=px-1;
            ex:=px+1;
            while(sx>=minx)and(yeyun(sx,py)=pf)do
            begin
              yeyan(sx,py,pc);
              dec(sx);
            end;
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
  myfilesize:=filesize(f);
  close(f);
end;{aload}

procedure asave(filename:string;var buf;size:word);
var
  f:file;
begin
  assign(f,filename);
  rewrite(f,1);
  blockwrite(f,buf,size);
  close(f);
end;{asave}

procedure psave(filename:string;var buf);
var
  f:file;
begin
  assign(f,filename);
  rewrite(f,1);
  blockwrite(f,buf,((memw[seg(buf):0]div 320)+1)*((memw[seg(buf):0]mod 320)+1));
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
{      while(mem[gsegpos:pp]<>mem[gsegpos:pp+1])and((t<127)and(pp<maxsize))do}
      while((mem[gsegpos:pp]<>mem[gsegpos:pp+1])or
           ((mem[gsegpos:pp+1]<>mem[gsegpos:pp+2])and(t+2<127)))and
           ((t<127)and(pp<maxsize))do
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

var t5:word;
procedure zip(var gbuf,pbuf);
begin
  gsegpos:=seg(gbuf);
  psegpos:=seg(pbuf);
  cp:=2;
  pp:=0;
  repeat
    if mem[gsegpos:pp]=mem[gsegpos:pp+1]then
    begin
      t5:=1;
      while(mem[gsegpos:pp]=mem[gsegpos:pp+1])and((t5<16383)and(pp<maxsize))do
      begin
        inc(t5);
        inc(pp);
      end;
      if t5>63 then
      begin
        mem[psegpos:cp]:=64+(t5 shr 8);
        inc(cp);
        mem[psegpos:cp]:=t5 and $ff;
        inc(cp);
      end else
      begin
        mem[psegpos:cp]:=t5;
        inc(cp);
      end;
      mem[psegpos:cp]:=mem[gsegpos:pp];
      inc(cp);
      inc(pp);
    end else
    begin
      lastcp:=cp;
      t5:=0;
      t2:=0;
      while((mem[gsegpos:pp]<>mem[gsegpos:pp+1])or
           ((mem[gsegpos:pp+1]<>mem[gsegpos:pp+2])and(t2+2<16383)))and
           ((t2<64)and(pp<maxsize))do inc(t2);
      if t2>=64 then
      begin
        inc(cp);
        while((mem[gsegpos:pp]<>mem[gsegpos:pp+1])or
             ((mem[gsegpos:pp+1]<>mem[gsegpos:pp+2])and(t5+2<16383)))and
             ((t5<16383)and(pp<maxsize))do
        begin
          inc(t5);
          inc(cp);
          mem[psegpos:cp]:=mem[gsegpos:pp];
          inc(pp);
        end;
        mem[psegpos:lastcp]:=$80+64+(t5 shr 8);
        mem[psegpos:lastcp+1]:=t5 and $ff;
      end else
      begin
        while((mem[gsegpos:pp]<>mem[gsegpos:pp+1])or
             ((mem[gsegpos:pp+1]<>mem[gsegpos:pp+2])and(t5+2<63)))and
             ((t5<63)and(pp<maxsize))do
        begin
          inc(t5);
          inc(cp);
          mem[psegpos:cp]:=mem[gsegpos:pp];
          inc(pp);
        end;
        mem[psegpos:lastcp]:=$80+t5;
      end;
      inc(cp);
    end;
  until pp>=maxsize;
  memw[psegpos:0]:=cp;
end;{zip}

procedure unzip(var gbuf,pbuf);
begin
  psegpos:=seg(pbuf);
  gsegpos:=seg(gbuf);
  lastcp:=memw[gsegpos:0];
  cp:=2;
  pp:=0;
  repeat
    if(mem[gsegpos:cp]and $80)=0 then
    begin
      if(mem[gsegpos:cp]and $40)=0 then
      begin
        t5:=mem[gsegpos:cp]and 63;
        inc(cp);
        for x:=1 to t5 do
        begin
          mem[psegpos:pp]:=mem[gsegpos:cp];
          inc(pp);
        end;
      end else
      begin
        t5:=((mem[gsegpos:cp]and 63)shl 8)+mem[gsegpos:cp+1];
        inc(cp,2);
        for x:=1 to t5 do
        begin
          mem[psegpos:pp]:=mem[gsegpos:cp];
          inc(pp);
        end;
      end;
    end else
    begin
      if(mem[gsegpos:cp]and $40)=0 then
      begin
        t5:=mem[gsegpos:cp]and 63;
        for x:=1 to t5 do
        begin
          inc(cp);
          mem[psegpos:pp]:=mem[gsegpos:cp];
          inc(pp);
        end;
      end else
      begin
        t5:=((mem[gsegpos:cp]and 63)shl 8)+mem[gsegpos:cp+1];
        inc(cp);
        for x:=1 to t5 do
        begin
          inc(cp);
          mem[psegpos:pp]:=mem[gsegpos:cp];
          inc(pp);
        end;
      end;
    end;
    inc(cp);
  until cp>=lastcp;
end;{unzip}

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