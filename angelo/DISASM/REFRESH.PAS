var
  b:byte;
  c:integer;
begin
  val(paramstr(1),b,c);
  port[$43]:=$56;
  port[$41]:=b;
end.