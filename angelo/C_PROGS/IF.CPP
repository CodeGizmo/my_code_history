#include <stdio.h>
#include <conio.h>
void main()
{
  int years;
  printf("How old are you? ");
  scanf("%d",&years);
  if (years<0)
    printf("That can\'t be!\n");
  else if (years==0)
    printf("You\'re kidding!\n");
  else if (years<13)
    printf("You are still a child.\n");
  else if (years>19)
    printf("You are an adult already.\n");
  else
    printf("So, you're a teenager!\n");
  getch();
}