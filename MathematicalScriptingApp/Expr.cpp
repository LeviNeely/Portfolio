/**
 * \file Expr.cpp
 * \brief Contains the definitions of the Expr class along with its children
 *
 * This file contains the definitions of the Expr class and its children (NumExpr, AddExpr, MultExpr, VarExpr, and LetExpr) along with all of
 * their various methods.
 *
 * \author Levi Neely
 */

#include "Value.h"
#include "Expr.h"
#include <string>
#include <stdexcept>
#include <sstream>

using namespace std;

//NumExpr
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * \brief Constructor
 * \param int val: the integer value assigned to the NumExpr
 */
NumExpr::NumExpr(int val) {
    this->val = val;
}

/**
 * \brief Equals method checks to see if a NumExpr is equal to another expression
 * \param Expr e: the Expression to compare to the NumExpr
 * \return false if not equal or null, true if equal
 */
bool NumExpr::equals(PTR(Expr) e) {
    PTR(NumExpr) otherNum = CAST(NumExpr)(e);
    if (otherNum == NULL) {
        return false;
    }
    return (this->val == otherNum->val);
}

/**
 * \brief Interpretation method that computes the value of the expression
 * \return the value of the expression
 */
PTR(Value) NumExpr::interp(PTR(Env) env) {
    return NEW(NumValue)(val);
}

/**
 * \brief Print method that prints the NumExpr
 * \param ostream os: the ostream to print to
 */
void NumExpr::print(ostream &os) {
    os << ::to_string(val);
}

/**
 * \brief A method to print out the NumExpr in a more visually pleasing way
 * \param os the stream to print out the expression
 * \param precedence the precedence of the expression
 * \param needKeywordParenthesis a boolean to indicate whether or not to include parenthesis in an expression with keywords
 * \param position the current position of the stream that is printing out
 */
void NumExpr::pretty_print_at(ostream &os, precedence_t precedence, bool needKeywordParenthesis, streampos& position) {
    os << val;
}

//AddExpr
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * \brief Constructor
 * \param Expr lhs = Left hand side expression
 * \param Expr rhs = right hand side expression
 */
AddExpr::AddExpr(PTR(Expr) lhs, PTR(Expr) rhs) {
    this->lhs = lhs;
    this->rhs = rhs;
}

/**
 * \brief Equals method checks to see if two expressions are equal
 * \param Expr e = expression to be checked against
 * \return false if not equal or null, true if equal
 */
bool AddExpr::equals(PTR(Expr) e) {
    PTR(AddExpr) otherAdd = CAST(AddExpr)(e);
    if (otherAdd == NULL) {
        return false;
    }
    return (this->lhs->equals(otherAdd->lhs) &&
            this->rhs->equals(otherAdd->rhs));
}

/**
 * \brief Interpretation method that returns the value of the add expression
 * \return the value of the two expressions that make up the AddExpr
 */
PTR(Value) AddExpr::interp(PTR(Env) env) {
    return (lhs->interp(env)->add_to(rhs->interp(env)));
}

/**
 * \brief Print method that prints the AddExpr
 * \param ostream &os: the ostream to print to
 */
void AddExpr::print(ostream& os) {
    os << "(" + lhs->to_string() + "+" + rhs->to_string() + ")";
}

/**
 * \brief A method to print out the AddExpr in a more visually pleasing way
 * \param os the stream to print out the expression
 * \param precedence the precedence of the expression
 * \param needKeywordParenthesis a boolean to indicate whether or not to include parenthesis in an expression with keywords
 * \param position the current position of the stream that is printing out
 */
void AddExpr::pretty_print_at(ostream &os, precedence_t precedence, bool needKeywordParenthesis, streampos& position) {
    if (precedence >= prec_add) {
        os << "(";
    }
    lhs->pretty_print_at(os, prec_add, true, position);
    os << " + ";
    rhs->pretty_print_at(os, prec_none, false, position);
    if (precedence >= prec_add) {
        os << ")";
    }
}

