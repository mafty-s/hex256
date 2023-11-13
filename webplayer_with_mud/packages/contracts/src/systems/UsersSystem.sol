// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Users, UsersData} from "../codegen/index.sol";

contract UsersSystem is System {
    function addUser(string memory description) public returns (bytes32 key) {
//        key = keccak256(abi.encode(block.prevrandao, _msgSender(), description));
//        Users.set(key, UsersData({
//            description : description,
//            createdAt : block.timestamp,
//            completedAt : 0
//        })
//        );
    }


}
