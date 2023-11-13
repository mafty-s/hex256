// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Users, UsersData} from "../codegen/index.sol";

contract UsersSystem is System {
    function addUser(string memory username) public returns (bytes32 key) {
        key = keccak256(abi.encode(block.prevrandao, _msgSender(), username));
//        Users.set(key, UsersData({
//            id : username,
//            createdAt : block.timestamp,
//            coin : 10000,
//            xp : 0,
//            avatar : "",
//            cardback : ""
//        })
//        );
    }


}
