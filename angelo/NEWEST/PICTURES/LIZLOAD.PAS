uses crt,vgaliza3,rolfazil;
var
  p:pointer;
begin
  getmem(p,65530);
  aload('wall.liz',p^);
  vgamode(1);
  uncompress(p^,ptr($a000,0)^);
  move(ptr($a000,0)^,p^,64000);
  asave('wall.all',p^,64000);
  readkey;
end.