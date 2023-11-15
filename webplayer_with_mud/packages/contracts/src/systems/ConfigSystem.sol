// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {RarityType} from "../codegen/common.sol";

contract ConfigSystem is System {

    constructor() {

    }

    function initCard(string memory name, uint8 mana, uint8 attack, uint8 hp, uint32 cost) public returns (bytes32 key)  {
        key = keccak256(abi.encode(name));
        Cards.set(key, CardsData({mana : mana, attack : attack, hp : hp, cost : cost, tid : name, cardType : "1", team : "1", rarity : RarityType.COMMON}));
    }

    function getCard(string memory id) public view returns (CardsData memory _table) {
        bytes32 key = keccak256(abi.encode(id));
        return Cards.get(key);
    }

    function setCard(string memory id, CardsData calldata data) public {
        bytes32 key = keccak256(abi.encode(id));
        Cards.set(key, data);
    }
}
