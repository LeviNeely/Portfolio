//
// Created by Levi Neely on 3/1/23.
//

#include "BlockCypher.h"
#include <iostream>
#include <vector>

using namespace std;

/**
 * A method used to generate a key
 * @param password the password to be used to generate the key
 * @return the key as a Block object
 */
Block* generateKey(string password) {
    Block* key;
    for (int i = 0; i < password.length(); i++) {
        //Generate the key by XORing the body with the password
        key->body[i % 8] = key->body[i % 8] ^ password[i];
    }
    return key;
}

/**
 * Constructor for the Block object
 */
Block::Block() {
    //Just filling the array with 0s
    for (int i = 0; i < 8; i++) {
        body[i] = 0;
    }
}

/**
 * A method used to print the data in a data block
 * @param data the block that should be printed
 */
void printBody(Block* data) {
    for (int i = 0; i < 8; i++) {
        cout << unsigned(data->body[i]) << "\n";
    }
}

/**
 * A method using the key to encrypt the data
 * @param data the block to be encrypted
 * @param key the key to encrypt the block of data
 */
void xorWithKey(Block* data, Block* key) {
    for (int i = 0; i < 8; i++) {
        data->body[i] = data->body[i] ^ key->body[i];
    }
}

/**
 * A method used to shuffle the data with the shuffle tables
 * @param data the data block to be shuffled
 * @param tables the shuffle tables to be used to shuffle the data
 */
void shuffleTheData(Block* &data, vector<vector<uint8_t>> tables) {
    for (int i = 0; i < 8; i++) {
        data->body[i] = tables[i][(unsigned)data->body[i]];
    }
}

/**
 * A method used to shuffle the shuffle tables
 * @param table the table to be shuffled
 */
void shuffleTheTables(vector<uint8_t> &table) {
    srand(clock());
    for (int i = 0; i < 255; i++) {
        int randNum = rand() % 256;
        uint8_t temp = table[i];
        table[i] = table[randNum];
        table[randNum] = temp;
    }
    return;
}

/**
 * A method used to generate the shuffle tables
 * @return A vectore of shuffle tables
 */
vector<vector<uint8_t>> generateShuffleTables() {
    vector<vector<uint8_t>> tables;
    //The first table is to remain unshuffled
    vector<uint8_t> table0;
    for (int i = 0; i < 256; i++) {
        table0.push_back(i);
    }
    tables.push_back(table0);
    //All the others should be filled and shuffled
    for (int i = 1; i < 8; i++) {
        vector<uint8_t> table;
        for (int j = 0; j < 256; j++) {
            table.push_back(j);
        }
        shuffleTheTables(table);
        tables.push_back(table);
    }
    return tables;
}

/**
 * A method used to turn a data block into a string of characters
 * @param data the data block to be turned into a string
 * @return the string from the data block
 */
string toString(Block* data) {
    char* chars = (char *) data->body;
    string message = "";
    for (int i = 0; i < 8; i++) {
        message += chars[i];
    }
    return message;
}

/**
 * A method used to shift the bits inside the data block one to the left
 * @param data the block to be bit shifted
 */
void shiftBitsLeft(Block* &data) {
    //Grab the most significant bit in the first byte
    uint8_t firstBit = data->body[0] >> 7;
    for (int i = 0; i < 7; i++) {
        //Grab the most significant bit from the next byte
        uint8_t nextBit = data->body[i+1] >> 7;
        //Replace that byte with a shifted byte combined with the most significant bit from the next byte
        data->body[i] = data->body[i] << 1 | nextBit;
    }
    //Replace the last byte with a shifted byte combined with the most significant bit form the first byte
    data->body[7] = data->body[7] << 1 | firstBit;
}

/**
 * A method used to shift the bits inside the data block one to the right
 * @param data the block to be bit shifted
 */
void shiftBitsRight(Block* &data) {
    //Grab the least significant bit from the last byte
    uint8_t lastBit = data->body[7] << 7;
    for (int i = 7; i > 0; i--) {
        //Grab the least significant bit from the previous byte
        uint8_t previousBit = data->body[i-1] << 7;
        //Replace that byte with a shifted byte combined with the least significant bit from the previous byte
        data->body[i] = data->body[i] >> 1| previousBit;
    }
    //Replace the first byte with a shifted byte combined with the least significant bit from the last byte
    data->body[0] = data->body[0] >> 1| lastBit;
}

/**
 * A method used to unshuffle the data in a block using the shuffle tables
 * @param data the data to be unshuffled
 * @param tables the shuffle tables used to unshuffle the
 */
void unshuffleTheData(Block* &data, vector<vector<uint8_t>> tables) {
    for (int i = 0; i < 8; i++) {
        auto result = find(tables[i].begin(), tables[i].end(), data->body[i]);
        int index = result - tables[i].begin();
        data->body[i] = (uint8_t) index;
    }
}

void encrypt(Block* key, vector<vector<uint8_t>> tables, Block* &data) {
    cout << "\nThe data to be encrypted is as follows: \n";
    printBody(data);
    cout << toString(data);
    for (int i = 0; i < 16; i++) {
        xorWithKey(data, key);
        shuffleTheData(data, tables);
        shiftBitsLeft(data);
    }
}

void decrypt(Block* key, vector<vector<uint8_t>> tables, Block* &data) {
    for (int i = 0; i < 16; i++) {
        shiftBitsRight(data);
        unshuffleTheData(data, tables);
        xorWithKey(data, key);
    }
    cout << "\nThe decrypted data is as follows: \n";
    printBody(data);
    cout << toString(data);
}
