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

procedure put(x,y:word;var buf);
var
  max1,max2,max3,max4    :word;
  pos1,pos2,pos3,pos4    :word;
  m,n,dex,dey            :word;
  leap1,leap2,leap3,leap4:word;
  plane1,plane2,plane3,plane4:byte;
  mysyaofs               :word;
begin
  mysyaofs:=syaofs;
  m:=seg(buf);
  n:=ofs(buf);
  dey:=memw[m:n]div 320;
  dex:=memw[m:n]mod 320;
  inc(n,2);
  inc(dey);
  inc(dex);

  max1:=(dex+3)shr 2;
  max2:=(dex+2)shr 2;
  max3:=(dex+1)shr 2;
  max4:=dex shr 2;

  plane1:=1 shl(x and 3);
  plane2:=1 shl((x+1)and 3);
  plane3:=1 shl((x+2)and 3);
  plane4:=1 shl((x+3)and 3);

  pos1:=y*80+(x shr 2);
  pos2:=y*80+((x+1)shr 2);
  pos3:=y*80+((x+2)shr 2);
  pos4:=y*80+((x+3)shr 2);

  leap1:=80-max1;
  leap2:=80-max2;
  leap3:=80-max3;
  leap4:=80-max4;

  asm
    push bx
    push ds
    mov  ax,0a000h
    mov  es,ax
    mov  ds,m


    mov  di,pos1    
    add  di,mysyaofs
    mov  si,n      {/inc si}
    mov  ah,plane1 
    mov  al,2      
    mov  dx,3c4h   
    out  dx,ax     
    mov  cx,dey    
    mov  ax,dex    
    mov  dx,leap1  
  @again1:         
    push cx        
    mov  bx,si     
    mov  cx,max1   
  @hear1:         {\          }
    movsb         { >rep movsb}
    add  si,3     {/          }
    loop @hear1    
    mov  si,bx     
    add  si,ax     
    add  di,dx     
    pop  cx        
    loop @again1

    cmp  max2,0        {********}
    je   @ending   
    mov  di,pos2    
    add  di,mysyaofs
    mov  si,n      {/inc si}
    inc  si
    mov  ah,plane2 
    mov  al,2      
    mov  dx,3c4h   
    out  dx,ax     
    mov  cx,dey    
    mov  ax,dex    
    mov  dx,leap2  
  @again2:         
    push cx        
    mov  bx,si     
    mov  cx,max2   
  @hear2:         {\          }
    movsb         { >rep movsb}
    add  si,3     {/          }
    loop @hear2    
    mov  si,bx     
    add  si,ax     
    add  di,dx     
    pop  cx        
    loop @again2

    cmp  max3,0        {********}
    je   @ending   
    mov  di,pos3    
    add  di,mysyaofs
    mov  si,n      {/inc si}
    add  si,2
    mov  ah,plane3 
    mov  al,2      
    mov  dx,3c4h   
    out  dx,ax     
    mov  cx,dey    
    mov  ax,dex    
    mov  dx,leap3  
  @again3:         
    push cx        
    mov  bx,si     
    mov  cx,max3   
  @hear3:         {\          }
    movsb         { >rep movsb}
    add  si,3     {/          }
    loop @hear3    
    mov  si,bx     
    add  si,ax     
    add  di,dx     
    pop  cxount);
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

