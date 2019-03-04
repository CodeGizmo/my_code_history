uses vgayey,crt;
const
  stars=2999;
var
  x,y,c,incs:array[0..stars]of word;
  count,ct:word;
  ch:char;
  method:byte;
begin
  vgamode(1);
  for ct:=0 to stars do
  begin
	 myup(ct,ct,ct,ct);
	 x[ct]:=random(320);
	 y[ct]:=random(200);
	 c[ct]:=63;
	 incs[ct]:=random(10);
  end;
  repeat
	 for ct:=0 to stars do
		yeyan(x[ct],y[ct],incs[ct]*63 div 10);
	 if keypressed then
	 begin
		ch:=readkey;
		if ch='+'then begin for ct:=0 to 63 do inc(incs[ct]);ch:='a';end;
		if ch='-'then begin for ct:=0 to 63 do dec(incs[ct]);ch:='a';end;
                if ch=#13 then begin inc(method);method:=method mod 9;end;
	 end;
	 retr;
	 for ct:=0 to stars do
	 begin
		yeyan(x[ct],y[ct],0);
                case method of
                  0:begin
                      inc(x[ct],incs[ct]);
		      if x[ct]>319 then
		      begin
		        x[ct]:=x[ct]mod 320;
		        y[ct]:=random(200);
		      end;
                    end;
                  2:begin
                      inc(y[ct],incs[ct]);
		      if y[ct]>199 then
		      begin
		        y[ct]:=y[ct]mod 200;
		        x[ct]:=random(320);
		      end;
                    end;
                  4:begin
                      dec(x[ct],incs[ct]);
		      if x[ct]>319 then
		      begin
		        x[ct]:=x[ct]+320;
		        y[ct]:=random(200);
		      end;
                    end;
                  6:begin
                      dec(y[ct],incs[ct]);
		      if y[ct]>199 then
		      begin
		        y[ct]:=y[ct]+200;
		        x[ct]:=random(320);
		      end;
                    end;
                end;
                case method of
                  1:begin
                      inc(x[ct],incs[ct]);
                      inc(y[ct],incs[ct]);
		      if (x[ct]>319) then x[ct]:=x[ct]mod 320;
                      if (y[ct]>199) then y[ct]:=y[ct]mod 200;
                    end;
                  3:begin
                      dec(x[ct],incs[ct]);
                      inc(y[ct],incs[ct]);
		      if (x[ct]>319) then x[ct]:=x[ct]+320;
                      if (y[ct]>199) then y[ct]:=y[ct]mod 200;
                    end;
                  5:begin
                      dec(x[ct],incs[ct]);
                      dec(y[ct],incs[ct]);
		      if (x[ct]>319) then x[ct]:=x[ct]+320;
                      if (y[ct]>199) then y[ct]:=y[ct]+200;
                    end;
                  7:begin
                      inc(x[ct],incs[ct]);
                      dec(y[ct],incs[ct]);
		      if (x[ct]>319) then x[ct]:=x[ct]mod 320;
                      if (y[ct]>199) then y[ct]:=y[ct]+200;
                    end;
                  8:begin
                      if (ct mod 2)=1{odd(ct)}then
                      begin
                        dec(x[ct],incs[ct]);
	       	        if (x[ct]>319) then
                        begin
                          x[ct]:=x[ct]+320;
                          y[ct]:=random(200);
                        end;
                      end else
                      begin
                        dec(x[ct],incs[ct]);
                        dec(y[ct],incs[ct]);
	                if (x[ct]>319) then x[ct]:=x[ct]+320;
                        if (y[ct]>199) then y[ct]:=y[ct]+200;
                      end;
                    end;
                end;
	 end;
  until ch=#27;
end.