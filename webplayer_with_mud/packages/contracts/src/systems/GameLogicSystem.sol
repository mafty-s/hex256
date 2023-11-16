// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {Decks, DecksData} from "../codegen/index.sol";
import {Matches, MatchesData} from "../codegen/index.sol";
import {Players, PlayersData} from "../codegen/index.sol";
import {PlayersCard, PlayersCardData} from "../codegen/index.sol";
import {GameType, GameState, GamePhase} from "../codegen/common.sol";

contract GameLogicSystem is System {

    constructor() {

    }

    function GameSetting(string memory game_uid) public returns (bytes32 key)  {
        key = keccak256(abi.encode(game_uid));
        Matches.set(key, MatchesData({gameType : GameType.SOLO, gameState : GameState.INIT, uid : game_uid, firstPlayer : 0, currentPlayer : 0, turn_count : 0, players : new bytes32[](0)}));
    }

    function PlayerSetting(string memory username, string memory game_uid, string memory desk_id) public {

        bytes32 desk_key = keccak256(abi.encode(desk_id));
        bytes32 match_key = keccak256(abi.encode(game_uid));
        bytes32 player_key = keccak256(abi.encode(game_uid, username));

        DecksData memory deck = Decks.get(desk_key);

        Matches.pushPlayers(match_key, player_key);
        Players.set(player_key, PlayersData({owner : address(0), hp : 0, mana : 0, hpMax : 0, manaMax : 0, name : username, deck : desk_id}));
        PlayersCard.set(player_key, PlayersCardData({cards_deck : deck.cards, cards_hand : new bytes32[](0), cards_board : new bytes32[](0), cards_equip : new bytes32[](0), cards_discard : new bytes32[](0)}));

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

    function ShuffleDeck(bytes32[] memory cards) public view returns (bytes32[] memory) {
        uint256 deckSize = cards.length;
        bytes32[] memory shuffledDeck = new bytes32[](deckSize);

        // Copy the original deck to the shuffled deck array
        for (uint256 i = 0; i < deckSize; i++) {
            shuffledDeck[i] = cards[i];
        }

        // Shuffle the deck using Fisher-Yates algorithm
        for (uint256 i = deckSize - 1; i > 0; i--) {
            uint256 j = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, i))) % (i + 1);
            bytes32 temp = shuffledDeck[i];
            shuffledDeck[i] = shuffledDeck[j];
            shuffledDeck[j] = temp;
        }

        return shuffledDeck;
    }

    function StartTurn() public {

    }

    function EndGame() public {

    }

    function RemoveCardFromAllGroups(bytes32 player_key, byte32 card_key) public {

    }

    function PayMana(bytes32 player_key, byte32 card_key) public {

    }

}