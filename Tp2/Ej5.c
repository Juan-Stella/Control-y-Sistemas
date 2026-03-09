#include <math.h>
#include <stdio.h>
#include <limits.h>
#include <stdint.h>

__int32 truncation(__int64 X, char n){
    __int64 x_trunc;
    x_trunc = (__int32)(X>>n);
    return x_trunc;
}

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


int64_t MAC1(int32_t A[], int32_t B[]){
    int32_t acum_32a = 0;

    for(int i=0; i < 5; i++)
        acum_32a += (int32_t) ( truncation( (int64_t) ( A[i] * B[i] ),10 ) );
    return acum_32a;
}

int32_t MAC2(int32_t A[], int32_t B[]){
    int64_t acum_64 = 0;
    int32_t acum_32b = 0;

    for(int i = 0; i < 5; i++)
        acum_64 += ((int64_t)A[i] * B[i]);
    

    acum_32b = truncation(acum_64, 10);

    return acum_32b;
}

int main (void){
    double X[5] = {1.1,2.2,3.3,4.4,5.5};
    double Y[5] = {6.6,7.7,8.8,9.9,10.10};

    double producto_acum = 0.0;

    for (int i=0; i<5; i++)
        producto_acum += X[i]*Y[i];

    int xq[5];
    int yq[5];

    for (int i=0; i<5; i++)
        xq[i] = fp2fx(X[i],10);
    for (int j=0; j<5; j++)
        yq[j] = fp2fx(Y[j],10);

    for (int i = 0; i < 5; i++)
        printf("Xq[%d] = %d\n", i, xq[i]);

    for (int j = 0; j < 5; j++)
        printf("Yq[%d] = %d\n", j, yq[j]);

    int32_t mac1 = MAC1(xq, yq);
    int32_t mac2 = MAC2(xq, yq);

    printf("MAC1 en Q21.10 = %d\n", mac1);
    printf("MAC1 en float  = %f\n", fx2fp(mac1, 10));

    printf("MAC2 en Q21.10 = %d\n", mac2);
    printf("MAC2 en float  = %f\n", fx2fp(mac2, 10));

    printf("Producto en double = %f\n", producto_acum);
  
    return 0;
}
