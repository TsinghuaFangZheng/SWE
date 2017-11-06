EXEC = main 
CC=gfortran-7
CFLAGS=-I/usr/local/Cellar/gcc/7.2.0/lib/gcc/7/gcc/x86_64-apple-darwin16.7.0/7.2.0/include 
LDFLAGS=-L/usr/local/Cellar/gcc/7.2.0/lib/gcc/7
LIBS=-fopenmp
SOURCES = $(wildcard *.F90)
HEADERS = $(wildcard *.h)
OBJECTS = $(SOURCES:.F90=.o)

all: $(EXEC)

$(EXEC): $(OBJECTS)
	$(CC) $(LDFLAGS) $(LIBS) -O $(OBJECTS) -o $(EXEC)

%.o: %.F90 $(HEADERS)
	$(CC) $(CFLAGS) $(LIBS) -c $< -o $@

.PHONY: clean run
clean:
	rm -f $(EXEC) $(OBJECTS)

run:
	./$(EXEC)
