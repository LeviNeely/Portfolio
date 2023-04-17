//
//  DiyVector.hpp
//  DiyVector
//
//  Created by Levi Neely on 9/13/22.
//

#ifndef DiyVector_hpp
#define DiyVector_hpp

#include <stdio.h>
#include <iostream>

template<typename T>
class MyVector {
private:
    T * _data;
    size_t _size, _capacity;
public:
// Constructors:
    MyVector() { }
    MyVector (size_t initialCapacity);
    MyVector (size_t arrayCapacity, size_t arrayValue, T array []);
    // The copy constructor:
    MyVector (const MyVector& copy);
// Templatizing for being able to use algorithms:
    T* begin();
    T* end();
    const T* begin() const;
    const T* end() const;
// Functions:
    // freeVector frees up any data. Since there is only one pointer in the Struct, that's the only one we free up.
    T data();
    size_t size();
    size_t capacity();
    // pushBack adds a variable to the end of the container.
    void pushBack (T newValue);
    void popBack ();
    T get (int index);
    void set (int index, T newValue);
    void growMyVector ();
    void printVector ();
    size_t getSize ();
    size_t getCapacity ();
// Destructors:
    ~MyVector ();
// Operators:
    MyVector& operator= (const MyVector& rhs);
    T& operator[] (int index);
    bool operator== (const MyVector& comparison);
    bool operator!= (const MyVector& comparison);
    bool operator< (const MyVector& comparison);
    bool operator<= (const MyVector& comparison);
    bool operator> (const MyVector& comparison);
    bool operator>= (const MyVector& comparison);
};

// Constructors:
template <typename T>
MyVector<T>::MyVector (size_t initialCapacity){ // Returns a vector with the given capacity and a size of 0.
    _size = 0;
    _capacity = initialCapacity;
}

template <typename T>
MyVector<T>::MyVector (size_t arrayCapacity, size_t arrayValue, T array []){
    _data = &array [0];
    _size = arrayValue;
    _capacity = arrayCapacity;
}

template <typename T>
MyVector<T>::MyVector (const MyVector& copy){
    _size = copy._size;
    _capacity = copy._capacity;
    _data = new T[_capacity];
    for (size_t i = 0; i < _size; i++){
        _data [i] = copy._data [i];
    }
}

// Templatizing for being able to use algorithms:
template <typename T>
T* MyVector<T>::begin(){
    return _data;
}

template <typename T>
T* MyVector<T>::end(){
    return (_data + _size);
}

template <typename T>
const T* MyVector<T>::begin() const{
    return _data;
}

template <typename T>
const T* MyVector<T>::end() const{
    return (_data + _size);
}

// Functions:

// pushBack adds a variable to the end of the container.
template <typename T>
void MyVector<T>::pushBack (T newValue){
    if (_size == _capacity){
        growMyVector();
    }
    _size ++;
    _data [_size-1] = newValue;
}

template <typename T>
void MyVector<T>::popBack (){
    T * tempArray = new T [(_size - 1)];
    for (int i = 0; i < (_size - 1); i++){
        tempArray [i] = _data [i];
    }
    _size -= 1;
    delete [] _data;
    _data = &tempArray [0];
    tempArray = nullptr;
    _capacity --;
}

template <typename T>
T MyVector<T>::get (int index) {
    T valueAtIndex;
    valueAtIndex = _data[index];
    return valueAtIndex;
}

template <typename T>
void MyVector<T>::set (int index, T newValue){
    _data [index] = newValue;
}

template <typename T>
void MyVector<T>::growMyVector (){
    T * tempArray = new T [(2 * _capacity)];
    for (int i = 0; i < _capacity; i++){
        tempArray [i] = _data [i];
    }
    _capacity = 2 * _capacity;
    _data = &tempArray[0];
    tempArray = nullptr;
}

template <typename T>
void MyVector<T>::printVector(){
    for (int i = 0; i < _size; i++){
        std::cout << _data[i] << " ";
    }
}

template <typename T>
size_t MyVector<T>::getSize(){
    return _size;
}

template <typename T>
size_t MyVector<T>::getCapacity(){
    return _capacity;
}

// Destructors:

template <typename T>
MyVector<T>::~MyVector (){
//    delete [] _data;
    _data = nullptr;
    _size = 0;
    _capacity = 0;
}

// Operators:
template <typename T>
MyVector<T>& MyVector<T>::operator= (const MyVector<T>& rhs){
//    if (*_data == *(rhs._data)){
//        return *this;
//    }
    _capacity = rhs._capacity;
    _size = rhs._size;
    for (size_t i = 0; i < _size; i++){
        _data[i] = rhs._data[i];
    }
    return *this;
}

template <typename T>
T& MyVector<T>::operator[] (int index){
    return this->_data[index];
}

template <typename T>
bool MyVector<T>::operator== (const MyVector& comparison){
    for (size_t i = 0; i < _size; i++){
        if (_data[i] != comparison._data[i]){
            return false;
        }
    }
    return true;
}

template <typename T>
bool MyVector<T>::operator!= (const MyVector& comparison){
    for (size_t i = 0; i < _size; i++){
        if (_data[i] != comparison._data[i]){
            return true;
        }
    }
    return false;
}

template <typename T>
bool MyVector<T>::operator< (const MyVector& comparison){
    for (size_t i = 0; i < _size; i++){
        if (_data[i] > comparison._data[i]){
            return false;
        }
        else if (_data[i] == comparison._data[i]){
        }
        else if (_data[i] < comparison._data[i]){
            return true;
        }
    }
    return false;
}

template <typename T>
bool MyVector<T>::operator<= (const MyVector& comparison){
    if (*this < comparison || *this == comparison){
        return true;
    }
    return false;
}

template <typename T>
bool MyVector<T>::operator> (const MyVector& comparison){
    for (size_t i = 0; i < _size; i++){
        if (_data[i] < comparison._data[i]){
            return false;
        }
        else if (_data[i] == comparison._data[i]){
        }
        else if (_data[i] > comparison._data[i]){
            return true;
        }
    }
    return false;
}

template <typename T>
bool MyVector<T>::operator>= (const MyVector& comparison){
    if (*this > comparison || *this == comparison){
        return true;
    }
    return false;
}

#endif /* DiyVector_hpp */
