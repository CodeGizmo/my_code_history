uses crt,vgaliza2,mystring;
var a:word;
begin
  vgamode(3);
  loadchar('mychar.chr');
(*  putstring('The quick brown fox jumps over the lazy dog.'#13);
  putstring('`1234567890-=\qwertyuiop[]asdfghjkl;''zxcvbnm,./~!@#$%^&*()_+|QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?');*)
  for a:=0 to 2500 do putchar(a);
  readstring;
  readkey;
  vgamode(mtext);
end.