uses crt,graph;
var
  gd,gm:integer;
{begin
  gd:=detect;
  initgraph(gd,gm,'e:\tp7\bgi');
  settextstyle
  outtext('Angelo');
  readkey;
end.}

  Y, Size: Integer;
begin
  Gd := Detect;
  InitGraph(Gd, Gm, 'e:\tp7\bgi');
  if GraphResult <> grOk then
    Halt(1);
  for gd:=0 to 4 do
  begin
    Y := 0;
    for Size := 1 to 10 do
    begin
      SetTextStyle(gd, HorizDir, Size);
      OutTextXY(0, Y, 'Size = ' + Chr(Size + 48));
      Inc(Y, TextHeight('H') + 1);
    end;
    Readln;
    cleardevice;
  end;
  CloseGraph;
end.
