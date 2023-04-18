/**
 * \file Value.cpp
 * \brief Contains the definitions of the Value class along with its children
 *
 * This file contains the definitions of the Value class and its children (NumValue and BoolVal) along with all of
 * their various methods.
 *
 * \author Levi Neely
 */

#include "Expr.h"
#include "Value.h"
#include <string>

using namespace std;

//NumValue
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * \brief Constructor
 * \param int val: the integer value assigned to the NumValue
 */
NumValue::NumValue(int val) {
    this->val = val;
}

/**
 * \breif A method to test if two NumValues are equal
 * \param otherValue the other Value to be tested against
 * \return true if they are equal, false if they are not or incompatible
 */
bool NumValue::equals(PTR(Value) otherValue) {
    PTR(NumValue) other_num = CAST(NumValue)(otherValue);
    if (other_num == NULL) {
        return false;
    }
    return (this->val == other_num->val);
}

/**
 * \brief A method to add one NumValue to another
 * \param otherValue the other NumValue to be added to the original
 * \return the combined NumValue
 */
PTR(Value) NumValue::add_to(PTR(Value) otherValue) {
    PTR(NumValue) other_num = CAST(NumValue)(otherValue);
    if (other_num == NULL) {
        throw runtime_error("Cannot add non-number");
    }
    return NEW(NumValue)((unsigned)this->val + (unsigned)other_num->val);
}

/**
 * \brief A method to multiply one NumValue with another
 * \param otherValue the other NumValue to be multiplied with the original
 * \return the multiplied NumValue
 */
PTR(Value) NumValue::multiply_with(PTR(Value) otherValue) {
    PTR(NumValue) other_num = CAST(NumValue)(otherValue);
    if (other_num == NULL) {
        throw runtime_error("Cannot multiply non-number");
    }
    return NEW(NumValue)((unsigned)this->val * (unsigned)other_num->val);
}

/**
 * \brief A method to print out the value of the NumValue as a string
 * \param os the stream to print out to
 */
void NumValue::print(std::ostream& os) {
    os << val;
}

/**
 * \brief A method used to determine if the NumValue is true
 * \return an error, since it is impossible for an int to be a boolean
 */
bool NumValue::is_true() {
    throw runtime_error("Cannot evaluate a non-boolean value");
}

/**
 * \brief A method used to evaluate a function
 * @param actual_arg the argument to be implemented in the function
 * @return an error, since it is impossible to call a NumValue
 */
PTR(Value) NumValue::call(PTR(Value) actual_arg) {
    throw runtime_error("Cannot evaluate a non-function value");
}

//BoolValue
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * \brief A constructor for the BoolValue class
 * \param val the boolean used to indicate the BoolValue's boolean value
 */
BoolValue::BoolValue(bool val) {
    this->val = val;
}

/**
 * \breif A method to test if two BoolValues are equal
 * \param otherValue the other Value to be tested against
 * \return true if they are equal, false if they are not or incompatible
 */
bool BoolValue::equals(PTR(Value) otherValue) {
    PTR(BoolValue) other_bool = CAST(BoolValue)(otherValue);
    if (other_bool == NULL) {
        return false;
    }
    return (this->val == other_bool->val);
}

/**
 * \brief A method used to add two BoolValues together
 * \param otherValue the other value to add to this one
 * \return an error, since it is impossible to add booleans together
 */
PTR(Value) BoolValue::add_to(PTR(Value) otherValue) {
    throw runtime_error("Cannot add non-number");
}

/**
 * \brief A method used to multiply two BoolValues together
 * \param otherValue the other value to multiply with this one
 * \return an error, since it is impossible to multiply booleans together
 */
PTR(Value) BoolValue::multiply_with(PTR(Value) otherValue) {
    throw runtime_error("Cannot multiply non-number");
}

/**
 * \brief A method to print out the value of a BoolValue
 * \param os the output stream to print to
 */
void BoolValue::print(std::ostream& os) {
    if (val) {
        os << "_true";
    }
    else {
        os << "_false";
    }
}

/**
 * \brief A method to tell if a BoolValue is true or not
 * \return the val of the BoolValue, indicating true or false
 */
bool BoolValue::is_true() {
    return val;
}

/**
 * \brief A method used to evaluate a function
 * @param actual_arg the argument to be implemented in the function
 * @return an error, since it is impossible to call a BoolValue
 */
PTR(Value) BoolValue::call(PTR(Value) actual_arg) {
    throw runtime_error("Cannot evaluate a non-function value");
}

//FunValue
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * \brief Constructor
 * @param formal_arg the formal argument of the function
 * @param body the function to be analyzed
 */
FunValue::FunValue(std::string formal_arg, PTR(Expr) body, PTR(Env) env) {
    this->formal_arg = formal_arg;
    this->body = body;
    this->env = env;
}

/**
 * \brief A method to evaluate equality between two Values
 * @param otherValue the other value to be compared to this value
 * @return true if the values are equal
 */
bool FunValue::equals(PTR(Value) otherValue) {
    PTR(FunValue) other_fun = CAST(FunValue)(otherValue);
    if (other_fun == NULL) {
        return false;
    }
    return (this->formal_arg == other_fun->formal_arg && this->body->equals(other_fun->body));
}

/**
 * \brief A method to add two values together
 * @param otherValue the other value to be added
 * @return an error, since it will not be able to add two FunValues together
 */
PTR(Value) FunValue::add_to(PTR(Value) otherValue) {
    throw runtime_error("Cannot add non-number");
}

/**
 * \brief A method to multiply two values together
 * @param otherValue the other value to be multiplied
 * @return an error, since it will not be able to multiply two FunValues together
 */
PTR(Value) FunValue::multiply_with(PTR(Value) otherValue) {
    throw runtime_error("Cannot multiply non-number");
}

/**
 * \brief A method to print a FunValue
 * @param os the stream to print out to
 */
void FunValue::print(std::ostream& os) {
    os << "[function]";
}

/**
 * \brief A method to evaluate if the FunValue is true
 * @return an error, since a FunValue cannot be a boolean
 */
bool FunValue::is_true() {
    throw runtime_error("Cannot evaluate a non-boolean value");
}

/**
 * \brief A method used to evaluate a function
 * @param actual_arg the argument to be implemented in the function
 * @return a value representing the function utilizing the actual argument
 */
PTR(Value) FunValue::call(PTR(Value) actual_arg) {
    return this->body->interp(NEW(ExtendedEnv)(this->formal_arg, actual_arg, this->env));
}