CC		:= gcc
FLAGS	:= 

mian: min.o max.o main.o
	$(CC) $(FLAGS) main.o min.o max.o $@

min.o: min.h min.c
	$(CC) $(FLAGS) -c min.c

max.o: max.h max.c
	$(CC) $(FLAGS) -c max.c

clean:
	@rm -f *.o
	@rm -f main