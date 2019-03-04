unit mystring;
interface
var maxs:byte;
procedure textxy(x,y:word);
function readbyte:byte;
function readword:word;
function readstring:string;

implementation
uses crt,vgaliza3;

procedure textxy(x,y:word);
begin
  textx:=x;
  texty:=y;
end;

function readbyte:byte;
var ch:char;
    rb:byte;
begin
  rb:=0;
  ch:=readkey;
  if ch in['0'..'9']then
  begin
    putchar(byte(ch));
    rb:=byte(ch)-byte('0');
  end;
  while (ch<>#13)and(rb<25)do
  begin
    ch:=readkey;
    if ch in['0'..'9']then
    begin
      putchar(byte(ch));
      rb:=rb*10+byte(ch)-byte('0');
    end;
  end;
  readbyte:=rb;
end;

function readword:word;
var ch:char;
    rb:word;
begin
  ch:=readkey;
  if ch in['0'..'9']then
  begin
    putchar(byte(ch));
    rb:=byte(ch)-byte('0');
  end;
  while (ch<>#13)and(rb<6553)do
  begin
    ch:=readkey;
    if ch in['0'..'9']then
    begin
      putchar(byte(ch));
      rb:=rb*10+byte(ch)-byte('0');
    end;
  end;
  readword:=rb;
end;

function readstring:string;
var ch:char;
  s:string;
begin
  s:='';
  ch:=readkey;
  if ch<>#13then
  while (ch<>#13)do
  begin
    if ch=#8 then
    begin
      if s[0]>#0 then
      begin
        s[0]:=char(byte(s[0])-1);
        putchar(byte(ch));
      end;
    end else
    begin
      if byte(s[0])<maxs then
      begin
        putchar(byte(ch));
        s:=s+ch;
      end else
      begin
        textxy(textx-charw,texty);
        putchar(byte(ch));
      end;
    end;
    ch:=readkey;
  end;
  readstring:=s;
end;

begin
  maxs:=255;
end.