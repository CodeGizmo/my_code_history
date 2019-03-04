Program HUFFMAN_COMPRESSOR_DECOMPRESSOR;
uses crt,dos;
var
  x,y:integer;
  ch:char;
  quit:boolean;

type
  mybyteptr=array[0..1]of byte;
  mywordptr=array[0..1]of word;

function fileexist(filename:string):boolean;
var
  DirInfo: SearchRec;
begin
  fileexist:=false;
  FindFirst(Filename, Archive, DirInfo);
  if Doserror=0 then fileexist:=true;
end;

function countfile(filename:string):integer;
var
  DirInfo: SearchRec;
  count:integer;
begin
  count:=0;
  FindFirst(Filename, Archive, DirInfo);
  while DosError = 0 do
  begin
    inc(count);
    FindNext(DirInfo);
  end;
  countfile:=count;
end;


procedure choose(filename:string;var buf);
{buf=no. of filenames:word,max no. of filenames:word}
begin

end;

begin
  ch:=' ';
  repeat
    clrscr;
    if ch=#13 then write(fileexist('*.*'),' ',countfile('*.*'));
    if ch=#27 then quit:=true;
    ch:=readkey;
  until quit;
end.