                                                                                                                                                                                                                                             goto angelo
running:

while not instat
if path=1 or path=4 then put(x,y),dot,preset:put(x,y),dot,pset
if path=2 or path=5 then put(x,0),lineup,preset:put(0,y),lineside,preset
wend
a$=inkey$
if path=2 or path=5 then put(x,0),lineup,pset:put(0,y),lineside,pset
if a$=k4$ or a$=k7$ or a$=k1$ then x=x-1:if x<0 then x=0:play p$
if a$=k6$ or a$=k9$ or a$=k3$ then x=x+1:if x>319 then x=319:play p$
if a$=k8$ or a$=k7$ or a$=k9$ then y=y-1:if y<0 then y=0:play p$
if a$=k2$ or a$=k1$ or a$=k3$ then y=y+1:if y>199 then y=199:play p$
if c=4 then goto nocolor
if path=3 and y<8 or path=4 and y<8 or path=5 and y<8 then put(0,0),up,pset
pset(x,y),c
if path=3 and y<8 or path=4 and y<8 or path=5 and y<8 then get(0,0)-(319,7),up

nocolor:

get(x,y)-(x,y),dot:get(x,0)-(x,199),lineup:get(0,y)-(319,y),lineside
if path=3 or path=4 or path=5 then locate 1,1:?"X=";x;" Y=";y;" C=";c;"          "
if a$=k1$ or a$=k2$ or a$=k3$ or a$=k4$ or a$=k6$ or a$=k7$ or a$=k8$ or a$=k9$ then goto running
if a$="0"then c=0
if a$="1"then c=1
if a$="2"then c=2
if a$="3"then c=3
if a$="4"then c=4
if c=4 then goto walangkulay
pset(x,y),c

walangkulay:

get(x,y)-(x,y),dot:get(x,0)-(x,199),lineup:get(0,y)-(319,y),lineside
if a$="0" or a$="1" or a$="2" or a$="3" or a$="4" then goto running
if path=3 or path=4 or path=5 then put(0,0),up,pset
if a$="B"then goto background
if a$="C"then goto change
if a$="D"then get(0,0)-(319,199),drawing:screen 2:files:while not instat:wend:screen 1:put(0,0),drawing,pset
if a$="E"then cls:get(x,y)-(x,y),dot:get(x,0)-(x,199),lineup:get(0,y)-(319,y),lineside:c=4
if a$="F"then goto fill
if a$="G"then goto gets
if a$="I"then goto ink
if a$="L"then goto loads
if a$="P"then goto puts
if a$="Q"then goto ending
if a$="R"then goto flipright
if a$="S"then goto saves
if a$="U"then goto flipup
if a$="W"then goto windows
if a$="Z"then goto zoom
if a$="H"then goto help
goto running



help:
get(0,0)-(319,199),drawing
screen 2
print"Shift-B = changes background color"
print"shift-C = changes page number"
print"shift-D = look at the directory of the current drive"
print"shift-E = erases the current page"
print"shift-F = paint or fills the region of current position"
print"shift-G = cut a specified rectangular portion"
print"          press shift-G again to cut or press shift-C if you want to cancel"
print"shift-I = changes the color of the ink for the fill or paint(1,b-blue,"
print"          2,r-red, 3,w-white, 0,d-black) ex. 0,bb; 3,r; 2,b; 2,rw; etc."
print"shift-L = loads a file"
print"shift-P = puts the cutted rectangular portion to a new portion"
print"          press shif-P again to paste or press shift-C if you want to cancel"
print"shift-Q = ends my program"
print"shift-R = reverses the drawing sidewards"
print"shift-S = saves the drawing"
print"shift-U = reverses the drawing vertically"
print"shift-W = changes the pallete color"
print"shift-Z = changes cursor style (this has 6 styles)"
print"shift-H = Help (goto this window)"
print"press buttons 0,1,2 or 3 to change the color of the dot and press button 4 if"
print"you like the cursor to be transparent"
print"press + or - to increase or decrease put or get displacement by ones and"
print"press * or / to increase or decrease put or get displacement by 5's"
while not instat:wend
screen 1
put(0,0),drawing,pset
goto running


saves:

