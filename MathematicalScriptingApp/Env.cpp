//
// Created by Levi Neely on 4/18/23.
//
#include "Env.h"
#include "pointer.h"

PTR(Env) Env::empty = NEW(EmptyEnv)();