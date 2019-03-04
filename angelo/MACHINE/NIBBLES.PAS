program NIBBLES;

uses crt,dos,graph;

type
  players=record
            x,y         :array[0..1002]of integer;
            xx,yy       :integer;
            c           :byte;
            lives       :integer;
            level       :integer;
            lft,rght    :char;
            ext         :boolean;
            head        :integer;
            dir         :char;
            died        :boolean;
          end;

var
  menu,
  d,d1,d2,d3,d4,d5,d6,
  graphdriver,graphmode :integer;
  quit                  :boolean;
  ch                    :char;
  plyrno                :integer;
  p                     :array[0..3] of players;
  plyr                  :integer;
  alldead               :boolean;
  lastlives             :integer;
  delays                :integer;
  counter               :longint;
  foodx,foody           :integer;
  color                 :byte;
  s,s2                  :string;

const
  left  = #75;
  right = #77;
  up    = #72;
  down  = #80;

procedure boxout(ymin:integer;c1,c2:byte);
var
  d:integer;
begin
  for d:=239 downto ymin do
  begin
    setcolor(c1);
    moveto(d,d);
    lineto(639-d,d);
    lineto(639-d,479-d);
    lineto(d,479-d);
    lineto(d,d);
    setcolor(c2);
    moveto(d+1,d+1);
    lineto(638-d,d+1);
    lineto(638-d,478-d);
    lineto(d+1,478-d);
    lineto(d+1,d+1);
  end;
end;

procedure boxin;
var
  d:integer;
begin
  for d:=0 to 239 do
  begin
    setcolor(0);
    moveto(d,d);
    lineto(639-d,d);
    lineto(639-d,479-d);
    lineto(d,479-d);
    lineto(d,d);
  end;
end;

procedure l(x1,y1,x2,y2:integer;c:byte);
var d:integer;
begin
  if x1>x2 then
  begin
    d:=y1;
    y1:=y2;
    y2:=d;
    d:=x1;
    x1:=x2;
    x2:=d;
  end;
  setcolor(c);
  line(x1,y1,x2,y2);
end;

procedure puttitle;
begin
  settextstyle(gothicfont,horizdir,5);
  settextjustify(centertext,centertext);
  setcolor(0);
  outtextxy(320,100,'WELCOME');
  settextstyle(gothicfont,horizdir,3);
  outtextxy(320,140,'to');
  settextstyle(TRIPLEXfont,horizdir,8);
  setcolor(8);
  for d:=9 downto 0 do
  begin
    outtextxy(320+d,180+d,'NIBBLES');
  end;
  setcolor(15);
  outtextxy(320,180,'NIBBLES');
  settextstyle(triplexfont,horizdir,2);
  outtextxy(320,240,'ver. 1.00');

  setcolor(0);
  settextstyle(defaultfont,horizdir,1);
  outtextxy(320,280,'Programmed by  :  LANUZA, Angelo L.      ');
  outtextxy(320,300,'Submitted on   :  Monday, January 8, 1995');
  outtextxy(320,320,'for the subject:  KODP 351L - A581       ');
  outtextxy(320,340,'Submitted to   :  Ms. Noemi Bulaong     ');
end;

procedure initialize;
begin
  graphdriver:=detect;
  detectgraph(graphdriver,graphmode);
  initgraph(graphdriver,graphmode,'d:\tp7\bgi');
  delay(4100);
  boxout(0,8,7);
  l(0,0,639,0,15);
  l(0,0,0,479,15);
  l(639,479,0,479,8);
  l(639,479,639,0,8);
  l(1,1,638,1,15);
  l(1,1,1,478,15);
  l(638,478,1,478,8);
  l(638,478,638,1,8);
  l(2,2,637,2,15);
  l(2,2,2,477,15);
  l(637,477,2,477,8);
  l(637,477,637,2,8);
  l(3,3,636,3,15);
  l(3,3,3,476,15);
  l(636,476,3,476,8);
  l(636,476,636,3,8);

  l(14,14,625,14,8);
  l(14,14,14,401,8);
  l(625,401,14,401,15);
  l(625,401,625,14,15);
  l(15,15,624,15,15);
  l(15,15,15,400,15);
  l(624,400,15,400,8);
  l(624,400,624,15,8);

  l(14,14,625,14,8);
  l(14,14,14,401,8);
  l(625,401,14,401,15);
  l(625,401,625,14,15);
  l(15,15,624,15,15);
  l(15,15,15,400,15);
  l(624,400,15,400,8);
  l(624,400,624,15,8);

  puttitle;

  quit:=false;
  menu:=0;
  plyrno:=3;
