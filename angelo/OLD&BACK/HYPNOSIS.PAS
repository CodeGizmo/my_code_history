uses vgaliz,crt;
var
  a,b,c:byte;
  ch:char;
begin
  vgamode(1);
  for a:=0 to 159 do
  begin
	 line(a,0,a,199,a);
	 line(319-a,0,319-a,199,a);
  end;
  for a:=0 to 200 do
  begin
	 circle(160,100,a*100 div 255,a);
	 circle(159,99,a*100 div 255,a);
	 circle(160,99,a*100 div 255,a);
  end;
  repeat
	 for a:=0 to 255 do
	 begin
		if a mod 6=0 then
		begin
		  for b:=1 to 127 do
		  begin
			 c:=b shr 1;
			 myup(a+b,c,0,63-c);
			 myup(a+255-b,c,0,63-c);
		  end;
		end;
	 end;
  until keypressed;
  ch:=readkey;
  repeat
	 for a:=0 to 255 do
	 begin
		if a mod 6=0 then
		begin
		  retr;
		  for b:=1 to 127 do
		  begin
			 c:=b shr 1;
			 myup(a+b,c,0,63-c);
			 myup(a+255-b,c,0,63-c);
		  end;
		end;
	 end;
  until keypressed;
end.
