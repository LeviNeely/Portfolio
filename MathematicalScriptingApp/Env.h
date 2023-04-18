//
// Created by Levi Neely on 4/11/23.
//

#ifndef EXPR_CPP_ENV_H
#define EXPR_CPP_ENV_H

#include "pointer.h"
#include <string>
class Value;

using namespace std;

class Env {
public:
    virtual PTR(Value) lookup(string find_name) = 0;
    static PTR(Env) empty;
};

class EmptyEnv : public Env {
public:
    PTR(Value) lookup(string find_name) {
        throw runtime_error("Free variable: " + find_name);
    }
};

class ExtendedEnv : public Env {
public:
    string name;
    PTR(Value) val;
    PTR(Env) rest;
    ExtendedEnv(string name, PTR(Value) val, PTR(Env) rest) {
        this->name = name;
        this->val = val;
        this->rest = rest;
    };
    PTR(Value) lookup(string find_name) {
        if (find_name == name) {
            return val;
        }
        else {
            return rest->lookup(find_name);
        }
    }
};

#endif //EXPR_CPP_ENV_H
