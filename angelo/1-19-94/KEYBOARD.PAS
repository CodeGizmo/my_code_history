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
var passed:byte;

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
          cli
          mov  al,20h
          out  20h,al
          cmp  passed,0
          ja   @wait
          mov  passed,1
          call refresh
          mov  passed,0
      @wait:
{          sti}
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
 ��������������������������������������������������������������������������������������������������������6����A����A����A����A����A���B�(��B�(��B� G 	                   specify1:$DF ;
                                      specify2: 02 ;
                                     motor_off:$25 ;
                              bytes_per_sector: 02 ;
                              sector_per_track: 15 ;
                                    gap_length:$1B ;
                                   data_length:$FF ;
                                    gap_format:$54 ;
                                     fill_byte:$F6 ;
                              head_settle_time:$0F ;
                                   motor_start: 08
                              );
                              mem4090:{15} _500kbs+known_media+k1200in1200;
                              media_desc:$F9;
                              interleave:1
                             ),

                            { 720 }
                             (table:
                              (
                                      specify1:$DF ;
                                      specify2: 02 ;
                                     motor_off:$25 ;
                              bytes_per_sector: 02 ;
                              sector_per_track: 09 ;
                                    gap_length:$2A ;
                       M  �       data_length:$FF ;
                                    gap_format:$50 ;
                                     fill_byte:$F6 ;
                              head_settle_time:$0F ;
                                   motor_start: 08
                              );
                              mem4090:{97}_250kbs+known_media+k720or1440;
                              media_desc:$F9;
                              interleave:1
                             ),

                ;begin if mykey2[$1c]<>0 then begin enter:=true;mykey2[$1c]:=0 end else enter:=false;end;




begin
  installed:=false;
  for key:=255 downto 0 do mykey[key]:=0;
  key:=0;
  beepon:=false;
end.