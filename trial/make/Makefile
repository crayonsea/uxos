CC		:= gcc
FLAGS	:= -c

main: min.o max.o main.o
    $(CC) main.o min.o max.o -o $@

min.o: min.h min.c
    $(CC) $(FLAGS) -o min.o min.c

max.o: max.h max.c
    $(CC) $(FLAGS) -o max.o max.c

main.o: main.c
    $(CC) $(FLAGS) -o main.o main.c

clean:
    @rm -f *.o
    @rm -f main