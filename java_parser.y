%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int line_num;
extern char* yytext;
extern FILE* yyin;
int yylex();
void yyerror(const char* s);
%}

/* Bison declarations */
%union {
    int ival;
    float fval;
    char* sval;
}

%token <sval> IDENTIFIER STRING_LITERAL
%token <ival> INTEGER_LITERAL
%token <fval> FLOAT_LITERAL

/* Keywords */
%token CLASS PUBLIC PRIVATE PROTECTED STATIC
%token VOID MAIN IF ELSE WHILE FOR DO
%token INT_TYPE FLOAT_TYPE DOUBLE_TYPE CHAR_TYPE STRING_TYPE BOOLEAN_TYPE
%token TRUE FALSE RETURN NEW

/* Operators */
%token PLUS MINUS MULTIPLY DIVIDE MOD
%token ASSIGN PLUSASSIGN MINUSASSIGN MULTASSIGN DIVASSIGN
%token INCREMENT DECREMENT
%token EQ NEQ GT LT GEQ LEQ AND OR NOT

/* Delimiters */
%token LBRACE RBRACE LPAREN RPAREN LBRACKET RBRACKET
%token SEMICOLON COMMA DOT

/* Associativity and precedence */
%left OR
%left AND
%left EQ NEQ
%left GT LT GEQ LEQ
%left PLUS MINUS
%left MULTIPLY DIVIDE MOD
%right NOT
%right UMINUS
%left LBRACKET RBRACKET DOT

%start program

%%

program
    : class_declaration
    ;

class_declaration
    : modifier CLASS IDENTIFIER class_body
    | CLASS IDENTIFIER class_body
    ;

modifier
    : PUBLIC
    | PRIVATE
    | PROTECTED
    | STATIC
    | modifier modifier
    ;

class_body
    : LBRACE class_body_declarations RBRACE
    | LBRACE RBRACE
    ;

class_body_declarations
    : class_body_declaration
    | class_body_declarations class_body_declaration
    ;

class_body_declaration
    : field_declaration
    | method_declaration
    | constructor_declaration
    ;

field_declaration
    : modifier type variable_declarators SEMICOLON
    | type variable_declarators SEMICOLON
    ;

variable_declarators
    : variable_declarator
    | variable_declarators COMMA variable_declarator
    ;

variable_declarator
    : IDENTIFIER
    | IDENTIFIER ASSIGN expression
    | IDENTIFIER LBRACKET RBRACKET
    | IDENTIFIER LBRACKET RBRACKET ASSIGN array_initializer
    | IDENTIFIER LBRACKET expression RBRACKET
    | IDENTIFIER LBRACKET expression RBRACKET ASSIGN expression
    ;

array_initializer
    : LBRACE variable_initializers RBRACE
    | LBRACE RBRACE
    ;

variable_initializers
    : expression
    | variable_initializers COMMA expression
    ;

method_declaration
    : method_header method_body
    ;

method_header
    : modifier type IDENTIFIER LPAREN parameter_list RPAREN
    | modifier type IDENTIFIER LPAREN RPAREN
    | modifier VOID IDENTIFIER LPAREN parameter_list RPAREN
    | modifier VOID IDENTIFIER LPAREN RPAREN
    | modifier VOID MAIN LPAREN STRING_TYPE LBRACKET RBRACKET IDENTIFIER RPAREN
    | type IDENTIFIER LPAREN parameter_list RPAREN
    | type IDENTIFIER LPAREN RPAREN
    | VOID IDENTIFIER LPAREN parameter_list RPAREN
    | VOID IDENTIFIER LPAREN RPAREN
    | VOID MAIN LPAREN STRING_TYPE LBRACKET RBRACKET IDENTIFIER RPAREN
    ;

parameter_list
    : parameter
    | parameter_list COMMA parameter
    ;

parameter
    : type IDENTIFIER
    | type IDENTIFIER LBRACKET RBRACKET
    ;

method_body
    : block
    ;

constructor_declaration
    : modifier IDENTIFIER LPAREN parameter_list RPAREN block
    | modifier IDENTIFIER LPAREN RPAREN block
    | IDENTIFIER LPAREN parameter_list RPAREN block
    | IDENTIFIER LPAREN RPAREN block
    ;

type
    : primitive_type
    | reference_type
    ;

primitive_type
    : INT_TYPE
    | FLOAT_TYPE
    | DOUBLE_TYPE
    | CHAR_TYPE
    | BOOLEAN_TYPE
    ;

