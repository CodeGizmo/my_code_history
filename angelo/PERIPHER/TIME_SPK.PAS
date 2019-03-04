uses crt,vgaliza3;
var
  c0,c1,c2:word;
  d,dd:byte;
  lh,ll,h,l:byte;
begin
 clrscr;
{  asm
    mov  al,0a7h
    out  $43,al
  end;}
  port[$43]:=$0b7;
  port[$42]:=$ff;
  port[$42]:=$ff;
  d:=port[$61];
  port[$61]:=d or 1;
  port[$43]:=$80{D8};
  c2:=0;

  c1:=0;
  repeat
  c0:=65535;
  repeat
    l:=port[$42];
    h:=port[$42];
{    mem[$b800:2]:=port[$42];
    mem[$b800:0]:=port[$42];}
    {gotoxy(1,2);write(word(port[$42]+(port[$42]shl 8)):8);
{    retr;{retr;retr;retr;retr;}
    inc(c1);
    if (h>lh) then
    begin
{      if c1>c2 then c2:=c1;}
{      else} if c1<c0 then c0:=c1;
      c1:=0;
    end;
{    ll:=l;}
    lh:=h;
  until keypressed;

  writeln('highest -> ',c2,'  | lowest -> ',c0);
  until readkey=#27;
  port[$61]:=d and (255-3);
end.