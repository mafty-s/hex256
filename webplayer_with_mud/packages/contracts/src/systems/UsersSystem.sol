// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Users, UsersData} from "../codegen/index.sol";

contract UsersSystem is System {
    function addUser(string memory username) public returns (bytes32 key) {
        key = keccak256(abi.encode(block.prevrandao, _msgSender(), username));

        UsersData memory userData = UsersData(
            msg.sender,
            1000, //initialCoinAmount,
            0, //initialXp,
            block.timestamp,
            new uint8[](0),
            new uint256[](0),
            username,
            "bear",
            "user_cardback"
        );

        Users.set(key, userData);
        Users.setOwner(key, msg.sender);
    }

    function getUser(string memory username) public view returns (UsersData memory _table) {
        bytes32 key = keccak256(abi.encode(block.prevrandao, _msgSender(), username));
        return Users.get(key);
    }


}
