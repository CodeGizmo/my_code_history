uses crt,dos;
var
  f                     :file;
  s                     :string;
  tsize,x,size          :longint;
  pos                   :word;
  p,p1,p2,p3,p4,p5,p6     :pointer;
  run,pat,upto          :byte;
  h1,h2,h3,hd,
  m1,m2,m3,md,
  s1,s2,s3,sd,s100      :word;
  tt1,tt2,ttd,tt3       :longint;
  pass:word;

type
  myptr=array[0..65000]of byte;
begin
  clrscr;
  s:='e:\Angelo.al2';
  getmem(p,65535);
{  getmem(p1,32768);
  getmem(p2,32768);
  getmem(p3,32768);
  getmem(p4,32768);
  getmem(p5,32768);
  getmem(p6,32768);}
  for pos:=0 to 65534 do
  begin
    myptr(p^)[pos]:=random(256);
{    myptr(p1^)[pos]:=$55;
    myptr(p2^)[pos]:=$aa;
    myptr(p3^)[pos]:=$33;
    myptr(p4^)[pos]:=$66;
    myptr(p3^)[pos]:=$cc;
    myptr(p4^)[pos]:=$99;}
  end;
  assign(f,s);
  rewrite(f,1);
  x:=0;
  size:=0;
  tsize:=diskfree(5);
  gettime(h1,m1,s1,s100);
  tt1:=longint(h1)*3600+m1*60+s1;
  repeat
      {seek(f,x);
      blockwrite(f,p1^,32768);
      gotoxy(1,2);write('pattern: 5, run ',run);
      seek(f,x);
      blockwrite(f,p2^,32768);
      gotoxy(1,2);write('pattern: 6, run ',run);}
    for run:=1 to 1 do
    begin
{      seek(f,x);  }
      blockwrite(f,p^,65535);
      gotoxy(1,2);write('pattern: 1, run ',run);
{      seek(f,x);
      blockwrite(f,p4^,32768);
      gotoxy(1,2);write('pattern: 2, run ',run);
      seek(f,x);
      blockwrite(f,p5^,32768);
      gotoxy(1,2);write('pattern: 3, run ',run);
      seek(f,x);
      blockwrite(f,p6^,32768);
      gotoxy(1,2);write('pattern: 4, run ',run);}
    end;
    x:=filesize(f);
    size:=filesize(f);
    gotoxy(1,1);write('current size is: ',size:10,',  total size: ',tsize:10);
    gotoxy(1,3);write('percent completed: ',(x*100/tsize):3:3,'%');
    gotoxy(1,5);write('          starting time -> ',h1:2,':',m1:2,':',s1:2);
    gettime(h2,m2,s2,s100);
    tt2:=longint(h2)*3600+m2*60+s2;
    ttd:=tt2-tt1;
    tt3:=tsize*ttd;
    tt3:=tt3 div x+tt1;
    h3:=tt3 div 3600;
    tt3:=tt3 mod 3600;
    m3:=tt3 div 60;
    s3:=tt3 mod 60;
    gotoxy(1,6);write('           current time -> ',h2:2,':',m2:2,':',s2:2);
    inc(pass);
    if pass and 7 = 7 then
    begin
      gotoxy(1,7);
      write('expected time to finish -> ',h3:2,':',m3:2,':',s3:2);
      gotoxy(1,8);
      write('transfer rate -> ',x div (ttd+1):6);
    end;
  until (size+65535>tsize{4000000})or(keypressed and (readkey=#27));
  close(f);
end.