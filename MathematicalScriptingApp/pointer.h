/**
 * \file pointer.h
 * \brief header file containing macro definitions about which pointer system to use
 *
 * This file contains the definition of macros used to select which pointer system to utilize
 * inside the program (either smart pointers or classic pointers).
 *
 * \author Levi Neely
 */

#ifndef EXPR_CPP_POINTER_H
#define EXPR_CPP_POINTER_H

#include <memory>

#define USE_PLAIN_POINTERS 0
#if USE_PLAIN_POINTERS

# define NEW(T)     new T
# define PTR(T)     T*
# define CAST(T)    dynamic_cast<T*>
# define CLASS(T)   class T
# define THIS       this

#else

# define NEW(T)     std::make_shared<T>
# define PTR(T)     std::shared_ptr<T>
# define CAST(T)    std::dynamic_pointer_cast<T>
# define CLASS(T)   class T : public std::enable_shared_from_this<T>
# define THIS       shared_from_this()

#endif

#endif //EXPR_CPP_POINTER_H
