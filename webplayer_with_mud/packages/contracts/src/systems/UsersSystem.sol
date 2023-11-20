// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Users, UsersData} from "../codegen/index.sol";

contract UsersSystem is System {
    function addUser(string memory username) public returns (bytes32 key) {
        key = keccak256(abi.encode(_msgSender()));

        UsersData memory userData = UsersData(
            _msgSender(),
            1000000, //initialCoinAmount,
            0, //initialXp,
            block.timestamp,
            new bytes32[](0),
            new bytes32[](0),
            username,
            "bear",
            "user_cardback"
        );

        Users.set(key, userData);
    }

    function getUser() public view returns (UsersData memory _table) {
        bytes32 key = keccak256(abi.encode(_msgSender()));
        return Users.get(key);
    }

    function getUserByKey(bytes32 key) public view returns (UsersData memory _table) {
        return Users.get(key);
    }

    function getUserByOwner(address owner) public view returns (UsersData memory _table) {
        bytes32 key = keccak256(abi.encode(owner));
        return Users.get(key);
    }
}
