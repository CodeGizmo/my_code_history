uses crt,addition,waveplay;
type
  QandA=record
          Q:string;
          A:string[80];
        end;
  QAp=^QandA;

var
  menu2,maxmenu2,
  menu1,maxmenu1                :byte;
  quit,quitcreate               :boolean;
  QAS                           :array[0..1000]of QAp;
  QA                            :QandA;
  s:string;
  ss:integer;



procedure choosemenu(var menu,maxmenu:byte);
begin
  case ch of
    #72:begin
          dec(menu);
          if menu=0 then menu:=maxmenu;
        end;
    #80:begin
          inc(menu);
          if menu>maxmenu then menu:=1;
        end;
  end;
end;

procedure choosemenuLR(var menu,maxmenu:byte);
begin
  case ch of
    #75:begin
          dec(menu);
          if menu=0 then menu:=maxmenu;
        end;
    #77:begin
          inc(menu);
          if menu>maxmenu then menu:=1;
        end;
  end;
end;





procedure obeyload;
begin
  write('loading...');
  play('wrong3.wav',1,0);

end;

procedure obeyplay;
begin
  write('playing...');
  play('breakrec.wav',1,0);
end;

procedure obeycreateanother;
begin
  play('e:\wav\crash.wav',2,0);
end;

procedure obeysavecreate;
begin
end;

procedure clearmenu2;
begin
  textcolor(lightgreen);
  textbackground(BLUE);
  gotoxy(5,25);write('ANOTHER     SAVE     CANCEL');
end;

procedure highlightmenu2;
begin
  textcolor(lightred);
  textbackground(BLUE);
  case menu2 of
    1:begin gotoxy(5,25);write('ANOTHER');end;
    2:begin gotoxy(17,25);write('SAVE');end;
    3:begin gotoxy(26,25);write('CANCEL');end;
  end;
end;


procedure obeymenu2;
begin
 case menu2 of
    3:quitcreate:=true;
    1:obeycreateanother;
    2:obeysavecreate;
  end;
{  frameoutcb(2,2,79,23,yellow,blue);}
  clearmenu2;
  highlightmenu2;
end;

procedure obeycreate;
begin
  quitcreate:=false;
  begin
    frameoutcb2(2,2,79,23,yellow,blue,' ');
    centerwrite(2,'Type The Question:');
    frameread(60,4,8,s);
    centerwrite(11,'Type The Answer:');
    centerread(13,s);
    clearmenu2;
    highlightmenu2;
    repeat
      ch:=readkey;
      if ch=#0 then
      begin
        ch:=readkey;
        if ch in[#75,#77]then
        begin
          clearmenu2;
          choosemenulr(menu2,maxmenu2);
          highlightmenu2;
        end;
      end else
      begin
        case ch of
          #13:obeymenu2;
          #27:quitcreate:=true;
        end;
      end;
    until quitcreate;
  end;
end;

procedure obeystudy;
begin
  play('excelent.wav',1,0);
end;

procedure obeymusic;
begin
  play('f:\h20moon.wav',0,1);
end;

procedure clearmenu1;
begin
  textcolor(lightgreen);
  textbackground(BLUE);
  centerwrite(10,'LOAD TEST');
  centerwrite(11,'PLAY TEST');
  centerwrite(12,'CREATE TEST');
  centerwrite(13,'STUDY QUESTIONS & ANSWERS');
  centerwrite(14,'EXIT');
  centerwrite(15,'MUSIC PLAY');
end;

procedure highlightmenu1;
begin
  textcolor(lightred);
  textbackground(BLUE);
  case menu1 of
    1:centerwrite(10,'LOAD TEST');
    2:centerwrite(11,'PLAY TEST');
    3:centerwrite(12,'CREATE TEST');
    4:centerwrite(13,'STUDY QUESTIONS & ANSWERS');
    5:centerwrite(14,'EXIT');
    6:centerwrite(15,'MUSIC PLAY');
  end;
end;


procedure obeymenu1;
begin
  case menu1 of
    5:quit:=true;
    1:obeyload;
    2:obeyplay;
    3:obeycreate;
    4:obeystudy;
    6:obeymusic;
  end;
  frameoutcb(2,2,79,23,yellow,blue);
  clearmenu1;
  highlightmenu1;
end;

begin
  quit:=false;
  cursorhide;
  clrscr;
  frameoutcb(2,2,79,23,yellow,blue);
  clearmenu1;
  menu1    := 1;
  maxmenu1 := 6;
  menu2    := 1;
  maxmenu2 := 3;
  highlightmenu1;
  readkey;
  repeat
    ch:=readkey;
    if ch=#0 then
    begin
      ch:=readkey;
      if ch in[#72,#80]then
      begin
        clearmenu1;
        choosemenu(menu1,maxmenu1);
        highlightmenu1;
      end;
    end else
    begin
      case ch of
        #13:obeymenu1;
        #27:quit:=true;
      end;
    end;
  until quit;
end.