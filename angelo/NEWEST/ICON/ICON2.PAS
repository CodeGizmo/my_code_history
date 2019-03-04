uses dos,crt,rolfazil,vgaliza3;
var
  fin,fout,f                    :file;
  dinfo                         :searchrec;
  s,filename                    :string;
  fsize                         :word;
  p,p1                          :pointer;
  ptrpos,a,b,c,d,x,y            :word;
  lx,ly                         :integer;
  red,grn,blu                   :array[0..255]of byte;
  aa,bb,cc,dd                   :byte;


type myptr=array[0..65500]of byte;

{procedure defchar(ch:byte;bitno:word;bit:byte);
begin
  orer:=bitno and 7;
  charpos:=ch*charsize

end;}

begin
  vgamode(3);
  framein(0,201,99,399,18,10,31,29,27);
  windin;
  for x:=winx1 to winx2 do
    for y:=winy1 to winy2 do
    begin
      yeyan(x,y,((x*y+y*y+x*x)mod(256-32))+32);
    end;
  framein(0,0,99,199,18,10,31,29,27);
  windin;
  for x:=winx1 to winx2 do
    for y:=winy1 to winy2 do
    begin
      yeyan(x,y,((x*x-y*y)mod (256-32))+32);
    end;
  textxy(10,18);putstring('Hi! How are you?'#13'Im Angelo Lanuza');
  framein(101,0,319,399,18,10,31,29,27);
  windin;
  filename:='rolfazil.bak';
  assign(f,filename);
  reset(f,1);
  fsize:=filesize(f);
  getmem(p,65535);
  blockread(f,p^,fsize);
  close(f);
  for ptrpos:=0 to fsize do
  begin
    putchar(myptr(p^)[ptrpos]);
{    delay(10);}
  end;
  for aa:=0 to 255 do mygetdac(aa,red[aa],grn[aa],blu[aa]);
  while not keypressed do
  begin
    inc(bb);
    for aa:=32 to 255 do
    begin
      if aa and 63=63 then retr;
      myup(aa,red[aa+bb],grn[aa+bb],blu[aa+bb]);
    end;
  end;
  readkey;
end.