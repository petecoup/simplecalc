calc: lexer.o
	g++ lexer.o -o calc

parser.c: parser.y
	lemon parser.y

parser.h: parser.y
	lemon parser.y

lexer.cpp: lexer.rl parser.h parser.c
	ragel lexer.rl -o lexer.cpp

lexer.o: lexer.cpp
	g++ -c lexer.cpp

clean:
	rm -f *.o lexer.cpp parser.h parser.c parser.out calc

