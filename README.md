# my_code_history

Main Code Summary List:
[2019-03-04, 4:32pm est] Adding all my legacy hobby codes(Pascal, Assemby language and very few beginners C Language) that I was able to save when I was still a teenager and college student. My main college projects\hobby projects will be added later(as of 2019-03-04).

This legacy code collection of mine includes: (from 1989 to 1997)
* Drawing app source codes with image files that I made, encoded with my own codec.
* Compression/Decompression (Huffman/Sliding window/etc) source codes.
* COM Dissasembler source codes.
* Boot sector/Boot manipulation source codes.
* Sound manipulation source codes.
* epson and postscript print manipulation source codes.
* My own pascal graphics unit replacement source codes which has better performance than turbo pascals own graphics library.
* Math coprocessor indirect replacement mainly for square-root computation, etc.
* Source codes I made to help my close friends project, mainly Lenin, Razette and etc.
* And other hobby/experimental pascal/assembly language source codes.


===============================================================================
Historical Coding Background:

This is my historical codes repository.  I will put as much codes I did ever since I started coding programs as a kid at age of 14 as a 1st year highschool freshman at the year 1987 if I can and up to recently this days. Unfortunately, some of my hobby works are gone because either my old 5 inch floppy disks got a bad sector or a virus destroyed some of them or because I reformatted some of my floppy disk from a 1.2MB capacity each into 1.4MB up to 1.6MB capacity. Nope its not using software compression, its pure physical possible formatable capacity using low level progmamming with assembly language manipulating interrupt 13h and calling direct bios system commands using direct port access, this is during 3rd year highschool.  I was too young did not know that the reason a floppy is designed to hold only 1.2MB is to have an acceptable life to survive few years somewhat. The 1.4MB to 1.6MB format for floppy disk diminished its survivability by I guess about 10 folds worst compared to a normal 1.2MB format.

For now, I will just mention the history of what I coded during those times and what system I was using and just a short story how it began.  I will eventually fill up this repository with the codes I was able to save in my backup system while I try to locate all source codes I can upload here.

Chapter I. High school days.
The very first computer system I got was called "basictutor" on 1987, basically its a basic programming device meant for kids. It has an awesome display of 14 characters where each character size is 7x5, 7 pixels high and 5 pixels wide.  And its memory was a whooping 1 Kilobyte max capacity which cant retain its memory contents if you powered down. In this device I started learning my very first programming language called "BASIC" which means "Beginner's All-purpose Symbolic Instruction Code" and so I did. Surprisingly, I learned the whole basic coding in literally less than a day. Well I was very excited back then to learn my very first programming experience, its because of the "Whiz kids" tv show about programming with computers was one of my favourite show during those times and I actually thought everything in that show was real so I wanted to be like their level of intimacy with programming and computers.

So the first basic program I made was a divide and conquer kind of number game (from one of the exercises with the accompanying booklet of the basictutor). The player will try to guess what random number between 1 and 100 is the computer hiding, there will be an input for a number from the player and the computer will respond whether the hidden number is higher or lower or if the player finally got the correct answer. Then after that some more small programs that I already forgotten nowadays, except the last program I made which was the card game "Black Jack" (which again was out of the exercises from the booklet).  Then after that, I finished all the programming exercises from the booklet, this was all during deep midnight until dawn.  I was still excited to do more programming but I already finished all exercises from the booklet. So I started to improvise some of the finished exercises and I tried to reverse the objectives like the divide and conquer number game, instead of the player trying to guess the number, I made the computer to guess a number that the player was thinking while the player inputs whether the last guess of the computer was higher or lower or correct.  Until I improvise some new small ideas to program.

Then this schoolmate of my big brother 2 years ahead of me came to visit us and luckily he has some programming experience with a real commodore or apple computer and ask me if I knew some secret commands in BASIC language and if he can try to show it to me on my basictutor device.  I was dumbfounded that it worked, there was a secret command that was not written in the manual, its about manipulating the character in the display, he was able to show me some hidden characters among the possible ascii codes, some graphical looking characters.  And so I made some pseudo animation that uses different ascii codes that looks like some thumbling stick people whle pressing enter continuously.

