// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, Players, CardOnBoards, Games} from "../codegen/index.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";
import {Slot, SlotLib} from "../libs/SlotLib.sol";

contract PlayCardSystem is System {

    function PlayCard(bytes32 game_key, bytes32 player_key, bytes32 card_key, uint16 slot_encode) public {
        require(CardOnBoards.getId(card_key) != 0, "Card not found");
        require(Players.getOwner(player_key) == _msgSender(), "Not owner");

        GameLogicLib.PlayCard(game_key, player_key, card_key, slot_encode, false);
    }
}
