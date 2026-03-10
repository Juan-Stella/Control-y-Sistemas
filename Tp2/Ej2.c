#include <math.h>
#include <stdio.h>
#include <limits.h>
#include <stdint.h>

float fx2fp(int32_t valor, char n) {
    float resultado;
    resultado = (float)valor /(1<<n);
    return resultado;
}

int32_t fp2fx(float valor, char n) {
    int32_t resultado;
    resultado = (int32_t)(valor * (1<<n));
    return resultado;
}

int main(void) {
    float b,b21,b10;


    b = fx2fp(fp2fx(2.4515, 4), 4);
    printf("b = %f\n", b);

    b21 = fx2fp(fp2fx(2.4515, 8), 8);
    printf("b = %f\n", b21);

    b10 = fx2fp(fp2fx(2.4515, 10), 10);
    printf("b = %f\n", b10);

    return 0;
}