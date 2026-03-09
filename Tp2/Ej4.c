#include <math.h>
#include <stdio.h>
#include <limits.h>
#include <stdint.h>

int32_t saturation(int32_t a, int32_t b){
    int64_t c = (int64_t)a+b;
    if (c > INT32_MAX )
        return INT32_MAX ;
    if (c < INT32_MIN )
        return INT32_MIN;
    return (int32_t)c;
}

int main(void) {
    int32_t a = 2147483647;
    int32_t b = 1;
    int32_t c = saturation(a,b);
    printf("Saturation result = %d\n", c);
    return 0;
}
