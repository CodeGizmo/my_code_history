GREGORIO, Lenin                                         February 5, 1996
ECE-3                                                   Mr. Dizon

ASSIGNMENT

#include <stdio.h>
void main()
{
  int N,I,prime;
  for(N=2;N<=100;N++) //Starting at 2 since 1 and below is not a prime number.
  {
    I = 2;          //Initializing the divisor to 2 as a 1st possible factor.
    prime = 1;      //Assuming that the current number is a prime number.
    while(I <= N/2) //No need to go beyond N/2.
    {
      if (N%I==0)   //Verifying if the number is divisible by any factor.
        prime=0;    //If the number is divisible by any factor this is done.
      I++;          //Go to the next divisor.
    }
    if (prime==1) printf("%d\n",N*N); //Prints the square of a prime number.
  }
}
