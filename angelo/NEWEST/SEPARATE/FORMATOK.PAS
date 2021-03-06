uses  crt,dos;

const _500kbs      =$00;
      _300kbs      =$40;
      _250kbs      =$80;

      double_stepping=$20;
      known_media  =$10;

      {reserve}

      k720or1440  =$07;
      k1200in1200 =$05;
      k360in1200  =$04;
      k360in360   =$03;
      t1200in1200 =$02;
      t360in1200  =$01;
      t360in360   =$00;

type
    Disk_Table=record
                   specify1,
                   specify2,
                   motor_off,
                   bytes_per_sector,
                   sector_per_track,
                   gap_length,
                   data_length,
                   gap_format,
                   fill_byte,
                   head_settle_time,
                   motor_start             :byte;
              end;

     disktype= (
               (* -->  d[disksize]{{s[specialsize]}in[drivesize]}  *)

                d360in360,
                d1200in1200,
                d720,
                d1440,
                d360in1200,

                d360s800in1200,
                d1200s1440,
                d360s420,
                d1200s1400,
                d1440s1600,
                d720s800
               );

     fat_types=(FAT12,FAT16,FAT32);

      romdisktable=array[d360in360..d720s800] of record
                       table:disk_table;
                       mem4090:byte;
                       media_desc:byte;
                       interleave:byte;
                   end;


var   disktable        :^Disk_Table absolute 0:$1e*4;
      sdisktable       :disk_table;
      drive            :byte;
      dt               :byte;

    
