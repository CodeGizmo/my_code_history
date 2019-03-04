uses vgaliz,crt;
var
  a,b,c,d,e,f,g,h,i:integer;
  la,lb,lc,ld,le,lf,lg,lh,li:integer;
begin
  a:=0;b:=0;c:=319;d:=319;e:=0;f:=199;g:=0;h:=199;
  vgamode(1);
  repeat
    i:=15{random(256)};
    la:=a;lb:=b;lc:=c;ld:=d;
    le:=e;lf:=f;lg:=g;lh:=h;
    a:=a+random(9)-4;
    b:=b+random(9)-4;
    c:=c+random(9)-4;
    d:=d+random(9)-4;
    e:=e+random(9)-4;
    f:=f+random(9)-4;
    g:=g+random(9)-4;
    h:=h+random(9)-4;
    if a<0 then a:=0;
    if b<0 then b:=0;
    if c<0 then c:=0;
    if d<0 then d:=0;
    if e<0 then e:=0;
    if f<0 then f:=0;
    if g<0 then g:=0;
    if h<0 then h:=0;

    if a>319 then a:=319;
    if b>319 then b:=319;
    if c>319 then c:=319;
    if d>319 then d:=319;

    if e>199 then e:=199;
    if f>199 then f:=199;
    if g>199 then g:=199;
    if h>199 then h:=199;
    line(la,le,lb,lf,0);
    line(la,le,lc,lg,0);
    line(la,le,ld,lh,0);
    line(lc,lg,lb,lf,0);
    line(ld,lh,lb,lf,0);
    line(ld,lh,lc,lg,0);
    retr;retr;
    line(a,e,b,f,i);
    line(a,e,c,g,i);
    line(a,e,d,h,i);
    line(c,g,b,f,i);
    line(d,h,b,f,i);
    line(d,h,c,g,i);

  until keypressed;
end.