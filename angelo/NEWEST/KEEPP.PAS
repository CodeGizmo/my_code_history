{ Example for Keep }

{$M $800,0,0 }   { 2K stack, no heap }
{ This program causes a click each time
 a key is pressed.}
uses Crt, Dos;
var
  TmrIntVec : Procedure;
{$F+}
procedure Timetick; interrupt;
begin
{  if Port[$60] < $80 then}
    { Only click when key is pressed }
    begin
    Sound(2000);
    Delay(1);
    Nosound;
    end;
  inline ($9C); { PUSHF -- Push flags }
  { Call old ISR using saved vector }
  TmrIntVec;
end;
{$F-}
begin
  { Insert ISR into keyboard chain }
  GetIntVec($8,@TmrIntVec);
  SetIntVec($8,Addr(Timetick));
  Keep(0); { Terminate, stay resident }
end.
