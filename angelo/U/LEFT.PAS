uses crt;
begin
  mem[$40:memw[$40:$1c]]:=224;
  mem[$40:memw[$40:$1c]+1]:=75;
  inc(memw[$40:$1c],2);
  if memw[$40:$1c]>=62 then memw[$40:$1c]:=30;
end.