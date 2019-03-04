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
  vgamode(2);
  framein(0,201,99,399,18,10,31,29,27);
  windin;
  for x:=winx1 to winx2 do
    for y:=winy1 to winy2 do
    begin
      yeyan(x,y,x mod 128{((x*y+y*y+x*x)mod (144-32))+32});
    end;
  framein(0,0,99,199,18,10,31,29,27);
  windin;
  for x:=winx1 to winx2 do
    for y:=winy1 to winy2 do
    begin
      yeyan(x,y,(y mod 128)+128{((x*x-y*y)mod (144-32))+32+144});
    end;
  textxy(10,18);putstring('Hi! How are you?'#13'Im Angelo Lanuza');
  framein(101,0,319,399,18,10,31,29,27);
  windin;
  filename:='icon.bak';
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
  getmem(p1,5000);
  bb:=0;
  window(111,18,319-10,399-18);
  x:=winx1;
  y:=winy1;
  lx:=x;
  ly:=y;
  for aa:=0 to 255 do mygetdac(aa,red[aa],grn[aa],blu[aa]);
  getthis(x,y,x+22,y+22,p1^);
  lx:=9;
  ly:=9;
  ptrpos:=0;
  while not keypressed do
  begin
    inc(bb);
    for aa:=32 to 255 do
    begin
      if aa and 63=63 then retr;
      myup(aa,red[aa+bb],grn[aa+bb],blu[aa+bb]);
    end;
    putthis(x,y,p1^,0);
    x:=x+lx;
    y:=y+ly;
    if x+22>winx2 then
    begin
      repeat
        x:=winx2-22;
        lx:=random(19)-9;
{        ly:=random(19)-9;}
      until (lx<>0)or(ly<>0);
    end else if x<winx1 then
    begin
      repeat
        x:=winx1;
        lx:=random(19)-9;
{        ly:=random(19)-9;}
      until (lx<>0)or(ly<>0);
    end;
    if y+22>winy2 then
    begin
      repeat
        y:=winy2-22;
{        lx:=random(19)-9;}
        ly:=random(19)-9;
      until (lx<>0)or(ly<>0);
    end else if y<winy1 then
    begin
      repeat
        y:=winy1;
{        lx:=random(19)-9;}
        ly:=random(19)-9;
      until (lx<>0)or(ly<>0);
    end;
    putchar(myptr(p^)[ptrpos]);
    inc(ptrpos);
    if ptrpos>=fsize then ptrpos:=0;
    getthis(x,y,x+22,y+22,p1^);
    sphere(x+11,y+11,10,random(256));
  end;
  readkey;
end.