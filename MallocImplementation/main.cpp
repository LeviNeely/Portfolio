#include <iostream>
#include "MSDMalloc.h"
#include <vector>
#include <chrono>
#include <algorithm>

using namespace std;
using namespace std::chrono;

int main(int argc, char *argv[]) {
    if (argc > 1) {
        string argument = argv[1];
        if (argument == "--test") {
            int loopSize = 10000;
            for (int i = 0; i < loopSize; i++) {
                srand(clock());
                int varLength = rand() % 1000000000;
                int *ptr;
                ptr = (int *) allocate(sizeof(int) * varLength);
                if (ptr == NULL || ptr == nullptr) {
                    perror("Allocate failed");
                    exit(1);
                }
                deallocate(ptr);
            }
            return 0;
        }
        else if (argument == "--benchmark") {
            long sizeTest = 1000;
            for (int i = 0; i < 3; i++) {
                string size = "";
                if (sizeTest == 1000) {
                    size = "kilobyte";
                }
                else if (sizeTest == 1000000) {
                    size = "megabyte";
                }
                else if (sizeTest == 1000000000) {
                    size = "gigabyte";
                }
                auto startSize = high_resolution_clock::now();
                int *ptr = (int *) malloc(sizeof(int) * sizeTest);
                free(ptr);
                auto stopSize = high_resolution_clock::now();
                auto sizeTime = duration_cast<nanoseconds>(stopSize - startSize);
                cout << "Malloc took " << sizeTime.count() << " nanoseconds to allocate and deallocate a " << size << " of data.\n";
                startSize = high_resolution_clock::now();
                ptr = (int *) allocate(sizeof(int) * sizeTest);
                deallocate(ptr);
                stopSize = high_resolution_clock::now();
                sizeTime = duration_cast<nanoseconds>(stopSize - startSize);
                cout << "MSDMalloc took " << sizeTime.count() << " nanoseconds to allocate and deallocate a " << size << " of data.\n";
                sizeTest *= 1000;
            }
            vector<int> values(100000);
            srand(clock());
            auto f = []() -> int { return rand() % 100000; };
            generate(values.begin(), values.end(), f);
            long long int totalMalloc = 0;
            long long int totalMSDMalloc = 0;
            for (int i = 0; i < values.size(); i++) {
                auto startMalloc = high_resolution_clock::now();
                int *ptr = (int *) malloc(sizeof(int) * values[i]);
                free(ptr);
                auto stopMalloc = high_resolution_clock::now();
                auto mallocTime = duration_cast<nanoseconds>(stopMalloc - startMalloc);
                totalMalloc += mallocTime.count();
            }
            for (int i = 0; i < values.size(); i++) {
                auto startMSDMalloc = high_resolution_clock::now();
                int *ptr = (int *) allocate(sizeof(int) * values[i]);
                deallocate(ptr);
                auto stopMSDMalloc = high_resolution_clock::now();
                auto MSDMallocTime = duration_cast<nanoseconds>(stopMSDMalloc - startMSDMalloc);
                totalMSDMalloc += MSDMallocTime.count();
            }
            auto averageMalloc = totalMalloc / values.size();
            auto averageMSDMalloc = totalMSDMalloc / values.size();
            cout << "Average time to complete malloc() and free(): " << averageMalloc << " nanoseconds\n";
            cout << "Average time to complete MSD version of malloc() and free(): " << averageMSDMalloc
                 << " nanoseconds\n";
            cout << "Malloc is " << averageMSDMalloc / averageMalloc << " times faster than MSDMalloc\n";
        }
    }
    return 0;
}