//MultExpr
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * \brief Constructor
 * \param Expr lhs = left hand side expression
 * \param Expr rhs = right hand side expression
 */
MultExpr::MultExpr(PTR(Expr) lhs, PTR(Expr) rhs) {
    this->lhs = lhs;
    this->rhs = rhs;
}

/**
 * \brief Equals method checks two expressions to see if they are equal
 * \param Expr e = expression to be checked against
 * \return false if not equal or null, true if equal
 */
bool MultExpr::equals(PTR(Expr) e) {
    PTR(MultExpr) otherMult = CAST(MultExpr)(e);
    if (otherMult == NULL) {
        return false;
    }
    return (this->lhs->equals(otherMult->lhs) &&
            this->rhs->equals(otherMult->rhs));
}

/**
 * \brief Interpretation method that computes the value of the expression
 * \return the value of the product of this expression
 */
PTR(Value) MultExpr::interp(PTR(Env) env) {
    return (lhs->interp(env)->multiply_with(rhs->interp(env)));
}

/**
 * \brief Print method that prints the MultExpr
 * \param ostream &os: the ostream to print to
 */
void MultExpr::print(ostream& os) {
    os << "(" + lhs->to_string() + "*" + rhs->to_string() + ")";
}

/**
 * \brief A method to print out the MultExpr in a more visually pleasing way
 * \param os the stream to print out the expression
 * \param precedence the precedence of the expression
 * \param needKeywordParenthesis a boolean to indicate whether or not to include parenthesis in an expression with keywords
 * \param position the current position of the stream that is printing out
 */
void MultExpr::pretty_print_at(ostream &os, precedence_t precedence, bool needKeywordParenthesis, streampos& position) {
    if (precedence == prec_mult) {
        os << "(";
        lhs->pretty_print_at(os, prec_mult, true, position);
        os << " * ";
        rhs->pretty_print_at(os, prec_add, false, position);
        os << ")";
    }
    else {
        lhs->pretty_print_at(os, prec_mult, true, position);
        os << " * ";
        rhs->pretty_print_at(os, prec_add, needKeywordParenthesis, position);
    }
}

//VarExpr
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * \brief Constructor
 * \param String val = string used to denote the value of the variable
 */
VarExpr::VarExpr(string val) {
    this->val = val;
}

/**
 * \brief Equals method checks two expressions to see if they are equal
 * \param Expr e = expression to be checked against
 * \return false if not equal or null, true if equal
 */
bool VarExpr::equals(PTR(Expr) e) {
    PTR(VarExpr) otherVar = CAST(VarExpr)(e);
    if (otherVar == NULL) {
        return false;
    }
    return (this->val == otherVar->val);
}

/**
 * \brief Interpretation method that returns the value of the expression
 * \return a Value, but since this is a variable, it will throw an error
 */
PTR(Value) VarExpr::interp(PTR(Env) env) {
    return env->lookup(this->val);
}

/**
 * \brief Print method that prints the VarExpr
 * \param ostream &os: the ostream to print to
 */
void VarExpr::print(ostream& os) {
    os << val;
}

/**
 * \brief A method to print out the VarExpr expression in a more visually pleasing way
 * \param os the stream to print out the expression
 * \param precedence the precedence of the expression
 * \param needKeywordParenthesis a boolean to indicate whether or not to include parenthesis in an expression with keywords
 * \param position the current position of the stream that is printing out
 */
void VarExpr::pretty_print_at(ostream &os, precedence_t precedence, bool needKeywordParenthesis, streampos& position) {
    os << val;
}

//LetExpr
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * \brief Constructor
 * \param val the string value that explains what will be replaced
 * \param rhs the expression that will replace val
 * \param rhs the expression that contains val that will be replaced
 */
LetExpr::LetExpr(string val, PTR(Expr) rhs, PTR(Expr) body) {
    this->val = val;
    this->rhs = rhs;
    this->body = body;
}

/**
 * \brief Equals method checks two LetExpr expressions to see if they are equal
 * \param Expr e = expression to be checked against
 * \return false if not equal or null, true if equal
 */
