// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {Decks, DecksData} from "../codegen/index.sol";
import {Matches, MatchesData} from "../codegen/index.sol";
import {GameType, GameState, GamePhase} from "../codegen/common.sol";

contract GameLogicSystem is System {

    constructor() {

    }

    function GameSetting(string memory game_uid) public returns (bytes32 key)  {
        key = keccak256(abi.encode(game_uid));
        Matches.set(key, MatchesData({gameType : GameType.SOLO, gameState : GameState.INIT, uid : game_uid, firstPlayer : 0, currentPlayer : 0, turn_count : 0, players : new bytes32[](0)}));
    }

    function PlayerSetting(string memory username, string memory game_uid, bytes32 desk_key) public {
        DecksData memory deck = Decks.get(desk_key);
        bytes32 match_key = keccak256(abi.encode(game_uid));
        //Matches match = Matches.get();
        //        Matches.setPlayerOneCards(match_key, deck.cards);

    }

    function PlayCard(bytes32 card_key, uint8 slot) public {

    }

    function AttackTarget(bytes32 card_key, uint8 slot) public {

    }


    function AttackPlayer(bytes32 card_key, uint8 slot) public {

    }

    function Move(bytes32 card_key, uint8 slot) public {

    }

    function EndTurn(bytes32 card_key, uint8 slot) public {

    }

}