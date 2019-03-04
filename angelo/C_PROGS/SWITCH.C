#include <stdio.h>
#include <conio.h>
void main()
{
  int num;
  printf("Choose a number from 1 to 3: ");
  scanf("%d",&num);
  switch (num)
  {
    case 1:printf("You\'ve chosen the number ONE.\n");break;
    case 2:printf("You\'ve chosen the number TWO.\n");break;
    case 3:printf("You\'ve chosen the number THREE.\n");break;
    default:printf("You\'ve chosen an invalid number.\n");
  }
  getch();
}