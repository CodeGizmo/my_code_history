uses vgaliza,crt;
var
  x,y:word;
  ch:char;
var
  wincolor:byte;
  winthickness:byte;
  winbackground:byte;
procedure window(x1,y1,x2,y2,method:word);
begin
  gseg:=$9000;
  movebar(x1,y1,x2,y2,random(319-x1),random(199-y1){winbackground});
  case method of
    1:begin
        box(x1,y1,x2,y2,wincolor);
      end;
    2:begin
        bar(x1-winthickness,y1-winthickness,x2+winthickness,y1,wincolor);
        bar(x1-winthickness,y1-winthickness,x1,y2+winthickness,wincolor);
        bar(x2+winthickness,y2+winthickness,x2,y1,wincolor);
        bar(x2+winthickness,y2+winthickness,x1,y2,wincolor);
      end;
    3:begin
        bar(x1-winthickness,y1-winthickness,x2+winthickness,y1,wincolor);
        bar(x1-winthickness,y1-winthickness,x1,y2+winthickness,wincolor);
        bar(x2+winthickness,y2+winthickness,x2,y1,wincolor);
        bar(x2+winthickness,y2+winthickness,x1,y2,wincolor);
        box(x1-winthickness shr 1,y1-winthickness shr 1,
            x2+winthickness shr 1,y2+winthickness shr 1,not(wincolor));
      end;
    4:begin
        bar(x1-winthickness,y1-winthickness,x2+winthickness,y1,wincolor);
        bar(x1-winthickness,y1-winthickness,x1,y2+winthickness,wincolor);
        bar(x2+winthickness,y2+winthickness,x2,y1,wincolor);
        bar(x2+winthickness,y2+winthickness,x1,y2,wincolor);
        box(x1-winthickness,y1-winthickness,x2+winthickness,y2+winthickness,not(wincolor));
        box(x1,y1,x2,y2,not(wincolor));
      end;
  end;
  sound(256-(x2-x1)*(y2-y1)shr 8);
end;

var x1,y1,x2,y2:word;
begin
  vgamode(1);
  aload('newbunny.all',ptr($9000,0)^);
  winthickness:=4;
  wincolor:=2;
  winbackground:=8;
  window(10,10,300,190,1);
  wincolor:=7;
  winbackground:=10;
  window(50,50,150,150,2);
  repeat
    wincolor:=random(256);
    winbackground:=random(256);
    x1:=random(309)+5;
    y1:=random(189)+5;
    x2:=random(313-x1)+x1+1;
    y2:=random(193-y1)+y1+1;
    window(x1,y1,x2,y2,random(4)+1);
  until keypressed;
  ch:=readkey;
  nosound;
end.