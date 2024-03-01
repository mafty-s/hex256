// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SlotLib, Slot} from "../libs/SlotLib.sol";
import {Games, Players} from "../codegen/index.sol";

contract SlotSystem is System {

    function GetAllSlot() public pure returns (Slot[] memory) {
        Slot[] memory origin = SlotLib.GetAll();
        uint16[] memory temp = new uint16[](origin.length);
        for (uint i = 0; i < origin.length; i++) {
            temp[i] = SlotLib.EncodeSlot(origin[i]);
        }
        Slot[] memory slots = new Slot[](temp.length);
        for (uint i = 0; i < temp.length; i++) {
            slots[i] = SlotLib.DecodeSlot(temp[i]);
        }
        return slots;
    }

    function GetRandomEmptySlot(bytes32 player_key) public view returns (Slot memory){
        bytes32 game_key = Players.getGame(player_key);
        bytes32[] memory players = Games.getPlayers(game_key);
        uint8 p = players[0] == player_key ? 0 : 1;
        return SlotLib.GetRandomEmptySlot(player_key, p);
    }

    function GetSlotCard(bytes32 game_key, Slot memory slot) public view returns (bytes32){
        bytes32[] memory players = Games.getPlayers(game_key);
        bytes32 slot_player = slot.p == 0 ? players[0] : players[1];
        bytes32 card_on_slot = SlotLib.GetCardOnSlot(slot_player, slot.x);
        return card_on_slot;
    }

    function GetEmptySlots(bytes32 player_key) public view returns (Slot[] memory) {
        bytes32 game_key = Players.getGame(player_key);
        bytes32[] memory players = Games.getPlayers(game_key);
        uint8 p = players[0] == player_key ? 0 : 1;
        return SlotLib.GetEmptySlots(player_key, p);
    }

    function ClearCardFromSlot(bytes32 player_key, bytes32 card_key) public {
        SlotLib.ClearCardFromSlot(player_key, card_key);
    }
}