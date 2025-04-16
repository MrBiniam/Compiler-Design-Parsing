%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

/* Helper function to safely duplicate strings */
char* safe_strdup(char* s) {
    if (!s) return NULL;
    size_t len = strlen(s) + 1;
    char* new_str = (char*)malloc(len);
    if (new_str) {
        memcpy(new_str, s, len);
    }
    return new_str;
}

/* Flag to control token printing */
int print_tokens = 1;

int line_num = 1;
%}

%option noyywrap

/* Regular expressions for tokens */
DIGIT       [0-9]
LETTER      [a-zA-Z]
ID          {LETTER}({LETTER}|{DIGIT}|_)*
INT         {DIGIT}+
FLOAT       {DIGIT}+\.{DIGIT}*
STRING      \"[^\"]*\"
COMMENT1    \/\/.*
COMMENT2    \/\*([^*]|\*+[^*/])*\*+\/
WS          [ \t\n\r]+

%%

{WS}            { /* Skip whitespace */
                  /* Count newlines */
                  for(int i=0; i < yyleng; i++) {
                      if(yytext[i] == '\n') line_num++;
                  }
                }
{COMMENT1}      { /* Skip single-line comments */ }
{COMMENT2}      { /* Skip multi-line comments */
                  /* Count newlines in comments */
                  for(int i=0; i < yyleng; i++) {
                      if(yytext[i] == '\n') line_num++;
                  }
                }

"class"         { if (print_tokens) printf("TOKEN: CLASS\n"); return CLASS; }
"public"        { if (print_tokens) printf("TOKEN: PUBLIC\n"); return PUBLIC; }
"private"       { if (print_tokens) printf("TOKEN: PRIVATE\n"); return PRIVATE; }
"protected"     { if (print_tokens) printf("TOKEN: PROTECTED\n"); return PROTECTED; }
"static"        { if (print_tokens) printf("TOKEN: STATIC\n"); return STATIC; }
"void"          { if (print_tokens) printf("TOKEN: VOID\n"); return VOID; }
"main"          { if (print_tokens) printf("TOKEN: MAIN\n"); return MAIN; }
"if"            { if (print_tokens) printf("TOKEN: IF\n"); return IF; }
"else"          { if (print_tokens) printf("TOKEN: ELSE\n"); return ELSE; }
"while"         { if (print_tokens) printf("TOKEN: WHILE\n"); return WHILE; }
"for"           { if (print_tokens) printf("TOKEN: FOR\n"); return FOR; }
"do"            { if (print_tokens) printf("TOKEN: DO\n"); return DO; }
"int"           { if (print_tokens) printf("TOKEN: INT_TYPE\n"); return INT_TYPE; }
"float"         { if (print_tokens) printf("TOKEN: FLOAT_TYPE\n"); return FLOAT_TYPE; }
"double"        { if (print_tokens) printf("TOKEN: DOUBLE_TYPE\n"); return DOUBLE_TYPE; }
"char"          { if (print_tokens) printf("TOKEN: CHAR_TYPE\n"); return CHAR_TYPE; }
"String"        { if (print_tokens) printf("TOKEN: STRING_TYPE\n"); return STRING_TYPE; }
"boolean"       { if (print_tokens) printf("TOKEN: BOOLEAN_TYPE\n"); return BOOLEAN_TYPE; }
"true"          { if (print_tokens) printf("TOKEN: TRUE\n"); return TRUE; }
"false"         { if (print_tokens) printf("TOKEN: FALSE\n"); return FALSE; }
"return"        { if (print_tokens) printf("TOKEN: RETURN\n"); return RETURN; }
"new"           { if (print_tokens) printf("TOKEN: NEW\n"); return NEW; }

"+"             { if (print_tokens) printf("TOKEN: PLUS\n"); return PLUS; }
"-"             { if (print_tokens) printf("TOKEN: MINUS\n"); return MINUS; }
"*"             { if (print_tokens) printf("TOKEN: MULTIPLY\n"); return MULTIPLY; }
"/"             { if (print_tokens) printf("TOKEN: DIVIDE\n"); return DIVIDE; }
"%"             { if (print_tokens) printf("TOKEN: MOD\n"); return MOD; }
"="             { if (print_tokens) printf("TOKEN: ASSIGN\n"); return ASSIGN; }
"+="            { if (print_tokens) printf("TOKEN: PLUSASSIGN\n"); return PLUSASSIGN; }
"-="            { if (print_tokens) printf("TOKEN: MINUSASSIGN\n"); return MINUSASSIGN; }
"*="            { if (print_tokens) printf("TOKEN: MULTASSIGN\n"); return MULTASSIGN; }
"/="            { if (print_tokens) printf("TOKEN: DIVASSIGN\n"); return DIVASSIGN; }
"++"            { if (print_tokens) printf("TOKEN: INCREMENT\n"); return INCREMENT; }
"--"            { if (print_tokens) printf("TOKEN: DECREMENT\n"); return DECREMENT; }
"=="            { if (print_tokens) printf("TOKEN: EQ\n"); return EQ; }
"!="            { if (print_tokens) printf("TOKEN: NEQ\n"); return NEQ; }
">"             { if (print_tokens) printf("TOKEN: GT\n"); return GT; }
"<"             { if (print_tokens) printf("TOKEN: LT\n"); return LT; }
">="            { if (print_tokens) printf("TOKEN: GEQ\n"); return GEQ; }
"<="            { if (print_tokens) printf("TOKEN: LEQ\n"); return LEQ; }
"&&"            { if (print_tokens) printf("TOKEN: AND\n"); return AND; }
"||"            { if (print_tokens) printf("TOKEN: OR\n"); return OR; }
"!"             { if (print_tokens) printf("TOKEN: NOT\n"); return NOT; }

"{"             { if (print_tokens) printf("TOKEN: LBRACE\n"); return LBRACE; }
"}"             { if (print_tokens) printf("TOKEN: RBRACE\n"); return RBRACE; }
"("             { if (print_tokens) printf("TOKEN: LPAREN\n"); return LPAREN; }
")"             { if (print_tokens) printf("TOKEN: RPAREN\n"); return RPAREN; }
"["             { if (print_tokens) printf("TOKEN: LBRACKET\n"); return LBRACKET; }
"]"             { if (print_tokens) printf("TOKEN: RBRACKET\n"); return RBRACKET; }
";"             { if (print_tokens) printf("TOKEN: SEMICOLON\n"); return SEMICOLON; }
","             { if (print_tokens) printf("TOKEN: COMMA\n"); return COMMA; }
"."             { if (print_tokens) printf("TOKEN: DOT\n"); return DOT; }

{INT}           { if (print_tokens) printf("TOKEN: INTEGER_LITERAL (%s)\n", yytext); yylval.ival = atoi(yytext); return INTEGER_LITERAL; }
{FLOAT}         { if (print_tokens) printf("TOKEN: FLOAT_LITERAL (%s)\n", yytext); yylval.fval = atof(yytext); return FLOAT_LITERAL; }
{STRING}        { if (print_tokens) printf("TOKEN: STRING_LITERAL (%s)\n", yytext); yylval.sval = safe_strdup(yytext); return STRING_LITERAL; }
{ID}            { if (print_tokens) printf("TOKEN: IDENTIFIER (%s)\n", yytext); yylval.sval = safe_strdup(yytext); return IDENTIFIER; }

.               { printf("Error at line %d: Unrecognized character '%s'\n", line_num, yytext); }

%%