end;

procedure initmenus;
begin
  setcolor(0);
  settextjustify(centertext,centertext);
  settextstyle(defaultfont,horizdir,1);
  outtextxy(320,460,'PLAY    HELP    SETTINGS    EXIT');
end;

procedure setmenu(m:integer;c:byte);
begin
  setcolor(c);
  settextjustify(centertext,centertext);
  settextstyle(defaultfont,horizdir,1);
  case m of
    0:outtextxy(320,460,'PLAY                            ');
    1:outtextxy(320,460,'        HELP                    ');
    2:outtextxy(320,460,'                SETTINGS        ');
    3:outtextxy(320,460,'                            EXIT');
  end;
end;

procedure initplayer(pp:integer);
begin
  if pp=0 then
  with p[0] do
  begin
    xx:=322;
    yy:=377;
    x[0]:=322;
    y[0]:=377;
    lives:=5;
    c:=1;
    head:=0;
    dir:=up;
    died:=false;
    ext:=true;
    lft:=left;
    rght:=right;
  end;

  if pp=1 then
  with p[1] do
  begin
    xx:=322;
    yy:=32;
    x[0]:=322;
    y[0]:=32;
    lives:=5;
    c:=2;
    head:=0;
    dir:=down;
    died:=false;
    lft:='z';
    rght:='x';
    ext:=false;
  end;

  if pp=2 then
  with p[2] do
  begin
    xx:=82;
    yy:=207;
    x[0]:=82;
    y[0]:=207;
    lives:=5;
    c:=3;
    head:=0;
    dir:=right;
    died:=false;
    lft:=',';
    rght:='.';
    ext:=false;
  end;

  if pp=3 then
  with p[3] do
  begin
    xx:=537;
    yy:=207;
    x[0]:=537;
    y[0]:=207;
    lives:=5;
    c:=4;
    head:=0;
    dir:=left;
    died:=false;
    lft:='1';
    rght:='2';
    ext:=false;
  end;
end;

procedure initplayers;
begin
  initplayer(0);
  initplayer(1);
  initplayer(2);
  initplayer(3);
  p[0].level:=5;
  p[1].level:=5;
  p[2].level:=5;
  p[3].level:=5;
end;

function spaceok(x,y:integer;c:byte):boolean;
var ok:boolean;
    xx,yy:integer;
begin
  ok:=true;
  color:=c;
  for xx:=x-2 to x+2 do
    for yy:=y-2 to y+2 do
      if getpixel(xx,yy)<>c then begin ok:=false;color:=getpixel(xx,yy)end;
  spaceok:=ok;
end;

