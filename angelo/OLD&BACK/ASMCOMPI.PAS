{$M $4000,0,0}
uses dos,crt;
var
  filename:string;
begin
  clrscr;
  gotoxy(1,1);
  swapvectors;
  filename:='sample3';
  exec('c:\dos\command.com','/c tasm.exe '+filename);
  exec('c:\dos\command.com','/c tlink.exe '+filename{+'/t'});
  swapvectors;
{  clrscr;}
  swapvectors;
  exec(filename+'.exe','');
  swapvectors;
  sound(100);
  delay(100);
  nosound;
  readln;
end.