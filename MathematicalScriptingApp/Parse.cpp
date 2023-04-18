/**
 * \file Parse.cpp
 * \brief Contains functions used to parse input from the user or a file
 *
 * This file contains the definitions of the methods used to parse either the input from a user or an input file in order
 * to interpret, print, or pretty print an expression
 *
 * \author Levi Neely
 */

#include "Parse.h"
#include "Expr.h"
#include <iostream>

using namespace std;

/**
 * \brief Method used to parse an expression
 * \param in the source of the input
 * \return a fully-parsed expression
 */
PTR(Expr) parse_expr(istream &in) {
    PTR(Expr) e = parse_comparg(in);
    skip_whitespace(in);
    int c = in.peek();
    if (c == '=') {
        consume(in, '=');
        c = in.peek();
        if (c == '=') {
            consume(in, '=');
            PTR(Expr) rhs = parse_expr(in);
            return NEW(EqExpr)(e, rhs);
        }
        else {
            throw runtime_error("invalid input");
        }
    }
    else {
        return e;
    }
}

/**
 * \brief Method used to parse a comparg (a way to recursively parse input)
 * \param in the source of the input
 * \return a fully-parsed expression
 */
PTR(Expr) parse_comparg(istream &in) {
    PTR(Expr) e = parse_addend(in);
    skip_whitespace(in);
    int c = in.peek();
    if (c == '+') {
        consume(in, '+');
        PTR(Expr) rhs = parse_comparg(in);
        return NEW(AddExpr)(e, rhs);
    }
    else {
        return e;
    }
}

/**
 * \brief A method used to parse an addend (another part of recursive parsing)
 * \param in the source of the input
 * \return a parsed addend
 */
PTR(Expr) parse_addend(istream &in) {
    PTR(Expr) e = parse_multicand(in);
    skip_whitespace(in);
    int c = in.peek();
    if (c == '*') {
        consume(in, '*');
        PTR(Expr) rhs = parse_addend(in);
        return NEW(MultExpr)(e, rhs);
    }
    else {
        return e;
    }
}

/**
 * \brief A method used to parse a multicand (another part of the recursive parsing)
 * @param in the source of the input
 * @return a parsed multicand
 */
PTR(Expr) parse_multicand(istream &in) {
    PTR(Expr) e = parse_inner(in);
    skip_whitespace(in);
    while (in.peek() == '(') {
        consume(in, '(');
        PTR(Expr) rhs = parse_expr(in);
        consume(in, ')');
        return NEW(CallExpr)(e, rhs);
    }
    return e;
}

/**
 * \brief A method used to parse an inner (another part of recursive parsing)
 * \param in the source of the input
 * \return a parsed inner
 */
PTR(Expr) parse_inner(istream &in) {
    skip_whitespace(in);
    PTR(Expr) e;
    int c = in.peek();
    if ((c == '-') || isdigit(c)) {
        return parse_num(in);
    }
    else if (c == '(') {
        consume(in, '(');
        e = parse_expr(in);
        skip_whitespace(in);
        c = in.get();
        if (c != ')') {
            throw runtime_error("missing parenthesis");
        }
        return e;
    }
    else if (isalpha(c)) {
        return parse_var(in);
    }
    else if (c == '_') {
        string keyWord = parse_keyword(in);
        if (keyWord == "_let") {
            return parse_let(in);
        }
        else if (keyWord == "_false") {
            return NEW(BoolExpr)(false);
        }
        else if (keyWord == "_true") {
            return NEW(BoolExpr)(true);
        }
        else if (keyWord == "_if") {
            return parse_if(in);
        }
        else if (keyWord == "_fun") {
            return parse_function(in);
        }
    }
    else {
        consume(in, c);
        throw runtime_error("invalid input");
    }
    return e;
}

/**
 * \brief A helper method to parse individual keywords into strings
 * \param in the source of the input
 * \return a string representing the keyword
 */
string parse_keyword(istream &in) {
    int c = in.peek();
    string keyWord = "";
    keyWord += c;
    consume(in, c);
    while ((c = in.peek()) && isalpha(c)) {
        consume(in, c);
        keyWord += c;
    }
    return keyWord;
}

/**
 * \brief A method used to parse a NumExpr expression
 * \param in the source of the input
 * \return a fully parsed NumExpr expression
 */
