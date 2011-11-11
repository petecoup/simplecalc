#include <iostream>
#include <string>
#include <stdlib.h>
#include "parser.c"

std::string getStr(const char* beg, const char* end)
{
    return std::string(beg).substr(0, end-beg);
}


%%{

machine calc;

action semi_tok {
   Parse(lparser, 0, 0);
}

action plus_tok {
   Parse(lparser, PLUS, 0);
}

action minus_tok {
   Parse(lparser, MINUS, 0);
}
                   
action times_tok {
   Parse(lparser, TIMES, 0);
}

action divide_tok {
   Parse(lparser, DIVIDE, 0);
}

action openp_tok {
   Parse(lparser, OPENP, 0);
}

action closep_tok {
   Parse(lparser, CLOSEP, 0);
}

action number_tok{ 
   Parse(lparser, DOUBLE, atof(getStr(ts, te).c_str()));
}

number = [0-9]+('.'[0-9]+)?;
plus = '+';
minus = '-';
openp = '(';
closep = ')';
times = '*';
divide = '/';
semi = ';';

main := |*
  number => number_tok;
  plus => plus_tok;
  minus => minus_tok;
  openp => openp_tok;
  closep => closep_tok;
  times => times_tok;
  divide => divide_tok;
  semi => semi_tok;
  space;
*|;

}%%

%% write data;

class Scan
{
public:
    ~Scan();
    void init();
    void execute(const char* data, size_t len);


private:
    int cs;
    int act;
    const char* ts;
    const char* te;

    void* lparser;
};

Scan::~Scan()
{
    ParseFree(lparser, free);
}

void
Scan::init()
{
    lparser = ParseAlloc(malloc);

    %% write init;
}

void
Scan::execute(const char* data, size_t len)
{
    const char* p = data;
    const char* pe = data + len;
    const char* eof = pe;

    %% write exec;
}

int main(int argc, char **argv)
{
    char buffer[4096];
    FILE* f;
    Scan scan;
    long numbytes;

    //Read the whole file into the buffer.
    f = fopen(argv[1], "r");
    fseek(f, 0, SEEK_END);
    numbytes = ftell(f);
    fseek(f, 0, SEEK_SET);
    fread(buffer, 1, numbytes, f);

    //Parse the buffer in one fell swoop.
    scan.init();
    scan.execute(buffer, numbytes);
    return 0;
}

