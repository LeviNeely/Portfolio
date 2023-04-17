CXX = c++
CFLAGS = --std=c++11 -g -O0 -fsanitize=address
OFILES = main.o MSDMalloc.o HashTable.o
CXXSOURCE = main.cpp MSDMalloc.cpp HashTable.cpp
HEADERS = MSDMalloc.h HashTable.h
COMP = -c
LINK = -o

.PHONY: msdmalloc
msdscript: $(OFILES)
	$(CXX) $(CFLAGS) $(LINK) msdmalloc $(OFILES)

$(OFILES): $(CXXSOURCE) $(HEADERS)
	$(CXX) $(CFLAGS) $(COMP) $(CXXSOURCE)

.PHONY: clean
clean:
	rm -f *.o msdmalloc

.PHONY: test
test: msdmalloc
	./msdmalloc --test

.PHONY: benchmark
benchmark: msdmalloc
	./msdmalloc --benchmark
