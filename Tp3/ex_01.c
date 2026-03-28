// Version: 002
// Date:    2022/04/05
// Author:  Rodrigo Gonzalez <rodralez@frm.utn.edu.ar>

// Compile usando el siguiente comando
// compile: gcc -Wall -std=c99 ex_01.c -o ex_01

#include <stdio.h>
#include <float.h>
#include <math.h>
#include <fenv.h>

typedef long int int64_t;

int main(void)
{	
	float a, b, c, f1, f2;
	double d1;

	a = 1000000000.0;	// mil millones
	b =   20000000.0;	// 20 millones
	c =   20000000.0;
	
	f1 = (a * b) * c;
	f2 = a * (b * c);

	d1 = (double) (a) * (double) (b) * (double) (c);

	printf("f1 = %lf \n", f1 );
	printf("f2 = %lf \n", f2 );
	printf("d1 = %lf \n", d1 );
	
	printf("Error en f1 = %10e \n", f1 - 400000000000000000000000.0 );
	printf("Error en f2 = %10e \n", f2 - 400000000000000000000000.0 );
	printf("Error en d1 = %20e \n", d1 - 400000000000000000000000.0 );
	
	double acum_1, acum_2;
	
	acum_1 = 0.0;
	for (int64_t i = 0; i < 10000000; i++){ acum_1 += 0.01; } 

	acum_2 = 0.0;
	b = 0.333;
	for (int64_t i = 0; i < 10000000; i++){ acum_2 += b / b; }
	
	printf("acum_1 = %f \n", acum_1 );
	printf("acum_2 = %f \n", acum_2 );
	
	printf("Error en acum_1 = %10e \n", acum_1 - (100000.0));
	printf("Error en acum_2 = %10e \n", acum_2 - (10000000.0));
	
	return 0;
}

//El objetivo principal es probar los problemas que se presentan en la precisión y redondeo al trabajar con float y double.
// En el caso de f1 y f2, podemos ver que no se cumple la propiedad asociativa (a⋅b)⋅c != a⋅(b⋅c). Cuando usamos dobule antes de hacer la multiplicación
// Lo que podemos ver es que aumenta la precisión debido a la cantidad de cifras significativas, por lo que el resultado final está mucho más cerca del
// valor real.

// Para acum1, 0.01 no puede representarse exactamente en binario. Entonces cada vez que se suma, se usa una aproximación de 0.01.
// Después de 10 millones de sumas, aparece un error acumulado.

// Para acum2 como se divide el número almacenado por sí mismo, el resultado sale exactamente 1.0 en punto flotante en este caso.
// Por lo tanto, no hay error acumulado.