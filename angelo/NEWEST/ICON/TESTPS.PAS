uses printer,crt;
begin
  writeln(lst,'/Helvetica findfont');
  writeln(lst,'16 scalefont');
  writeln(lst,'setfont');
  writeln(lst,'20 40 moveto');
  writeln(lst,'(Angelo L. Lanuza)show');
{  writeln(lst,'50 50 moveto');
  writeln(lst,'2 setlinewidth');
  writeln(lst,'50 0 rlineto');
  writeln(lst,'0 50 rlineto');
  writeln(lst,'-50 0 rlineto');
  writeln(lst,'0 -50 rlineto');

  writeln(lst,'150 150 moveto');
  writeln(lst,'2 setlinewidth');
  writeln(lst,'50 0 rlineto');
  writeln(lst,'0 50 rlineto');
  writeln(lst,'-50 0 rlineto');
  writeln(lst,'0 -50 rlineto');
  writeln(lst,'stroke');}
  writeln(lst,'/ppp {16 scalefont');
  writeln(lst,'setfont');
  writeln(lst,'0 40 rmoveto');
  writeln(lst,'(ABCDEFGHIJKLMNOPQRSTUVWXYZ)show');
  writeln(lst,'(abcdefghijklmnopqrstuvwxyz)show}');
  writeln(lst,'def');
  writeln(lst,'/Helvetica findfont');
  writeln(lst,'ppp');
  writeln(lst,'/Times-Roman findfont');
  writeln(lst,'ppp');
  writeln(lst,'/Courier findfont');
  writeln(lst,'ppp');
  writeln(lst,'showpage')

end.