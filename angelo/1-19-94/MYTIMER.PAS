unit mytimer;
interface
uses dos;
var
  h,m,s,s100:word;
  startclock,stopclock,dt:real;
procedure clockon;
procedure clockoff;
implementation

procedure clockon;
begin
  gettime(h,m,s,s100);
  startclock:=h*3600+m*60+s+s100/100;
end;
procedure clockoff;
begin
  gettime(h,m,s,s100);
  stopclock:=h*3600+m*60+s+s100/100;
  dt:=stopclock-startclock;
end;
end.