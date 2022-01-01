#include <stdio.h>
int main (int argc, char* argv[]) {
<<<<<<< HEAD
double x;
double t0=7.000000;
double t1=0.000000;
double  t2 = t0 < t1;
x = t2;

double t3=8.000000;
double t4=4.000000;
double  t5 = t3 + t4;
x = t5;

double t6=3.000000;
double t7=4.000000;
double  t8 = t6 > t7;
if(t8){

double a;
double t9=2.000000;
a = t9;
=======
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
>>>>>>> 6b5d84f19f30565a66a491fcb72230ec0078ab2f

}
else {

double b;
<<<<<<< HEAD
double t10=8.000000;
double t11=2.000000;
double  t12 = t10 * t11;
b -= t12;
=======
double t9=8.000000;
double t10=2.000000;
double  t11 = t9 * t10;
b -= t11;
>>>>>>> 6b5d84f19f30565a66a491fcb72230ec0078ab2f

}

double i;
<<<<<<< HEAD
double t13=4.000000;
double t14=7.000000;
double t15=1.000000;
for(i = t13; i < t14 ;i=i + t15){

double m;
double t16=i;
m = t16;
=======
double t12=4.000000;
double t13=7.000000;
double t14=1.000000;
for(i = t12; i < t13 ;i=i + t14){

double m;
double t15=i;
m = t15;
>>>>>>> 6b5d84f19f30565a66a491fcb72230ec0078ab2f

}

double a;
<<<<<<< HEAD
double t17=4.000000;
a = t17;

double t18=a;
double t19=4.000000;
double  t20 = t18 < t19;
while(t20){

double t21=1.000000;
a += t21;

t18=a;
t19=4.000000;
 t20 = t18 < t19;
=======
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
>>>>>>> 6b5d84f19f30565a66a491fcb72230ec0078ab2f
}


double t21=c;
double t22=4.000000;
double  t23 = t21 + t22;
printf("%f\n",t23);

return 0;
}