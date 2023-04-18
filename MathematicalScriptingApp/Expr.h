/**
 * \file Expr.h
 * \brief Expression class
 *
 * This file contains the declarations of the Expr class, its children, and all methods.
 */

#ifndef HW1_EXPR_H
#define HW1_EXPR_H
#include "pointer.h"
#include "Env.h"
#include <string>
#include <sstream>
#include <iostream>
class Value;

/**
 * \brief enum to assign precedence for printing functions
 */
typedef enum {
    prec_none, ///< No precedence
    prec_eq, ///< Precedence for EqExpr
    prec_add, ///< Precedence for AddExpr
    prec_mult ///< Precedence for MultExpr
} precedence_t;

/**
 * \brief Expr class that represents an expression
 */
CLASS(Expr) {
public:
    virtual bool equals(PTR(Expr) e) = 0;
    virtual PTR(Value) interp(PTR(Env) env) = 0;
    virtual void print(std::ostream& os) = 0;

    /**
     * \brief A method for all Expr that represents the Expr as a string
     * @return the string representing the Expr
     */
    std::string to_string() {
        std::stringstream st("");
        THIS->print(st);
        return st.str();
    };

    /**
     * \brief A method that prints out Expr in a more visually pleasing way
     * @param os the output stream the Expr will be printed to
     */
    void pretty_print(std::ostream& os) {
        precedence_t precedence = prec_none;
        std::streampos position = os.tellp();
        THIS->pretty_print_at(os, precedence, false, position);
    }

    /**
     * A method utilized for testing to return a string from the pretty_print method
     * @return a string representing an Expr printed using pretty_print
     */
    std::string pretty_print_to_string() {
        std::stringstream st("");
        pretty_print(st);
        return st.str();
    }
    virtual void pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position) = 0;
    virtual ~Expr() {};
};

/**
 * \brief NumExpr class that represents a number, inherits from Expr
 */
class NumExpr : public Expr {
public:
    int val; ///< The integer value of the NumExpr class
    NumExpr(int val);
    bool equals(PTR(Expr) e);
    PTR(Value) interp(PTR(Env) env);
    void print(std::ostream& os);
    void pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position);
};

/**
 * \brief AddExpr class that represents an addition expression, inherits from Expr
 */
class AddExpr : public Expr {
public:
    PTR(Expr) lhs; ///< The Expr on the left-hand side of the AddExpr class
    PTR(Expr) rhs; ///< The Expr on the right-hand side of the AddExpr class
    AddExpr(PTR(Expr) lhs, PTR(Expr) rhs);
    bool equals(PTR(Expr) e);
    PTR(Value) interp(PTR(Env) env);
    void print(std::ostream& os);
    void pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position);
};

/**
 * \brief MultExpr class that represents a multiplication expression, inherits from Expr
 */
class MultExpr : public Expr {
public:
    PTR(Expr) lhs; ///< The Expr on the left-hand side of the MultExpr class
    PTR(Expr) rhs; ///< The Expr on the right-hand side of the MultExpr class
    MultExpr(PTR(Expr) lhs, PTR(Expr) rhs);
    bool equals(PTR(Expr) e);
    PTR(Value) interp(PTR(Env) env);
    void print(std::ostream& os);
    void pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position);
};

/**
 * \brief VarExpr class that represents a variable, inherits from Expr
 */
class VarExpr : public Expr {
public:
    std::string val; ///< The string value of the VarExpr class
    VarExpr(std::string val);
    bool equals(PTR(Expr) e);
    PTR(Value) interp(PTR(Env) env);
    void print(std::ostream& os);
    void pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position);
};

/**
 * \brief LetExpr class that represents let phrases (e.g. let x = 5 in x + 5), inherits from Expr
 */
 class LetExpr : public Expr {
 public:
     std::string val; ///< The variable expression that will be replaced with an Expr
     PTR(Expr) rhs; ///< The "left-hand side" of the let (the thing that will replace val)
     PTR(Expr) body; ///< The "right-hand side" of the let (the "in" part, denoting what contains val)
     LetExpr(std::string val, PTR(Expr) rhs, PTR(Expr) body);
     bool equals(PTR(Expr) e);
     PTR(Value) interp(PTR(Env) env);
     void print(std::ostream& os);
     void pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position);
 };

 /**
  * \brief BoolExpr class that represents boolean expressions
  */
 class BoolExpr : public Expr {
 public:
     bool val; ///< The boolean value of the BoolExpr class
     BoolExpr(bool val);
     bool equals(PTR(Expr) e);
     PTR(Value) interp(PTR(Env) env);
     void print(std::ostream& os);
     void pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position);
 };

 /**
  * \brief IfExpr class that represents an if expressions (e.g. if...then...else...)
  */
 class IfExpr : public Expr {
 public:
     PTR(Expr) condition; ///< The condition used in the IfExpr
     PTR(Expr) rhs; ///< The expression representing the "then" statement
     PTR(Expr) lhs; ///< The expression representing the "else" statement
     IfExpr(PTR(Expr) condition, PTR(Expr) rhs, PTR(Expr) lhs);
     bool equals(PTR(Expr) e);
     PTR(Value) interp(PTR(Env) env);
     void print(std::ostream& os);
     void pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position);
 };

 /**
  * \brief EqExpr class that represents equality between two Exprs
  */
 class EqExpr : public Expr {
 public:
     PTR(Expr) lhs; ///< The expression on the left hand side of the equals
     PTR(Expr) rhs; ///< The expression on the right hands side of the equals
     EqExpr(PTR(Expr) lhs, PTR(Expr) rhs);
     bool equals(PTR(Expr) e);
     PTR(Value) interp(PTR(Env) env);
     void print(std::ostream& os);
     void pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position);
 };

 /**
  * \brief FunExpr class that represents a function
  */
 class FunExpr : public Expr {
 public:
    std::string formal_arg; ///< The variable that will be replaced in the function
    PTR(Expr) body; ///< The function that will contain the variable that will be evaluated
    FunExpr(std::string formal_arg, PTR(Expr) body);
    bool equals(PTR(Expr) e);
    PTR(Value) interp(PTR(Env) env);
    void print(std::ostream& os);
    void pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position);
 };

 /**
  * \brief CallExpr class that represents a call to a function
  */
 class CallExpr : public Expr {
 public:
     PTR(Expr) to_be_called; ///< The expression to be called
     PTR(Expr) actual_arg; ///< The expression to be passed to the function
     CallExpr(PTR(Expr) to_be_called, PTR(Expr) actual_arg);
     bool equals(PTR(Expr) e);
     PTR(Value) interp(PTR(Env) env);
     void print(std::ostream& os);
     void pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position);
 };
#endif //HW1_EXPR_H