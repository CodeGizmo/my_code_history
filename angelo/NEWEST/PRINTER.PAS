uses crt,printer;
var
  a,b:byte;
begin
  clrscr;
  writeln('Angelo Lian Lanuza');
  writeln(' 1   - Miniature Mode On');
  writeln('2   - Miniature Mode Off');
  writeln('3   - Double-Strike On');
  writeln('4   - Double-Strike Off');
  writeln('5   - Compressed Mode On');
  writeln('6   - Compressed Mode Off');
  writeln('7   - Expanded Mode On');
  writeln('8   - Expanded Mode off');
  writeln('9   - Emphasized Mode On');
  writeln('10  - Emphasized Mode off');
  writeln('11  - Elite Mode On');
  writeln('12  - Elite Mode Off');
  writeln('13  - Skip Perforation On');
  writeln('14  - Skip Perforation Off');
  writeln('15  - 1/8 in. Line Spacing');
  writeln('16  - 7/72 in. Line Spacing');
  writeln('17  - 1/6 in. Line Spacing');
  writeln('18  - Line feed');
  writeln('19  - Form feed');
  writeln('20  - Reset Printer');
  writeln('21  - EXIT');
repeat
  gotoxy(1,24);
  readln(a);
  case a of
    1:write(lst,#15#27#83#0#27#65#6);
    2:write(lst,#18#27#84#27#50);
    3:write(lst,#27,'G');
    4:write(lst,#27,'H');
    5:write(lst,#27,'3',#15);
    6:write(lst,#18);
    7:write(lst,#27,'W1');
    8:write(lst,#27,'W0');
    9:write(lst,#27,'E');
    10:write(lst,#27,'F');
    11:write(lst,#27,'M');
    12:write(lst,#27,'P');
    13:write(lst,#27#78#8);
    14:write(lst,#27#79);
    15:write(lst,#27,'0');
    16:write(lst,#27,'1');
    17:write(lst,#27,'2');
    18:write(lst,#10);
    19:write(lst,#12);
    20:write(lst,#27,'@');
  end;
  if a=0 then
  begin
    for b:=1 to 127 do write(lst,chr(random(256-36)+36));
    writeln(lst);
  end;
until a=21;
end.