%module test_scanner

/* Wrap only the 'scan' function */
%{
int scan(char*, char*, char*, char*);
%}

int scan(char*, char*, char*, char*);
