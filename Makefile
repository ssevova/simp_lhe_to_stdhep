
INCDIR = 
FFLAGS = -O2 -fno-automatic
X11LIB=/usr/X11R6/lib
CERNLIB=/cern/2002/lib
LOADLIBS=-L$(CERNLIB) -L$(X11LIB)
LDLIBS=-lkernlib -lmathlib -lpacklib -ldl -lcrypt -lX11 -lstdhep -lFmcfio
FC = g77

#######	Files
SOURCES = hadwrt_test.f

OBJECTS	= hadwrt_test.o


#######	Implicit rules

.SUFFIXES: .o .f

.f.o:
	$(FC) -c $(FFLAGS) $<

#######	Build rules

hadwrt_test: $(OBJECTS) 
	$(FC) $(OBJECTS) -o hadwrt_test $(LOADLIBS) $(LDLIBS)

showfiles:
	@echo $(SOURCES) $(HEADERS) Makefile

clean:
	-rm -f *.o *.bak *BAK *~ *% #*
	-rm -f $(TARGET) $(SRCMETA)

# DO NOT DELETE THIS LINE -- make depend depends on it.
