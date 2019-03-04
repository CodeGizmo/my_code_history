uses crt,vgaliza3;
const maxplyr=25;
type
  play=record
         living:byte;
         alldead:boolean;
         fired,locked,dead:array[0..255]of boolean;
         x,y,fx,fy:array[1..maxplyr]of word;
         life:array[1..maxplyr]of byte;
         shld:array[1..maxplyr]of byte;
         p:array[1..maxplyr]of pointer;
       end;
var
  p1,p2:play;
  d1,d2:word;
procedure initplayer(var p:play;xp:word);
var d1,d2:word;
begin
  with p do
  begin
    living:=maxplyr;
    for d1:=1 to 25 do
    begin
      fired[d1]:=false;
      locked[d1]:=false;
      dead[d1]:=false;
      x[d1]:=xp;
      fx[d1]:=xp;
      y[d1]:=d1*6+3;
      fy[d1]:=y[d1];
      life[d1]:=255;
      shld[d1]:=255;
      getmem(p[d1],66);
    end;
  end;
end;

var lock:boolean;

begin
  initplayer(p1,20);
  initplayer(p2,299);
  vgamode(1);
  for d1:=1 to 25 do
  begin
    bar(0,0,10,10,28);
    sphere(3,3,2,random(15)+1);
    getthis(0,0,7,7,p1.p[d1]^);
    bar(1,1,6,6,random(15)+1);
    getthis(0,0,7,7,p2.p[d1]^);
  end;
  frame(10,8,309,189,6,8,30,28,26);
  framemode:=1;
  frame(20,172,299,179,8,8,30,28,26);

  yeymode:=1;
  for d1:=1 to 25 do
  begin
    putthis(p1.x[d1],p1.y[d1],p1.p[d1]^,0);
    putthis(p2.x[d1],p2.y[d1],p2.p[d1]^,0);
  end;
  repeat
    for d1:=1 to 25 do
    begin
      yeyan(p1.fx[d1],p1.fy[d1],15);
    end;
    retr;
  until (p1.alldead)or(p2.alldead)or(keypressed and(readkey=#27));
  readkey;
end.