# Java Syntax Analyzer

**Dilla University, Computer Science Department**  
**Compiler Design Project**

A lexical and syntax analyzer for a subset of Java that implements token printing to show the parsing process.

## How to Run

```
win_bison -d -y -Wno-conflicts-sr java_parser.y
win_flex java_lexer.l
gcc -std=c99 -o java_parser.exe lex.yy.c y.tab.c
.\java_parser.exe test.java
```

## Project Components
- **java_lexer.l**: Lexical analyzer with token printing
- **java_parser.y**: Grammar rules for Java syntax
- **test.java**: Sample Java program for testing
