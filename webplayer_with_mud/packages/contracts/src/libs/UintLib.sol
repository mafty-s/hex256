// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

library UintLib {
    function combineUint32(uint8 a, uint8 b, uint8 c, uint8 d) internal pure returns (uint32) {
        uint32 result = (uint32(a) << 24) | (uint32(b) << 16) | (uint32(c) << 8) | uint32(d);
        return result;
    }

    function splitUint32(uint32 value) internal pure returns (uint8, uint8, uint8, uint8) {
        uint8 a = uint8((value >> 24) & 0xFF);
        uint8 b = uint8((value >> 16) & 0xFF);
        uint8 c = uint8((value >> 8) & 0xFF);
        uint8 d = uint8(value & 0xFF);
        return (a, b, c, d);
    }
}