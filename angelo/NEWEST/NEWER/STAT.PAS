uses crt;
var
  d1,d2,d3,d4,d5:byte;
  t:word;
begin
  clrscr;
  t:=0;
  for d1:=1 to 6 do
    for d2:=1 to 6 do
      for d3:=1 to 6 do
        for d4:=1 to 6 do
          for d5:=1 to 6 do
          begin
            if ((d1=d2)and(d1=d3)and(d1=d4)and(d1<>d5))or
               ((d1=d2)and(d1=d3)and(d1<>d4)and(d1=d5))or
               ((d1=d2)and(d1<>d3)and(d1=d4)and(d1=d5))or
               ((d1<>d2)and(d1=d3)and(d1=d4)and(d1=d5))or
               ((d1<>d2)and(d2=d3)and(d2=d4)and(d2=d5))then
               begin
                 inc(t);
                 {gotoxy(1,1);}write(t:3,'>',d1:2,d2:2,d3:2,d4:2,d5:2);
{                 delay(1);}
                 if(t mod 25)=24 then readkey;
               end;
          end;
  readkey;
end.