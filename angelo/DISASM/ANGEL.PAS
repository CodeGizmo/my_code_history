PROGRAM TELEPHONY;

USES CRT, DOS;

TYPE REC=RECORD
           NAME :STRING;
           ADD  :STRING;
           TELNO:STRING;
         END;
     CO=RECORD
          Demands   :LongInt;
          LineUnits :LongInt;
          Erlang    :Real;
        END;
     ARR=ARRAY[1..60]OF REC;

VAR
   totmatrix    :array[0..8]of real;
   demanders    :array[1..8]of longint;
   tandems      :array[1..8]of boolean;
   matrix       :array[0..8,0..8]of real;
   tempint      :longint;
   COs:array[1..8]of CO;
   DIRECTORY    :ARR;
   NOSWAP       :BOOLEAN;
   RECTOT,X,
   CODE,
   I,RECNO,N,Z  :INTEGER;
   S            :STRING;
   ANS          :CHAR;
   TEMP         :REC;
   f            :file;

   tandemno     :integer;

function myround(r:real):longint;
begin
  if int(r)>0.5 then myround:=trunc(r)+1
  else myround:=trunc(r)+1;
end;

FUNCTION GETINFONO(NAME:STRING):INTEGER;
VAR X:INTEGER;
BEGIN
  X:=0;
  REPEAT
    INC(X);
  UNTIL (X>RECTOT)OR(NAME=DIRECTORY[X].NAME);
  GETINFONO:=X;
END;

procedure readint(x:word;var i:longint);
var y:integer;
begin
  y:=wherey;
  repeat
    gotoxy(x,y);
    clreol;
{$I-}
    read(i);
{$I+}
  until ioresult=0;
  gotoxy(x,y);
end;

procedure readinteger(var i:integer);
var y:integer;
    x:integer;
begin
  y:=wherey;
  x:=wherex;
  repeat
    gotoxy(x,y);
    clreol;
{$I-}
    read(i);
{$I+}
  until ioresult=0;
  gotoxy(x,y);
end;

function findlu(d:longint):longint;
begin
  while (d mod 50)<>0 do inc(d);
  findlu:=d;
end;

procedure makemesh(nn:integer);
var x,y:word;
    total:longint;
    tottraf:real;
begin
  writeln;
  writeln('M E S H');
  write('ÚÄÄÄÄÄ');
  for x:=1 to nn+1 do write('ÂÄÄÄÄÄÄÄ');
  writeln('¿');
  write('³     ');
  for x:=1 to nn do write('³  CO',x,'  ');
  writeln('³ TOTAL ³');
  for x:=0 to nn do
    for y:=0 to nn do
    begin
      matrix[y,x]:=0;
    end;
  for y:=1 to nn do
  begin
    total:=0;
    write('ÃÄÄÄÄÄ');
    for x:=1 to nn do
    begin
      write('ÅÄÄÄÄÄÄÄ');
      total:=total+COs[x].lineunits;
    end;
      write('ÅÄÄÄÄÄÄÄ');
    writeln('´');
    write('³ CO',y,' ');
    for x:=1 to nn do
    begin
      if x<>y then
      begin
        matrix[y,x]:=round(100*COs[y].erlang*COs[x].lineunits/(total-COs[y].lineunits))/100;
        write('³',matrix[y,x]:7:2);
        matrix[y,0]:=matrix[y,0]+matrix[y,x];
      end else write('³ ----  ');
    end;
    writeln('³',matrix[y,0]:7:2,'³');
  end;
  write('ÃÄÄÄÄÄ');
  for x:=1 to nn do
  begin
    write('ÅÄÄÄÄÄÄÄ');
    total:=total+COs[x].lineunits;
  end;
    write('ÅÄÄÄÄÄÄÄ');
  writeln('´');
  write('³TOTAL³');
  for x:=1 to nn do
  begin
    for y:=1 to nn do
    begin
      matrix[0,x]:=matrix[0,x]+matrix[y,x];
    end;
    write(matrix[0,x]:7:2,'³');
  end;
  tottraf:=0;
  for x:=1 to nn do tottraf:=tottraf+matrix[0,x];
  writeln(tottraf:7:2,'³');
    write('ÀÄÄÄÄÄ');
  for x:=1 to nn+1 do write('ÁÄÄÄÄÄÄÄ');
  writeln('Ù');
  readkey;
end;

procedure makestar(nn,chosen:integer);
var x,y:word;
    total:real;
    tottraf:real;
    tanno:integer;