const romtable:romdisktable=(

                  (*****    ORDINARY FORMAT     ****)

                            { 360 in 360 }

                             (table:
                              (
                                      specify1:$DF ;
                                      specify2: 02 ;
                                     motor_off:$25 ;
                              bytes_per_sector: 02 ;
                              sector_per_track: 09 ;
                                    gap_length:$2A ;
                                   data_length:$FF ;
                                    gap_format:$50 ;
                                     fill_byte:$F6 ;
                              head_settle_time:$0F ;
                                   motor_start: 08
                              );
                              mem4090:{93}_250kbs+known_media+k360in360;
                              media_desc:$FD;
                              interleave:1
                             ),


                            { 1.2 }
                             (table:
                              (
                                      specify1:$DF ;
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
                                   data_length:$FF ;
                                    gap_format:$50 ;
                                     fill_byte:$F6 ;
                              head_settle_time:$0F ;
                                   motor_start: 08
                              );
                              mem4090:{97}_250kbs+known_media+k720or1440;
                              media_desc:$F9;
                              interleave:1
                             ),

                            { 1.44 }
                             (table:
                              (
                                      specify1:$AF ;
                                      specify2: 02 ;
                                     motor_off:$25 ;
                              bytes_per_sector: 02 ;
                              sector_per_track: 18 ;
                                    gap_length:$1B ;
                                   data_length:$FF ;
                                    gap_format:$6C ;
                                     fill_byte:$F6 ;
                              head_settle_time:$0F ;
                                   motor_start: 08
                              );
                              mem4090:{17}_500kbs+known_media+k720or1440;
                              media_desc:$F0;
                              interleave:1
                             ),

                            { 360 in 1.2}
                             (table:
                              (
                                      specify1:$DF ;
                                      specify2: 02 ;
                                     motor_off:$25 ;
                              bytes_per_sector: 02 ;
                              sector_per_track: 09 ;
                                    gap_length:$2A ;
                                   data_length:$FF ;
                                    gap_format:$50 ;
                                     fill_byte:$F6 ;
                              head_settle_time:$0F ;
                                   motor_start: 08
                              );
                              mem4090:{74}_300kbs+double_stepping+known_media+k360in1200;
                              media_desc:$FD;
                              interleave:1
                             ),


       (*****    SPECIAL FORMAT     ****)

                           { 360 to 800 in 1.2}
                             (table:
                              (
                                      specify1:$DF ;
                                      specify2: 02 ;
                                     motor_off:$25 ;
                              bytes_per_sector: 02 ;
                              sector_per_track: 10 ;
                                    gap_length:$1B {2A} ;
                                   data_length:$FF ;
                                    gap_format:$28 {50} ;
                                     fill_byte:$F6 ;
                              head_settle_time:$0F ;
                                   motor_start: 08
                              );
                              mem4090:{57}_300kbs+known_media+k720or1440;
                              media_desc:$F0;
                              interleave:1
                             ),

                            { 1.2 to 1.44  interleave 2 }
                             (table:
                              (
                                      specify1:$DF ;
                                      specify2: 02 ;
                                     motor_off:$25 ;
                              bytes_per_sector: 02 ;
                              sector_per_track: 18 ;
                                    gap_length:$02 {1B} ;
                                   data_length:$FF ;
                                    gap_format:$02 ;
                                     fill_byte:$F6 ;
                              head_settle_time:$0F ;
                                   motor_start: 08
                              );
                              mem4090:{15} _500kbs+known_media+k1200in1200;
                              media_desc:$F0;
                              interleave:2
                             ),

                            { 360 to 420 in 1.2 interleave 3 }
                             (table:
                              (
                                      specify1:$DF ;
                                      specify2: 02 ;
                                     motor_off:$25 ;
                              bytes_per_sector: 02 ;
                              sector_per_track: 10 ;
                                    gap_length:$1B ;
                                   data_length:$FF ;
                                    gap_format:$1A ;
                                     fill_byte:$F6 ;
                              head_settle_time:$0F ;
                                   motor_start: 08
                              );
                              mem4090:{74}_300kbs+double_stepping+known_media+k360in1200;
                              media_desc:$FD;
                              interleave:3
                             ),

                            { 1200 to 1400 in 1.2 interleave 3 }
                             (table:
                              (
                                      specify1:$DF ;
                                      specify2: 02 ;
                                     motor_off:$25 ;
                              bytes_per_sector: 02 ;
                              sector_per_track: 17 ;
                                    gap_length:$1B ;
                                   data_length:$FF ;
                                    gap_format:$1A ;
                                     fill_byte:$F6 ;
                              head_settle_time:$0F ;
                                   motor_start: 08
                              );
                              mem4090:{15} _500kbs+known_media+k1200in1200;
                              media_desc:$F9;
                              interleave:3
                             ),

                            { 1440 to 1600 in 1.4 interleave 3 }
                             (table:
                              (
                                      specify1:$DF ;
                                      specify2: 02 ;
                                     motor_off:$25 ;
                              bytes_per_sector: 02 ;
                              sector_per_track: 20 ;
                                    gap_length:$1B ;
                                   data_length:$FF ;
                                    gap_format:$0A ;
                                     fill_byte:$F6 ;
                              head_settle_time:$0F ;
                                   motor_start: 08
                              );
                              mem4090:{17}_500kbs+known_media+k720or1440;
                              media_desc:$F0;
                              interleave:3
                             ),

                            { 720 to 800 in 720 interleave 3 }
                             (table:
                              (
                                      specify1:$DF ;
                                      specify2: 02 ;
                                     motor_off:$25 ;
                              bytes_per_sector: 02 ;
                              sector_per_track: 10 ;
                                    gap_length:$1B ;
                                   data_length:$FF ;
                                    gap_format:$1A ;
                                     fill_byte:$F6 ;
                              head_settle_time:$0F ;
                                   motor_start: 08
                              );
                              mem4090:{97}_250kbs+known_media+k720or1440;
                              media_desc:$F9;
                              interleave:3
                             )
                            );

procedure UpdateTable(diskt:disktype);
begin
     mem[$40:$90]:=romtable[diskt].mem4090;
     disktable^:=romtable[diskt].table;
end;

procedure SaveTable;
begin
     dt:=mem[$40:$90];
     sdisktable:=disktable^;
end;

procedure RestoreTable;
begin
     disktable^:=sdisktable;
     mem[$40:$90]:=dt;
