// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

library MathLib {
    function max(uint256 a, uint256 b) public pure returns (uint256) {
        if (a >= b) {
            return a;
        } else {
            return b;
        }
    }

    function min(uint256 a, uint256 b) public pure returns (uint256) {
        if (a <= b) {
            return a;
        } else {
            return b;
        }
    }

    function min_u8(uint8 a, uint8 b) public pure returns (uint8) {
        if (a <= b) {
            return a;
        } else {
            return b;
        }
    }

    function min_int8(int8 a, int8 b) public pure returns (int8) {
        if (a <= b) {
            return a;
        } else {
            return b;
        }
    }


    function RollRandomValue(uint8 min, uint8 max) public view returns (uint8){
        uint8 randomValue = uint8(uint256(keccak256(abi.encodePacked(block.prevrandao, block.prevrandao, msg.sender))) % (max - min + 1)) + min;
        return randomValue;
    }

    function RollRandomValueInt8(int8 min, int8 max) public view returns (int8) {
        uint8 randomValue = uint8(uint256(keccak256(abi.encodePacked(block.prevrandao, block.prevrandao, msg.sender))) % (uint8(max - min + 1))) + uint8(min);
        return int8(randomValue);
    }


}