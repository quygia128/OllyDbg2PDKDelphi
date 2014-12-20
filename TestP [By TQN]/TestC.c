#define UNICODE

#include <windows.h>
#include <stdio.h>
#include <stdlib.h>

#include "plugin.h"

void main(void)
{
    printf("%d\n", sizeof(t_font));
    printf("%d\n", sizeof(CONTEXT));
}