end;

procedure format(utracks:byte;udisktype:disktype);
var   x,retries,err    :byte;
      track,head       :byte;
      regs             :registers;
      order            :array[1..25] of byte;
      format_field     :array[1..25,1..4] of byte;
      sectors_total,
      sectors_left     :word;
      percent          :real;
      interleave       :byte;
      sec_no:byte;
      spt:byte;
begin
     spt:=romtable[udisktype].table.sector_per_track;
     interleave:=romtable[udisktype].interleave;

{****   setup ordering of sectors based on interleave value *******}
     begin
       for x:=1 to 25 do
         order[x]:=0;
       sec_no:=0;
       for x:=1 to spt do
       begin
           while (order[sec_no+1]<>0) do
             sec_no:=sec_no+1;
           order[sec_no+1]:=x;
           sec_no:=(sec_no + interleave) mod spt;
       end;
     end;

     for x:=1 to spt do
     begin
          format_field[x,3]:=order[x];
          format_field[x,4]:=disktable^.bytes_Per_sector;
     end;

     with regs do {reset}
     begin
          ah:=0;
          dl:=drive;
          UpdateTable(udisktype);
          intr($13,regs);
     end;

     sectors_total:=utracks*2*spt;
     sectors_left :=sectors_total;
     gotoxy(1,1);
     writeln('T=   0 H=   0');
     percent:=100-(sectors_left/sectors_total)*100;
     write(' Percent completed: ');
     writeln(round(percent):3,' %');

     for track:=0 to utracks-1 do
     begin
          for x:=1 to spt do format_field[x,1]:=track;
          for head:=0 to 1 do
          begin
               for x:=1 to spt do format_field[x,2]:=head;
               retries:=0;
               repeat
                  err:=0;
                  with regs do
                  begin
                       ah:=5;
                       al:=spt;
                       ch:=track;
                       cl:=0{1}{spt};
                       dh:=head;
                       dl:=drive;
                       es:=seg(format_field);
                       bx:=ofs(format_field);
                       UpdateTable(udisktype);
                       intr($13,regs);
                       if (ah<>0) then
                       begin
                            err:=ah;
                            inc(retries);
                            if retries > 3 then
                            begin
                              writeln('(',retries,
                                    ') Error in format: TRACK ',track);
                              readln;
                            end;
                            ah:=0;
                            dl:=drive;
                            UpdateTable(udisktype);
                            intr($13,regs);
                       end;
                  end;{ regs}
               until (err=0) or (retries>3);
               if (retries > 3) then
               begin
                    writeln('Error in track ',track,' head ',head);
               end;
               dec(sectors_left,spt);
               gotoxy(1,1);
               writeln('T= ',track:3,' H= ',head:3);
               percent:=100-(sectors_left/sectors_total)*100;
               write(' Percent completed: ');
               writeln(percent:3:2);
          end; {head}
     end; {track}
end;

type
      Boot_Record=record
                       jump                :byte;{ $E9}
                       offset_jump         :word;
                       OEM_ID              :array[1..8] of char;
                       bytes_per_sector    :word;
                       sectors_per_cluster :byte;
                       sectors_in_reserve  :word;
                       copies_of_FAT       :byte;
                       root_dirs           :word;
                       sectors             :word;
                       media               :byte;
                       sectors_per_FAT     :word;
                       sectors_per_track   :word;
                       heads               :word;
                       hidden_sector       :longint;
                       sectors32           :longint; {if sectors = 0}
                     {extended boot record}
                       drive_              :byte;
                       r1                  :byte;
                       signature           :byte;{29h}
                       serial2,serial1     :word;
                       volume_label        :array[1..11] of char;
                       FILE_system_ID      :array[1..8] of char;
                  end;

      directory = record
                       name     :array[1..8] of char;
                       ext      :array[1..3] of char;
                       attr     :byte;
                       reserved :array[1..10] of byte;
                       time     :word;
                       date     :word;
                       cluster1 :word;
                       size     :longint;
                  end;

