uses vgayey,crt;
var
  x,y,c,incs:array[0..999]of word;
  count,ct:word;
  ch:char;
begin
  vgamode(1);
  for ct:=0 to 163 do
  begin
	 myup(ct,ct,ct,ct);
	 x[ct]:=random(320);
	 y[ct]:=random(200);
	 c[ct]:=63;
	 incs[ct]:=random(6);
  end;
  repeat
	 for ct:=0 to 299 do
		yeyan(x[ct],y[ct],incs[ct]*63 div 10);
	 if keypressed then
	 begin
		ch:=readkey;
		if ch='+'then begin for ct:=0 to 63 do inc(incs[ct]);ch:='a';end;
		if ch='-'then begin for ct:=0 to 63 do dec(incs[ct]);ch:='a';end;
	 end;
	 retr;
	 for ct:=0 to 299 do
	 begin
		yeyan(x[ct],y[ct],0);
		inc(x[ct],incs[ct]);
		if x[ct]>319 then
		begin
		  x[ct]:=random(320);
		  y[ct]:=random(200);
		  c[ct]:=63;
		  incs[ct]:=random(6);
		end;
	 end;
  until ch=#27;
end.