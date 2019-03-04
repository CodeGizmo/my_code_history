uses crt,dos;
var
  d1,d2,d3,d4                :word;
  p                          :pointer;
  f                          :file;
  filename                   :string;
  sorted                     :array[0..255]of byte;
  weights                    :array[0..511]of word;
  size,x,y                   :word;
  ch                         :char;

type
  myptr=^mypointer;
  mypointer=array[0..65530]of byte;

procedure loadfirst(filename:string;var buf);
begin
  {$I-}
  assign(f,filen    d3:=sorted[max];
    sorted[max]:=sorted[d1];
    sorted[d1]:=d3;
  end;
end;{sort}

var
  bitsofbyte    :array[0..255]of byte;
  branch        :array[256..511,0..1]of word;
  branchbits    :array[0..511]of byte;
  ready         :array[0..511]of boolean;

procedure testhuffman;
begin
  for d1:=0 to 255 do
    if weights[sorted[d1]]>0 then ready[d1]:=true else ready[d1]:=false;
  for d1:=256 to 511  do ready[d1]:=false;

end;

procedure my2;
begin
  clrscr;
  getmem(p,6do
  begin
    max:=d1;
    for d2:=d1 to 255 do
    begin
      if weights[sorted[max]]<weights[sorted[d2]]then
      begin
        max:=d2;
      end;
    end;
    d3:=sorted[max];
    sorted[max]:=sorted[d1];
    sorted[d1]:=d3;
  end;
end;{sort}

procedure sortmin;
var max:byte;
begin
  for d1:=0 to 255 do
  begin
    max:=d1;
    for d2:=d1 to 255 do
    begin
      if weights[sorted[max]]>weights[sorted[d2]]then
      begin
        max:=d2;
      end;
    end;
    d3:=sorted[max];
    sorted[max]:=sorted[d1];
    sorted[d1]:=d3;
  end;
end;{sort}

var
  bitsofbyte    :array[0..255]of byte;
  branch        :array[256..511,0..1]of word;
  branchbits    :array[0..511]of byte;
  ready         :array[0..511]of boolean;

procedure testhuffman;
begin
  for d1:=0 to 255 do
    if weights[sorted[d1]]>0 then ready[d1]:=true else ready[d1]:=false;
  for d1:=256 to 511  do ready[d1]:=false;

end;

procedure my2;
begin
  clrscr;
  getmem(p,65535);
  assign(f,'huffman0.pas');
  reset(f,1);
  blockread(f,p^,filesize(f));
  for d1:=0 to 1999 do
  begin
    mem[$b800:d1 shl 1]:=mypointer(p^)[d1];
  end;

  ch:=readkey;
  writeln('Current position is ',filepos(f));
  ch:=readkey;
  seek(f,500);
  blockwrite(f,mypointer(p^)[1500],500);
  writeln('Current position is ',filepos(f));
  seek(f,0);
  blockread(f,p^,filesize(f));
  ch:=readkey;
  for d1:=0 to 1999 do
  begin
    mem[$b800:d1 shl 1]:=mypointer(p^)[d1];
  end;
  close(f);
  ch:=readkey;
  freemem(p,65535);
end;

begin
  my2;
{  clrscr;
  getmem(p,65535);
  loadfirst('newdraw7.exe',p^);
  clearweights;
  if ioresult=0 then
  begin
    getweights(p^);
    sortmax;
    repeat
      ch:=readkey;
      case ch of
        'f':for x:=0 to 127 do
            begin
              gotoxy((x div  25)*10+1,(x mod 25)+1);
              write(x:3,':',weights[x]:5);
            end;
        's':begin
              for x:=0 to 127 do
              begin
                gotoxy((x div  25)*10+1,(x mod 25)+1);
                write((x+128):3,':',weights[x+128]:5);
              end;
              gotoxy(65,25);write('size is ',size:5);
            end;
        'x':for x:=0 to 127 do
            begin
              gotoxy((x div  25)*10+1,(x mod 25)+1);
              write(sorted[x]:3,':',weights[sorted[x]]:5);
            end;
        'y':begin
              for x:=0 to 127 do
              begin
                gotoxy((x div  25)*10+1,(x mod 25)+1);
                write((sorted[x+128]):3,':',weights[sorted[x+128]]:5);
              end;
            end;
        'a':sortmin;
        'b':sortmax;
      end;
    until ch=#27;
  end else writeln('Error reading');
  freemem(p,65535);}
end.