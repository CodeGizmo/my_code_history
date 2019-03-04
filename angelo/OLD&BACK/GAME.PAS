uses vgayey,newint09,crt;

procedure game3;
var
  x,y,myspeed:word;
procedure makeframe;
var
  y:word;
begin
  bar(0,0,319,3,15);
  bar(0,196,319,199,15);
  bar(0,0,3,199,15);
  bar(316,0,319,199,15);
  bar(158,0,161,199,15);
  line(50,4,50,195,7);
  line(109,4,109,195,7);
  line(210,4,210,195,7);
  line(269,4,269,195,7);
  pseg:=$9000;
  clear;
  for y:=0 to 19 do
  bar(78,y*40,81,y*40+19,2);
end;

procedure mover;
var r:word;
begin
  gseg:=$9000;
  pseg:=$a000;
  retr;
  movebar(78,0,81,y,78,199-y);
  movebar(78,y,81,199,78,0);

end;
var
  pluser,newkey,lastkey:byte;

begin
  vgamode(1);
  key:=0;
  makeframe;
  y:=4;
  pluser:=1;
  myspeed:=0;
  repeat
    inc(y,myspeed);if y>199 then y:=y-199;
    mover;
    if key=$1c then begin inc(myspeed);key:=0;end;
  until key=1;
  key:=0;
end;



procedure game2;
begin
end;

(*procedure tetris;

procedure block(x,y:word;c:byte);
begin
  bar(x shl 3,y shl 3,(x shl 3)+6,(y shl 3)+6,c);
  box(x shl 3,y shl 3,(x shl 3)+6,(y shl 3)+6,c+8);
end;

procedure delblock(x,y:word);
begin
  bar(x shl 3,y shl 3,(x shl 3)+6,(y shl 3)+6,0);
end;

var
  level:byte;
  x,y,blkcol,style:byte;
  ht,col,drop,delays:byte;
begin
  vgamode(1);
  clear;
{  aload('newbunny.all',ptr($a000,0)^);
  for x:=15 to 24 do
    for y:=0 to 24 do delblock(x,y);}
  level:=1;
  col:=random(40);
  drop:=1;
  delays:=0;
  repeat
    if ht>24 then begin col:=random(40);ht:=0;end;
    for y:=0 to delays do retr;
    if yeyun(col shl 3,ht shl 3)=0 then
    begin
      if ht>0 then delblock(col,ht-1);
      block(col,ht,blkcol);
    end else begin col:=random(40);ht:=0;blkcol:=random(7)+1;style:=random(7);end;
    ht:=ht+drop;
 {   randomize;}
  until key=1;
end;*)

procedure tetris2;

procedure block(x,y:word;c:byte);
begin
  if y<25 then
  begin
    bar(x shl 3,y shl 3,(x shl 3)+6,(y shl 3)+6,c);
    box(x shl 3,y shl 3,(x shl 3)+6,(y shl 3)+6,c+8);
  end;
end;

procedure delblk(x,y:word);
begin
  if y<25 then bar(x shl 3,y shl 3,(x shl 3)+6,(y shl 3)+6,0);
end;

function okay(x,y:byte):boolean;
begin
  okay:=yeyun(x shl 3,y shl 3)=0;
end;

function okayd(x,y:byte):boolean;
begin
  okayd:=yeyun(x shl 3,(y+1)shl 3)=0;
end;

function okayl(x,y:byte):boolean;
begin
  okayl:=yeyun((x-1)shl 3,y shl 3)=0;
end;

function okayr(x,y:byte):boolean;
begin
  okayr:=yeyun((x+1) shl 3,y shl 3)=0;
end;

var
  col,ht,blkcol,rcnt,style,stylpos,lev:array[1..2]of byte;
  pl,nopl:byte;

procedure keycommand;
begin
  if mykey[$1e]<>0 then
    if okay(col[pl]-2,ht[pl]-1)and okay(col[pl]-2,ht[pl])and(col[pl]<>1) then
    begin
      delblk(col[pl],ht[pl]);
      delblk(col[pl],ht[pl]-1);
      block(col[pl]-2,ht[pl],blkcol[pl]);
      block(col[pl]-2,ht[pl]-1,blkcol[pl]);
      dec(col[pl]);
    end;
  if mykey[$20]<>0 then
    if okay(col[pl]+1,ht[pl]-1)and okay(col[pl]+1,ht[pl])and(col[pl]<>9)then
    begin
      delblk(col[pl]-1,ht[pl]);
      delblk(col[pl]-1,ht[pl]-1);
      inc(col[pl]);
      block(col[pl],ht[pl],blkcol[pl]);
      block(col[pl],ht[pl]-1,blkcol[pl]);
    end;
  if mykey[$2d]=$2d then
    if okayd(col[pl],ht[pl])and okayd(col[pl]-1,ht[pl])and(ht[pl]<24) then
    begin
      inc(ht[pl]);
      delblk(col[pl],ht[pl]-2);
      delblk(col[pl]-1,ht[pl]-2);
      block(col[pl],ht[pl],blkcol[pl]);
      block(col[pl]-1,ht[pl],blkcol[pl]);
    end;
  freshkeys:=0;
end;{keycommand}

procedure renewstyle;
begin
  col[pl]:=random(9)+1;
  blkcol[pl]:=random(7)+1;
  ht[pl]:=0;
  style[pl]:=random(1);{random(7)}
  stylpos[pl]:=0;
end;

procedure down(style,stylpos:byte);
begin
  inc(rcnt[pl]);
  if rcnt[pl]>=70-lev[pl] then
  begin
    rcnt[pl]:=0;
    case style of
      0:if okayd(col[pl],ht[pl])and okayd(col[pl]-1,ht[pl])and(ht[pl]<24) then
        begin
          inc(ht[pl]);
          delblk(col[pl],ht[pl]-2);
          delblk(col[pl]-1,ht[pl]-2);
          block(col[pl],ht[pl],blkcol[pl]);
          block(col[pl]-1,ht[pl],blkcol[pl]);
        end else renewstyle;
      {1:
      2:
      3:
      4:
      5:
      6:}
    end;
  end;
end;{down}

begin
  vgamode(1);
  clear;
  nopl:=1;
  rcnt[1]:=0;
  style[1]:=0;
  ht[1]:=0;
  col[1]:=5;
  blkcol[1]:=7;
  lev[1]:=35;
  repeat
    retr;
    inc(rcnt[1]);
    inc(rcnt[2]);
    for pl:=1 to nopl do
    begin
      if freshkeys=255 then keycommand;
      down(style[pl],stylpos[pl]);
    end;
  until key=1;
end;

procedure givemes;
begin
  gotoxy(1,1);writeln('CHOOSE A GAME');
  writeln('1 - Tetris');
  writeln('2 - puzzle');
  writeln('3 - racing(not yet finished)');
  writeln('4 - Exit');
end;

var
  newkey,lastkey:word;

begin
  directvideo:=false;
  clrscr;
  gotomyint9;
  key:=0;
  givemes;
  repeat
    newkey:=repeatcount;
    if newkey<>lastkey then
    begin
      if key=2 then tetris2;
      if key=3 then game2;
      if key=4 then game3;
      if key=5 then key:=1;
      givemes;
      lastkey:=newkey;
    end;
  until key=1;
  goaway;
end.