The basictutor booklet also teaches other programming related things like about binary, octal and hexadecimal conversions while during that time I was also good in math, so at a young age I mastered those computer related numbers conversion. I can convert numbers almost like an instant without using scratch paper.

All those was during my 1st and 2nd year highschool days.
--------------------

When I entered 3rd year high school, my big brother was a freshman college student of computer science so my mom bought him a computer, which I can borrow when he is not around.  This computer is a PC/XT with a 4.77-MHz processor clock speed that has a turbo button that increases it to a superb 8-MHz speed.  The memory was a whooping 360 KB size. It comes with a floppy drive to start an OS and comes with a CGA type of monitor, I forgot if it has 4 or 16 colors possible and it has 320x200 resolution in color mode and twice the size in black and white mode.

I eventually found out that there is a secret key combination or some software initiation to a certain interrupt port maybe to initiate the built in BASIC programming capability of the BIOS, it is named either "basica or gwbasic". So I started using it and was able to program much more interesting software codes and learned that it has much more additional capability that was definitely not possible from my old basictutor.  I was so curious about graphics mode rendering, so that is where it all started, I learned the BASIC command "pset", which plots a single dot in the monitor in graphics mode.  So I got a graphing paper and traced my micky mouse shirt graphics into it, so that I can plot its equivalent pixel location into the screen monitor.  While doing it I learned a new command "line" which plots a line between 2 points in the screen, so now it fasten a bit my creation of hundreds of pset command that has a consecutive occurence of same color in a line. At this time my little brother was of 0% interest in programming but I enticed him to start programming so that he could plot the graphics of his desire to the computer screen. While I like programming, he likes cartoon graphics, so he got interested of the opportunity. However I already am using the line together with pset command, he was just purely using the pset single pixel command.  I was able to finish ploting my micky mouse graphics soon. But it took him some time coz he is using dot by dot command but his perseverance prevailed and he finished his graphics.  Eventually I wanted to plot more cartoon graphics into the monitor, but I found it tiring to plot manually using codes for each pixel or line of the graphics, so I got interested in creating my own simple graphic drawing utility.  (Note: during this time we dont have any drawing software, it is hard to come by)  I tried to find out what command i need to get a single keystroke input that does not use the regular input command so that I can continue pressing any succeeding keystroke continuously so that I can draw to the screen interactively.  The problem with regular input command is you need to press enter each time you type a specific character, but eventually I found the "secret" command (not really a secret but an unknow command to me) then eureka I can fully plot my graphics interactively using a keystroke.  Eventually while playing games I noticed that some games are able to input several keys at the same time without conflict especially in two player mode.  Eventually i got so curious about the possibilities that I could do with simultaneous keytrokes at the same time I got curious why other games can detect the different shift keys or caps lock, etc.  

Eventually, I got a hold of "turbo basic" editor with a much powerful text ide editor, it has more capability as a language. I ported and continued my graphics editor code and added some more capability.

Eventually, my big brother introduced me to PASCAL programming language using turbo pascal which he was also learning from his com-sci course. So I started using it and eventually I find it more easier, more direct and more powerful to use, soon I mastered it. I made an equivalent drawing utility code in pascal and added some of my own improvised compression probably called "run length" encoding which i was not aware at that time of what it is called.  I made that compression routine because at the time floppy disk is not enough to hold a lot of graphics.  Eventually, I learned assembly language programming using masm or tasm assembler.  This assembly language was an eye openner it enables me to manipulate the system commands directly, graphics modes, disk access, keyboard access, and direct memory access to boot sector and boot memory location or any memory location unrestricted.  It was so powerful that all system calls was in my grasp to manipulate. Moreover, upon learning the capabilities of assembly language, I explored further the capabilities of turbo pascal and learned the 2 most powerful command which are "mem" and "port", direct memory access command and direct system port access.  Those 2 commands can make or break the pc system.

(to be continued...as of 2019-02-28,Thu, 10:20pm est)


Chapter II. College days.


Chapter III. Professional days. 