get(0,0)-(319,199),drawing
locate 1,1:input"file to be bsave: ";file$
if file$="cancel" then put(0,0),drawing,pset:goto running
put(0,0),drawing,pset
bsave file$,0,16384
c=4
goto running

loads:

get(0,0)-(319,199),drawing
locate 1,1:input"file to be bload: ";file$
if file$="cancel" then put(0,0),drawing,pset:goto running
bload file$
get(0,0)-(319,7),up
get(0,0)-(319,199),drawing
get(x,y)-(x,y),dot:get(x,0)-(x,199),lineup:get(0,y)-(319,y),lineside
c=4
goto running

gets:

get(0,0)-(319,199),drawing

getting:

while not instat
line(x1,y1)-(x2,y2),3,b,&he4e4
line(x1,y1)-(x2,y2),0,b,&he4e4
wend
a$=inkey$
if a$=k4$ or a$=k7$ or a$=k1$ then x2=x2-steps:if x2<0 then x2=0:play p$
if a$=k6$ or a$=k9$ or a$=k3$ then x2=x2+steps:if x2>319 then x2=319:play p$
if a$=k8$ or a$=k7$ or a$=k9$ then y2=y2-steps:if y2<0 then y2=0:play p$
if a$=k2$ or a$=k1$ or a$=k3$ then y2=y2+steps:if y2>199 then y2=199:play p$

if a$="4" or a$="7" or a$="1" then x1=x1-steps:if x1<0 then x1=0:play p$
if a$="6" or a$="9" or a$="3" then x1=x1+steps:if x1>319 then x1=319:play p$
if a$="8" or a$="7" or a$="9" then y1=y1-steps:if y1<0 then y1=0:play p$
if a$="2" or a$="1" or a$="3" then y1=y1+steps:if y1>199 then y1=199:play p$

if a$="G"then goto geting
if a$="C"then put(0,0),drawing,pset:c=4:goto running
if a$="+"then steps=steps+1
if a$="-"then steps=steps-1
if a$="*"then steps=steps+5
if a$="/"then steps=steps-5
if steps< 1 then steps= 1:play p$
if steps>50 then steps=50:play p$
put(0,0),drawing,pset
line(x1,y1)-(x2,y2),2,b,&he4e4
goto getting

geting:

put(0,0),drawing,pset
if y1>y2 then swap y1,y2
if x1>x2 then swap x1,x2
xx=x2-x1
yy=y2-y1
get(x1,y1)-(x2,y2),picture
c=4
goto running

puts:

get(0,0)-(319,199),drawing

puting:

while not instat:wend
a$=inkey$
if a$=k4$ or a$=k7$ or a$=k1$ then x1=x1-steps:if x1<0 then x1=0:play p$
if a$=k6$ or a$=k9$ or a$=k3$ then x1=x1+steps:if x1>319 then x1=319:play p$
if a$=k8$ or a$=k7$ or a$=k9$ then y1=y1-steps:if y1<0 then y1=0:play p$
if a$=k2$ or a$=k1$ or a$=k3$ then y1=y1+steps:if y1>199 then y1=199:play p$

if a$="P"then goto putting
if a$="C"then put(0,0),drawing,pset:c=4:goto running
if a$="+"then steps=steps+1
if a$="-"then steps=steps-1
if a$="*"then steps=steps+5
if a$="/"then steps=steps-5
if steps< 1 then steps= 1:play p$
if steps>50 then steps=50:play p$
if x1<0 then x1=0:play p$
if y1<0 then y1=0:play p$
x2=x1+xx
y2=y1+yy
if x2>319 then x2=319:x1=x2-xx:play p$
if y2>199 then y2=199:y1=y2-yy:play p$
put(0,0),drawing,pset
put(x1,y1),picture,pset
goto puting

putting:

put(0,0),drawing,pset
put(x1,y1),picture,pset
while not instat:wend
a$=inkey$
if a$="O"then goto putted
put(0,0),drawing,pset
put(x1,y1),picture,preset
while not instat:wend
a$=inkey$
if a$="O"then goto putted
put(0,0),drawing,pset
put(x1,y1),picture,or
while not instat:wend
a$=inkey$
if a$="O"then goto putted
put(0,0),drawing,pset
put(x1,y1),picture,xor
while not instat:wend
a$=inkey$
if a$="O"then goto putted
put(0,0),drawing,pset
put(x1,y1),picture,and
while not instat:wend
a$=inkey$
if a$="O"then goto putted
goto putting

