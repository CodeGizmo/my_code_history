{$m 16384,0,65536}
uses crt,dos;
var
  a,b:word;
  ch:char;
  p:pointer;
  myseg,myofs:word;
  counter:word;
  fs:string;
  f:file;
  col:array[0..255,0..2]of byte;
  gmis:byte;
  pseg,pofs,gseg,gofs,syaofs:word;

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
  pseg:=$a000;
  gseg:=$a000;
  pofs:=0;
  gofs:=0;
  syaofs:=0;
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
    and  al,n=0 to 29 do
    begin
      blockread(f,ptr(seg(p^),ofs(p^)+2)^,16000);
      memw[seg(p^):ofs(p^)]:=99*320+159;
      putthis(0,0,p^,0);
    end;
    close(f);    }

  end;
  vgamode(mtext);
end.

*��*��*��*��*��*��*��*��*��*��*��*��*!.*�**��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��* 9�e� +*�*�*��*��*��*�M  ��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��**+*�*�*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��**9�e� ,*�*�***�*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*O*�*�***�*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*\�e�P*�*�***�*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��P*�*�***�*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��\�e�M*�*�*�*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*M*�*�*�*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*\�e�Q*�**��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*Q*�**��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*\�e�N*�*�*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��yeyan(x-5,y-5,12M  � end else
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
    for a:=0 to 255 do
        myup(a,col[a,0],col[a,1],col[a,2]);
    for a:=0 to 29 do
    begin
      blockread(f,ptr(seg(p^),ofs(p^)+2)^,16000);
      memw[seg(p^):ofs(p^)]:=99*320+159;
      putthis(0,0,p^,0);
    end;
    close(f);


  end;
  vgamode(255);
end.

