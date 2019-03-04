unit keyboard;
interface
uses crt;
var
  segg, ofss, oldo, olds        :word;
  key, lkey, rkey               :byte;
  mykey,mykey2                  :array[0..255]of byte;
  installed                     :boolean;
  repeatcount                   :word;
  freshkeys,freshrelease,contkey:byte;
  dumbyte,dumbyte2              :byte;
  passcount                     :byte;
  beepon                        :boolean;

procedure gotomyint9;
procedure goaway;
function myreadkey:byte;
function untouchkey:byte;
function mykeypressed:boolean;
function tot_keys:byte;
function up   :boolean;
function down :boolean;
function left :boolean;
function right:boolean;
function pgup :boolean;
function pgdn :boolean;
function home :boolean;
function last :boolean;
function esc  :boolean;
function tab  :boolean;
function space:boolean;
function enter:boolean;

implementation

procedure refresh;
begin
  for dumbyte:=1 to 127 do mykey2[dumbyte]:=mykey[dumbyte];
end;

procedure gotomyint9;
begin
  if not(installed)then
  begin
    oldo:=memw[0:36];
    olds:=memw[0:38];
    asm
          jmp  @mover
      @a:
          sti
          pusha
          in   al,60h
          push ax
          in   al,61h
          mov  ah,al
          or   al,80h
          out  61h,al
          xchg ah,al
          out  61h,al
          pop  ax
{          inc  passcount           {}
          xor  ah,ah
          cmp  al,80h
          jae  @released


          mov  contkey,0           {}
          cmp  al,lkey              {}
          je   @realcont           {}
          mov  contkey,255         {}
      @realcont:                    {}
          mov  key,al
          mov  lkey,al
          mov  bx,ax
          mov  byte(mykey[bx]),al
          mov  byte(mykey2[bx]),al
          jmp  @ending
      @released:
          mov  rkey,al             {}
{          mov  freshrelease,255    {}
          and  al,7fh
          mov  bx,ax
          mov  byte(mykey[bx]),0
          mov  byte(mykey2[bx]),0
      @ending:
          call refresh
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
  while key=0 do;
  myreadkey:=key;
  key:=0;
end;{myreadkey}

function untouchkey:byte;
begin
  untouchkey:=key;
  key:=0;
end;{myreadkey}

function mykeypressed:boolean;
var a,b:byte;
begin
  if key>0 then mykeypressed:=true else mykeypressed:=false;
end;{mykeypressed}

function tot_keys:byte;
begin
  dumbyte2:=0;
  for dumbyte:=0 to 127 do
  begin
    if mykey[dumbyte]<>0 then inc(dumbyte2);
  end;
  tot_keys:=dumbyte2;
end;

function up   :boolean;begin if mykey2[$48]<>0 then begin up   :=true;mykey2[$48]:=0 end else up   :=false;end;
function down :boolean;begin if mykey2[$50]<>0 then begin down :=true;mykey2[$50]:=0 end else down :=false;end;
function left :boolean;begin if mykey2[$4b]<>0 then begin left :=true;mykey2[$4b]:=0 end else left :=false;end;
function right:boolean;begin if mykey2[$4d]<>0 then begin right:=true;mykey2[$4d]:=0 end else right:=false;end;
function pgup :boolean;begin if mykey2[$49]<>0 then begin pgup :=true;mykey2[$49]:=0 end else pgup :=false;end;
function pgdn :boolean;begin if mykey2[$51]<>0 then begin pgdn :=true;mykey2[$51]:=0 end else pgdn :=false;end;
function home :boolean;begin if mykey2[$47]<>0 then begin home :=true;mykey2[$47]:=0 end else home :=false;end;
function last :boolean;begin if mykey2[$4f]<>0 then begin last :=true;mykey2[$4f]:=0 end else last :=false;end;
function esc  :boolean;begin if mykey2[$01]<>0 then begin esc  :=true;mykey2[$01]:=0 end else esc  :=false;end;
function tab  :boolean;begin if mykey2[$0f]<>0 then begin tab  :=true;mykey2[$0f]:=0 end else tab  :=false;end;
function space:boolean;begin if mykey2[$39]<>0 then begin space:=true;mykey2[$39]:=0 end else space:=false;end;
function enter:boolean;begin if mykey2[$1c]<>0 then begin enter:=true;mykey2[$1c]:=0 end else enter:=false;end;




begin
  installed:=false;
  for key:=255 downto 0 do mykey[key]:=0;
  key:=0;
  beepon:=false;
end.