// Version: 004
// Date:    2022/04/05
// Author:  Rodrigo Gonzalez <rodralez@frm.utn.edu.ar>

#define _GNU_SOURCE 1
#define _ISOC99_SOURCE
#include <fenv.h>

#include <float.h>
#include <math.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>


// Compile usando el siguiente comando
// compile: gcc -Wall -std=c99 ex_05.c -o ex_05 -lm -frounding-math
// -fsignaling-nans -DLINUX

// Variables globales
fexcept_t excepts;

void show_fe_exceptions(void) {
  printf("current exceptions raised: ");
  if (fetestexcept(FE_DIVBYZERO))
    printf(" FE_DIVBYZERO");
  if (fetestexcept(FE_INEXACT))
    printf(" FE_INEXACT");
  if (fetestexcept(FE_INVALID))
    printf(" FE_INVALID");
  if (fetestexcept(FE_OVERFLOW))
    printf(" FE_OVERFLOW");
  if (fetestexcept(FE_UNDERFLOW))
    printf(" FE_UNDERFLOW");
  if (fetestexcept(FE_ALL_EXCEPT) == 0)
    printf(" none");
  printf("\n");
}

void fpe_handler(int sig) {

  printf("UPS! Floating Point Exception \n");

  show_fe_exceptions();

  exit(EXIT_FAILURE);
}

int main(void) {
  feclearexcept(FE_ALL_EXCEPT);
  feenableexcept(FE_ALL_EXCEPT);

  //~ signal(SIGFPE, fpe_handler);

  /* Setup a "current" set of exception flags. */
  feraiseexcept(FE_INVALID);
  show_fe_exceptions();

  //~ /* Temporarily raise two other exceptions. */
  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_OVERFLOW | FE_INEXACT);
  show_fe_exceptions();

  //~ double s;
  //  s = 1.0 / 0.0;  // FE_DIVBYZERO
  //  s = 0.0 / 0.0;  // FE_INVALID
  //  show_fe_exceptions();

  return 0;
}

// Si, es consistente debido a que se printean las excepciones levantadas, que
// son las que se le pasan por parametro a feraiseexcept, em ambos casos antes y
// después de limpiar

// Descomentando las líneas 44 y 45 el programa finaliza con un código de error
// 136, que es el correspondiente  a SIGFPE (Floating Point Exception). Esto se
// debe a que se está levantando una excepción de punto flotante y no se está
// manejando, por lo que el programa termina abruptamente.

// ...Program finished with exit code 136
// Press ENTER to exit console.

// Luego, al descomentar la línea 47, el programa  finaliza con un código de
// error 1, ya que se está manejando la excepción de punto flotante.

// UPS! Floating Point Exception
// current exceptions raised:  none

// ...Program finished with exit code 1
// Press ENTER to exit console.
