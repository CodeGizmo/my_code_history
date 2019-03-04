#include <stdio.h>
#include <conio.h>
void main()
{
  int i,num,sum;
  printf("Enter a number: ");
  scanf("%d",&num);
  sum=0;
  for(i=1;i<=num;i++)
    if(i%2==0)sum = sum + i;
  printf("The sum of all even numbers from 1 to %d is %d",num,sum);
  getch();
}