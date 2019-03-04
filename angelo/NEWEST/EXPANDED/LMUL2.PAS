program Long_Multiplication;
{Started : Oct. 15, 1994;  9:47pm}
{Midway  : Oct. 15, 1994;  9:56pm}
{Finished: Oct. 15, 1994; 10:21pm}
{Revised : Jan.  9, 1995;  9:13pm}
uses crt;
const
  N = 4000;
var
  M1,M2:array[1..N]of byte;
  L1,L2,Lr,a,b,ref,p,np:word;
  R:array[1..2*N]of byte;
  ch:char;
procedure
begin
  clrscr;
  write('Enter the 1 to 100 digit multiplicand -> ');
  l1:=0;
  repeat
    ch:=readkey;
    if ch in['0'..'9']then
    begin
      inc(l1);
      m1[l1]:=byte(ch)-byte('0');
      write(ch);
    end;
  until (ch=#13)or(l1=N);
  writeln;
  write('Enter the 1 to 100 digit multiplier -> ');
  l2:=0;
  repeat
    ch:=readkey;
    if ch in['0'..'9']then
    begin
      inc(l2);
      m2[l2]:=byte(ch)-byte('0');
      write(ch);
    end;
  until (ch=#13)or(l2=N);
  for b:=l2 downto 1 do
    for a:=l1 downto 1 do
    begin
      ref:=1;
      p:=m1[a]*m2[b];
      repeat
        np:=(p+r[l2-b+l1-a+ref])mod 10;
        p:=(p+r[l2-b+l1-a+ref])div 10;
        r[l2-b+l1-a+ref]:=np;
        inc(ref);
      until p=0;
    end;
  writeln;
  write('The product is -> ');
  b:=l2+l1;
  while (r[b]=0)and(b>1)do dec(b);
  for a:=b downto 1 do begin write(r[a]);if (((a-1)mod 3)=0)and(a>1) then write(',');end;
  readln;
end.

