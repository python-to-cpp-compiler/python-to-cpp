#include <stdio.h>
int main (int argc, char* argv[]) {
double a;
double t0=12.000000;
a = t0;

double b;
double t1=2.230000;
double  t2 = - t1;
b = t2;

double f;
double t3=324.000000;
f = t3;

double c;
double t4=a;
double t5=b;
double  t6 = t4 * t5;
double t7=f;
double  t8 = t6 + t7;
c = t8;


double t9=c;
printf("%f\n",t9);

return 0;
}