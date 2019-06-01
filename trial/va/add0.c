#include <stdio.h>

/*
    params:
    func(a1, a2, a3) -->
    push a3
    push a2
    push a1
    call func
    add esp, 4*4
*/

int add(int argc, ...)
{
    int sum = 0;
    int *ap = &argc + 1;        // +1 means ADD 1 INT (4 Byte)

    for (int i=0; i<argc; i++) {
        sum += *(ap);
        ap++;
    }

    return sum;
}

int main()
{
    printf("add(1, 11) = %d\n", add(1, 11));
    printf("add(2, 11, 22) = %d\n", add(2, 11, 22));
    printf("add(3, 11, 22, 33) = %d\n", add(3, 11, 22, 33));

    return 0;
}

// cc -m32 -o add0 add0.c