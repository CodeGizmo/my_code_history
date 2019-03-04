program graphics_letter_editor;
uses crt,dos,vgaliza2,mouse;
var
  x,y,lx,ly,lastx,lasty,winx1,winx2,winy1,winy2:word;
  ch:char;
  exit:boolean;

procedure initmoves;
begin
  winx1:=0;
  winy1:=0;
  winx2:=319;
  winy2:=399;
  x:=(winx1+winx2)shr 1;
  lx:=x;
  y:=(winy1+winy2)shr 1;
  ly:=y;
end;{initmoves}

procedure getmoves;
begin
  if ch in[#71,#72,#73]then dec(y)else
  if ch in[#79,#80,#81]then inc(y);
  if ch in[#71,#75,#79]then dec(x)else
  if ch in[#73,#77,#81]then inc(x);
end;{getmoves}

procedure checkbounds;
begin
  if x>winx2 then x:=winx2 else
  if x<winx1 then x:=winx1;
  if y>winy2 then y:=winy2 else
  if y<winy1 then y:=winy1;
end;{checkbounds}

procedure obeyspecial;
begin
  giveme;
  if l then
  begin
    yeymode:=0;
    line(lastx,lasty,x,y,15);
    yeymode:=1;
  end;

end;{obeyspecial}

procedure initialize;
begin
  initmoves;
  initmouse;
  setmiceres(319,399,1);
  xmic:=x;
  ymic:=y;
  vgamode(3);
  yeymode:=1;
  line(x     ,winy1 ,x     ,winy2 ,0);
  line(winx1 ,y     ,winx2 ,y     ,0);
      line(x ,y ,winx1,winy1,0);
      line(x ,y ,winx1,winy2,0);
      line(x ,y ,winx2,winy1,0);
      line(x ,y ,winx2,winy2,0);
      ellipse(x,y,10,20,0);
end;{initialize}

begin
  initialize;
  repeat
    if keypressed then
    begin
      ch:=readkey;
      case ch of
        #0:begin
             ch:=readkey;
             getmoves;
           end;
        #27:begin
              exit:=true;
            end;
      end;
    end;
    xmic:=x; ymic:=y;
    addmousemove;
    x:=xmic; y:=ymic;
    checkbounds;

    if(lx<>x)or(ly<>y)then
    begin
      line(lx,ly,winx1,winy1,0);
      line(lx,ly,winx1,winy2,0);
      line(lx,ly,winx2,winy1,0);
      line(lx,ly,winx2,winy2,0);
      ellipse(lx,ly,10,20,0);
      line(lx    ,winy1 ,lx    ,winy2 ,0);
      line(winx1 ,ly    ,winx2 ,ly    ,0);

    end;

      obeyspecial;
      if m or l then begin lastx:=x; lasty:=y; end;

    if(lx<>x)or(ly<>y)then
    begin
      line(x ,y ,winx1,winy1,0);
      line(x ,y ,winx1,winy2,0);
      line(x ,y ,winx2,winy1,0);
      line(x ,y ,winx2,winy2,0);
      ellipse(x,y,10,20,0);
      line(x     ,winy1 ,x     ,winy2 ,0);
      line(winx1 ,y     ,winx2 ,y     ,0);
    end;

    lx:=x; ly:=y;
  until exit or r;
end.