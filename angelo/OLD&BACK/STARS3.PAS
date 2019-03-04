uses vgayey,crt;
var
  x,y,c,ix,iy:array[0..999]of integer;
  count,ct:word;
  ch:char;
  method:byte;
  stars:word;
begin
  vgamode(1);
  stars:=499;
  if stars>999 then stars:=999;
  for ct:=0 to stars do
  begin
	 myup(ct,ct,ct,ct);
	 ix[ct]:=random(21)-10;
         iy[ct]:=random(13)-6;
	 x[ct]:=160;
	 y[ct]:=100;
	 c[ct]:=trunc(sqrt(sqr(ix[ct]*6)+sqr(iy[ct]*10))/1.35);
  end;
  repeat
	 for ct:=0 to stars do
		yeyan(x[ct],y[ct],c[ct]);
         if keypressed then
	 begin
		ch:=readkey;
                if ch=#13 then begin inc(method);method:=method mod 2;end;
	 end;
	 retr;
	 for ct:=0 to stars do
	 begin
		yeyan(x[ct],y[ct],0);
                inc(x[ct],ix[ct]);
                inc(y[ct],iy[ct]);
                if method=1 then
                begin
                  ix[ct]:=ix[ct]+2*(x[ct]-160)div 160;
                  iy[ct]:=iy[ct]+2*(y[ct]-100)div 100;
                end;
                if (x[ct]>319)or(y[ct]>199)or(y[ct]<0)or(x[ct]<0)then
                begin
	          ix[ct]:=random(21)-10;
                  iy[ct]:=random(13)-6;
      	          x[ct]:=160{+random(ix[ct]){*(abs(ix[ct])div ix[ct])};
	          y[ct]:=100{+random(iy[ct]){*(abs(iy[ct])div iy[ct])};
	          c[ct]:=trunc(sqrt(sqr(ix[ct]*6)+sqr(iy[ct]*10))/1.35);
                end;
	 end;
  until ch=#27;
end.