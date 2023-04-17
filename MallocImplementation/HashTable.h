//
// Created by Levi Neely on 3/16/23.
//

#ifndef MSDMALLOC_HASHTABLE_H
#define MSDMALLOC_HASHTABLE_H

#include <cstddef>

using namespace std;

struct node {
    void *ptr;
    size_t size;
    bool deleted;
    node(void *ptr, size_t size) {
        this->ptr = ptr;
        this->size = size;
        this->deleted = false;
    }
};

class HashTable {
public:
    size_t size;
    size_t capacity;
    node* table;
    HashTable(size_t capacity);
    void insert(void *ptr, size_t size);
    void remove(void *ptr);
    void grow();
    bool find(void *ptr);
    size_t hash(void *ptr);
    ~HashTable();
};

#endif //MSDMALLOC_HASHTABLE_H