bool LetExpr::equals(PTR(Expr) e) {
    PTR(LetExpr) otherVar = CAST(LetExpr)(e);
    if (otherVar == NULL) {
        return false;
    }
    return (this->val == otherVar->val &&
            this->rhs->equals(otherVar->rhs) &&
            this->body->equals(otherVar->body));
}

/**
 * \brief Interpretation method that returns the value of the expression
 * \return a Value
 */
PTR(Value) LetExpr::interp(PTR(Env) env) {
    PTR(Value) rhs_val = rhs->interp(env);
    PTR(Env) new_env = NEW(ExtendedEnv)(val, rhs_val, env);
    return body->interp(new_env);
}

/**
 * \brief Print method that prints the LetExpr
 * \param ostream &os: the ostream to print to
 */
void LetExpr::print(ostream &os) {
    os << "(_let " + val + "=" + rhs->to_string() + " _in " + body->to_string() + ")";
}

/**
 * \brief A method to print out the LetExpr expression in a more visually pleasing way
 * \param os the stream to print out the expression
 * \param precedence the precedence of the expression
 * \param needKeywordParenthesis a boolean to indicate whether or not to include parenthesis in an expression with keywords
 * \param position the current position of the stream that is printing out
 */
void LetExpr::pretty_print_at(ostream &os, precedence_t precedence, bool needKeywordParenthesis, streampos& position) {
    if (needKeywordParenthesis) {
        os << "(";
    }
    streampos indent = os.tellp() - position;
    os << "_let " + val + " = ";
    rhs->pretty_print_at(os, prec_none, false, position);
    os << "\n";
    position = os.tellp();
    for (int i = 0; i < indent; i++) {
        os << " ";
    }
    os << "_in  ";
    body->pretty_print_at(os, prec_none, false, position);
    if (needKeywordParenthesis) {
        os << ")";
    }
}

//BoolExpr
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * \brief Constructor for the BoolExpr class
 * \param val the boolean value for the BoolExpr class
 */
BoolExpr::BoolExpr(bool val) {
    this->val = val;
}

/**
 * \brief Equals method checks two expressions to see if they are equal
 * \param Expr e = expression to be checked against
 * \return false if not equal or null, true if equal
 */
bool BoolExpr::equals(PTR(Expr) e) {
    PTR(BoolExpr) otherBool = CAST(BoolExpr)(e);
    if (otherBool == NULL) {
        return false;
    }
    return (this->val == otherBool->val);
}

/**
 * \brief Interpretation method that returns the value of the expression
 * \return a BoolValue, since it is a BoolExpr
 */
PTR(Value) BoolExpr::interp(PTR(Env) env) {
    return (NEW(BoolValue)(this->val));
}

/**
 * \brief Print method that prints the BoolExpr
 * \param ostream &os: the ostream to print to
 */
void BoolExpr::print(std::ostream& os) {
    if (val) {
        os << "_true";
    }
    else {
        os << "_false";
    }
}

/**
 * \brief A method to print out the BoolExpr expression in a more visually pleasing way
 * \param os the stream to print out the expression
 * \param precedence the precedence of the expression
 * \param needKeywordParenthesis a boolean to indicate whether or not to include parenthesis in an expression with keywords
 * \param position the current position of the stream that is printing out
 */
void BoolExpr::pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position) {
    if (val) {
        os << "_true";
    }
    else {
        os << "_false";
    }
}

//IfExpr
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * \brief Constructor
 * \param condition the expression used as the condition in the IfExpr
 * \param rhs the expression used as the "then" statement
 * \param lhs the expression used as the "else" statement
 */
IfExpr::IfExpr(PTR(Expr) condition, PTR(Expr) rhs, PTR(Expr) lhs) {
    this->condition = condition;
    this->rhs = rhs;
    this->lhs = lhs;
}

/**
 * \brief Equals method checks two expressions to see if they are equal
 * \param Expr e = expression to be checked against
 * \return false if not equal or null, true if equal
 */
