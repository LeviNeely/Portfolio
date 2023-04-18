/**
 * \file Value.h
 * \brief Value class
 *
 * This file contains the declarations of the Value class, its children, and all methods.
 */

#ifndef EXPR_CPP_VALUE_H
#define EXPR_CPP_VALUE_H
#include "pointer.h"
#include "Env.h"
#include <string>
#include <sstream>
#include <iostream>

class Expr;
/**
 * \brief Value class that represents a value
 */
CLASS(Value) {
public:
    virtual bool equals(PTR(Value) otherValue) = 0;
    virtual PTR(Value) add_to(PTR(Value) otherValue) = 0;
    virtual PTR(Value) multiply_with(PTR(Value) otherValue) = 0;
    virtual void print(std::ostream& os) = 0;
    virtual bool is_true() = 0;
    virtual PTR(Value) call(PTR(Value) actual_arg) = 0;
    /**
     * \brief A method for all Expr that represents the Expr as a string
     * @return the string representing the Expr
     */
    std::string to_string() {
        std::stringstream st("");
        THIS->print(st);
        return st.str();
    };
    virtual ~Value() {};
};

/**
 * \brief NumValue class that represents a number value, inherits from Value
 */
class NumValue : public Value {
public:
    int val; ///< The integer value of the NumValue class
    NumValue(int val);
    bool equals(PTR(Value) otherValue);
    PTR(Value) add_to(PTR(Value) otherValue);
    PTR(Value) multiply_with(PTR(Value) otherValue);
    void print(std::ostream& os);
    bool is_true();
    PTR(Value) call(PTR(Value) actual_arg);
};

/**
 * \brief BoolValue class that represents a true/false value, inherits from Value
 */
class BoolValue : public Value {
public:
    bool val; ///< The boolean value of the BoolValue class
    BoolValue(bool val);
    bool equals(PTR(Value) otherValue);
    PTR(Value) add_to(PTR(Value) otherValue);
    PTR(Value) multiply_with(PTR(Value) otherValue);
    void print(std::ostream& os);
    bool is_true();
    PTR(Value) call(PTR(Value) actual_arg);
};

/**
 * \brief FunValue class that represents a function value, inherits from Value
 */
class FunValue : public Value {
public:
    std::string formal_arg; ///< The formal argument of the function
    PTR(Expr) body; ///< The expression that the formal argument will replace to interpret
    PTR(Env) env; ///< The environmne to pass along
    FunValue(std::string formal_arg, PTR(Expr) body, PTR(Env) env);
    PTR(Expr) to_expr();
    bool equals(PTR(Value) otherValue);
    PTR(Value) add_to(PTR(Value) otherValue);
    PTR(Value) multiply_with(PTR(Value) otherValue);
    void print(std::ostream& os);
    bool is_true();
    PTR(Value) call(PTR(Value) actual_arg);
};
#endif //EXPR_CPP_VALUE_H