begin
  for x:= 1 to nn do tandems[x]:=false;
  tandems[chosen div 1000]:=true;
  tandems[(chosen div 100)mod 10]:=true;
  tandems[(chosen div 10)mod 10]:=true;
  tandems[chosen mod 10]:=true;
  for tanno:=1 to nn do
    if tandems[tanno] then
    begin
      writeln;
      writeln('S T A R');
      write('ÚÄÄÄÄÄ');
      for x:=1 to nn+1 do write('ÂÄÄÄÄÄÄÄ');
      writeln('¿');
      write('³     ');
      for x:=1 to nn do write('³  CO',x,'  ');
      writeln('³ TOTAL ³');
      for x:=1 to nn do totmatrix[x]:=0;
      for y:=1 to nn do
      begin
        total:=0;
        write('ÃÄÄÄÄÄ');
        for x:=1 to nn do
        begin
          write('ÅÄÄÄÄÄÄÄ');

       {   total:=total+;}
        end;
          write('ÅÄÄÄÄÄÄÄ');
        writeln('´');
        write('³ CO',y,' ');
        for x:=1 to nn do
        begin
          if (x<>y)and((tanno=x)or(tanno=y))then
          begin
            if tanno=x then
            begin
              total:=total+matrix[y,0];
              totmatrix[x]:=totmatrix[x]+matrix[y,0];
              write('³',matrix[y,0]:7:2)
            end else
            begin
              total:=total+matrix[0,x];
              totmatrix[x]:=totmatrix[x]+matrix[0,x];
              write('³',matrix[0,x]:7:2);
            end;
          end else write('³ ----  ');
        end;
        writeln('³',matrix[y,0]:7:2,'³');
      end;
      write('ÃÄÄÄÄÄ');
      for x:=1 to nn do
      begin
        write('ÅÄÄÄÄÄÄÄ');
{        total:=total+COs[x].lineunits;}
      end;
        write('ÅÄÄÄÄÄÄÄ');
      writeln('´');
      write('³TOTAL³');
      for x:=1 to nn do
      begin
{        for y:=1 to nn do
        begin
          matrix[0,x]:=matrix[0,x]+matrix[y,x];
        end;}
        write({matrix[0,x]}totmatrix[x]:7:2,'³');
      end;
      {tottraf:=0;}
{      for x:=1 to nn do tottraf:=tottraf+matrix[0,x];}
      writeln(tottraf:7:2,'³');
        write('ÀÄÄÄÄÄ');
      for x:=1 to nn+1 do write('ÁÄÄÄÄÄÄÄ');
      writeln('Ù');
      readkey;
    end;
end;

BEGIN
  rectot:=0;
  CLRSCR;
  GOTOXY(18,4);WRITELN('*******************************************');
  GOTOXY(18,5);WRITE('*'); GOTOXY(60,5);WRITELN('*');
  GOTOXY(18,6);WRITELN('*              TELEPHONY                  *');
  GOTOXY(18,7);WRITE('*'); GOTOXY(60,7);WRITELN('*');
  GOTOXY(18,8);WRITE('*'); GOTOXY(60,8);WRITELN('*');
  GOTOXY(18,9);WRITELN('*              ITERATIONS                 *');
  GOTOXY(18,10);WRITE('*'); GOTOXY(60,10);WRITELN('*');
  GOTOXY(18,11);WRITE('*'); GOTOXY(60,11);WRITELN('*');
  GOTOXY(18,12);WRITELN('*             E D I T O R                 *');
  GOTOXY(18,13);WRITE('*'); GOTOXY(60,13);WRITELN('*');
  GOTOXY(18,14);WRITELN('*******************************************');
  GOTOXY(26,25);WRITELN('PRESS ANY KEY FOR MAIN MENU');
  ANS:=READKEY;
  REPEAT
    Z:=0;
    CLRSCR;
    GOTOXY(30,2);WRITELN('********************');
    GOTOXY(30,3);WRITE('*'); GOTOXY(49,3);WRITELN('*');
    GOTOXY(30,4);WRITELN('* M A I N  M E N U *');
    GOTOXY(30,5);WRITE('*'); GOTOXY(49,5);WRITELN('*');
    GOTOXY(30,6);WRITELN('********************');
    GOTOXY(27,9);WRITELN('1.  INPUT DEMANDS');
    GOTOXY(27,11);WRITELN('2.  VIEW');
    GOTOXY(27,15);WRITELN('3.       ');
    GOTOXY(27,17);WRITELN('4.  SAVE');
    GOTOXY(27,19);WRITELN('5.  LOAD');
    GOTOXY(27,21);WRITELN('6.  EXIT');
    GOTOXY(23,25);WRITE('ENTER THE NUMBER OF YOUR CHOICE: ');
    repeat
      val(readkey,Z,code);
    until (z>0)and(z<7);
    IF Z=1 THEN
    BEGIN
      repeat
        CLRSCR;
        GOTOXY(25,12);WRITE(' ENTER NUMBER OF DEMANDS: ');
{$I-}
        READLN(RECNO);
{$I+}
      until ioresult=0;
      begin
        CLRSCR;
        Writeln('CO No.      DEMANDs      LineUnits      Erlangs');
        N:=1;
        WHILE(N<=RECNO)DO
        BEGIN
          Write(' #',N);
          Readint(14,tempint);
          with cos[n] do
          begin
            demands:=tempint;
            demanders[n]:=tempint;
            lineunits:=findlu(demands);
            erlang:=round(100*0.25*lineunits*0.5*0.4)/100;
            gotoxy(1,wherey);
            clreol;
            writeln(' #',N,'        ',demands:8,'       ',lineunits:8,'     ',erlang:8:2);
          end;
          i:=1;
          INC(N);
        END;
        makemesh(recno);
        write('Enter the 4 tandems you''ve chosen -> ');
        readinteger(tandemno);
        makestar(recno,tandemno);
{        readkey;}
      end;
    END else
    if z=4 then
    begin
      CLRSCR;
      GOTOXY(26,13);WRITE(' ENTER FILENAME TO SAVE: ');
      READLN(S);
      if S<>'' then
      BEGIN
        assign(f,s);
        rewrite(f,1);
        blockwrite(f,rectot,2);
        blockwrite(f,directory,60*256);
        close(f);
      END;
    end else
    if z=5 then
    begin
      CLRSCR;
      GOTOXY(26,13);WRITE(' ENTER FILENAME TO LOAD: ');
      READLN(S);
      if S<>'' then
      BEGIN
        assign(f,s);
        reset(f,1);
        blockread(f,rectot,2);
        blockread(f,directory,60*256);
        close(f);
      END;
    end;
  UNTIL Z=6;
END.



