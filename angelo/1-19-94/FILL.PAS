uses vgaliza,crt;
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
            inc(pos2);
            s2[pos2]:=sx+1;
            inc(pos2);
            s2[pos2]:=py;
            while(ex<=maxx)and(yeyun(ex,py)=pf)do
            begin
              yeyan(ex,py,pc);
              inc(ex);
            end;
            inc(pos2);
            s2[pos2]:=ex-1;

  repeat
    while (pos2>0) do
    begin
      ex:=s2[pos2];
      dec(pos2);
      ypos:=s2[pos2];
      dec(pos2);
      sx:=s2[pos2];
      dec(pos2);
      for line1:=sx to ex do
      begin
        if ypos>miny then
        begin
          yposu:=ypos-1;
          if (yeyun(line1,yposu)=pf)then
          begin
            yeyan(line1,yposu,pc);
            sx:=line1-1;
            ex:=line1+1;
            while(sx>=minx)and(yeyun(sx,yposu)=pf)do
            begin
              yeyan(sx,yposu,pc);
              dec(sx);
            end;
            inc(pos1);
            s1[pos1]:=sx+1;
            inc(pos1);
            s1[pos1]:=yposu;
            while(ex<=maxx)and(yeyun(ex,yposu)=pf)do
            begin
              yeyan(ex,yposu,pc);
              inc(ex);
            end;
            inc(pos1);
            s1[pos1]:=ex-1;
          end;
        end;


        if ypos<maxy then
        begin
          yposd:=ypos+1;
          if (yeyun(line1,yposd)=pf)then
          begin
            yeyan(line1,yposd,pc);
            sx:inc(mytime,10); end;
      if ch=',' then begin dec(mytime,10); if mytime>60000 then mytime:=0; end;
    end;
    if soundon then tring(mytime,myvol,mydur);
    inc(counter);
  until ch=#27;
  writeln('the count is ',counter:6);
  readkey;
end.


time=1000;vol=13  `� K K� ( (�( 	 	 �
 �
 �
 �  ` K K� (� (�( 	 �	 �
 �
 �
 �  ` K K ( �(�( 	 �	� 
 �
 �
 �  ` K K ( (�( 	 	 
 �
 �
 �  ` K K �(� (�( 	 �	 
 �
 �
 �  ` K K �(�(�( �	� 	 
 �
 �
 �  ` K K (�(�( �	�	� 
 �
 �
 �  ` K K (�( �	 
 �
 �
 �  ` K K (�( 	 
 
 �
 �  ` K K �(( 	� 
 
 
� �  �` K K �(( 	 
 
� 
� �  �` K K (� ( 	 �
 �
�
� �  � K K �(� ( 	 � 
� �  � K K (� ( �	�  
�
  �	  K (� ( 	�	 � 
� 
  � �K �( �( �	�
 � �
�    �(	  �
�& �(# �
' �($ �( (N (N (�N (�N (�N (�N (�N (�N (�M �(�M �(N �(N �(G � �(G �( (G �( (F �( (F �( (�F ( �(G ( (G (� �(! (# ((! �(Y �( �(�! �(Y (� (� (@(� ( �(" �(Y (� g� @�(@ (" �(Y Y� g� @ (�" �(Y Y� g�( @ �(�# �(Y Y� (g( @ (�# �(Y �(Y �g( @�( (�$ �(Y( Y �g( (@( % �(Y( Y �g( �(@(? �(Y( Y�( �g( �@(? �(Y( Y �g( �@(? �(Y(Y �g( �@(? �(Y(�Y( �g( �@(? �(Y(Y�( �g( �@(? �(Y(Y �g( �@(? �(Y(Y �g( �@(A �Y(Y g �@(A Y g �@(A Y g �@(A Y g �@(A Y g �@(A Y �(g �@(A Y�( �(g �@(A Y�( g �@(A Y�( �(g �@B Y�(Y �(g �@B Y�(Y g �@B Y� Y g �@B Y� Y g �@B Y� (Y g �@B Y� (Y g �@B Y �Y( g �@B Y �Y( (g�( �@B Y (� g �(B �Y( g �(B ( gM g�(gM (� ( � � � �: �    inc(ex);
            end;
            inc(pos2);
            s2[pos2]:=ex-1;
          end;
        end;
      end;
    end;
  until (pos1 or pos2)=0;
end;{fill}


var a:word;
begin
  vgamode(2);
  for a:=0 to 10000 do yeyan(a mod 320,a div 320 {random(320),random(400)},random(256));
  for a:=0 to 12000 do yeyan(a mod 320,a div 320,yeyun(a mod 320,a div 320));
  myfill(0,0,15);
  while not keypressed do {for a:=0 to 255 do yeyan(160,100,a)};
  filler(0,0,0);
  readln;
end.