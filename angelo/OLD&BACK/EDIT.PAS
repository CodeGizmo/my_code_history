uses crt;
var
  cha                                                  :byte;
  colpos,firstcol,a,x1,x2,y1,y2,runpos,rpos,rp         :word;
  ch                                                   :char;
  rowpos,firstrow,charpos,firstchar,totalchar,chrp     :word;
  charspos                           :array[0..$f1ff]of byte absolute $9000:0;
  charp                              :array[0..$f1ff]of char absolute $9000:0;
  insert,kailangan                                     :boolean;
  scrchrpos                  :array[1..25,1..80,0..1]of byte absolute $b800:0;
  runner                             :array[0..$f000]of byte absolute $e000:0;
  filename                                             :string;
  f                                                    :file;
  xx1                                                  :byte;
  xx2                                                  :array[0..1,1..25]of byte;

procedure initialize;
begin
  colpos:=1;
  firstcol:=1;
  rowpos:=1;
  firstrow:=1;
  charpos:=0;
  firstchar:=0;
  insert:=true;
  gotoxy(x1,y1);
  kailangan:=true;
  for a:=0 to 79 do
    mem[$b800:a shl 1+1]:=$ca;
  for a:=80 to 1999-80 do
    mem[$b800:a shl 1+1]:=$1e;
  xx1:=1;
  for a:=0 to 25 do
    xx2[xx1,a]:=80;
  xx1:=0;
end;

procedure save(filename:string);
begin
  assign(f,filename);
  rewrite(f,1);
  blockwrite(f,ptr($9000,0)^,totalchar);
  close(f);
end;

procedure load;
begin
  assign(f,filename);
  reset(f,1);
  blockread(f,ptr($9000,0)^,filesize(f));
  totalchar:=filesize(f);
  close(f);
  initialize;
end;

procedure beep;
begin
  for a:=500 downto 450 do sound(a);
  nosound;
end;

procedure shwpos;
begin
  gotoxy(1,1);
  write(' row=',rowpos:5,'  Col=',colpos:5,'|     size=',totalchar:5,'  Pos=',charpos:5,'  ',filename:12);
  gotoxy(colpos-firstcol+x1,rowpos-firstrow+y1);
end;

procedure shwchr(x1,y1,x2,y2:word);
var
  xx,yy,d1:word;