PTR(Expr) parse_num(istream &in) {
    long double n = 0;
    bool negative = false;
    if (in.peek() == '-') {
        negative = true;
        consume(in, '-');
    }
    while (1) {
        int decimalPlace = 10;
        int c = in.peek();
        if (isdigit(c)) {
            consume(in, c);
            n = n * decimalPlace + (c - '0');
        }
        else {
            break;
        }
    }
    if (negative && n != 0) {
        n = -n;
    }
    else if (negative && n == 0){
        throw runtime_error("invalid input");
    }
    else if (n > INT_MAX || n < INT_MIN) {
        throw runtime_error("Number outside range");
    }
    return NEW(NumExpr)(n);
}

/**
 * \brief A method used to parse a VarExpr expression
 * \param in the source of the input
 * \return a fully-parsed VarExpr expression
 */
PTR(Expr) parse_var(istream &in) {
    string variable = "";
    int c = in.peek();
    while (true) {
        if (isalpha(c)) {
            variable += c;
            consume(in, c);
            c = in.peek();
        }
        else {
            break;
        }
    }
    if (!isspace(c) && c != EOF && c != ')' && c != '(' && c != '=' && c != '+' && c != '*') {
        throw runtime_error("invalid input");
    }
    return NEW(VarExpr)(variable);
}

/**
 * \brief A method used to parse a LetExpr expression
 * \param in the source of the input
 * \return a fully-parsed LetExpr expression
 */
PTR(Expr) parse_let(istream &in) {
    string compareIn = "";
    string variable = "";
    skip_whitespace(in);
    int v = in.peek();
    while (isalpha(v)) {
        consume(in, v);
        variable += v;
        v = in.peek();
    }
    skip_whitespace(in);
    consume(in, '=');
    skip_whitespace(in);
    PTR(Expr) rhs = parse_expr(in);
    skip_whitespace(in);
    int c = in.peek();
    compareIn += c;
    consume(in, c);
    while ((c = in.peek()) && isalpha(c)) {
        consume(in, c);
        compareIn += c;
    }
    PTR(Expr) body;
    if (compareIn == "_in") {
        skip_whitespace(in);
        body = parse_expr(in);
    }
    else {
        throw runtime_error("invalid input");
    }
    return NEW(LetExpr)(variable, rhs, body);
}

/**
 * \brief A method used to parse an IfExpr from an input stream
 * \param in the input stream to read from
 * \return a fully parsed IfExpr
 */
PTR(Expr) parse_if(istream &in) {
    string compareThen = "";
    string compareElse = "";
    skip_whitespace(in);
    PTR(Expr) conditionExpr = parse_expr(in);
    skip_whitespace(in);
    int c = in.peek();
    compareThen += c;
    consume(in, c);
    while ((c = in.peek()) && isalpha(c)) {
        consume(in, c);
        compareThen += c;
    }
    PTR(Expr) thenExpr;
    if (compareThen == "_then") {
        skip_whitespace(in);
        thenExpr = parse_expr(in);
    }
    else {
        throw runtime_error("invalid input");
    }
    skip_whitespace(in);
    c = in.peek();
    compareElse += c;
    consume(in, c);
    while ((c = in.peek()) && isalpha(c)) {
        consume(in, c);
        compareElse += c;
    }
    PTR(Expr) elseExpr;
    if (compareElse == "_else") {
        skip_whitespace(in);
        elseExpr = parse_expr(in);
    }
    else {
        throw runtime_error("invalid input");
    }
    return NEW(IfExpr)(conditionExpr, thenExpr, elseExpr);
}

PTR(Expr) parse_function(istream &in) {
    skip_whitespace(in);
    int c = in.peek();
    string formalArg = "";
    if (c == '(') {
        consume(in, '(');
        skip_whitespace(in);
        while ((c = in.peek()) && c != ')') {
            consume(in, c);
            formalArg += c;
        }
        consume(in, ')');
    }
    else {
        throw runtime_error("invalid input");
    }
    skip_whitespace(in);
    PTR(Expr) rhs = parse_expr(in);
    return NEW(FunExpr)(formalArg, rhs);
}

/**
 * \brief A helper method used to consume a char in the stream
 * \param in the source of the input
 * \param expect the expected char to be consumed
 */
static void consume(istream &in, int expect) {
    int c = in.get();
    if (c != expect) {
        throw runtime_error("consume mismatch");
    }
}

/**
 * \brief A helper method used to parse a string (mostly used for testing)
 * \param input the string used as the input to be parsed
 * \return a fully-parsed expression
 */
PTR(Expr) parse_string(string input) {
    stringstream ss(input);
    return parse_expr(ss);
}

/**
 * \brief A helper method used to skip any whitespace within the input to be parsed
 * \param in the source of the input
 */
void skip_whitespace(istream &in) {
    while (1) {
        int c = in.peek();
        if (!isspace(c)) {
            break;
        }
        consume(in, c);
    }
}