uses vgaliza3,crt;
var p:pointer;
    f,f2:file;
    l:longint;
    x,y,d1:word;
    a,b:longint;
    s:string;
    d:byte;
begin
  getmem(p,65535);
  assign(f,'pictures\toprint2.tif');
  reset(f,1);
  l:=filesize(f)-64000-64000;
  seek(f,l);
  vgamode(1);
{  uncompress(p^,ptr($a000,0)^);}

            s:='pictures\logs.all';
            assign(f2,s);
            reset(f2,1);
            blockread(f2,d,1);
            if d in[2,3]then
            begin
              blockread(f2,p^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+0]:=mem[seg(p^):ofs(p^)+d1];
              blockread(f2,p^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+1]:=mem[seg(p^):ofs(p^)+d1];
              blockread(f2,p^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+2]:=mem[seg(p^):ofs(p^)+d1];
              blockread(f2,p^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+3]:=mem[seg(p^):ofs(p^)+d1];
            end;
            close(f2);
  move(ptr($a000,0)^,p^,64000);
  frame(10,10,309,189,8,8,29,27,25);
  gseg:=seg(p^);
  gofs:=ofs(p^);
  for x:=0 to 299 do
    for y:=0 to 189{179} do
    begin
{      a:=trunc((x/299)*319);}
      b:=y*199;
      yeyan(x+10,y+10,yeyun(x+5,b div 189));
    end;
  move(ptr($a000,0)^,p^,64000);
  blockwrite(f,p^,64000);
            s:='pictures\logs.all';
            assign(f2,s);
            reset(f2,1);
            blockread(f2,d,1);
            if d in[2,3]then
            begin
              blockread(f2,p^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+0]:=mem[seg(p^):ofs(p^)+d1+16000];
              blockread(f2,p^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+1]:=mem[seg(p^):ofs(p^)+d1+16000];
              blockread(f2,p^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+2]:=mem[seg(p^):ofs(p^)+d1+16000];
              blockread(f2,p^,32000);
              for d1:=16385 downto 0 do mem[$a000:(d1 shl 2)+3]:=mem[seg(p^):ofs(p^)+d1+16000];
            end;
            close(f2);
  move(ptr($a000,0)^,p^,64000);
  frame(10,10,309,189,8,8,29,27,25);
  gseg:=seg(p^);
  gofs:=ofs(p^);
  for x:=0 to 299 do
    for y:=0 to 189{179} do
    begin
{      a:=trunc((x/299)*319);}
      b:=y*199;
      yeyan(x+10,y,yeyun(x+5,b div 189));
    end;
  move(ptr($a000,0)^,p^,64000);
  blockwrite(f,p^,64000);
  close(f);
  readkey;
end.