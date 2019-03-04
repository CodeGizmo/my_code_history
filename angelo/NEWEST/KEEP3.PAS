{$M $ff00,0,165535 }
uses Crt, Dos;
var
  TimerIntVec : Procedure;
  counter:word;
  flag,son:boolean;
{  d:word;}
{  on,off:byte;}

var
  f:file;
  p:pointer;
  o,s:word;
  a,b,c,d:word;
  max,x,y:word;
  mydelay,rapid:byte;
  morevol:byte;
type
  myptr=array[0..65500]of byte;

var
  on,off:byte;
  qualvol:array[0..8192]of byte;
  fader,fade,outcomevol:byte;
  beat,counterr,pos:word;
  onfirst:byte;
  loading:boolean;

(*procedure playit;
begin
    y:=wherey;
    rapid:=0;
    mydelay:=0;
    morevol:=0;
    onfirst:=1;
    getmem(p,65535);
    assign(f,'f:\clsheavn.wav');
    reset(f,1);
    max:=64000;
    if filesize(f)<64000 then max:=filesize(f);
{    repeat}
      blockread(f,p^,max);
      {tring;}
      if (filesize(f)-filepos(f))<max then
      begin
        max:=filesize(f)-filepos(f);
      end;
{    until (keypressed)or(filepos(f)>=filesize(f));}
    close(f);
    freemem(p,65535);
end; *)
{$F+}
procedure Timeclick; interrupt;
begin
  if Port[$60]=$29 then
  begin
    Son:=true;
  end else
  if port[$60]=2 then
  begin
    son:=false;
    port[$43]:=$36;
    port[$40]:=$ff;
    port[$40]:=$ff;
    loading:=true;
  end;
  if (counter mod 3)=0 then
  begin
    inline ($9C);
    TimerIntVec;
  end;
  asm
    mov al,$20
    out $20,al
  end;
  if (counter and 1)=0 then
  begin

{    if son and not(loading)then port[$61]:=off;}
  end else
  begin

    if son then
    begin
      if loading then
      begin
        loading:=false;
        asm
          sti
        end;
        y:=wherey;
        rapid:=0;
        mydelay:=0;
        morevol:=0;
        onfirst:=1;
        getmem(p,65535);
        assign(f,'f:\clsheavn.wav');
        reset(f,1);
        max:=64000;
        if filesize(f)<64000 then max:=filesize(f);
        blockread(f,p^,max);
        port[$43]:=$36;
        port[$40]:=$40;
        port[$40]:=$00;
      end else
      begin
        port[$61]:=on;
        for beat:=0 to myptr(p^)[pos shl 1]shl 1 do;
        port[$61]:=off;
        inc(pos);
        if pos>=64000 then pos:=0;
{        if a>=4 then begin a:=0;inc(pos);end;
        {if pos>=max shr 1 then . . .}
      end;
    end;
    mem[$b800:316]:=counter shr 8;
    mem[$b800:318]:=counter and 255;
    mem[$b800:158]:=byte('A');
    mem[$b800:156]:=byte('Z');
    mem[$b800:154]:=byte('U');
    mem[$b800:152]:=byte('N');
    mem[$b800:150]:=byte('A');
    mem[$b800:148]:=byte('L');
{    for d:=0 to 128 do;}
  end;
  inc(counter);
end;
{$F-}
begin
  son:=false;
  clrscr;
  on:=port[$61]or 2;
  off:=port[$61]and not(3);
  loading:=true;
  counter:=0;
  GetIntVec($8,Addr(TimerIntVec));
  SetIntVec($8,Addr(Timeclick));
  Keep(0);
{  playit;}
end.




