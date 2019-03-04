uses crt;
begin
  port[$ce]:=$20;
  port[$20]:=$20;
  port[$19d]:=02;
  repeat
  until keypressed;
end.