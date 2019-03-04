{$M $8000,0,0 }
uses Crt, Dos;
var
  TimerIntVec : Procedure;
  counter:word;
  flag,son:boolean;
  d:word;
  on,off:byte;

{$F+}
procedure Timeclick; interrupt;
begin
  if Port[$60]=$29 then
    Son:=true else if port[$60]=2 then son:=false;
  if (counter and 1)=0 then
  begin
    inline ($9C);
    TimerIntVec;
    if son then port[$61]:=off;
  end else
  begin
    asm
      mov al,$20
      out $20,al
    end;
    if son then
    begin
      port[$61]:=on;
    end;
    mem[$b800:316]:=counter shr 8;
    mem[$b800:318]:=counter and 255;
    mem[$b800:158]:=byte('A');
    mem[$b800:156]:=byte('Z');
    mem[$b800:154]:=byte('U');
    mem[$b800:152]:=byte('N');
    mem[$b800:150]:=byte('A');
    mem[$b800:148]:=byte('L');
    for d:=0 to 128 do;
  end;
  inc(counter);
end;
{$F-}
begin
  on:=port[$61]or 2;
  off:=port[$61]and not(2);
  counter:=0;
  GetIntVec($8,Addr(TimerIntVec));
  SetIntVec($8,Addr(Timeclick));
  Keep(0);
end.
