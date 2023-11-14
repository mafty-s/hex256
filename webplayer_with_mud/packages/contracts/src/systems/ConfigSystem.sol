// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";

contract ConfigSystem is System {

    constructor () {
        Cards.set(keccak256(abi.encode("ashes_snake")), CardsData({mana : 5, attack : 6, hp : 1, cost : 1, createdAt : 1, tid : "1", cardType : "1", team : "1", rarity : "1"}));
    }

    function getCard() public view returns (CardsData memory _table) {
        bytes32 key = keccak256(abi.encode(1));
        return Cards.get(key);
    }


}
