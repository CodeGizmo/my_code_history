Program DrawGame;
uses keyboard,vgaliza,crt;
var
  Quit                          :boolean;
  p                             :pointer;
  red,grn,blu                   :array[0..255]of byte;
  Dumb,dumb2                    :byte;
  dumw,dumw2                    :word;
  brightness                    :byte;
  savemem                      :array[0..4095]of byte;
  boundpos                      :integer;
  boxx1,boxx2,boxy1,boxy2       :integer;
  lx,ly,x,y,x1,y1,x2,y2         :integer;
  mouseon                       :boolean;
  amaxx,amaxy,aminx,aminy       :integer;

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
    end;
  end;
end;

procedure addmousemove;
begin
  if mouseon then
  begin
    lx:=x;ly:=y;
    asm
      mov  ax,0bh
      int  33h
      add  x,cx
      mov  cx,x
      add  y,dx
      mov  dx,y
      cmp  cx,amaxx
      jle  @a1
      mov  cx,amaxx
      mov  x,cx
      jmp  @a2
  @a1:cmp  cx,aminx
      jge  @a2
      mov  cx,aminx
      mov  x,cx
  @a2:cmp  dx,amaxy
      jle  @a3
      mov  dx,amaxy
      mov  y,dx
      jmp  @a4
  @a3:cmp  dx,aminy
      jge  @a4
      mov  dx,aminy
      mov  y,dx
  @a4:
    end;
  end;
end;{addmousemove}

procedure putpen;
begin
  if x<160 then
  if y<100 then
  begin
    yeyan(x,y,15);
    line(x+1,y+1,x+4,y+4,c);
    line(x+1,y,x+6,y+5,14);
    line(x,y+1,x+5,y+6,14);
    line(x+4,y+5,x+5,y+4,12);
    line(x+5,y+6,x+6,y+5,12);
    yeyan(x+5,y+5,12);
  end else
  begin
    yeyan(x,y,15);
    line(x+1,y-1,x+4,y-4,c);
    line(x+1,y,x+6,y-5,14);
    line(x,y-1,x+5,y-6,14);
    line(x+4,y-5,x+5,y-4,12);
    line(x+5,y-6,x+6,y-5,12);
    yeyan(x+5,y-5,12);
  end else if y>100 then
  begin
    yeyan(x,y,15);
    line(x-1,y-1,x-4,y-4,c);
    line(x-1,y,x-6,y-5,14);
    line(x,y-1,x-5,y-6,14);
    line(x-4,y-5,x-5,y-4,12);
    line(x-5,y-6,x-6,y-5,12);
    yeyan(x-5,y-5,12);
  end else
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

procedure boxsave(x1,y1,x2,y2:word);
begin
  boundpos:=0;
  if x1>x2 then begin dumw:=x1;x1:=x2;x2:=dumw end;
  if y1>y2 then begin dumw:=y1;y1:=y2;y2:=dumw end;
  boxx1:=x1; boxx2:=x2; boxy1:=y1; boxy2:=y2;
  for dumw:=x1 to x2 do begin
    savemem[boundpos]:=yeyun(dumw,y1);
    inc(boundpos); end;
  for dumw:=y1 to y2 do begin
    savemem[boundpos]:=yeyun(x2,dumw);
    inc(boundpos); end;
  for dumw:=x2 downto x1 do begin
    savemem[boundpos]:=yeyun(dumw,y2);
    inc(boundpos); end;
  for dumw:=y2 downto y1 do begin
    savemem[boundpos]:=yeyun(x1,dumw);
    inc(boundpos); end;
end;{boxsave}

procedure boxres ptr [bp+DrawX]
                 and   cl,3
                 mov   ah,1
                 shl   ah,cl

                 mov   al,MAP_MASK
                 mov   dx,SC_INDEX
                 OUT_WORD

                 mov   al,byte ptr [bp+Color]
                 stosb
                 pop   di
                 pop   si
                 pop   bp
                 ret
_Draw320x400Dot endp

