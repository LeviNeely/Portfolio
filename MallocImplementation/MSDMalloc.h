//
// Created by Levi Neely on 3/16/23.
//

#ifndef MSDMALLOC_MSDMALLOC_H
#define MSDMALLOC_MSDMALLOC_H

#include <cstddef>
#include "HashTable.h"

size_t roundUp(size_t size);
void* allocate(size_t bytesToAllocate);
void deallocate(void* ptr);

#endif //MSDMALLOC_MSDMALLOC_H
