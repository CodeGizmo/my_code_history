uses crt,dos;
var
  size:word;
procedure aload(filename:string;var buf);
var
  f:file;
begin
  assign(f,filename);
  reset(f,1);
  size:=filesize(f);
  blockread(f,buf,filesize(f));
  close(f);
end;{aload}

procedure asave(filename:string;var buf);
var
  f:file;
begin
  assign(f,filename);
  rewrite(f,1);
  blockwrite(f,buf,$ffff);
  close(f);
end;{asave}

var
  byt:array[0..255]of word;
  zz:array[0..255]of byte;
  vv:array[0..255]of boolean;
  max:byte;
  a:byte;
  b:word;
procedure sort(filename:string);
begin
  for a:=0 to 255 do
  begin
    byt[a]:=0;
    vv[a]:=true;
  end;
  aload(filename,ptr($a000,0)^);
  for b:=0 to (size-1) do
    inc(byt[mem[$a000:b]]);
  for a:=0 to 255 do
  begin
    b:=0;
    while vv[b]=false do inc(b);
    max:=b;
    for b:=0 to 255 do
      if (byt[max]<byt[b])and(vv[b]) then
      begin
        max:=b;
      end;
    zz[a]:=max;
    vv[max]:=false;
  end;
end;

{procedure
begin
end;}

begin
  sort('d:ahuff.cmp');
  clrscr;
  readln;
  for a:=0 to 127 do
  write(zz[a]:5,':',byt[zz[a]]:4);
  readln;
  clrscr;
  for a:=128 to 255 do
  write(zz[a]:5,':',byt[zz[a]]:4);
  writeln;
  writeln('kk.arj filesize ',size:6);
  readln;
end.












