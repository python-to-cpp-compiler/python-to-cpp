#include <stdio.h>
int main (int argc, char* argv[]) {
double c;
double t0=3.000000;
double t1=5.000000;
double  t2 = t0 * t1;
double t3=4.000000;
double  t4 = t2 - t3;
c = t4;

double t5=3.000000;
double t6=4.000000;
double  t7 = t5 > t6;
if(t7){

double a;
double t8=2.000000;
a = t8;

}
else {

double b;
double t9=8.000000;
double t10=2.000000;
double  t11 = t9 * t10;
b -= t11;

}

double i;
double t12=4.000000;
double t13=7.000000;
double t14=1.000000;
for(i = t12; i < t13 ;i=i + t14){

double m;
double t15=i;
m = t15;

}

double a;
double t16=4.000000;
a = t16;

double t17=a;
double t18=4.000000;
double  t19 = t17 < t18;
while(t19){

double t20=1.000000;
a += t20;

t17=a;
t18=4.000000;
 t19 = t17 < t18;
}


double t21=c;
double t22=4.000000;
double  t23 = t21 + t22;
printf("%f\n",t23);

return 0;
}