reference_type
    : STRING_TYPE
    | IDENTIFIER
    | type LBRACKET RBRACKET
    ;

block
    : LBRACE block_statements RBRACE
    | LBRACE RBRACE
    ;

block_statements
    : block_statement
    | block_statements block_statement
    ;

block_statement
    : local_variable_declaration SEMICOLON
    | statement
    ;

local_variable_declaration
    : type variable_declarators
    ;

statement
    : block
    | SEMICOLON
    | expression SEMICOLON
    | IF LPAREN expression RPAREN statement
    | IF LPAREN expression RPAREN statement ELSE statement
    | WHILE LPAREN expression RPAREN statement
    | DO statement WHILE LPAREN expression RPAREN SEMICOLON
    | FOR LPAREN for_init SEMICOLON expression_opt SEMICOLON for_update RPAREN statement
    | RETURN expression_opt SEMICOLON
    ;

for_init
    : local_variable_declaration
    | expression_list
    | /* empty */
    ;

for_update
    : expression_list
    | /* empty */
    ;

expression_opt
    : expression
    | /* empty */
    ;

expression_list
    : expression
    | expression_list COMMA expression
    ;

expression
    : assignment
    | conditional_expression
    ;

assignment
    : lhs assignment_op expression
    ;

lhs
    : IDENTIFIER
    | field_access
    | array_access
    ;

assignment_op
    : ASSIGN
    | PLUSASSIGN
    | MINUSASSIGN
    | MULTASSIGN
    | DIVASSIGN
    ;

conditional_expression
    : conditional_or_expression
    ;

conditional_or_expression
    : conditional_and_expression
    | conditional_or_expression OR conditional_and_expression
    ;

conditional_and_expression
    : equality_expression
    | conditional_and_expression AND equality_expression
    ;

equality_expression
    : relational_expression
    | equality_expression EQ relational_expression
    | equality_expression NEQ relational_expression
    ;

relational_expression
    : additive_expression
    | relational_expression GT additive_expression
    | relational_expression LT additive_expression
    | relational_expression GEQ additive_expression
    | relational_expression LEQ additive_expression
    ;

additive_expression
    : multiplicative_expression
    | additive_expression PLUS multiplicative_expression
    | additive_expression MINUS multiplicative_expression
    ;

multiplicative_expression
    : unary_expression
    | multiplicative_expression MULTIPLY unary_expression
    | multiplicative_expression DIVIDE unary_expression
    | multiplicative_expression MOD unary_expression
    ;

unary_expression
    : postfix_expression
    | PLUS unary_expression
    | MINUS unary_expression %prec UMINUS
    | NOT unary_expression
    | INCREMENT unary_expression
    | DECREMENT unary_expression
    ;

postfix_expression
    : primary
    | postfix_expression INCREMENT
    | postfix_expression DECREMENT
    ;

primary
    : literal
    | LPAREN expression RPAREN
    | IDENTIFIER
    | method_invocation
    | field_access
    | array_access
    | NEW class_instance_creation
    ;

class_instance_creation
    : type LPAREN argument_list RPAREN
    | type LPAREN RPAREN
    | IDENTIFIER LBRACKET expression RBRACKET
    ;

method_invocation
    : IDENTIFIER LPAREN argument_list RPAREN
    | IDENTIFIER LPAREN RPAREN
    | field_access LPAREN argument_list RPAREN
    | field_access LPAREN RPAREN
    ;

field_access
    : primary DOT IDENTIFIER
    ;

array_access
    : IDENTIFIER LBRACKET expression RBRACKET
    | field_access LBRACKET expression RBRACKET
    ;

argument_list
    : expression
    | argument_list COMMA expression
    ;

literal
    : INTEGER_LITERAL
    | FLOAT_LITERAL
    | STRING_LITERAL
    | TRUE
    | FALSE
    ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "Error at line %d: %s near '%s'\n", line_num, s, yytext);
}

int main(int argc, char** argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file.java>\n", argv[0]);
        return 1;
    }
    
    FILE* input_file = fopen(argv[1], "r");
    if (!input_file) {
        fprintf(stderr, "Cannot open input file %s\n", argv[1]);
        return 1;
    }
    
    yyin = input_file;
    printf("Parsing Java file: %s\n", argv[1]);
    
    int parse_result = yyparse();
    
    fclose(input_file);
    
    if (parse_result == 0) {
        printf("Parsing completed successfully. No syntax errors found.\n");
        return 0;
    } else {
        printf("Parsing failed. Syntax errors found.\n");
        return 1;
    }
}
