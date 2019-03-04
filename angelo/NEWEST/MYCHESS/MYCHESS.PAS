uses crt,vgaliza3;
var d1,d2:word;

procedure d;
begin
end;

begin
  vgamode(3);
  for d1:=0 to 7 do
    for d2:=0 to 7 do
    begin
      bar(d1*20,d2*36,d1*20+19,d2*36+35,15-((d1+d2)and 1)*15);
    end;
  readkey;
end.