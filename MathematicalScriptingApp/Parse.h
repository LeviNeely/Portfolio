/**
 * \file Parse.h
 * \brief Parse declaration
 *
 * This file contains the declaration of the various methods used in the Parsing Process.
 */

#ifndef EXPR_CPP_PARSE_H
#define EXPR_CPP_PARSE_H

#include "pointer.h"
#include "Expr.h"

using namespace std;

static void consume(istream &in, int expect);
void skip_whitespace(istream &in);
PTR(Expr) parse_num(istream &in);
PTR(Expr) parse_comparg(istream &in);
PTR(Expr) parse_addend(istream &in);
PTR(Expr) parse_multicand(istream &in);
PTR(Expr) parse_inner(istream &in);
PTR(Expr) parse_expr(istream &in);
PTR(Expr) parse_var(istream &in);
PTR(Expr) parse_let(istream &in);
PTR(Expr) parse_if(istream &in);
PTR(Expr) parse_function(istream &in);
PTR(Expr) parse_string(string input);
string parse_keyword(istream &in);

#endif //EXPR_CPP_PARSE_H
