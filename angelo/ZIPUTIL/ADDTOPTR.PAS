
uses crt;
var p:pointer;
var
  pseg,pofs,bseg,bofs:word;

procedure getadd(var buf);
begin
  bseg:=seg(buf);
  bofs:=ofs(buf);
  p:=@buf;
  pseg:=seg(p^);
  pofs:=ofs(p^);

end;
begin
  getmem(p,20);
  getadd(p^);
  writeln(pseg:6,pofs:6,bseg:6,bofs:6);
  readkey;
end.