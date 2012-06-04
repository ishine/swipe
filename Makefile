# By default, "make; make install" gives you Python support. If you don't want 
# this, then you can run "make c installc". If you want control the 
# installation root (e.g., /, /usr, /usr/local), set the $PREFIX environmental
# variable. "bin" is appended automatically. Similarly, you can make a binary
# called something other than "swipe" by setting the $TARGET environmental
# variable.

TARGET=swipe
PREFIX=/usr/local

CFLAGS=-O2

all: c py
install: installc installpy

c:
	$(CC) $(CFLAGS) -o $(TARGET) swipe.c vector.c -lm -lc -lblas -llapack -lfftw3 -lsndfile

py:
	swig -python -threads swipe.i
	python setup.py build

installc: swipe
	install swipe $(PREFIX)/bin

installpy: swipe
	python setup.py install

clean: 
	python setup.py clean
	$(RM) -r build/ $(TARGET) swipe.py swipe.pyc swipe_wrap.c

test: swipe
	curl -O http://facstaff.bloomu.edu/jtomlins/Sounds/king.wav
	./swipe -ni king.wav
	python -c "import swipe; print swipe.Swipe('king.wav').regress(tmax=2.)"
	rm king.wav
