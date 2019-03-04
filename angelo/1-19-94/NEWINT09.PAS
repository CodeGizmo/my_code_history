unit newint09;
interface
uses crt;
var
  segg,ofss,oldo,olds           :word;
  key,rkey,bkey                 :byte;
  mykey                         :array[0..255]of byte;
  installed                     :boolean;
  repeatcount                   :word;
  freshkeys,freshrelease,contkey:byte;
  dumbyte,dumbyte2              :byte;
  passcount                     :byte;
  beepon                        :boolean;

procedure gotomyint9;
procedure goaway;
function myreadkey:byte;
function mykeyprepointer;{{{{{{{{{{{{}
  red,grn,blu                   :array[0..255]of byte;
  enter                         :boolean;
  centeron                      :boolean;

procedure showpos;
begin
  case yeyan_method of
    0:begin
        if centeron then
        begin
          yeymode:=1;
          line(x,y,x,maxy,c);
          line(x,y,maxx,y,c);
          line(x,y,minx,y,c);
          line(x,y,x,miny,c);
          yeymode:=0;
        end;

        d2:=yeyun(x,y);
        for d1:=0 to 255 do
        begin
          yeyan(x,y,d1);
        end;
        yeyan(x,y,d2);
      end;
    1:begin
        if centeron then
        begin
          yeymode:=1;
          line(x,y,x,maxy,c);
          line(x,y,maxx,y,c);
          line(x,y,minx,y,c);
          line(x,y,x,miny,c);
          yeymode:=0;
        end;
        yeymode:=1;
        line(x,y,lx,ly,c);
        yeymode:=0;
      end;
    2:begin
        yeymode:=1;
        oval(lx,ly,x,y,c);
          line(x,y,x,y+5,c);
          @released:
          mov  bkey,al
          mov  freshrelease,255
          and  al,7fh
          mov  bx,ax
          mov  byte(mykey[bx]),0
      @ending:
          cli
          mov  al,20h
          out  20h,al
          popa
          iret
      @mover:
          mov  ax,seg(@a)
          mov  cx,offset(@a);
          mov  segg,ax
          mov  ofss,cx
    end;
    asm
      cli
    end;
    memw[0:36]:=ofss;
    memw[0:38]:=segg;
    asm
      sti
    end;
    installed:=true;
  end;
  key:=0;
end;{gotomyint9}

procedure goaway;
begin
  if installed then
  begin
    asm
      cli
    end;
    memw[0:36]:=oldo;
    memw[0:38]:=olds;
    asm
      sti
    end;
    installed:=false;
  end;
end;{goaway}

function myreadkey:byte;
begin
  repeat if beepon then beep until(rkey>0);
  myreadkey:=rkey;
  rkey:=0;
end;{myreadkey}

function mykeypressed:boolean;
var a,b:byte;
begin
  if rkey>0 then mykeypressed:=true else mykeypressed:=false;
end;{mykeypressed}

function cont:boolean;
begin
  if contkey=0 then cont:=true else cont:=false;
end;{cont}

function freshkey:boolean;
begin
  if freshkeys>0 then begin freshkey:=true;freshkeys:=0 end else freshkey:=false;
end;{freshkey}

function tot_keys:byte;
begin
  dumbyte2:=0;
  for dumbyte:=0 to 127 do
  begin
    if mykey[dumbyte]<>0 then inc(dumbyte2);
  end;
  tot_keys:=dumbyte2;
end;

begin
  installed:=false;
  for key:=255 downto 0 do mykey[key]:=0;
  rkey:=0;
  beepon:=false;
end.