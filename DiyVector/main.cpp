//
//  main.cpp
//  DiyVector
//
//  Created by Levi Neely on 9/13/22.
//

#include <iostream>
#include "DiyVector.hpp"
#include <cassert>
#include <string>

using namespace std;

int main(int argc, const char * argv[]) {

    int testArray [5] = {1, 2, 3, 4, 5};
    int wildArray [5] = {-1, 0, 100000, 56495859, -29369534};
    char charTest [5] = {'h', 'e', 'l', 'l', 'o'};
    char wildChar [5] = {'H', 'E', 'L', '8', '!'};
    
    
// Testing creators
    MyVector<int> testVector (5, 5, testArray);
    MyVector<int> wildVector (5, 5, wildArray);
    MyVector<char> charVector (5, 5, charTest);
    MyVector<char> wildCharVector (5, 5, wildChar);
    
// Testing .printVector:
    testVector.printVector();
    cout << "\n";
    wildVector.printVector();
    cout << "\n";
    charVector.printVector();
    cout << "\n";
    wildCharVector.printVector();
    cout << "\n";
    
// Testing pushBack
    testVector.pushBack(6);
    testVector.printVector();
    cout << "\n";
    wildVector.pushBack(-22);
    wildVector.printVector();
    cout << "\n";
    charVector.pushBack('!');
    charVector.printVector();
    cout << "\n";
    wildCharVector.pushBack('?');
    wildCharVector.printVector();
    cout << "\n";
    
// Testing popBack
    testVector.popBack();
    testVector.printVector();
    cout << "\n";
    wildVector.popBack();
    wildVector.printVector();
    cout << "\n";
    charVector.popBack();
    charVector.printVector();
    cout << "\n";
    wildCharVector.popBack();
    wildCharVector.printVector();
    cout << "\n";
    
// Testing get
    cout << testVector.get(0) << "\n";
    cout << wildVector.get(0) << "\n";
    cout << charVector.get(0) << "\n";
    cout << wildCharVector.get(0) << "\n";
    
// Testing set
    testVector.set(0, 9);
    testVector.printVector();
    cout << "\n";
    wildVector.set(0, 9);
    wildVector.printVector();
    cout << "\n";
    charVector.set(0, 'z');
    charVector.printVector();
    cout << "\n";
    wildCharVector.set(0, 'z');
    wildCharVector.printVector();
    cout << "\n";
    
// Testing growMyVector and getCapacity and getSize
    cout << testVector.getCapacity() << "\n" << testVector.getSize() << "\n";
    testVector.growMyVector();
    cout << testVector.getCapacity() << "\n" << testVector.getSize() << "\n";
    cout << wildVector.getCapacity() << "\n" << wildVector.getSize() << "\n";
    wildVector.growMyVector();
    cout << wildVector.getCapacity() << "\n" << wildVector.getSize() << "\n";
    cout << charVector.getCapacity() << "\n" << charVector.getSize() << "\n";
    charVector.growMyVector();
    cout << charVector.getCapacity() << "\n" << charVector.getSize() << "\n";
    cout << wildCharVector.getCapacity() << "\n" << wildCharVector.getSize() << "\n";
    wildCharVector.growMyVector();
    cout << wildCharVector.getCapacity() << "\n" << wildCharVector.getSize() << "\n";
    
// Testing the operand=:
    wildVector = testVector;
    wildVector.printVector();
    cout << "\n";
    wildCharVector = charVector;
    wildCharVector.printVector();
    cout << "\n";
    
// Testing the operand[]:
    cout << testVector [0] << "\n";
    testVector [0] = 99;
    cout << testVector [0] << "\n";
    cout << charVector [0] << "\n";
    charVector [0] = 'P';
    cout << charVector [0] << "\n";
    
// Testing the operand==:
    testVector [0] = 9;
    if (wildVector == testVector){
        cout << "They are both equal to each other!\n";
    }
    charVector [0] = 'z';
    if (wildCharVector == charVector){
        cout << "They are both equal to each other!\n";
    }
    
// Testing the operand!=:
    wildVector.set(1, 55);
    if (wildVector != testVector){
        cout << "They are not equal to each other!\n";
    }
    wildChar [0] = '7';
    if (wildCharVector != charVector){
        cout << "They are not equal to each other!\n";
    }
    
// Testing the operand<:
    if (testVector < wildVector){
        cout << "The test worked!\n";
    }
    
// Testing the operand <=:
    wildVector = testVector;
    if (wildVector <= testVector){
        cout << "The test worked!\n";
    }
    wildVector.set(1, 55);
    if (testVector <= wildVector){
        cout << "The test worked!\n";
    }
    
// Testing the operand>:
    if (wildVector > testVector){
        cout << "The test worked!\n";
    }
    
// Testing the operand>=:
    wildVector = testVector;
    if (wildVector >= testVector){
        cout << "The test worked!\n";
    }
    wildVector.set(1, 55);
    if (wildVector >= testVector){
        cout << "The test worked!\n";
    }
    
// Testing the templatization for use of algorithms:
    for (auto x : testVector){
        cout << x << " ";
    }
    cout << "\n";
    sort(testVector.begin(), testVector.end());
    for (auto x : testVector){
        cout << x << " ";
    }
    cout << "\n";
    cout << *min_element(testVector.begin(), testVector.end()) << "\n";
    cout << count_if(testVector.begin(), testVector.end(), [] (const int& x) { return (x%2 == 0);}) << "\n";
    
    return 0;
}