bool IfExpr::equals(PTR(Expr) e) {
    PTR(IfExpr) otherIf = CAST(IfExpr)(e);
    if (otherIf == NULL) {
        return false;
    }
    return (this->condition->equals(otherIf->condition) &&
            this->rhs->equals(otherIf->rhs) &&
            this->lhs->equals(otherIf->lhs));
}

/**
 * \brief Method to interpret an IfExpr
 * \return the value of the IfExpr
 */
PTR(Value) IfExpr::interp(PTR(Env) env) {
    if ((condition->interp(env))->is_true()) {
        return rhs->interp(env);
    }
    else {
        return lhs->interp(env);
    }
}

/**
 * \brief Print method that prints the IfExpr
 * \param ostream &os: the ostream to print to
 */
void IfExpr::print(std::ostream& os) {
    os << "(_if " << condition->to_string() << " _then " << rhs->to_string() << " _else " << lhs->to_string() << ")";
}

/**
 * \brief A method to print out the IfExpr expression in a more visually pleasing way
 * \param os the stream to print out the expression
 * \param precedence the precedence of the expression
 * \param needKeywordParenthesis a boolean to indicate whether or not to include parenthesis in an expression with keywords
 * \param position the current position of the stream that is printing out
 */
void IfExpr::pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position) {
    if (needKeywordParenthesis) {
        os << "(";
    }
    streampos indent = os.tellp() - position;
    os << "_if ";
    condition->pretty_print_at(os, prec_none, false, position);
    os << "\n";
    position = os.tellp();
    for (int i = 0; i < indent; i++) {
        os << " ";
    }
    os << "_then ";
    rhs->pretty_print_at(os, prec_none, false, position);
    os << "\n";
    position = os.tellp();
    for (int i = 0; i < indent; i++) {
        os << " ";
    }
    os << "_else ";
    lhs->pretty_print_at(os, prec_none, false, position);
    if (needKeywordParenthesis) {
        os << ")";
    }
}

//EqExpr
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * \brief Constructor
 * \param lhs the expression on the left side of the equals
 * \param rhs the expression on the right side of the equals
 */
EqExpr::EqExpr(PTR(Expr) lhs, PTR(Expr) rhs) {
    this->lhs = lhs;
    this->rhs = rhs;
}

/**
 * \brief Equals method checks two expressions to see if they are equal
 * \param Expr e = expression to be checked against
 * \return false if not equal or null, true if equal
 */
bool EqExpr::equals(PTR(Expr) e) {
    PTR(EqExpr) otherEq = CAST(EqExpr)(e);
    if (otherEq == NULL) {
        return false;
    }
    return (this->lhs->equals(otherEq->lhs) &&
            this->rhs->equals(otherEq->rhs));
}

/**
 * \brief Method to interpret an EqExpr
 * \return true if both sides are interpreted as equal, false if not
 */
PTR(Value) EqExpr::interp(PTR(Env) env) {
    if ((lhs->interp(env))->equals(rhs->interp(env))) {
        return NEW(BoolValue)(true);
    }
    else {
        return NEW(BoolValue)(false);
    }
}

/**
 * \brief Print method that prints the EqExpr
 * \param ostream &os: the ostream to print to
 */
void EqExpr::print(std::ostream& os) {
    os << "(" << lhs->to_string() << "==" << rhs->to_string() << ")";
}

/**
 * \brief A method to print out the EqExpr expression in a more visually pleasing way
 * \param os the stream to print out the expression
 * \param precedence the precedence of the expression
 * \param needKeywordParenthesis a boolean to indicate whether or not to include parenthesis in an expression with keywords
 * \param position the current position of the stream that is printing out
 */
void EqExpr::pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position) {
    if (precedence >= prec_eq) {
        os << "(";
    }
    lhs->pretty_print_at(os, prec_eq, true, position);
    os << " == ";
    rhs->pretty_print_at(os, prec_none, false, position);
    if (precedence >= prec_eq) {
        os << ")";
    }
}