procedure play;
begin
  initplayers;
  setfillstyle(solidfill,7);
  bar(16,16,623,399);
  setcolor(0);
  moveto(79,29);
  lineto(540,29);
  lineto(540,380);
  lineto(79,380);
  lineto(79,29);
  delays:=100;
  counter:=0;
  for d:=0 to plyrno do
  begin
    repeat
      d5:=random(92);
      d6:=random(70);
    until spaceok(d5*5+82,d6*5+32,7);
    setcolor(14);
    circle(d5*5+82,d6*5+32,2);
  end;
  repeat
    alldead:=true;
    if keypressed then
    begin
      ch:=readkey;
      if ch=#0 then
      begin
        ch:=char(ord(readkey)+128);
      end else
      if ch='p' then repeat until readkey='p';
    end else ch:=#255;
    for plyr:=0 to plyrno do
      with p[plyr] do
      begin
        if not(died) then
        begin
          if ch<>#255 then
          begin
            if ext and (ord(ch)>127) then
            begin
              ch:=char(ord(ch)-128);
              if ch=lft then
              case dir of
                up:dir:=left;
                left:dir:=down;
                down:dir:=right;
                right:dir:=up;
              end else
              if ch=rght then
              case dir of
                up:dir:=right;
                left:dir:=up;
                down:dir:=left;
                right:dir:=down;
              end;
            end else
            if not(ext) and (ord(ch)<128) then
            begin
              if ch=lft then
              case dir of
                up:dir:=left;
                left:dir:=down;
                down:dir:=right;
                right:dir:=up;
              end else
              if ch=rght then
              case dir of
                up:dir:=right;
                left:dir:=up;
                down:dir:=left;
                right:dir:=down;
              end;
            end;
          end;
          if dir=up then dec(yy,5)
          else if dir=down then inc(yy,5)
          else if dir=right then inc(xx,5)
          else if dir=left then dec(xx,5);
          if spaceok(xx,yy,7)or(color=14)then
          begin
            if color=14 then
            begin
              setfillstyle(solidfill,7);
              bar(xx-2,yy-2,xx+2,yy+2);
              inc(level,10);{********************************}
              if (level mod 200)=0 then inc(lives);
              repeat
                d5:=random(92);
                d6:=random(70);
              until spaceok(d5*5+82,d6*5+32,7);
              setcolor(14);
              circle(d5*5+82,d6*5+32,2);
            end;
            setcolor(14);
            circle(d5*5+82,d6*5+32,2);
            setfillstyle(solidfill,c);
            bar(xx-2,yy-2,xx+2,yy+2);
            setfillstyle(solidfill,7);
            d3:=(head+1000-level)mod 1000;
            bar(x[d3]-2,y[d3]-2,x[d3]+2,y[d3]+2);
            head:=(head+1)mod 1000;
            x[head]:=xx;
            y[head]:=yy;
          end else
          begin
            if lives=0 then died:=true
            else
            begin
              dec(lives);
              lastlives:=lives;
              for d4:=0 to level do
              begin
                setfillstyle(solidfill,7);
                d3:=(head+1000-d4)mod 1000;
                bar(x[d3]-2,y[d3]-2,x[d3]+2,y[d3]+2);
              end;
              initplayer(plyr);
              lives:=lastlives;
            end;
          end;
        end;
        alldead:=alldead and died;
      end;
      inc(counter);
      if (counter mod 600)=600 then begin counter:=0;delays:=delays*10 div 12;end;
      delay(delays);
      setfillstyle(solidfill,7);
      bar(100,405,120,450);
      bar(180,405,205,450);
      setcolor(0);
      settextjustify(lefttext,centertext);
      settextstyle(defaultfont,horizdir,1);
      str(p[0].level div 10:3,s);
      str(p[0].lives:2,s2);
      outtextxy(20,410,'Player 1:'+s+' levels, '+s2+' lives left');
      str(p[1].level div 10:3,s);
      str(p[1].lives:2,s2);
      outtextxy(20,420,'Player 2:'+s+' levels, '+s2+' lives left');
      str(p[2].level div 10:3,s);
      str(p[2].lives:2,s2);
      outtextxy(20,430,'Player 3:'+s+' levels, '+s2+' lives left');
      str(p[3].level div 10:3,s);
      str(p[3].lives:2,s2);
      outtextxy(20,440,'Player 4:'+s+' levels, '+s2+' lives left');
  until alldead;
end;

