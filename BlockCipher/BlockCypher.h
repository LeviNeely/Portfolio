//
// Created by Levi Neely on 3/1/23.
//

#ifndef BLOCKCIPHER_BLOCKCYPHER_H
#define BLOCKCIPHER_BLOCKCYPHER_H

#include <cstdint>
#include <iostream>

using namespace std;

class Block {
public:
    Block();
    uint8_t body[8];
};

Block* generateKey(string password);
void shuffleTheTables(vector<uint8_t> &table);
void printBody(Block* data);
void xorWithKey(Block* data, Block* key);
vector<vector<uint8_t>> generateShuffleTables();
void shuffleTheData(Block* &data, vector<vector<uint8_t>> tables);
string toString(Block* data);
void shiftBitsLeft(Block* &data);
void shiftBitsRight(Block* &data);
void unshuffleTheData(Block* &data, vector<vector<uint8_t>> tables);
void encrypt(Block* key, vector<vector<uint8_t>> tables, Block* &data);
void decrypt(Block* key, vector<vector<uint8_t>> tables, Block* &data);


#endif //BLOCKCIPHER_BLOCKCYPHER_H
