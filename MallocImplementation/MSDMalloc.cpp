//
// Created by Levi Neely on 3/16/23.
//

#include "MSDMalloc.h"
#include "HashTable.h"
#include <cstddef>
#include <sys/mman.h>
#include <cstdio>
#include <iostream>

using namespace std;

HashTable hashTable = HashTable(16);

void* allocate(size_t bytesToAllocate) {
    size_t size = roundUp(bytesToAllocate);
    void *ptr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
    bool allocated = hashTable.find(ptr);
    if (allocated) {
        perror("Already allocated");
        exit(1);
    }
    hashTable.insert(ptr, size);
    return ptr;
}

void deallocate(void* ptr) {
    bool allocated = hashTable.find(ptr);
    if (!allocated) {
        perror("Already deallocated");
        exit(1);
    }
    hashTable.remove(ptr);
    int error = munmap(ptr, sizeof(node));
    if (error < 0) {
        perror("Deallocate munmap failed");
        exit(1);
    }
}

size_t roundUp(size_t size) {
    size_t a = (size / 4096) * 4096;
    return a + 4096;
}