procedure help;
begin
  setfillstyle(solidfill,7);
  bar(16,16,623,399);
  setcolor(0);
  settextstyle(triplexfont,horizdir,2);
  outtextxy(320,100,'       CONTROL KEYS ASSIGNED FOR THE PLAYERS      ');
  settextstyle(defaultfont,horizdir,1);
  outtextxy(320,130,'  Player 1: Right arrow - turns 90 degrees clockwise        ');
  outtextxy(320,150,'             Left arrow - turns 90 degrees counter-clockwise');
  outtextxy(320,180,'  Player 2:           z - turns 90 degrees clockwise        ');
  outtextxy(320,200,'                      x - turns 90 degrees counter-clockwise');
  outtextxy(320,230,'  Player 3:           , - turns 90 degrees clockwise        ');
  outtextxy(320,250,'                      . - turns 90 degrees counter-clockwise');
  outtextxy(320,280,'  Player 4:           1 - turns 90 degrees clockwise        ');
  outtextxy(320,300,'                      2 - turns 90 degrees counter-clockwise');
  if readkey=#0 then ch:=readkey;
  setfillstyle(solidfill,7);
  bar(16,16,623,399);
  setcolor(0);
  settextstyle(triplexfont,horizdir,2);
  outtextxy(320,100,'RULES OF THE GAME');
  settextstyle(defaultfont,horizdir,1);
  outtextxy(320,130,'* Each player has 5 lives.                                          ');
  outtextxy(320,150,'* A player will lose a life if he bumps to the wall,                ');
  outtextxy(320,170,'  bumps an opponent or bumps himself.                               ');
  outtextxy(320,190,'* he can gain a level higher if he passes along a circular object   ');
  outtextxy(320,210,'* A bonus life will be given every 20 levels.                       ');
  outtextxy(320,230,'* A maximum of 100 levels can be achieve.                           ');
  outtextxy(320,250,'* Pressing p pauses the game.                                       ');
  outtextxy(320,270,'* the speed increases by a factor of 1.2 at a desired amount of time');
  outtextxy(320,290,'* Minimum player is 1 and Maximum players is 4.                     ');
  outtextxy(320,310,'* Player 1 starts from bottom, player 2 from top                    ');
  outtextxy(320,330,'  player 3 from left and player 4 from right.                       ');
  ch:=readkey;
  setfillstyle(solidfill,7);
  bar(16,16,623,399);
  puttitle;
end;

procedure settings;
var howmany:integer;
begin
  setfillstyle(solidfill,7);
  bar(16,16,623,399);
  setcolor(0);
  settextstyle(Triplexfont,horizdir,2);
  outtextxy(320,130,'HOW MANY PLAYERS');
  outtextxy(320,160,'1 Player ');
  outtextxy(320,190,'2 Players');
  outtextxy(320,220,'3 Players');
  outtextxy(320,250,'4 Players');
  setcolor(15);
  outtextxy(320,160,'1        ');
  outtextxy(320,190,'2        ');
  outtextxy(320,220,'3        ');
  outtextxy(320,250,'4        ');
  repeat
    ch:=readkey;
  until ch in[#27,'1','2','3','4'];
  if ch<>#27 then plyrno:=ord(ch)-byte('1');
  bar(16,16,623,399);
  puttitle;
end;

procedure menuhandler;
begin
  if ch in[left,right]then
  begin
    setmenu(menu,0);
    if ch=left then dec(menu)
      else inc(menu);
    menu:=(menu+4)mod 4;
    setmenu(menu,15);
  end;
end;

begin
  initialize;
  initmenus;
  setmenu(0,15);
  repeat
    ch:=readkey;
    case ch of
      #00:begin
            ch:=readkey;
            case ch of
              #45:quit:=true;
            end;
            menuhandler;
         end;
      #13:begin
            case menu of
              0:play;
              1:help;
              2:settings;
              3:quit:=true;
            end;
          end;
    end;
  until quit;
  boxin;
  closegraph;
  writeln('I hope you''ve enjoyed playing.  Have a nice day!');
end.