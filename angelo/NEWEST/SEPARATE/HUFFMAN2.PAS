uses crt,dos;
var
  d1,d2,d3,d4                     :word;
  pin,pout                        :pointer;
  fin,fout                        :file;
  filein,fileout                  :string;
  sorted                          :array[0..255]of byte;
  weights                         :array[0..255]of word;
  neww                            :array[0..511]of word;
  sizein,sizeout,x,y              :word;
  ch                              :char;
  dirinfo                         :searchrec;

type
  myptr=array[0..65530]of byte;
  word2=^word;

procedure loadfirst(filename:string;var buf);
begin
  assign(fin,filename);
  reset(fin,1);
  blockread(fin,buf,64512,sizein);
  close(fin);
end;{loadfirst}

procedure loadnext(var buf);
begin
  blockread(fin,buf,64512,sizein);
end;{loadnext}

procedure closein;
begin
  close(fin);
end;

procedure savefirst(filename:string;var buf);
begin
  assign(fout,filename);
  rewrite(fout,1);
  blockwrite(fout,buf,sizeout);
end;{savefirst}

procedure savenext(var buf);
begin
  blockwrite(fout,buf,sizeout);
end;{savenext}

procedure closeout;
begin
  close(fout);
end;{closeout}

procedure clearweights;
begin
  for d1:=0 to 255 do
  begin
    weights[d1]:=0;
    sorted[d1]:=d1;
  end;
  for d1:=0 to 511 do neww[d1]:=0;
end;

procedure getweights(var buf);
var pos:word;
    bufseg,bufofs:word;
begin
  for pos:=0 to sizein-1 do inc(weights[myptr(buf)[pos]]);
end;{getweights}

procedure sortmax;
var max:byte;
begin
  for d1:=0 to 255 do
  begin
    max:=d1;
    for d2:=d1 to 255 do
    begin
      if weights[sorted[max]]<weights[sorted[d2]]then
      begin
        max:=d2;
      end;
    end;
    d3:=sorted[max];
    sorted[max]:=sorted[d1];
    sorted[d1]:=d3;
    neww[d1]:=weights[d3];
  end;
end;{sort}

procedure sortmin;
var min:byte;
begin
  for d1:=0 to 255 do
  begin
    min:=d1;
    for d2:=d1 to 255 do
    begin
      if weights[sorted[min]]>weights[sorted[d2]]then
      begin
        min:=d2;
      end;
    end;
    d3:=sorted[min];
    sorted[min]:=sorted[d1];
    sorted[d1]:=d3;
    neww[d1]:=weights[d3];
  end;
end;{sort}

var
  grandma                  :word;
  mother                   :array[0..511]of word;
  ff,ss                    :array[256..511]of word;
  bits                     :array[0..511]of byte;
  ready                    :array[0..511]of boolean;
  sizes                    :array[0..255]of byte;
  tot_ready                :word;
  lastlight0,lastlight1    :word;

procedure getready;
var d:word;
begin
  tot_ready:=0;
  for d:=0 to 255 do
  begin
    if neww[d]>0 then
    begin
      ready[d]:=true;
      inc(tot_ready);
    end else ready[d]:=false;
    sizes[d]:=0;
  end;
  for d:=256 to 511 do ready[d]:=false;
end;{getready}

procedure getsizes(inisize:byte;this:word);
begin
  if this<256 then
  begin
    sizes[this]:=inisize;
  end else
  begin
    getsizes(inisize+1,ff[this]);
    getsizes(inisize+1,ss[this]);
  end;
end;{getsizes}

var
  tcom,tuncom:longint;
procedure showsizes;
var d:byte;
    com,uncom:longint;
begin
  com:=0;uncom:=0;
  for d:=0 to 127 do
  begin
{    gotoxy((d div  25)*10+1,(d mod 25)+1);
    write(d:3,':',sizes[d]:5);}
    com:=com+longint(sizes[d]*neww[d]);
    uncom:=uncom+8*longint(neww[d]);
  end;
  for d:=0 to 127 do
  begin
{    gotoxy((d div  25)*10+1,(d mod 25)+1);
    write(d+128:3,':',sizes[d+128]:5);}
    com:=com+longint(sizes[d+128]*neww[d+128]);
    uncom:=uncom+8*longint(neww[d+128]);
  end;
  tcom:=tcom+com;
  tuncom:=tuncom+uncom;
  clrscr;
  writeln('FILENAME: ',dirinfo.name);
  writeln('              Uncompressed       Compressed');
  writeln('by bits  :',uncom:15,com:15);
  writeln('by bytes :',uncom/8:15:0,com/8:15:0);
  writeln('Percent compressed (ideal) : ',com/uncom*100:0:2,'%');
  writeln('Precent compressed (real)  : ',(com+1024)/uncom*100:0:2,'%');
  writeln;
  writeln('     C U M U L A T I V E :');
  writeln('              Uncompressed       CompressKEEHFFDEFIED

GDFDGFE
DD	GDED
D	G



DFDDEI1

DEJDHF


DD	HDFDDE
D	
DL


HGDDDEFDEFEDFHIGFĄEEGĨ§ēš ū Į Ö ë )TzĄÎ 9rŠā\ūý;ÉKÜ nķ[Īō9Ó	o	š	
Z
­
Mï6Ô$qÃTĐþLß(bŪî9ÅĸGŋõcĒÜF{ķÝ7cĐĘė 0ģFŦĐKEĐĶJDĐĪJDEĢĒ
O 



DG
	


D

I	

H
DK



DI
DI



GDL
DD


EK
	E

D





G

D
DD

E


FE

	
D

E

L



E



GF
DDG


GD
GF

ED


EE
G

J



DKED

EDJ
F





DHF
DF







E


GE

FD
IE	


ED
DE
D



F	D
GO

D
FE
	

	G


EGF
R
DD

DK
	

	D
		



DF
	
DH

H
		D

	D


EDDD
P
"



		





FF


E
F
	J

		

E
DO
	



DD
			

D	
EDEG
	

D
D&







D	DFD
	D
		D(








E

I

IDE
	
EDE



D
DEGE

FE

	
HDEEE
DE	G

IDG



DDG


IFD




DFE



HEDE




D
DDD


DEGF 






HDD



G



FGDG



DF





E
	FE
D
E

IE

EDD




F

FD  D!




IE
FD 




D

F	FF 

D

F	K (



DE

HK ED


D
GDL 



DL

J 
E