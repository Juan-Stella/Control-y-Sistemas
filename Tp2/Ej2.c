#include <math.h>
#include <stdio.h>

float fx2fp(int valor, char n) {
    float resultado;
    resultado = (float)valor /(1<<n);
    return resultado;
}

int fp2fx(float valor, char n) {
    int resultado;
    resultado = (int)(valor * (1<<n));
    return resultado;
}

int main(void) {
    float b,b21,b10;


    b = fx2fp(fp2fx(2.4515, 4), 4);
    printf("b = %f\n", b);

    b21 = fx2fp(fp2fx(2.4515, 21), 21);
    printf("b = %f\n", b21);

    b10 = fx2fp(fp2fx(2.4515, 10), 10);
    printf("b = %f\n", b10);

    return 0;
}