RParms struc
                 dw ?
                 dw ?
ReadX  dw ?
ReadY  dw ?
RParms ends

; int Read320x400ModeM  �X,int Y)
;
; Returns: pixel color
					  public _Read320x400Dot
_Read320x400Dot proc far
                 push  bp
                 mov   bp,sp
                 push  si
                 push  di
                 mov   ax,VGA_SEGMENT
                 mov   es,ax
                 mov   ax,SCREEN_WIDTH/4

                 mul   [bp+DrawY]
                 mov   si,[bp+DrawX]
                 shr   si,1
                 shr   si,1
                 add   si,ax
                 mov   ah,byte ptr [bp+DrawX]

                 and   ah,3
                 mov   al,READ_MAP
                 mov   dx,GC_INDEX
                 OUT_WORD

                 lods  byte ptr es:[si]
                 sub   ah,ah
                 pop   di
                 pop   si
                 pop   bp
_Read320x400Dot endp
_TEXT ends
                end
% 
  � �  � � � � $� � �     	 	� 	� 		  	 	� 
� 
� $�   �  � � � � � � $� � �    	 
	� 	 	       writeln('Error in size of boot code!');
               halt;
          end;

         { Setup the boot code right after the boot info }
          move(@boot_code^,buffer^[sizeof(boot)],size_code);
          buffer^[510]:=$55;buffer^[511]:=$AA;
          for x:=0 to sectors_in_reserve-1 do
          begin
              Write_to_Sector(x,buffer^,'boot ');
              writeln(x+1);
          end;

         { Setup the FAT }
          fillchar(buffer^,512,0);
          for x:=0 to copies_of_FAT-1 do
          begin
               case ufat_type of
                  FAT12:begin
                          buffer^[0]:=media;
                          buffer^[1]:=$FF; buffer^[2]:=$FF;
                        end;
                  FAT16:begin
                          buffer^[0]:=media;buffer^[1]:=$FF;
                          buffer^[2]:=$FF;buffer^[3]:=$FF;
                        end;
                  FAT32:begin
                          buffer^[0]:=media;
   M  ��                  buffer^[1]:=$FF;buffer^[2]:=$FF;buffer^[3]:=$FF;
                          buffer^[4]:=$FF;buffer^[5]:=$FF;buffer^[6]:=$FF;
                          buffer^[7]:=$FF;
                        end;
               end;

               Write_to_Sector(sectors_in_reserve+x*sectors_per_FAT,
                               buffer^,'FAT ');
               writeln(x+1);

               buffer^[0]:=0;buffer^[1]:=0;buffer^[2]:=0;buffer^[3]:=0;
               buffer^[4]:=0;buffer^[5]:=0;buffer^[6]:=0;buffer^[7]:=0;

               for y:=1 to sectors_per_FAT-1 do
               begin
                   Write_to_Sector(sectors_in_reserve+y+x*sectors_per_FAT,
                                   buffer^,'FAT ');
                   writeln(x+1,'-',y+1);
               end;
          end;

          buffer^[0]:=0;buffer^[1]:=0;buffer^[2]:=0;
          with directory(ADDR(buffer^)^) do
          begin
               St_to_ANY('FORMAT 43',name,11);
               attr:=VolumeID;
          end;
          Write_to_Sector(sectors_in_reserve+copies_of_FAT*sectors_per_FAT,
                          buffer^,'DIR ');
          writeln(1);

          with directory(ADDR(buffer^)^) do
          begin
               St_to_ANY(#0#0#0#0#0#0#0#0#0#0#0,name,11);
               attr:=0;
          end;
          for x:=1 to root_dir_sectors-1 do
          begin
               buffer^[0]:=0;buffer^[1]:=0;buffer^[2]:=0;
               Write_to_Sector(sectors_in_reserve+
                               copies_of_FAT*sectors_per_FAT+x,buffer^,'DIR ');
               writeln(x+1);
          end;
          writeln('Serial number ',dectohex(serial1):4,'-',dectohex(serial2):4);
     end;
     freemem(buffer,512);
end;

begin
     clrscr;
     drive:=0;
     savetable;
     format(80,d360s800in1200);
(*     boot_maker(1,
                  { sectors per cluster }
                224,
                  { root directory entries }
                80,
                  { tracks }
                fat12,
           M  �  { fat type}
                d1200s1440
                  { disk type }
               );
     restoretable;*)
end.uses vgaliz,crt,dos;
var
  x,y,a,b:integer;
  p:pointer;
  s:string;
  mys,myo:integer;
begin
  getmem(p,65535);
  vgamode(1);
  aload('e:\tp\bin\turbo.ico',p^);
  myo:=ofs(p^);
  mys:=seg(p^);
{  for c:=0 to 255 do myup(c,random(64),random(64),random(64));}
  for b:=0 to 199 do
  for a:=0 to  15 do
  yeyan(a,b,mem[mys:myo+a+b*16]);
  readln;
end.#C�������������������
�
�������
�	�
�
�
�
�
�
�
�	��	�	�	�	�	�	�	��������������������	�	��	�	�	�	�	�	�
�
�	�
�
�
�
�
�
���
������� � � � � � � � �                   � �  � � � � � � C������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������6����A����A����A����A����A���B�(��B�(��B� G 	     �(� ( 	 � 
� �  � K K (� ( �	�  
�
  �	  K (� ( 	�	 � 
� 
  � �K �( �( �	�
 � �
�    �(	  �
�& �(# �
' �($ �( (N (N (�N (�N (�N (�N (�N (�N (�M �(�M �(N �(N �(G � �(G �( (G �( (F �( (F �( (�F ( �(G ( (G (� �(! (# ((! �(Y �( �(�! �(Y (� (� (@(� ( �(" �(Y (� g� @�(@ (" �(Y Y� g� @ (�" �(Y Y� g�( @ �(�# �(Y Y� (g( @ (�# �(Y �(Y �g( @�( (�$ �(Y( Y �g( (@( % �(Y( Y �g( �(@(? �(Y( Y�( �g( �@(? �(Y( Y �g( �@(? �(Y(Y �g( �@(? �(Y(�Y( �g( �@(? �(Y(Y�( �g( �@(? �(Y(Y �g( �@(? �(Y(Y �g( �@(A �Y(Y g �@(A Y g �@(A Y g �@(A Y g �@(A Y g �@(A Y �(g �@(A Y�( �(g �@(A Y�( g �@(A Y�( �(g �@B Y�(Y �(g �@B Y�(Y g �@B Y� Y g �@B Y� Y g �@B Y� (Y g �@B Y� (Y g �@B Y �Y( g �@B Y �Y( (g�( �@B Y (� g �(B �Y( g �(B ( gM g�(gM (� ( � � � �: �  �  �0  �  �     � �  � � �  � �  �  � �   �    �  �  � $ �
 �    �  �  � � -    � �  � $ �
 � �   ! �
 � � � - �  �. �  �^ � �+  �	  �* � � �  1 � � � 	 �	 ( � �  � 
 �
  � � � �  �  �1 � � 	 �, � � �  � �  � �   � �  � � � �  � � � �
 � �   � 	 � � � � � � � � 	 � � �( � � � � � � � � �  � � �  �
 �    �  �  �	 � � �
 �  � � � �  �	 �  � � � �  � �   �  � � � �   � � � � �  � � � � �  � �   �  �  � �  �  � � � � � �  �  � �  6 �: � �2  � � �j �4 �l �` �A� A� A� B	 uses crt,vgaliz;
var
  lx,ly                 :word;
  ch                    :char;
  xmic,ymic             :word;
  l,r,m,closethis       :boolean;
  posmeth,pmic,bmic     :byte;
  minc                  :byte;
  p1,p2,p3,pen,micpos   :pointer;
  luh,ldh,llv,lrv       :pointer;
  x1,x2,y1,y2           :word;
  pt                    :array[0..15]of pointer;
  f                     :string;
  mydelay               :word;
  speed,faster,slower   :word;
  forposition           :pointer;
  upper,onplot          :boolean;

procedure beep;
begin
  sound(100);
  delay(10);
  nosound;
end;

procedure yeynot(x,y:word);
begin
  asm
    push ds
    mov  ax,0a000h
    mov  es,ax
    mov  ds,ax
    mov  ax,320
    mul  y
    add  ax,x
    mov  si,ax
    mov  di,ax
    lodsb
    not  al
    stosb
    pop  ds
  end;
end;{yeyxor}

procedure mygetdac(what:byte;var red,green,blue:byte);
var
  r,g,b:byte;
begin
  asm
    pushf
    cli
    mov  dx,03c8h
    mov  al,what
    out  dx,al
    inc  dx
    in   al,dx
    mov  r,al
    in   al,dx
    mov  g,al
    in   al,dx
    mov  b,al
    popf
  end;
  red:=r;
  green:=g;
  blue:=b;
end;

procedure ellipsexor(x0,y0,a0,b0:integer);
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
    yeynot(x0+x,y0+y) ;
    yeynot(x0-x,y0+y) ;
    yeynot(x0+x,y0-y) ;
    yeynot(x0-x,y0-y) ;
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
    yeynot(x0+x,y0+y) ;
    yeynot(x0-x,y0+y) ;
    yeynot(x0+x,y0-y) ;
    yeynot(x0-x,y0-y) ;
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
end;{ellipsexor}

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

procedure oval(x,y,x0,y0:integer;c:byte);
begin
  ellipse(x,y,round(abs(x0-x)*1.414213562),round(abs(y0-y)*1.414213562),c);
end;{oval}

procedure ovalxor(x,y,x0,y0:word);
var
  xx,yy:integer;
begin
  xx:=x0-x;
  xx:=abs(xx);
  xx:=round(xx*1.414213562);
  yy:=y0-y;
  yy:=abs(yy);
  yy:=round(yy*1.414213562);
  ellipsexor(x,y,xx,yy);
end;{oval}

procedure putpen;
begin
  if xmic<160 then
  if ymic<100 then
  begin
    yeyan(xmic,ymic,15);
    line(xmic+1,ymic+1,xmic+4,ymic+4,pmic);
    line(xmic+1,ymic,xmic+6,ymic+5,14);
    line(xmic,ymic+1,xmic+5,ymic+6,14);
    line(xmic+4,ymic+5,xmic+5,ymic+4,12);
    line(xmic+5,ymic+6,xmic+6,ymic+5,12);
    yeyan(xmic+5,ymic+5,12);
  end else
  begin
    yeyan(xmic,ymic,15);
    line(xmic+1,ymic-1,xmic+4,ymic-4,pmic);
    line(xmic+1,ymic,xmic+6,ymic-5,14);
    line(xmic,ymic-1,xmic+5,ymic-6,14);
    line(xmic+4,ymic-5,xmic+5,ymic-4,12);
    line(xmic+5,ymic-6,xmic+6,ymic-5,12);
    yeyan(xmic+5,ymic-5,12);
  end else if ymic>100 then
  begin
    yeyan(xmic,ymic,15);
    line(xmic-1,ymic-1,xmic-4,ymic-4,pmic);
    line(xmic-1,ymic,xmic-6,ymic-5,14);
    line(xmic,ymic-1,xmic-5,ymic-6,14);
    line(xmic-4,ymic-5,xmic-5,ymic-4,12);
    line(xmic-5,ymic-6,xmic-6,ymic-5,12);
    yeyan(xmic-5,ymic-5,12);
  end else
  begin
    yeyan(xmic,ymic,15);
    line(xmic-1,ymic+1,xmic-4,ymic+4,pmic);
    line(xmic-1,ymic,xmic-6,ymic+5,14);
    line(xmic,ymic+1,xmic-5,ymic+6,14);
    line(xmic-4,ymic+5,xmic-5,ymic+4,12);
    line(xmic-5,ymic+6,xmic-6,ymic+5,12);
    yeyan(xmic-5,ymic+5,12);
  end;
end;{putpen}

procedure giveme;
var
  bot:byte;
begin
  asm
    mov  ax,3
    int  33h
    mov  bot,bl
  end;
  l:=bot and 1=1;
  r:=bot and 2=2;
  m:=bot and 4=4;
end;

procedure init;
begin
  asm
    mov  ax,0fh
    mov  cx,1
    mov  dx,1
    int  33h
  end;
end;

procedure getcount;
begin
  asm
    mov  ax,0bh
    int  33h
    add  xmic,cx
    add  ymic,dx
    cmp  xmic,319
    jle  @a1
    mov  xmic,319
    jmp  @a2
@a1:cmp  xmic,0
    jge  @a2
    mov  xmic,0
@a2:cmp  ymic,199
    jle  @a3
    mov  ymic,199
    jmp  @a4
@a3:cmp  ymic,0
    jge  @a4
    mov  ymic,0
@a4:
  end;
end;

procedure clear;
begin
  asm
    mov ax,0a000h
    mov es,ax
    mov di,0
    mov cx,32000
    mov al,bmic
    mov ah,al
    rep stosw
  end;
end;

procedure showposition;
var
  a,c:byte;
begin
  case posmeth of
    0,2:begin
        c:=yeyun(xmic,ymic);
        for a:=0 to 255 do
        begin
          inc(c);
          yeyan(xmic,ymic,c);
        end;
      end;
    1,2:begin
        if xmic<160 then
          if ymic<100 then getthis(xmic,ymic,xmic+6,ymic+6,pen^)
          else getthis(xmic,ymic-6,xmic+6,ymic,pen^)
        else if ymic>100 then getthis(xmic-6,ymic-6,xmic,ymic,pen^)
          else getthis(xmic-6,ymic,xmic,ymic+6,pen^);
        putpen;
        delay(10);
        if xmic<160 then
          if ymic<100 then putthis(xmic,ymic,pen^,0)
          else putthis(xmic,ymic-6,pen^,0)
        else if ymic>100 then putthis(xmic-6,ymic-6,pen^,0)
          else putthis(xmic-6,ymic,pen^,0);
      end;
  end;
  if posmeth=2 then
  begin
    if ymic>100 then
    begin
      if not(upper) then
      begin
        putthis(0,192,forposition^,0);
        getthis(0,0,319,7,forposition^);
        upper:=true;
      end;
      gotoxy(1,1);
      write('X:',xmic:4,' Y:',ymic:4,' C:',pmic:4);
    end else
    begin
      if upper then
      begin
        putthis(0,0,forposition^,0);
        getthis(0,192,319,199,forposition^);
        upper:=false;
      end;
      gotoxy(1,25);
      write('X:',xmic:4,' Y:',ymic:4,' C:',pmic:4);
    end;
  end;
end;{showposition}

procedure boxer;
var a:byte;
begin
  getthis(x1,y1,xmic,y1,luh^);
  getthis(x1,ymic,xmic,ymic,ldh^);
  getthis(x1,y1,x1,ymic,llv^);
  getthis(xmic,y1,xmic,ymic,lrv^);
  repeat
    if y1=ymic then line(x1,y1,xmic,ymic,a)else box(x1,y1,xmic,ymic,a);
    inc(a);
  until a=255;
  putthis(x1,y1,luh^,0);
  putthis(x1,ymic,ldh^,0);
  putthis(x1,y1,llv^,0);
  putthis(xmic,y1,lrv^,0);
end;{boxer}

procedure obeyoval;
var
  lx,ly:word;
begin
  repeat
    giveme;
    getcount;
    showposition;
    if l then
    begin
      lx:=xmic;
      ly:=ymic;
      repeat
        giveme;
        getcount;
        showposition;
        ovalxor(lx,ly,xmic,ymic);
        ovalxor(lx,ly,xmic,ymic);
        if m then oval(lx,ly,xmic,ymic,pmic);
      until not(l)or m;
    end;
    if keypressed then ch:=readkey;
  until(ch=#27)or(r or m);
  while l or m or m do
  begin
    giveme;
  end;
  getcount;
  lx:=xmic;ly:=ymic;
end;{obeyoval}

procedure obeyload;
begin
  gotoxy(1,1);write('filename ');
  readln(f);
  aload(f,p1^);
  putthis(0,0,p1^,0);
end;{obeyload}

procedure obeysave;
begin
  getthis(0,0,319,199,p1^);
  gotoxy(1,1);write('filename ');
  readln(f);
  asave(f,p1^,65535);
  putthis(0,0,p1^,0);
end;{obeysave}

procedure zipperns;
begin
  compress(ptr($a000,0)^,p1^);
  gotoxy(1,1);write('filename ');
  readln(f);
  lizsave(f,p1^);
  uncompress(p1^,ptr($a000,0)^);
end;{zipperns}

procedure unzipperns;
begin
  gotoxy(1,1);write('filename ');
  readln(f);
  aload(f,p1^);
  uncompress(p1^,ptr($a000,0)^);
end;{zipperns}

procedure unzipperns2;
begin
  gotoxy(1,1);write('filename ');
  readln(f);
  aload(f,p1^);
  explode(p1^,ptr($a000,0)^);
end;{zipperns}

procedure obeycut;
begin
  repeat
    giveme;
    getcount;
    showposition;
    if l then
    begin
      x1:=xmic;
      y1:=ymic;
      repeat
        giveme;
        getcount;
        if xmic<x1 then xmic:=x1;
        if ymic<y1 then ymic:=y1;
        boxer;
        showposition;
        if m then getthis(x1,y1,xmic,ymic,p2^);
      until not(l)or m;
    end;
    if keypressed then ch:=readkey;
  until(ch=#27)or(r or m);
  while l or m or r do
  begin
    giveme;
  end;
  getcount;
  lx:=xmic;ly:=ymic;
end;{obeycut}

procedure obeyput;
var lx,ly:word;
begin
  getthis(0,0,319,199,p3^);
  repeat
    getcount;
    giveme;
    putthis(xmic,ymic,p2^,0);
    if(lx<>xmic)or(ly<>ymic)then putthis(0,0,p3^,0);
    lx:=xmic;ly:=ymic;
    if l then putthis(xmic,ymic,p2^,0);
  until (l or m);
  lx:=xmic;
  ly:=ymic;
end;{obeyput}

procedure makeforanimate;
var x,y:word;
begin
  for x:=0 to 3 do
  begin
    line(0,x*50,319,x*50,255);
    line(x*80,0,x*80,199,255);
  end;
end;{makeforanimate}

procedure animate;
var a:byte;
begin

{  for a:=0 to 15 do}
{  getthis((a and 3)*80,(a shr 2)*50,(a and 3)*80+79,(a shr 2)*50+49,pt[a]^);}
  repeat
    for a:=0 to 3 do
    begin
{      delay(mydelay);}
      retr;retr;retr;retr;
      movebar(0,0,79,49,a*80,0);
    end;
    for a:=0 to 3 do
    begin
{      delay(mydelay);}
      retr;retr;retr;retr;
      movebar(0,0,79,49,a*80,50);
    end;
    for a:=3 downto 0 do
    begin
{      delay(mydelay);}
      retr;retr;retr;retr;
      movebar(0,0,79,49,a*80,50);
    end;
    for a:=3 downto 0 do
    begin
{      delay(mydelay);}
      retr;retr;retr;retr;
      movebar(0,0,79,49,a*80,0);
    end;
  until keypressed;
end;{animate}

procedure choosecolor;
var
  x,y,xx,yy:word;
  red,grn,blu:byte;
begin
  getthis(0,0,319,199,p1^);
  for y:=0 to 7 do for x:=0 to 31 do
  begin
    for yy:=0 to 6 do for xx:=0 to 6 do
      yeyan(x*8+xx,y*8+yy,y*32+x);
    for yy:=0 to 7 do
      yeyan(x*8+7,y*8+yy,0);
    for xx:=0 to 7 do
      yeyan(x*8+xx,y*8+7,0);
  end;
  bar(264,0,319,63,0);
  gotoxy(33,1);write('red');
  gotoxy(33,3);write('green');
  gotoxy(33,5);write('blue');
  gotoxy(33,7);write('gray');
  closethis:=false;
  repeat
    getcount;
    giveme;
    showposition;
    if l then
    begin
      if(xmic<256)and(ymic<64)then
      begin
        pmic:=((ymic shr 3)shl 5)+(xmic shr 3);
        mygetdac(pmic,red,grn,blu);
        bar(256+red,8,319,15,0);
        if red<>0 then bar(256,8,256+red,15,12);
        bar(256+grn,24,319,31,0);
        if grn<>0 then bar(256,24,256+grn,31,10);
        bar(256+blu,40,319,47,0);
        if blu<>0 then bar(256,40,256+blu,47,9);
        bar(256+blu,56,319,63,0);
        if (red and grn and blu)<>0 then bar(256,56,256+(red+grn+blu)div 3,63,15);
        gotoxy(39,1);write(red:2);
        gotoxy(39,3);write(grn:2);
        gotoxy(39,5);write(blu:2);
        gotoxy(38,7);write((red+grn+blu):3);
      end else if(xmic<40)and(ymic>192)then closethis:=true;
    end;
    if m then
    begin
    end;
    if keypressed then ch:=readkey;
  until(ch=#27)or closethis;
  while l do giveme;
  putthis(0,0,p1^,0);
end;{choosecolor}

procedure lethimchoose;
begin
end;

procedure checkright;
begin
  if posmeth=2 then
    if ymic>100 then putthis(0,0,forposition^,0)else putthis(0,192,forposition^,0);
  posmeth:=1;
end;

procedure obeycommand;
begin
  ch:=readkey;
  if ch=#0 then
  begin
    ch:=readkey;
    case ch of
      #24:obeyoval;
      #38:obeyload;
      #31:obeysave;
      #46:obeycut;
      #25:obeyput;
      #50:makeforanimate;
      #30:animate;
      #32:begin
            getthis(0,0,319,20,p1^);
            gotoxy(1,1);write('delays ');readln(mydelay);
            putthis(0,0,p1^,0);
          end;
      else
      begin
        for faster:=0 to speed do
        begin
          case ch of
            #72:if ymic>0 then dec(ymic)else beep;
            #80:if ymic<199 then inc(ymic)else beep;
            #75:if xmic>0 then dec(xmic)else beep;
            #77:if xmic<319 then inc(xmic)else beep;
            #71:begin if xmic>0 then dec(xmic)else beep;if ymic>0 then dec(ymic)else beep;end;
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
          getthis(0,192,319,199,forposition^);
          upper:=false;
        end;
      end;
      if posmeth=0 then
      begin
        if ymic>100 then putthis(0,0,forposition^,0)else putthis(0,192,forposition^,0);
      end;
    end;
  end;
end;{obeycommand}

procedure fetchmouse;
begin
  giveme;
  if r then
  begin
    checkright;
    minc:=0;
    if l then filler(xmic,ymic,pmic);
    if m then clear;
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
  counter:=0;
  soundon:=true;
  mytime:=1000;
  myvol:=13;
  mydur:=100;

  for a:=0 to 255 do
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
      ]<>0)and(mykey[$2d]<>0);
  goaway;
  for dumbyte2:=0 to 84 do
  for dumbyte:=0 to 15 do box(dumbyte+dumbyte2,dumbyte+dumbyte2,319-dumbyte-dumbyte2,199-dumbyte-dumbyte2,dumbyte+16);

  vgamode(3);
  beep;
  freemem(p,65535)
end.














