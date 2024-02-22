// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Users, UsersData} from "../codegen/index.sol";

contract UsersSystem is System {
    function addUser(string memory username) public returns (address key) {
         key = _msgSender();

//        UsersData memory userData = UsersData(
//            _msgSender(),
//            1000000, //initialCoinAmount,
//            0, //initialXp,
//            block.timestamp,
//            new bytes32[](0),
//            new bytes32[](0),
//            username,
//            "bear",
//            "user_cardback"
//        );
//
//        Users.set(key, userData);

        Users.setOwner(key, _msgSender());
        Users.setCoin(key, 1000000);
        Users.setCreatedAt(key, block.timestamp);
        Users.setId(key, username);

    }

    function getUser() public view returns (UsersData memory _table) {
        address key = _msgSender();
        return Users.get(key);
    }

    function getUserByKey(address key) public view returns (UsersData memory _table) {
        return Users.get(key);
    }

    function getUserByOwner(address owner) public view returns (UsersData memory _table) {
        address key = _msgSender();
        return Users.get(key);
    }
}
