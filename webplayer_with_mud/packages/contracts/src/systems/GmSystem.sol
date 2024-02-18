// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {Decks, DecksData} from "../codegen/index.sol";
import {Games} from "../codegen/index.sol";
import {Players} from "../codegen/index.sol";
import {CardOnBoards, CardOnBoardsData} from "../codegen/index.sol";
import {GameType, GameState, GamePhase, SelectorType} from "../codegen/common.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";
import {SlotLib,Slot} from "../libs/SlotLib.sol";
import {PlayerCardsDeck, PlayerCardsHand, PlayerCardsBoard} from "../codegen/index.sol";

//    struct PlayerSettingResult {
//        CardTuple[] cards;
//    }

contract GmSystem is System {
    function AddCard(string memory game_uid, string memory player_name, string memory card_name) public returns (bytes32) {
        bytes32 card_config_key = keccak256(abi.encode(card_name));
        bytes32 player_key = keccak256(abi.encode(game_uid, player_name));
        bytes32 card_uid = GameLogicLib.AddCard(player_key, card_config_key);
        PlayerCardsHand.pushValue(player_key, card_uid);
        return card_uid;
    }

    function AddCardOnEmptySlots(string memory game_uid, string memory player_name, string memory card_name) public returns (bytes32) {
        bytes32 card_config_key = keccak256(abi.encode(card_name));
        bytes32 player_key = keccak256(abi.encode(game_uid, player_name));
        bytes32 game_key = Players.getGame(player_key);
        bytes32[] memory players = Games.getPlayers(game_key);
        uint8 p = players[0] == player_key ? 0 : 1;

        Slot memory slot = SlotLib.GetRandomEmptySlot(player_key,p);
        uint16 slot_encode = SlotLib.EncodeSlot(slot);

        bytes32 card_uid = GameLogicLib.AddCard(player_key, card_config_key);
        CardOnBoards.setSlot(card_uid,slot_encode);

        PlayerCardsBoard.pushValue(player_key, card_uid);
        return card_uid;
    }

    function setMana(bytes32 game_key) public {
        bytes32[] memory players = Games.getPlayers(game_key);
        for (uint8 i = 0; i < players.length; i++) {
            Players.setMana(players[i], 10);
        }
    }

}