var   boot:boot_record;

procedure St_to_ANY(st:String;var buf;l:integer);
type ar=array[1..128] of char;
var stl,x:integer;
begin
     stl:=length(st);
     if l-stl<0 then stl:=l;
     for x:=1 to stl do ar(buf)[x]:=st[x];
     for x:=stl+1 to l do ar(buf)[x]:=' ';
end;

{$S-}
procedure Boot_Code;assembler;
asm
        cli
        xor     ax,ax                {;Place stack segment}
        mov     ss,ax                {;     and stack offset}
        mov     sp,0                 {;     at Location 0000:0000}
        sti                          {;Prepare for interrupts}
        mov     ah,1                 {;Set Cursor size}
        mov     cx,2019h             {;Setting CH>CL removes Cursor (I hope!)}
        int     10h                  {;Commence...}
        mov     ax,0600h
        mov     bx,2200h
        mov     cx,00
        mov     dx,184fh
        int     10h
        mov     bx,2
        mov     ah,0bh
        int     10h
        mov     ax,7c0h              {;Assuming this is a Boot Sector at 0:7c00}
        mov     ds,ax                {;Make sure DS points at Segment of MSG}
        mov     ax,offset boot_code
        mov     si,offset @msg+TYPE Boot{;Source index should point at MSG}
        sub     si,ax
        mov     ax,0b800h
        mov     es,ax
        mov     di,1166-160            {;Column where text would appear}
        mov     bx,di                  {;Save a copy of column to BX}
        cld
@pr:    lodsb                         { ;Load byte}
        or      al,al                 {;Verify if Null ""}
        jz      @done                 {;Yes?  then done in this routine}
        cmp     al,13                 {;No, then check if CHR is <enter>}
        jnz     @cont                 {;Not <enter>?  then continue...}
        add     bx,160                {;Yes! increment BX which is a copy of}
        mov     di,bx                 {;original DI and transfer it to DI}
        jmp     @pr
@cont:  mov     ah,17h               { ;Color Attribute = 17h = 10111b}
        stosw                        {;Transfer CHR and Attribute to DI
    ; Create a shadow of MSG by Zeroing the attribute at [DI+0163]}
        mov     byte ptr es:[di+0163],0
        jmp     @pr
@done:
        mov     ah,1
        int     16h
        jz      @done0
        mov     ah,0
        int     16h
        jmp     @done
@done0: mov     ah,0                 {  ;Service 00h for AH}
        int     16h                  {;    for reading Keyboardz}
        cmp     al,1bh
        jnz     @done1
        db      0EAh                 { jmp     @Reset_Comp}
        dd      0ffff0000h
@done1: mov     bx,0
        mov     ah,0bh
        int     10h
        mov     ax,3                 {;If key was pressed so...}
        int     10h                  {;  ...Clear the screen then...}
        int     19h                  {;       ...Load Boot strap... OK!}

@msg:   db      "浜様様様様様様様様様様様様様様�",13
        db      "�                             �",13
        db      "�         Formatted           �",13
        db      "�            in               �",13
        db      "�         FormatOK            �",13
        db      "�                             �",13
        db      "�                             �",13
@$mac:  db      "�                             �",13
        db      "藩様様様様様様様様様様様様様様�",0
end;
procedure end_boot_code;assembler;
asm
end;
{$S+}

function Dectohex(decimal:longint):string;
const Hex_Str:array [0..15] of char = '0123456789ABCDEF';
var  remainder:byte;
     hex_num:string;
begin
     hex_num:='';
     while decimal > 15 do
     begin
          remainder:=decimal mod 16;
          hex_num:=hex_str[remainder]+hex_num;
          decimal:=decimal div 16;
     end;
     hex_num:=hex_str[decimal]+hex_num;
     while length(hex_num) < 4 do hex_num:='0'+hex_num;
     dectohex:=hex_num;
end;

procedure Boot_maker(usectors_per_cluster:byte;
                     uroot_dirs:word;
                     utracks:byte;
                     ufat_type:fat_Types;
                     udisktype:disktype);

