#include <fenv.h>
#include <float.h>
#include <math.h>
#include <stdio.h>

int main(void) {
  float a = INFINITY;
  float b = NAN;

  float c, d;

  c = 1.0 / 0.0;
  d = 0.0 / 0.0;

  printf("infinito: %f\n", a);
  printf("NAN: %f\n", b);
  printf("infinito generado: %f\n", c);
  printf("NAN generado: %f\n", d);
  return 0;
}