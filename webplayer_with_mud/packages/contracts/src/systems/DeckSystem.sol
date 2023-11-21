// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Decks} from "../codegen/index.sol";

contract DeckSystem is System {

    function addDeck(string memory tid, bytes32 hero, bytes32[] memory cards) public returns (bytes32 key) {
        key = keccak256(abi.encode(_msgSender(), tid));
        Decks.setOwner(key, _msgSender());
        Decks.setHero(key, hero);
        Decks.setCards(key, cards);
        Decks.setTid(key, tid);
    }

}