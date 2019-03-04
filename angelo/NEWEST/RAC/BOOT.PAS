uses crt,dos;
var
  p:pointer;
  myseg,myofs:word;
  regs:registers;
  f:file;
begin
  getmem(p,512);
  myseg:=seg(p^);
  myofs:=ofs(p^);
  regs.ah:=2;{function}
  regs.al:=1;{# of sectors}
  regs.ch:=0;{track}
  regs.cl:=1;{sector}
  regs.dh:=0;{head}
  regs.dl:=0;{drive}
  regs.es:=myseg;
  regs.bx:=myofs;
  intr($13,regs);
  assign(f,'bootsec.com');
  rewrite(f,1);
  blockwrite(f,p^,512);
  close(f);

end.