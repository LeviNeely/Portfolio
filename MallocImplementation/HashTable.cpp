//
// Created by Levi Neely on 3/16/23.
//

#include "HashTable.h"
#include <cstddef>
#include <algorithm>
#include <sys/mman.h>
#include <iostream>

using namespace std;

HashTable::HashTable(size_t capacity) {
    this->size = 0;
    this->capacity = capacity;
    node* ptr;
    ptr = (node*)mmap(NULL, capacity*sizeof(node), PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
    if (ptr == MAP_FAILED) {
        perror("HashTable mmap failed");
        exit(1);
    }
    table = ptr;
    for (int i = 0; i < this->capacity; i++) {
        table[i] = node(nullptr, 0);
    }
}

void HashTable::insert(void *ptr, size_t size) {
    int hashValue = hash(ptr);
    int hash = abs(hashValue) % this->capacity;
    for (int i = hash; i < this->capacity; i++) {
        if (table[i].ptr == nullptr || table[i].deleted) {
            table[i] = node(ptr, size);
            this->size++;
            break;
        }
        if (i == this->capacity - 1) {
            i -= this->capacity;
        }
    }
    if (this->size == this->capacity) {
        this->grow();
    }
}

void HashTable::remove(void *ptr) {
    int hashValue = hash(ptr);
    int hash = abs(hashValue) % this->capacity;
    for (int i = hash; i < this->capacity; i++) {
        if (table[i].ptr == ptr && !table[i].deleted) {
            table[i].deleted = true;
            this->size--;
            break;
        }
        if (i == this->capacity - 1) {
            i -= this->capacity;
        }
    }
}

void HashTable::grow() {
    HashTable temp = HashTable(this->capacity * 2);
    for (int i = 0; i < this->capacity; i++) {
        if (!this->table[i].deleted) {
            temp.table[i] = this->table[i];
        }
    }
    swap(this->size, temp.size);
    swap(this->capacity, temp.capacity);
    swap(this->table, temp.table);
}

bool HashTable::find(void *ptr) {
    int hashValue = hash(ptr);
    int hash = abs(hashValue) % this->capacity;
    bool visited = false;
    for (int i = hash; i < this->capacity; i++) {
        if (i == hash && !visited) {
            visited = true;
        }
        else if (i == hash && visited) {
            break;
        }
        if (table[i].ptr == ptr && !table[i].deleted) {
            return true;
        }
        if (i == this->capacity - 1) {
            i -= this->capacity;
        }
    }
    return false;
}

size_t HashTable::hash(void *ptr) {
    size_t hashValue = (size_t)ptr;
    hashValue = ~hashValue + (hashValue << 15);
    hashValue = hashValue ^ (hashValue >> 12);
    hashValue = hashValue + (hashValue << 2);
    hashValue = hashValue ^ (hashValue >> 4);
    hashValue = hashValue * 2057;
    hashValue = hashValue ^ (hashValue >> 16);
    return hashValue;
}

HashTable::~HashTable() {
    int error = munmap(this->table, this->capacity);
    if (error < 0) {
        perror("HashTable munmap failed");
        exit(1);
    }
}