putted:

get(0,0)-(319,199),drawing
get(0,0)-(319,7),up
c=4
get(x,y)-(x,y),dot:get(x,0)-(x,199),lineup:get(0,y)-(319,y),lineside
goto running

ink:

get(0,0)-(319,199),drawing
locate 1,1:input"boundary,color";by,ink$
if ink$="b"or ink$="bb"then cc$=chr$(&h55)
if ink$="r"or ink$="rr"then cc$=chr$(&haa)
if ink$="w"or ink$="ww"then cc$=chr$(&hff)
if ink$="d"or ink$="dd"then cc$=chr$(&h0)
if ink$="br"or ink$="rb"then cc$=chr$(&h66)+chr$(&h99)
if ink$="bw"or ink$="wb"then cc$=chr$(&h77)+chr$(&hdd)
if ink$="bd"or ink$="db"then cc$=chr$(&h11)+chr$(&h44)
if ink$="rw"or ink$="wr"then cc$=chr$(&hbb)+chr$(&hee)
if ink$="rd"or ink$="dr"then cc$=chr$(&h22)+chr$(&h88)
if ink$="wd"or ink$="dw"then cc$=chr$(&h33)+chr$(&hcc)
if ink$="dbrw"then cc$=chr$(&h1b)+chr$(&hb1)
put(0,0),drawing,pset
goto running

fill:

paint(x,y),cc$,by
get(x,y)-(x,y),dot:get(x,0)-(x,199),lineup:get(0,y)-(319,y),lineside
get(0,0)-(319,7),up
goto running

flipup:

for a=0 to 99
b=199-a
get(0,a)-(319,a),line1
get(0,b)-(319,b),line2
put(0,b),line1,pset
put(0,a),line2,pset
next a
get(x,y)-(x,y),dot:get(x,0)-(x,199),lineup:get(0,y)-(319,y),lineside:c=4
get(0,0)-(319,7),up
goto running

flipright:

for a=0 to 159
b=319-a
get(a,0)-(a,199),line1
get(b,0)-(b,199),line2
put(b,0),line1,pset
put(a,0),line2,pset
next a
get(x,y)-(x,y),dot:get(x,0)-(x,199),lineup:get(0,y)-(319,y),lineside:c=4
get(0,0)-(319,7),up
goto running

background:

background=background+1:if background=16 then background=0
color background
goto running

windows:

w=w+1:if w=7 then w=1
if w=1 then get(0,0)-(319,199),drawing:screen 1,1:put(0,0),drawing,pset
if w=2 then color 0
if w=3 then get(0,0)-(319,199),drawing:screen 1,0:put(0,0),drawing,pset
if w=4 then color ,0
if w=5 then color 0,1
if w=6 then color ,0
goto running

change:

if path=3 or path=4 or path=5 then goto running
change=change+1:if change=6 then change=1
if change=1 then get(0,0)-(319,199),drawing5:put(0,0),drawing1,pset
if change=2 then get(0,0)-(319,199),drawing1:put(0,0),drawing2,pset
if change=3 then get(0,0)-(319,199),drawing2:put(0,0),drawing3,pset
if change=4 then get(0,0)-(319,199),drawing3:put(0,0),drawing4,pset
if change=5 then get(0,0)-(319,199),drawing4:put(0,0),drawing5,pset
get(x,y)-(x,y),dot:get(x,0)-(x,199),lineup:get(0,y)-(319,y),lineside
get(0,0)-(319,7),up
goto running

zoom:

path=path+1
if path>5 then path=0
if path=3 then get(0,0)-(319,7),up
goto running
           ending:
screen 2:screen 0,0,0
color ,9
?string$(2000,32)
color 10,12
locate 5,28:print" D R A W I N G   K I T "
color 14,9
locate 10,30:PRINT"by Angelo L. Lanuza"
locate 11,36:print"(M.I.T.)"
color 9,1
locate 18,32:print"Copyright 1991"
locate 19,30:print"All rights reserved"
while not instat:wend
color,0
?string$(2000,32)
locate 1,1:print"Bye! I hope you enjoyed my program.  By the way if you like my program, and you want to copy my next lovable program, please give me a free 1-meg diskette, it'sokay if you don't, but you'll miss the fun . . .(hi. . . hi. . . hic.)"
end










