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
}