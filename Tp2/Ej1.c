#include <math.h>
#include <stdio.h>
void main(void)
{
signed char a, b, c, d, s1, s2;
a = 127;
b = 127;
c = a + b;
d = a * b;
s1 = (-8) >> 2;
s2 = (-1) >> 5;
printf("c = %d \n", c );
printf("d = %d \n", d );
printf("s1 = %d \n", s1 );
printf("s2 = %d \n", s2 );

signed char a1,b1,s11,s22;
int c1, d1;
a1 = 127;
b1 = 127;
c1 = a1 + b1;
d1 = a1 * b1;
s11 = (-8) >> 2;
s22 = (-1) >> 5;
printf("c1 = %d \n", c1 );
printf("d1 = %d \n", d1 );

}