//FunExpr
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * \brief Constructor
 * @param formal_arg the string that will represent the formal argument of the function
 * @param body the expression that represents the function to be analyzed
 */
FunExpr::FunExpr(string formal_arg, PTR(Expr) body) {
    this->formal_arg = formal_arg;
    this->body = body;
}

/**
 * \brief A method to check if two Expressions are equal
 * @param e the expression to be checked against
 * @return true if the expressions are equal, false if not
 */
bool FunExpr::equals(PTR(Expr) e) {
    PTR(FunExpr) otherFun = CAST(FunExpr)(e);
    if (otherFun == NULL) {
        return false;
    }
    return (this->formal_arg == otherFun->formal_arg &&
            this->body->equals(otherFun->body));
}

/**
 * \brief A method to interpret the FunExpr
 * @return a FunValue representing the FunExpr
 */
PTR(Value) FunExpr::interp(PTR(Env) env) {
    return NEW(FunValue)(this->formal_arg, this->body, env);
}

/**
 * \brief A method used to print out the function expression
 * @param os the output stream to print to
 */
void FunExpr::print(std::ostream& os) {
    os << "(_fun (" << this->formal_arg << ") ";
    this->body->print(os);
    os << ")";
}

/**
 * \brief A method used to print out a function expression in a more visually pleasing way
 * @param os the output stream to print to
 * @param precedence the precedence of the expression
 * @param needKeywordParenthesis whether or not keyword parentheses are needed
 * @param position the position of the cursor
 */
void FunExpr::pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position) {
    if (needKeywordParenthesis) {
        os << "(";
    }
    streampos indent = os.tellp() - position;
    os << "_fun (" + formal_arg + ")\n";
    position = os.tellp();
    for (int i = 0; i < indent; i++) {
        os << " ";
    }
    os << "  ";
    body->pretty_print_at(os, prec_none, false, position);
    if (needKeywordParenthesis) {
        os << ")";
    }
}

//CallExpr
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * \brief Constructor
 * @param var the expression representing the function to be called
 * @param body the expression representing the argument to be passed to the function
 */
CallExpr::CallExpr(PTR(Expr) to_be_called, PTR(Expr) actual_arg) {
    this->to_be_called = to_be_called;
    this->actual_arg = actual_arg;
}

/**
 * \brief A method to test if two Expressions are equal
 * @param e the expression to be compared to
 * @return true if the expressions are equal, false if not
 */
bool CallExpr::equals(PTR(Expr) e) {
    PTR(CallExpr) otherCall = CAST(CallExpr)(e);
    if (otherCall == NULL) {
        return false;
    }
    return (this->to_be_called->equals(otherCall->to_be_called) &&
            this->actual_arg->equals(otherCall->actual_arg));
}

/**
 * \brief A method to interpret the value of the CallExpr
 * @return a value representing the value of the CallExpr
 */
PTR(Value) CallExpr::interp(PTR(Env) env) {
    return to_be_called->interp(env)->call(actual_arg->interp(env));
}

/**
 * \brief A method used to print out a call expression
 * @param os the output stream to be printed to
 */
void CallExpr::print(std::ostream& os) {
    to_be_called->print(os);
    os << "(";
    actual_arg->print(os);
    os << ")";
}

/**
 * \brief A method used to print out a call expression in a more visually pleasing way
 * @param os the output stream to be printed to
 * @param precedence the precedence of the expression
 * @param needKeywordParenthesis whether or not the keywords need parentheses
 * @param position the position of the cursor
 */
void CallExpr::pretty_print_at(std::ostream& os, precedence_t precedence, bool needKeywordParenthesis, std::streampos& position) {
    if (needKeywordParenthesis) {
        os << "(";
    }
    to_be_called->pretty_print_at(os, prec_mult, false, position);
    if (needKeywordParenthesis) {
        os << ")(";
    }
    actual_arg->pretty_print_at(os, prec_none, true, position);
    if (needKeywordParenthesis) {
        os << ")";
    }
}
