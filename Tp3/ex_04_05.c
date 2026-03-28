#include <stdio.h>
#include <float.h>
#include <math.h>
#include <signal.h>
#include <stdlib.h>

#define _GNU_SOURCE 1
#define _ISOC99_SOURCE
#include <fenv.h>


void show_fe_exceptions(void)
{
    printf("current exceptions raised: ");
    if(fetestexcept(FE_DIVBYZERO))     printf(" FE_DIVBYZERO");
    if(fetestexcept(FE_INEXACT))       printf(" FE_INEXACT");
    if(fetestexcept(FE_INVALID))       printf(" FE_INVALID");
    if(fetestexcept(FE_OVERFLOW))      printf(" FE_OVERFLOW");
    if(fetestexcept(FE_UNDERFLOW))     printf(" FE_UNDERFLOW");
    if(fetestexcept(FE_ALL_EXCEPT)==0) printf(" none");
    printf("\n");
}

int main(void)
{
    volatile float a, b, c, d, e;

    // VARIABLES VOLÁTILES DE ENTRADA
    // Estas variables frenan en seco al compilador para que no resuelva las
    // cuentas por adelantado cuando usas el botón de "Run normal".
    volatile float cero = 0.0f;
    volatile float uno = 1.0f;
    volatile float dos = 2.0f;
    volatile float tres = 3.0f;
    volatile float cien = 100.0f;
    volatile float v_max = FLT_MAX;
    volatile float v_min = FLT_MIN;

    // Genera FE_INVALID
    a = cero/cero;
    show_fe_exceptions();
    feclearexcept(FE_ALL_EXCEPT);


    // Genera FE_DIVBYZERO
    b = uno/cero;
    show_fe_exceptions();
    feclearexcept(FE_ALL_EXCEPT);


    // Genera FE_OVERFLOW (Pasarse del límite máximo de float)
    c = v_max * dos;
    show_fe_exceptions();
    feclearexcept(FE_ALL_EXCEPT);


    // Genera FE_UNDERFLOW (Pasarse del límite minúsculo cercano a cero)
    d = v_min / cien;
    show_fe_exceptions();
    feclearexcept(FE_ALL_EXCEPT);


    // Genera FE_INEXACT (1 dividido 3 pierde precision en binario)
    e = uno/tres;
    show_fe_exceptions();
    feclearexcept(FE_ALL_EXCEPT);


    // Lo imprimimos todo junto al final para "engañar" al compilador 
    // y que no nos borre el código con su optimización -O3
    printf("\nVariables: a=%f, b=%f, c=%f, d=%f, e=%f\n", a, b, c, d, e);

    return 0;
}