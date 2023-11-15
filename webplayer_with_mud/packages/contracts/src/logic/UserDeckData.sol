// PDX-License-Identifier: MIT
pragma solidity >=0.8.21;

struct UserDeckData {
    address owner;
    uint256 coin;
    uint256 xp;
    uint256 createdAt;
    uint8[] cards;
    uint256[] packs;
    string id;
    string avatar;
    string cardback;
}