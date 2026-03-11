#include <math.h>
#include <stdio.h>
#include <limits.h>
#include <stdint.h>


int main (void){
    int64_t cantidad_sumas;
    int64_t cantidad_sumas_MAC;
    cantidad_sumas = 1<<24;
    cantidad_sumas_MAC = 1<<8;
    printf("Cantidad de sumas: %d\n", cantidad_sumas);
    printf("Cantidad de sumas MAC: %d\n", cantidad_sumas_MAC);
    return 0;
}