angelo:

while not instat:wend
a$=inkey$
if a$<>"a"then goto angelo
while not instat:wend
a$=inkey$
if a$<>"n"then goto angelo
while not instat:wend
a$=inkey$
if a$<>"g"then goto angelo
while not instat:wend
a$=inkey$
if a$<>"e"then goto angelo
while not instat:wend
a$=inkey$
if a$<>"l"then goto angelo
while not instat:wend
a$=inkey$
if a$<>"o"then goto angelo

color ,9
?string$(2000,32)
color 14,9,4
locate 4,22:?"‹ﬂﬂﬂ‹ €   € ‹ﬂﬂﬂ‹ €ﬂﬂﬂﬂ €     ‹ﬂﬂﬂ‹"
locate 5,22:?"€‹‹‹€ €ﬂ‹ € €     €‹‹‹  €     €   €"
locate 6,22:?"€   € €  ﬂ€ €  ﬂ€ €     €     €   €"
locate 7,22:?"ﬂ   ﬂ ﬂ   ﬂ  ﬂﬂﬂ  ﬂﬂﬂﬂﬂ ﬂﬂﬂﬂﬂ  ﬂﬂﬂ "
locate  9,22:?"€     ‹ﬂﬂﬂ‹ €   € €   € ﬂﬂﬂﬂ€ ‹ﬂﬂﬂ‹"
locate 10,22:?"€     €‹‹‹€ €ﬂ‹ € €   €   ‹ﬂ  €‹‹‹€"
locate 11,22:?"€     €   € €  ﬂ€ €   € ‹ﬂ    €   €"
locate 12,22:?"ﬂﬂﬂﬂﬂ ﬂ   ﬂ ﬂ   ﬂ  ﬂﬂﬂ  ﬂﬂﬂﬂﬂ ﬂ   ﬂ"
color 2,15
locate 16,8:?"€ﬂﬂﬂ‹ €ﬂﬂﬂ‹ ‹ﬂﬂﬂ‹ € € €  ﬂ€ﬂ  €   € ‹ﬂﬂﬂ‹      €  ‹ﬂ  ﬂ€ﬂ  ﬂﬂ€ﬂﬂ"
locate 17,8:?"€   € €‹‹‹ﬂ €‹‹‹€ € € €   €   €ﬂ‹ € €          €‹ﬂ     €     €  "
locate 18,8:?"€   € €   € €   € € € €   €   €  ﬂ€ €  ﬂ€      € ﬂ‹    €     €  "
locate 19,8:?"ﬂﬂﬂﬂ  ﬂ   ﬂ ﬂ   ﬂ  ﬂ ﬂ   ﬂﬂﬂ  ﬂ   ﬂ  ﬂﬂﬂ       ﬂ   ﬂ  ﬂﬂﬂ    ﬂ  "


color 14,12:locate 24,28:?"Press any key to continue"
while not instat:wend
a$=inkey$
k1$=chr$(len(a$)=0)+"O"
k2$=chr$(len(a$)=0)+"P"
k3$=chr$(len(a$)=0)+"Q"
k4$=chr$(len(a$)=0)+"K"
k6$=chr$(len(a$)=0)+"M"
k7$=chr$(len(a$)=0)+"G"
k8$=chr$(len(a$)=0)+"H"
k9$=chr$(len(a$)=0)+"I"
screen 1
def seg=&hb800
dim dot(4),drawing(4000),drawing1(4000),drawing2(4000),drawing3(4000),drawing4(4000),drawing5(4000),picture(4000),line1(400),line2(400),lineup(400),lineside(400),up(400)
get(0,0)-(0,0),drawing:get(0,0)-(0,0),drawing1:get(0,0)-(319,199),drawing2:get(0,0)-(319,199),drawing3:get(0,0)-(319,199),drawing4:get(0,0)-(319,199),drawing5:get(0,0)-(0,0),picture
x2=0:y2=0:steps=10:xx=0:yy=0:y1=0:y2=0:x1=0:x2=0:cc$=chr$(&h0):c=4
p$="l64t255msa"
goto running