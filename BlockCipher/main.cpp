#include <iostream>
#include <vector>
#include "BlockCypher.h"

using namespace std;

/**
 * Main driver method for block cipher encryption/decryption
 * @return It just returns 0 if the process ran correctly
 */
int main() {
    string password;
    //Asking the user for a password
    cout << "Please input a secret password\n";
    cin >> password;
    //Using the password, generate a key
    Block* key = generateKey(password);
    //Generate a set of shuffle tables
    vector<vector<uint8_t>> tables = generateShuffleTables();
    //Generate and fill a new data block
    Block *data = new Block();
    for (int i = 0; i < 8; i++) {
        srand(clock());
        uint8_t item = rand() % 256;
        data->body[i] = item;
    }
    //Encrypt the data
    encrypt(key, tables, data);
    //Decrypt the data
    decrypt(key, tables, data);
    return 0;
}
