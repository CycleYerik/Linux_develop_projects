#include <stdio.h>

#include "utils.h"

int main(void) {
    printf("Basic Project Example — version %s\n", utils_version());
    printf("demo: utils_add(2, 3) = %d\n", utils_add(2, 3));
    return 0;
}
