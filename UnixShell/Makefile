CXX = c++
CFLAGS = --std=c++11
LFLAGS = -lreadline
OFILES = main.o shelpers.o
CXXSOURCE = main.cpp shelpers.cpp
HEADERS = shelpers.hpp
COMP = -c
LINK = -o

.PHONY: shell
#Linking all *.o files
shell: $(OFILES)
	$(CXX) $(CFLAGS) $(LINK) shell $(OFILES) $(LFLAGS)

#Compiling all source and header files into .o files
$(OFILES): $(CXXSOURCE) $(HEADERS)
	$(CXX) $(CFLAGS) $(COMP) $(CXXSOURCE)

.PHONY: clean
#Cleaning rule
clean:
	rm -f *.o shell

.PHONY: run
run: shell
	./shell
