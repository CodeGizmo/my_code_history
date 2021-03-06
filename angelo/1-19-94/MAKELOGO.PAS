program makelogo;
uses crt,vgaliza2;
var
  ch       :char;

procedure show;
begin
  line(100,100,300,50,15);
  line(50,100,300

end;

begin
  vgamode(3);
  show;
  ch:=readkey;
end.}

var
  a,b:word;
begin
  vgamode(1);
  for b:=0 to 7 do
    for a:=0 to 31 do
    begin
      bar(1+a shl 3,1+b shl 3,a shl 3+6,b shl 3+6,b*32+a);
      box(a shl 3,b shl 3,a shl 3+7,b shl 3+7,0);
    end;
  ch:=readkey;
end.




(*program Drawing_Kit{version 1.12};
uses keyboard,vgaliza2,crt;
var
  micex,micey                   :word;
  dumbyte,dumbyte2              :byte;
  dumword,dumword2              :word;
  c,lcc,paint                   :byte;
  x,y,lx,ly,x1,y1,x2,y2         :integer;
  miny,maxy,minx,maxx           :word;
  ch                            :byte;
  p,pen,boxp,getp,largesave     :pointer;
  boxseg,boxofs                 :word;
  bigx,bigy,lbigx,lbigy         :integer;
  largeleft                     :boolean;
  good_to_enlarge               :boolean;

var
  rcount:byte;
  linelx,linely:integer;
  yeyan_method:byte;
  mouseon:boolean;

procedure beep;
begin
  sound(500);
  delay(50);
  nosound;
end;{beep}

var cur_pos:word;
procedure boxsave(x1,y1,x2,y2:word);
begin
  cur_pos:=0;
  if x1>x2 then begin dumword:=x1;x1:=x2;x2:=dumword end;
  if y1>y2 then begin dumword:=y1;y1:=y2;y2:=dumword end;
  for dumword:=x1 to x2 do begin
    mem[boxseg:boxofs+cur_pos]:=yeyun(dumword,y1);
    inc(cur_pos); end;
  for dumword:=y1 to y2 do begin
    mem[boxseg:boxofs+cur_pos]:=yeyun(x2,dumword);
    inc(cur_pos); end;
  for dumword:=x2 downto x1 do begin
    mem[boxseg:boxofs+cur_pos]:=yeyun(dumword,y2);
    inc(cur_pos); end;
  for dumword:=y2 downto y1 do begin
    mem[boxseg:boxofs+cur_pos]:=yeyun(x1,dumword);
    inc(cur_pos); end;
end;{boxsave}

procedure boxrestore(x1,y1,x2,y2:word);
begin
  cur_pos:=0;
  if x1>x2 then begin dumword:=x1;x1:=x2;x2:=dumword end;
  if y1>y2 then begin dumword:=y1;y1:=y2;y2:=dumword end;
  for dumword:=x1 to x2 do begin
    yeyan(dumword,y1,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos); end;
  for dumword:=y1 to y2 do begin
    yeyan(x2,dumword,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos); end;
  for dumword:=x2 downto x1 do begin
    yeyan(dumword,y2,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos); end;
  for dumword:=y2 downto y1 do begin
    yeyan(x1,dumword,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos); end;
end;{boxrestore}

var cur_cpat    :word;
    cur_fc      :byte;
    cur_dot     :shortint;
procedure boxer(x1,y1,x2,y2:word);
begin
  cur_cpat:=cur_fc shl 2;
  cur_pos:=0;
  if (cur_dot>3)or(cur_dot<0)then cur_dot:=0;
  if x1>x2 then begin dumword:=x1;x1:=x2;x2:=dumword end;
  if y1>y2 then begin dumword:=y1;y1:=y2;y2:=dumword end;
  for dumword:=x1 to x2 do
  begin
    if(cur_cpat and 3)=cur_dot then yeyan(dumword,y1,cur_cpat shr 2)
      else yeyan(dumword,y1,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos);
    inc(cur_cpat);
  end;
  for dumword:=y1 to y2 do
  begin
    if(cur_cpat and 3)=cur_dot then yeyan(x2,dumword,cur_cpat shr 2)
      else yeyan(x2,dumword,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos);
    inc(cur_cpat);
  end;
  for dumword:=x2 downto x1 do
  begin
    yeyan(dumword,y2,cur_cpat shr 2);
    if(cur_cpat and 3)=cur_dot then yeyan(dumword,y2,cur_cpat shr 2)
      else yeyan(dumword,y2,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos);
    inc(cur_cpat);
  end;
  for dumword:=y2 downto y1 do
  begin
    yeyan(x1,dumword,cur_cpat shr 2);
    if(cur_cpat and 3)=cur_dot then yeyan(x1,dumword,cur_cpat shr 2)
      else yeyan(x1,dumword,mem[boxseg:boxofs+cur_pos]);
    inc(cur_pos);
    inc(cur_cpat);
  end;
  if cur_dot=0 then
  begin
    inc(cur_fc);
    cur_dot:=3;
  end else dec(cur_dot);
end;{boxer}

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

      if (b( (Y( �(
g( (@(	@�(J ( 
 �(Y�( (Y�( �(	g�( �(@�(K (  �(Y�(
 �(Y�( �(g�( �(@�(L (  �(Y�(	 �(Y�( (g�( �(@(N �(  �(Y�( �(Y�(	 �(g�( �(@(O (  �(Y( �(	Y�(	 �(g�( (	@(Q   �(Y�( (	Y�(	 �(g�( (@(  �(Y�( (	Y(	 �(g�( �(@�(  � (Y�( �(Y( �(g�( �(@�(  � (Y�( �(Y( �(g�( �(@�(  � (Y�(  ((Y( �(g�( �(@�(  � (Y�(  (Y( �(g�( �(@�(  � (Y�( (Y�( �(g�( �(@�(  � ((Y(Y( �(g�( �(@�(   �(Y(Y�( �(g�( �(@�(   �(Y�( �(g�( �(@�(   �(Y�( �(g�( �(@�(   �(Y( �(g�( �(@�(   �(Y�( �(g�( �(@�(   �(Y�( �(g�( �(@�(   �(Y( �(g�( �(@�(   �(Y�( �(g�( �(@�(   �(Y(Y( �(g�( �(@�(   (Y�( ((Y�( �(g�( �(@�(   �(Y�(  ((Y�( �(g�( �(@�(   �(Y�( (Y�( �(g�( �(@�(   �(Y�( (Y�( �(g( �(@�(   �(Y�( (Y( �(g�( �(@�(   �(Y�( (Y�(
 (g�( �(@�(   �(Y�( (Y( �(g�( �(@� � � � +� �  
�		
�  �  �  	� 	� � 	�  �  	 �  	�    � � � � � � � � � �  �	� � � +� �  
�	�	
�  �   � 		 	� � 	�  �  	 �     	�     � �� � � � � 
�  �  �  � +� �  
�	  	
�  � �  � 	 	 	� � 	�  �  	 	 � �  		 	�   � � � � � � � 
�    �	 �    ��������������������������������������������������������������������������������������������������������I� G 	    	�  �	 � 	�  � �       		  � � � � � � �  � � �  �   � +� �  

�   � �  	 � 	�  � 	�  � � �  � � 	�   � � � � � � �  �     
 � +� �  

 
�   � �  	� � 		  �	 � 	�  � � � �  	�  � � � 
�� � �  �  �   � � +� �  

 �

�   �  	� � 	 � 	� 	� 		  �  � � 	 	�  �  
� � �   � �   � � +� �  

�   � �  	� � � 	� 	� 		  �   � � � 	 �  �� � �  ' 
� � +� �  
��
�   � �  	� � � 		 
� 	�  �   � 
�  	�     � � �   �   �   � � +� �  
�
�  �  � �  	� � � 		 
� 	�   �  �  
 	�  � �� � �   � � � � +� �  
��
�  �   � �  	� � 		 
� 	�   	 �    � 		   � � � � � �   	�   � � +� �  
�
�   � 
� 	�  
� 		 
� 	�  �    �  � �� � � � �   ��   � � +� �  
�

�   � 	�    � 		 
� 	�    � �  � � � � �  � �   � � +� �  
�

�  � � � 	�   � � 	� 
� 	�    � � 	� � � � � � �  � �   � � +� �  � �  �  � 	�   � � 	� 
� 	�   � � �  � � � � � �   � ��   � � +� � � � �   � � 	 �  	� 
� 	�  	�     
�  � � � � � �  �     � � 	� �
�������
�	�
�
�
�
�
�
�
�	��	�	�	�	�	�	�	��������������� � M g �   8  �  :    <          F 	    ��	�	�	�	�	�	�
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

procedure ellipsexor
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
end.x<dy do
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
 � 6� �  � < 	   � �  � 1� � � � 9 
�   � �  � ,� � � � #N x  Pthen
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
            #77:if xmic<319 then inc(xmic)elsevgamode(mtext);
  beep;
{  freemem(p,65535)}
end.














