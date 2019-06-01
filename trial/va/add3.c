#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

// gcc -m32 -0 add3 add3.c -std=c99

int has_next(const char* s, int* ppos, int* ptype)
{
	int pos = *ppos;
	while (s[pos] == ' ') pos++;
	
	const char* cur_arg = s + pos;
	*ppos = pos + 2;
	
	if (strncmp("%d", cur_arg, 2) == 0) {
		return (*ptype) = 1;
	} 
	if (strncmp("%s", cur_arg, 2) == 0) {
		return (*ptype) = 2;
	}
	
	return 0;
}

int add(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	
	int sum = 0, arg;
	int pos = 0, type;
	while (has_next(format, &pos, &type)) {
		// get param
		if (type == 1) {			// int
			arg = va_arg(ap, int);
		} else if (type == 2) {		// string
			arg = atoi(va_arg(ap, char*));
		}
		// add param
		sum += arg;
	}
	
	va_end(ap);
	
	return sum;
}

int main()
{
    printf("int + int: sum = %d\n", add("%d %d", 11, 22));
    printf("str + str: sum = %d\n", add("%s %s", "11", "22"));
    printf("int + str: sum = %d\n", add("%d %s", 11, "22"));

	return 0;
}