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

__int32 trunctation(__int64 X, char n){
    __int64 x_trunc;
    x_trunc = (__int32)(X>>n);
    return x_trunc;
}

__int32 rounding(__int64 X, char n){
    return trunctation(X+(1<<(n-1)),10);
}


int main(void) {
    double a = 2.4515;
    double b = 1.327;
    double resultado_real  = a*b;
    __int32 qa = fp2fx(a,10);
    __int32 qb = fp2fx(b,10);
    __int64 multip_en_Q = (__int64)(qa * qb);
    __int32 trunc = trunctation (multip_en_Q,10);
    __int32 redond = rounding (multip_en_Q,10);

    float trunc_fp = fx2fp(trunc, 10);
    float redond_fp = fx2fp(redond, 10);

    printf("Resultado real        = %f\n", resultado_real);
    printf("Truncation result     = %f\n", trunc_fp);
    printf("Rounding result       = %f\n", redond_fp);
    return 0;
}