var   regs:registers;
      spt:byte;

      procedure Initialize;
      var total_sectors:word;
      begin
           total_sectors:=spt*utracks*2;
           with boot do
           begin
                jump                :=$E9;             {}
                offset_jump         :=sizeof(boot)-3;  {}
                St_to_ANY('DLSU S16',OEM_ID,8);        {}
                bytes_per_sector    :=512;             {}
                sectors_per_cluster :=usectors_per_cluster;
                sectors_in_reserve  :=1;               {}
                copies_of_FAT       :=2;               {}
                root_dirs           :=uroot_dirs;
                sectors             :=0;
                media               :=romtable[udisktype].media_desc;
                sectors_per_FAT     :=0;
                sectors_per_track   :=spt;
                heads               :=2;               {}
                hidden_sector       :=0;               {}
                sectors32           :=0; {if sectors = 0}

              {extended boot record}
                drive_              :=0;
                r1                  :=0;
                signature           :=$29;
                randomize;
                serial1             :=random($ffff);
                serial2             :=random($ffff);

           end;
      end;

      type index=array[0..511] of byte;
      var  buffer:^index;
           size_Code,x,y:word;

      procedure Write_to_Sector(lsector:byte;var buffer;st:String);
      begin
           with regs,boot do
           begin
                ah:=3;
                al:=1;
                ch:=lsector div  (sectors_per_track*heads);    {track}
                cl:=1+(lsector mod sectors_per_track);         {sector no}
                dh:=(lsector div  sectors_per_track) mod heads;{head}
                dl:=drive;
                es:=seg(buffer);
                bx:=ofs(buffer);
                write('Writing ',st);
                UpdateTable(udisktype);
                intr($13,regs);
                if ah<>0 then write(' !!!Error in ',st);
           end;
      end;

      function ceiling(p:longint;d:longint):longint;
      begin
           if (p mod d) > 0 then ceiling:=(p div d) + 1
           else  ceiling:= p div d;
      end;

var  bytes:longint;
     root_dir_sectors,
     fat_sectors,
     sfat_sectors,
     free_sectors,
     clusters
     :word;

