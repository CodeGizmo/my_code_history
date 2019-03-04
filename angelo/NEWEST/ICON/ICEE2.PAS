uses printer,crt;
procedure putlines;
begin
  writeln(lst,'130 750 moveto');
  writeln(lst,'1 setlinewidth');

  writeln(lst,'/frame {300 0 rlineto');
  writeln(lst,'0 -100 rlineto');
  writeln(lst,'-300 0 rlineto');
  writeln(lst,'0 100 rlineto');


  writeln(lst,'5 -5 rmoveto');
  writeln(lst,'290 0 rlineto');
  writeln(lst,'0 -15 rmoveto');
  writeln(lst,'-290 0 rlineto');
  writeln(lst,'-5 20 rmoveto');
  writeln(lst,'125 -5 rmoveto');
  writeln(lst,'0 -15 rlineto');
  writeln(lst,'50 0 rmoveto');
  writeln(lst,'0 15 rlineto');
  writeln(lst,'-175 5 rmoveto');

  writeln(lst,'5 -95 rmoveto');
  writeln(lst,'290 0 rlineto');
  writeln(lst,'0 10 rmoveto');
  writeln(lst,'-290 0 rlineto');
  writeln(lst,'-5 85 rmoveto');

  writeln(lst,'0 -120 rmoveto}def');

  writeln(lst,'frame');
  writeln(lst,'frame');
  writeln(lst,'frame');
  writeln(lst,'frame');
  writeln(lst,'frame');
  writeln(lst,'frame');
  writeln(lst,'stroke');
end;

procedure putbars;
begin
  writeln(lst,'130 750 moveto');
  writeln(lst,'1 setlinewidth');

  writeln(lst,'/frame {5 -7 rmoveto');
  writeln(lst,'118 0 rlineto');
  writeln(lst,'0 -11 rlineto');
  writeln(lst,'-118 0 rlineto');
  writeln(lst,'0 11 rlineto');
  writeln(lst,'-5 7 rmoveto');

  writeln(lst,'295 -7 rmoveto');
  writeln(lst,'-118 0 rlineto');
  writeln(lst,'0 -11 rlineto');
  writeln(lst,'118 0 rlineto');
  writeln(lst,'0 11 rlineto');
  writeln(lst,'-295 7 rmoveto');

  writeln(lst,'5 -93 rmoveto');
  writeln(lst,'290 0 rlineto');
  writeln(lst,'0 6 rlineto');
  writeln(lst,'-290 0 rlineto');
  writeln(lst,'0 -6 rlineto');
  writeln(lst,'-5 93 rmoveto');

  writeln(lst,'0 -120 rmoveto}def');

  writeln(lst,'frame');
  writeln(lst,'frame');
  writeln(lst,'frame');
  writeln(lst,'frame');
  writeln(lst,'frame');
  writeln(lst,'frame');
  writeln(lst,'fill');

end;

procedure signlines;
begin
  writeln(lst,'180 670 moveto');
  writeln(lst,'2 setlinewidth');

  writeln(lst,'/frame {200 0 rlineto');
  writeln(lst,'-200 0 rmoveto');
  writeln(lst,'0 -120 rmoveto}def');

  writeln(lst,'frame');
  writeln(lst,'frame');
  writeln(lst,'frame');
  writeln(lst,'frame');
  writeln(lst,'frame');
  writeln(lst,'frame');
  writeln(lst,'stroke');
end;

procedure puticee;
begin
  writeln(lst,'/Helvetica-Bold findfont');
  writeln(lst,'14 scalefont');
  writeln(lst,'setfont');
  writeln(lst,'265 732 moveto');
  writeln(lst,'(ICEE)show');
  writeln(lst,'265 612 moveto');
  writeln(lst,'(ICEE)show');
  writeln(lst,'265 492 moveto');
  writeln(lst,'(ICEE)show');
  writeln(lst,'265 372 moveto');
  writeln(lst,'(ICEE)show');
  writeln(lst,'265 252 moveto');
  writeln(lst,'(ICEE)show');
  writeln(lst,'265 132 moveto');
  writeln(lst,'(ICEE)show');
end;

procedure putnames;
begin
  writeln(lst,'/Times-Bold findfont');
  writeln(lst,'20 scalefont');
  writeln(lst,'setfont');
  writeln(lst,'280 710 moveto');
  writeln(lst,'(ARCEGA, LENIE V.)dup stringwidth pop');
  writeln(lst,'2 div 0 exch sub 0 rmoveto show');

  writeln(lst,'280 590 moveto');
  writeln(lst,'(PINEDA, GENE PAUL B.)dup stringwidth pop');
  writeln(lst,'2 div 0 exch sub 0 rmoveto show');

  writeln(lst,'280 470 moveto');
  writeln(lst,'(LIM, HARRIS Y.)dup stringwidth pop');
  writeln(lst,'2 div 0 exch sub 0 rmoveto show');

  writeln(lst,'280 350 moveto');
  writeln(lst,'(GACUMA, Ma. LUISA D.)dup stringwidth pop');
  writeln(lst,'2 div 0 exch sub 0 rmoveto show');

  writeln(lst,'280 230 moveto');
  writeln(lst,'(DIZON, ALEJANDRO J.)dup stringwidth pop');
  writeln(lst,'2 div 0 exch sub 0 rmoveto show');

  writeln(lst,'280 110 moveto');
  writeln(lst,'(CONSTANTINO, ROMMEL R.)dup stringwidth pop');
  writeln(lst,'2 div 0 exch sub 0 rmoveto show');

  writeln(lst,'/Helvetica-Oblique findfont');
  writeln(lst,'14 scalefont');
  writeln(lst,'setfont');
  writeln(lst,'280 690 moveto');
  writeln(lst,'(TREASURER)dup stringwidth pop');
  writeln(lst,'2 div 0 exch sub 0 rmoveto show');

  writeln(lst,'280 570 moveto');
  writeln(lst,'(AUDITOR)dup stringwidth pop');
  writeln(lst,'2 div 0 exch sub 0 rmoveto show');

  writeln(lst,'280 450 moveto');
  writeln(lst,'(BUSINESS MANAGER)dup stringwidth pop');
  writeln(lst,'2 div 0 exch sub 0 rmoveto show');

  writeln(lst,'280 330 moveto');
  writeln(lst,'(PRO.)dup stringwidth pop');
  writeln(lst,'2 div 0 exch sub 0 rmoveto show');

  writeln(lst,'280 210 moveto');
  writeln(lst,'(5TH YEAR REP.)dup stringwidth pop');
  writeln(lst,'2 div 0 exch sub 0 rmoveto show');

  writeln(lst,'280 90 moveto');
  writeln(lst,'(4TH YEAR REP.)dup stringwidth pop');
  writeln(lst,'2 div 0 exch sub 0 rmoveto show');

end;

begin
  writeln(lst,'/Times-Bold findfont');
  writeln(lst,'16 scalefont');
  writeln(lst,'setfont');

  putlines;
  putbars;
  signlines;
  puticee;
  putnames;

  writeln(lst,'showpage');
end.