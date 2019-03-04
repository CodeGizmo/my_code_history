unit mouse2;
interface
var l,m,r,ll,lm,lr              :boolean;
    bot,lbot,botcount,lbotcount :byte;
    mybot                       :array[0..255]of byte;
    cancel                      :boolean;
    mouseon,mouseinstalled      :boolean;
    miceres                     :byte;
    maxmicex,maxmicey           :word;
    xmic,ymic,lxmic,lymic   :integer;

procedure initmouse;
procedure giveme;
procedure setmiceres(x,y:word;res:byte);
procedure addmousemove(var lxmic,lymic,xmic,ymic:integer);

implementation

procedure initmouse;
var result:byte;
begin
  asm
    mov  ax,0
    int  33h
    mov  result,ah
  end;
  mouseinstalled:=0<>result;
  xmic:=0;ymic:=0;
  maxmicex:=319;
  maxmicey:=199;
  mouseon:=true
end;

procedure giveme;
begin
  if mouseon and mouseinstalled then
  begin
    if bot=0 then botcount:=0;
    lbot:=bot;
    ll:=l;lm:=m;lr:=r;
    asm
      mov  ax,3
      int  33h
      mov  bot,bl
    end;
    l:=bot and 1=1;
    r:=bot and 2=2;
    m:=bot and 4=4;

    if (lbot<>bot)and(botcount<250)then
    begin
      if (ll<>l)and l then
      begin
        inc(botcount);
        mybot[botcount]:=1;
      end;
      if (lm<>m)and m then
      begin
        inc(botcount);
        mybot[botcount]:=2;
      end;
      if (lr<>r)and r then
      begin
        inc(botcount);
        mybot[botcount]:=3;
      end;

      if (bot=0)and(lr=true)then cancel:=true else cancel:=false;
    end;
  end;
end;

procedure setmiceres(x,y:word;res:byte);
begin
  miceres:=res;
  maxmicex:=x*miceres;
  maxmicey:=y*miceres;
end;

procedure addmousemove(var lxmic,lymic,xmic,ymic:integer);
var x,y:integer;
begin
  if mouseon and mouseinstalled then
  begin
    lxmic:=xmic;lymic:=ymic;
    x:=xmic;y:=ymic;
    asm
      mov  ax,0bh
      int  33h
      add  x,cx
      add  y,dx
      mov  ax,maxmicex
      cmp  x,ax
      jle  @a1
      mov  x,ax
      jmp  @a2
  @a1:cmp  x,0
      jge  @a2
      mov  x,0
  @a2:mov  ax,maxmicey
      cmp  y,ax
      jle  @a3
      mov  y,ax
      jmp  @a4
  @a3:cmp  y,0
      jge  @a4
      mov  y,0
  @a4:
    end;
    xmic:=x; ymic:=y;
  end;
end;{addmousemove}
begin
  mouseon:=false;
  setmiceres(319,199,1);
  initmouse;
end.