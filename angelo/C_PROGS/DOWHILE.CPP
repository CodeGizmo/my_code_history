#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
void main()
{
  int i,num,count;
  randomize();
  i=random(1000);
  count=0;
  do
  { ++count;
    clrscr();
    printf("Enter a number between 0 to 999 -> ");
    scanf("%d",&num);
    if(i>num)printf("\nHigher");
    else if(i<num)printf("\nLower");
    else printf("\nEureka! You got it in %d tries!",count);
    getch();
  }while (num!=i);
}              