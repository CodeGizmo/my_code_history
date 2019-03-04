program String_Manipulation;
uses crt,vgaliza;
var
  st:string;
  d1,d2,d3,d4   :word;

var
  deltax,deltay,deltachar     :byte;{sizes of the characters}
  xcursor,ycursor             :word;{current location of cursor}
  bitpos                      :word;{position of the characters}
  charseg,charofs             :word;
  p:pointer;


procedure init_characters;
begin
  getmem(p,16384);
  charseg:=seg(p^);
  charofs:=ofs(p^);
  aload('pictures\letters.all',p^);
  xcursor:=0;
  ycursor:=0;
  deltax:=7;
  deltay:=7;
  deltachar:=(deltax+1)*(deltay+1);
end;

procedure setxy(x,y:word);
begin
  xcursor:=x*(deltax+1);
  ycursor:=y*(deltay+1);
end;{setloc}

procedure mychar1(ch:char);
var x, y           :word;
begin
  {**********************************}
  bitpos:=byte(ch)*deltachar;
    for y:=ycursor to ycursor+deltay do
      for x:=xcursor to xcursor+deltax do
      begin
        yeyan(x,y,mem[charseg:charofs+bitpos]);
        inc(bitpos);
      end;
  {**********************************}
end;{mychar1}

procedure mychar2(ch:char);
var x, y           :word;
begin
  {**********************************}
  bitpos:=byte(ch)*deltachar;
    for y:=ycursor to ycursor+deltay do
      for x:=xcursor to xcursor+deltax do
      begin
        yeyan(x,y,mem[charseg:charofs+bitpos+x+y*320]);
      end;
  {**********************************}
end;{mychar2}

Procedure mywrite(s:string);
begin

end;{mywrite}

begin
  init_characters;
  vgamode(1);
  st:='Angelo L. Lanuza';
  for d1:=0 to 255 do
  begin
    setxy(d1 mod 40,d1 div 40);
    mychar2(char(d1));
  end;
  readkey;
end.