begin
  chrp:=charpos-(colpos-firstcol);
  xx:=x1;
  if(xx<=x2)and(charspos[chrp]<>13)and(chrp<totalchar)then
  begin
    while(xx<=x2)and(charspos[chrp]<>13)and(chrp<totalchar)do
    begin
      scrchrpos[y1+(rowpos-firstrow),xx,0]:=charspos[chrp];
      inc(xx);
      inc(chrp);
    end;
    for a:=xx to xx2[xx1 xor 1,y1] do
      scrchrpos[y1+(rowpos-firstrow),a,0]:=0;
  end;
  chrp:=firstchar;
  d1:=chrp;
  yy:=y2-y1;
  while(y2>=y1)and(chrp<totalchar){and((kailangan)or(not keypressed))}do
  begin
{    if keypressed then begin ch:=readkey;if ch=#0 then ch:=readkey end;}
    while(charspos[chrp]<>13)and(chrp<totalchar)do inc(chrp);
    xx:=x2-x1;
    if chrp-d1+1>=firstcol then
    begin
      inc(d1,firstcol-1);
      if chrp-d1<xx+1 then xx:=chrp-d1-1;
{}    xx2[xx1,y1]:=x1+xx;
      for a:=x1 to x1+xx do
      begin
        scrchrpos[y1,a,0]:=charspos[d1];
        inc(d1);
      end;
      {if not keypressed then} for a:=x1+xx+1 to xx2[xx1 xor 1,y1]do
        scrchrpos[y1,a,0]:=0;
    end else {if not keypressed then} for a:=x1 to xx2[xx1 xor 1,y1]do scrchrpos[y1,a,0]:=0;
    inc(chrp,2);
    d1:=chrp;
    inc(y1);
  end;

  if(y1<=y2){and(not keypressed)}then
  for yy:=y1 to y2 do
    for xx:=x1 to x2 do
      scrchrpos[yy,xx,0]:=0;
  kailangan:=not kailangan;
  xx1:=xx1 xor 1;
  shwpos;
end;

procedure pageup;
begin
  if rowpos>1 then
  begin
    chrp:=charpos;
    if(charspos[chrp]=13)or(chrp=totalchar)then
    while charspos[chrp-1]=32 do dec(chrp);
    if charpos=totalchar then
    begin
      if charspos[chrp-1]=10 then dec(totalchar,colpos+1)else
      if chrp<charpos then totalchar:=chrp;
    end else if charspos[charpos]=13 then
    begin
      if charpos<>chrp then
      begin
        move(ptr($9000,charpos)^,ptr($9000,chrp)^,totalchar-charpos);
        dec(totalchar,charpos-chrp);
      end;
    end;
    dec(charpos,colpos+1);

    chrp:=charpos;
    a:=y2-y1+1;
    while(charpos>0)and(a>1)do
    begin
      if a>2 then
      begin
        if(charpos=totalchar)and(charspos[charpos-1]=10)then begin dec(chrp,2);totalchar:=chrp end;
        while(charspos[charpos-1]<>10)and(charpos>0)do dec(charpos);
        if charpos>0 then
        begin
          dec(rowpos);
          dec(charpos,2);
        end;
      end;
      if firstchar>0 then
      begin
        dec(firstchar,2);
        dec(firstrow);
      end;
      while(charspos[firstchar-1]<>10)and(firstchar>0)do dec(firstchar);
      dec(a);
    end;
    if charpos=0 then while(charspos[charpos]<>13)and(charpos<totalchar)do inc(charpos);

    chrp:=charpos;
    while(charspos[chrp-1]<>10)and(chrp>0)do dec(chrp);
    if firstchar>chrp then begin firstchar:=chrp;dec(firstrow)end;
    if charpos-chrp+1<colpos then
    begin
      move(ptr($9000,charpos)^,ptr($9000,chrp+colpos-1)^,totalchar-charpos);
      inc(totalchar,chrp+colpos-charpos-1);
      for a:=charpos to chrp+colpos-2 do charspos[a]:=32;
    end;
    charpos:=chrp+colpos-1;
    dec(rowpos,1);
  end;
end;

procedure pagedown;
begin
  if rowpos<65535-(y2-y1)then
  begin
    if(charspos[charpos]=13)or(charpos=totalchar)then
    begin
      chrp:=charpos;
      while(charspos[chrp-1]=32)and(chrp>0)do dec(chrp);
      if charpos=totalchar then
      begin
        charspos[chrp]:=13;
        charspos[chrp+1]:=10;
        inc(totalchar,2);
      end else move(ptr($9000,charpos)^,ptr($9000,chrp)^,totalchar-charpos);
      dec(totalchar,charpos-chrp);
      charpos:=chrp;
    end else
    begin
      while(charspos[charpos]<>13)and(charpos<totalchar)do inc(charpos);
      if charpos=totalchar then
      begin
        charspos[charpos]:=13;
        charspos[charpos+1]:=10;
        inc(totalchar,2);
      end;
    end;
    inc(charpos,2);

    a:=1;
    while(a<y2-y1)and(charpos<totalchar)do
    begin
      while(charspos[charpos]<>13)and(charpos<totalchar)do inc(charpos);
      if charpos<totalchar then
      begin
        while(charspos[firstchar]<>13)do inc(firstchar);
        inc(firstchar,2);
        inc(firstrow);
        inc(charpos,2);
        inc(rowpos);
      end else while(charspos[charpos-1]<>10)do dec(charpos);
      inc(a);
    end;
    while(charspos[firstchar]<>13)do inc(firstchar);
    inc(firstchar,2);
    inc(firstrow);

    chrp:=charpos;
    while(charspos[chrp]<>13)and(chrp<totalchar)do inc(chrp);
    if chrp-charpos+1<colpos then
    begin
      if chrp<>totalchar then move(ptr($9000,chrp)^,ptr($9000,charpos+colpos-1)^,totalchar-chrp);
      inc(totalchar,colpos-(chrp-charpos)-1);
      for a:=chrp to charpos+colpos-2 do charspos[a]:=32;
    end;
    inc(charpos,colpos-1);
    inc(rowpos);
    if rowpos-firstrow=23 then
    begin
      inc(firstrow);
      while charspos[firstchar]<>10 do inc(firstchar);
      inc(firstchar);
    end;
  end;
end;

procedure compile;
procedure glab;
begin
  a:=chrp;
  while(charp[a]<>':')and(charp[a]<>#13)and(a<totalchar)do inc(a);
  if charp[a]=':'then
  begin
    while(charp[chrp]<>#13)and(chrp<totalchar)do inc(chrp);
    if chrp<totalchar then inc(chrp,2);
  end else if(chrp=a)or((charp[a-1]=#32)and(a>0))then if chrp<totalchar then inc(chrp,2);
end;

begin
  chrp:=0;
  rpos:=0;
  repeat
    while(charp[chrp]=#32)and(chrp<totalchar)do inc(chrp);
    rp:=chrp;
    case charp[chrp]of
      'n':case charp[chrp+1]of
        'o':case charp[chrp+2]of
          'p':if((charp[chrp+3]=#13)or(charp[chrp+3]=#32)or(chrp+3=totalchar))and(chrp+3<=totalchar)then
            begin
              runner[rpos]:=$b9;
              runner[rpos+1]:=$ff;
              runner[rpos+2]:=$ff;
              inc(rpos,3);
              runner[rpos]:=$90;
              inc(rpos);
              runner[rpos]:=$e2;
              runner[rpos+1]:=$fd;
              inc(rpos,2);
              while(charp[chrp]<>#13)and(chrp<totalchar)do inc(chrp);
              if chrp<totalchar then inc(chrp,2);
            end else glab;
          else glab;
        end else glab;
      end else glab;
    end;
  until(chrp>=totalchar)or(rp=chrp);
end;

procedure run;
begin
  gotoxy(73,1);write('RUNNING');
  runner[rpos]:=$cb;
  inline($9a/0/0/0/$e0);
  gotoxy(73,1);write('READY  ');
  initialize;
end;

procedure getspecialkey;
begin
  ch:=readkey;
  case ch of
    #75:begin
          if colpos>1 then
          begin
            if((charspos[charpos]=13)or(charpos=totalchar))and(charspos[charpos-1]=32)then
            begin
              move(ptr($9000,charpos)^,ptr($9000,charpos-1)^,totalchar-charpos+1);
              dec(totalchar);
            end;
            dec(charpos);
            dec(colpos);
            if colpos<firstcol then dec(firstcol);
          end;
        end;
    #82:insert:=not(insert);
    #83:begin
          if charpos<totalchar then
          begin
            if charspos[charpos]=13 then
            begin
              move(ptr($9000,charpos+2)^,ptr($9000,charpos)^,totalchar-charpos-1);
              dec(totalchar);
            end else
            begin
              move(ptr($9000,charpos+1)^,ptr($9000,charpos)^,totalchar-charpos);
            end;
            dec(totalchar);
          end;
        end;
    #77:begin
          if(charspos[charpos]=13)or(charpos=totalchar)then
          begin
            move(ptr($9000,charpos)^,ptr($9000,charpos+1)^,totalchar-charpos);
            charspos[charpos]:=32;
            inc(totalchar);
          end;
          inc(charpos);
          inc(colpos);
          if colpos=(firstcol+x2-x1+1)then
          begin
            inc(firstcol)
          end;
        end;
    #71:begin
          if colpos>1 then
          begin
            if(charspos[charpos]=13)or(charpos=totalchar)then
            begin
              chrp:=charpos;
              while(charspos[chrp-1]=32)and(chrp>0)do dec(chrp);
              if chrp<>charpos then
              begin
                if charpos=totalchar then totalchar:=chrp else
                begin
                  move(ptr($9000,charpos)^,ptr($9000,chrp)^,totalchar-charpos);
                  dec(totalchar,charpos-chrp);
                end;
              end;
            end;
            dec(charpos,colpos-1);
            colpos:=1;
            firstcol:=1;
          end;
        end;
    #79:begin
          chrp:=charpos;
          while(charspos[chrp]<>13)and(chrp<totalchar)do inc(chrp);
          while(charspos[chrp-1]=32)and(chrp>0)do dec(chrp);
          if chrp<charpos then
          begin
            move(ptr($9000,charpos)^,ptr($9000,chrp)^,totalchar-charpos);
            dec(totalchar,charpos-chrp);
            dec(colpos,charpos-chrp);
          end else inc(colpos,chrp-charpos);
          charpos:=chrp;
          if colpos>x2-x1+1 then firstcol:=colpos-(x2-x1) else firstcol:=1;
        end;
    #72:begin
          if rowpos>1 then
          begin
            chrp:=charpos;
            if(charspos[chrp]=13)or(chrp=totalchar)then
              while charspos[chrp-1]=32 do dec(chrp);
            if charpos=totalchar then
            begin
              if charspos[chrp-1]=10 then dec(totalchar,colpos+1)else
              if chrp<charpos then totalchar:=chrp;
            end else if charspos[charpos]=13 then
            begin
              if charpos<>chrp then
              begin
                move(ptr($9000,charpos)^,ptr($9000,chrp)^,totalchar-charpos);
                dec(totalchar,charpos-chrp);
              end;
            end;
            dec(charpos,colpos+1);
            chrp:=charpos;
            while(charspos[chrp-1]<>10)and(chrp>0)do dec(chrp);
            if firstchar>chrp then begin firstchar:=chrp;dec(firstrow)end;
            if charpos-chrp+1<colpos then
            begin
              move(ptr($9000,charpos)^,ptr($9000,chrp+colpos-1)^,totalchar-charpos);
              inc(totalchar,chrp+colpos-charpos-1);
              for a:=charpos to chrp+colpos-2 do charspos[a]:=32;
            end;
            charpos:=chrp+colpos-1;
            dec(rowpos);
          end;
        end;
    #80:begin
          if rowpos<65535 then
          begin
            if(charspos[charpos]=13)or(charpos=totalchar)then
            begin
              chrp:=charpos;
              while(charspos[chrp-1]=32)and(chrp>0)do dec(chrp);
              if charpos=totalchar then
              begin
                charspos[chrp]:=13;
                charspos[chrp+1]:=10;
                inc(totalchar,2);
              end else move(ptr($9000,charpos)^,ptr($9000,chrp)^,totalchar-charpos);
              dec(totalchar,charpos-chrp);
              charpos:=chrp;
            end else
            begin
              while(charspos[charpos]<>13)and(charpos<totalchar)do inc(charpos);
              if charpos=totalchar then
              begin
                charspos[charpos]:=13;
                charspos[charpos+1]:=10;
                inc(totalchar,2);
              end;
            end;
            inc(charpos,2);
            chrp:=charpos;
            while(charspos[chrp]<>13)and(chrp<totalchar)do inc(chrp);
            if chrp-charpos+1<colpos then
            begin
              if chrp<>totalchar then move(ptr($9000,chrp)^,ptr($9000,charpos+colpos-1)^,totalchar-chrp);
              inc(totalchar,colpos-(chrp-charpos)-1);
              for a:=chrp to charpos+colpos-2 do
                charspos[a]:=32;
            end;
            inc(charpos,colpos-1);
            inc(rowpos);
            if rowpos-firstrow-1=y2-y1 then
            begin
              inc(firstrow);
              while charspos[firstchar]<>10 do inc(firstchar);
              inc(firstchar);
            end;
          end;
        end;
    #81:pagedown;
    #73:pageup;
    #19:begin
          gotoxy(1,2);write('ษออออออออออออออออออออออออออออป');
          gotoxy(1,3);write('บ Save                       บ');
          gotoxy(1,4);write('ศออออออออออออออออออออออออออออผ');
          gotoxy(8,3);write(filename,'?(Y/N)');
          ch:=readkey;
          if ch='y'then save(filename);
          compile;
          run;
        end;
    #38:begin
          gotoxy(1,25);
          readln(filename);
          load;
        end;
    else beep;
  end;
end;

procedure another;
begin
  case ch of
    #13:begin
          chrp:=charpos;
          while(charspos[chrp-1]=32)and(chrp>0)do
          begin
            dec(chrp);
          end;
          move(ptr($9000,charpos)^,ptr($9000,chrp+2)^,totalchar-charpos+1);
          totalchar:=totalchar-(charpos-chrp)+2;
          charspos[chrp]:=13;
          inc(chrp);
          charspos[chrp]:=10;
          inc(chrp);
          charpos:=chrp;
          colpos:=1;
          firstcol:=1;
          inc(rowpos);
          if rowpos=firstrow+y2-y1+1 then
          begin
            inc(firstrow);
            while(charspos[firstchar]<>13)do
            begin
              inc(firstchar);
            end;
            inc(firstchar,2);
          end;
        end;
    #8:begin
         if charpos>0 then
         begin
           if charspos[charpos-1]=10 then
           begin
             move(ptr($9000,charpos)^,ptr($9000,charpos-2)^,totalchar-charpos+1);
             dec(charpos,2);
             dec(totalchar,2);
             dec(rowpos);
             if rowpos<firstrow then
             begin
               dec(firstrow);
               firstchar:=charpos;
               colpos:=1;
               while(charspos[firstchar-1]<>10)and(firstchar>0)do
               begin
                 dec(firstchar);
                 inc(colpos);
               end;
             end else
             begin
               chrp:=charpos;
               colpos:=1;
               while(charspos[chrp-1]<>10)and(chrp>0)do
               begin
                 dec(chrp);
                 inc(colpos);
               end;
             end;
           end else
           begin
             move(ptr($9000,charpos)^,ptr($9000,charpos-1)^,totalchar-charpos+1);
             dec(charpos);
             dec(totalchar);
             dec(colpos);
           end;
           if colpos<firstcol then dec(firstcol);
         end;
       end;
    #25:begin
          chrp:=charpos;
          while(charspos[chrp-1]<>10)and(chrp>0)do
          begin
            dec(chrp);
          end;
          if charpos+1<totalchar then
          begin
            while(charspos[charpos]<>13)and(charpos<totalchar)do
            begin
              inc(charpos);
            end;
            move(ptr($9000,charpos+2)^,ptr($9000,chrp)^,totalchar-charpos-1);
            dec(totalchar,(charpos-chrp)-2);
          end else totalchar:=chrp;
          charpos:=chrp;
          firstcol:=1;
          colpos:=1;
        end;
    #0:getspecialkey;
    else beep;
  end
end;

procedure keyfunction;
begin
  ch:=readkey;
  cha:=ord(ch);
  if((cha>31)and(cha<=255))and(colpos<$ffff)then
  begin
    inc(colpos);
    if colpos>firstcol+x2-x1 then inc(firstcol);
    if insert then
    begin
      inc(totalchar);
      move(ptr($9000,charpos)^,ptr($9000,charpos+1)^,totalchar-charpos);
      charspos[charpos]:=cha;
      inc(charpos);
    end else
    begin
      if charspos[charpos]=13 then
      begin
        inc(totalchar);
        move(ptr($9000,charpos)^,ptr($9000,charpos+1)^,totalchar-charpos);
        charspos[charpos]:=cha;
        inc(charpos);
      end else
      begin
        charspos[charpos]:=cha;
        inc(charpos);
        if charpos>totalchar then inc(totalchar);
      end;
    end;
  end else another;
end;

begin
  clrscr;
  textcolor($a);
  textbackground($c);
  initialize;
  totalchar:=0;
  shwpos;
  x1:=1;
  y1:=2;
  x2:=80;
  y2:=24;
  filename:='noname.all';
  shwpos;
  repeat
    keyfunction;
    shwchr(x1,y1,x2,y2);
  until ch=#27;
end.