begin
     spt:=romtable[udisktype].table.sector_per_track;
     initialize;
     getmem(buffer,512);
     fillchar(buffer^,512,0);

     with boot do
     begin
{          bytes_per_sector:=128 * (1 shl disktable^.bytes_per_sector);}
          root_dir_sectors:=ceiling(root_dirs*32,bytes_per_sector);
          sectors:=spt*heads*uTracks;

          {*******************************************************}
          fat_sectors:=0;
          free_sectors:=sectors-root_dir_sectors-sectors_in_reserve;
          if ((free_sectors - (copies_of_fat)) div sectors_per_cluster)
              <= 4078 then
            ufat_type:=fat12;

          repeat
            fat_sectors:=fat_sectors+ (copies_of_fat);
            free_sectors:=free_sectors - (copies_of_fat);

            clusters:=free_sectors div sectors_per_cluster;
            case ufat_type of
              FAT12:sfat_Sectors:=ceiling(((clusters+2)*3),
                                          bytes_per_sector*2);
              FAT16:sfat_sectors:=ceiling((clusters+2)*2,
                                          bytes_per_sector);
              FAT32:sfat_sectors:=ceiling((clusters+2)*4,
                                          bytes_per_sector);
            end;
          until sfat_sectors <= (fat_sectors div copies_of_fat);
          sectors_per_FAT:=fat_sectors div copies_of_fat;

          case ufat_type of
            fat12:begin
                    St_to_ANY('Name 12',volume_label,11);
                    St_to_ANY('FAT  12',file_system_id,8);
                  end;
            fat16:begin
                    St_to_ANY('Name 16',volume_label,11);
                    St_to_ANY('FAT  16',file_system_id,8);
                  end;
            fat32:begin
                    St_to_ANY('Name 32',volume_label,11);
                    St_to_ANY('FAT  32',file_system_id,8);
                  end;
          end;
          {*******************************************************}

          bytes:=longint(bytes_per_sector)*sectors;
          writeln('bytes: ',bytes);

          bytes:=bytes-
                 longint(1+
                         copies_of_FAT*sectors_per_FAT+
                         root_dir_sectors) *bytes_per_sector;
          writeln('bytes for data: ',bytes);
          writeln('clusters: ',clusters);
          writeln('total sectors: ',sectors);
          writeln('free sectors: ',free_sectors);

         { Setup Boot Record }
          move(boot,buffer^,sizeof(boot));
          size_Code:=ofs(end_boot_code)-ofs(boot_code)-1;
          if size_Code+sizeof(boot)>510 then
          begin
               writeln('Error in size of boot code!');
               halt;
          end;

         { Setup the boot code right after the boot info }
          move(@boot_code^,buffer^[sizeof(boot)],size_code);
          buffer^[510]:=$55;buffer^[511]:=$AA;
          for x:=0 to sectors_in_reserve-1 do
          begin
              Write_to_Sector(x,buffer^,'boot ');
              writeln(x+1);
          end;

         { Setup the FAT }
          fillchar(buffer^,512,0);
          for x:=0 to copies_of_FAT-1 do
          begin
               case ufat_type of
                  FAT12:begin
                          buffer^[0]:=media;
                          buffer^[1]:=$FF; buffer^[2]:=$FF;
                        end;
                  FAT16:begin
                          buffer^[0]:=media;buffer^[1]:=$FF;
                          buffer^[2]:=$FF;buffer^[3]:=$FF;
                        end;
                  FAT32:begin
                          buffer^[0]:=media;
                          buffer^[1]:=$FF;buffer^[2]:=$FF;buffer^[3]:=$FF;
                          buffer^[4]:=$FF;buffer^[5]:=$FF;buffer^[6]:=$FF;
                          buffer^[7]:=$FF;
                        end;
               end;

               Write_to_Sector(sectors_in_reserve+x*sectors_per_FAT,
                               buffer^,'FAT ');
               writeln(x+1);

               buffer^[0]:=0;buffer^[1]:=0;buffer^[2]:=0;buffer^[3]:=0;
               buffer^[4]:=0;buffer^[5]:=0;buffer^[6]:=0;buffer^[7]:=0;

               for y:=1 to sectors_per_FAT-1 do
               begin
                   Write_to_Sector(sectors_in_reserve+y+x*sectors_per_FAT,
                                   buffer^,'FAT ');
                   writeln(x+1,'-',y+1);
               end;
          end;

          buffer^[0]:=0;buffer^[1]:=0;buffer^[2]:=0;
          with directory(ADDR(buffer^)^) do
          begin
               St_to_ANY('FORMAT 43',name,11);
               attr:=VolumeID;
          end;
          Write_to_Sector(sectors_in_reserve+copies_of_FAT*sectors_per_FAT,
                          buffer^,'DIR ');
          writeln(1);

          with directory(ADDR(buffer^)^) do
          begin
               St_to_ANY(#0#0#0#0#0#0#0#0#0#0#0,name,11);
               attr:=0;
          end;
          for x:=1 to root_dir_sectors-1 do
          begin
               buffer^[0]:=0;buffer^[1]:=0;buffer^[2]:=0;
               Write_to_Sector(sectors_in_reserve+
                               copies_of_FAT*sectors_per_FAT+x,buffer^,'DIR ');
               writeln(x+1);
          end;
          writeln('Serial number ',dectohex(serial1):4,'-',dectohex(serial2):4);
     end;
     freemem(buffer,512);
end;

begin
     clrscr;
     drive:=1;
     savetable;
     format(40,d1440);
     boot_maker(1,
                  { sectors per cluster }
                224,
                  { root directory entries }
                40,
                  { tracks }
                fat12,
                  { fat type}
                d360in1200
                  { disk type }
               );
     restoretable;
end.