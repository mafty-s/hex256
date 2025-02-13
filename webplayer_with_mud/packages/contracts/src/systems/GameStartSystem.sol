// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, Users} from "../codegen/index.sol";
import {Decks, DecksData} from "../codegen/index.sol";
import {Games, GamesData, GamesExtended} from "../codegen/index.sol";
import {Players, PlayersData} from "../codegen/index.sol";
import {CardOnBoards, CardOnBoardsData} from "../codegen/index.sol";
import {GameType, GameState, GamePhase, SelectorType, PileType} from "../codegen/common.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";
import {CardTableLib} from "../libs/CardTableLib.sol";

//    struct PlayerSettingResult {
//        CardTuple[] cards;
//    }

contract GameStartSystem is System {


    function GameSetting(string memory game_uid) public {

    }

    function shuffle(bytes32[] memory array) internal view returns (bytes32[] memory) {
        uint256 arrSize = array.length;
        bytes32[] memory shuffled = new bytes32[](arrSize);

        // Copy the original deck to the shuffled deck array
        for (uint256 i = 0; i < arrSize; i++) {
            shuffled[i] = array[i];
        }

        // Shuffle the deck using Fisher-Yates algorithm
        for (uint256 i = arrSize - 1; i > 0; i--) {
            uint256 j = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, i))) % (i + 1);
            bytes32 temp = shuffled[i];
            shuffled[i] = shuffled[j];
            shuffled[j] = temp;
        }

        return shuffled;
    }


    function PlayerSetting(string memory username, string memory game_uid, string memory desk_id, bool is_ai, int8 hp, int8 mana, int8 dcards, bool need_shuffle, uint pid) public returns (bytes32[] memory) {

        bytes32 desk_key = keccak256(abi.encode(desk_id));
        bytes32 game_key = keccak256(abi.encode(game_uid));
        bytes32 player_key = keccak256(abi.encode(game_uid, username));

        //        DecksData memory deck = Decks.get(desk_key);

        bytes32[] memory players = Games.getPlayers(game_key);
        if (players.length == 0) {
            players = new bytes32[](2);
        }
        players[pid] = player_key;
        Games.setPlayers(game_key, players);

//        Games.pushPlayers(game_key, player_key);

//        Players.set(player_key, PlayersData({owner: _msgSender(), dcards: dcards, hp: hp, mana: mana, hpMax: hp, manaMax: mana, name: username, deck: desk_id, isAI: is_ai}));
        Players.setOwner(player_key, _msgSender());
        Players.setDcards(player_key, dcards);
        Players.setHp(player_key, hp);
        Players.setMana(player_key, mana);
        Players.setHpMax(player_key, hp);
        Players.setManaMax(player_key, mana);
        Players.setName(player_key, username);
        Players.setDeck(player_key, desk_id);
        Players.setIsAI(player_key, is_ai);
        Players.setGame(player_key, game_key);

        bytes32 hero = Decks.getHero(desk_key);
        if (hero != 0) {
            bytes32 hero_uid = GameLogicLib.AddCard(player_key, hero);
            Players.setHero(player_key, hero_uid);
        }

        bytes32[] memory cards = Decks.getCards(desk_key);
        if (need_shuffle) {
            cards = shuffle(cards);
        }

        CardTableLib.setValue(PileType.Board, player_key, new bytes32[](0));
        CardTableLib.setValue(PileType.Hand, player_key, new bytes32[](0));
        CardTableLib.setValue(PileType.Deck, player_key, new bytes32[](0));
        CardTableLib.setValue(PileType.Discard, player_key, new bytes32[](0));
        CardTableLib.setValue(PileType.Secret, player_key, new bytes32[](0));
        CardTableLib.setValue(PileType.Equipped, player_key, new bytes32[](0));
        CardTableLib.setValue(PileType.Temp, player_key, new bytes32[](0));

        for (uint i = 0; i < cards.length; i++) {
            bytes32 on_board_card_key = GameLogicLib.AddCard(player_key, cards[i]);
            CardTableLib.pushValue(PileType.Deck, player_key, on_board_card_key);
        }


        if (players[0] != 0 && players[1] != 0) {
            StartGame(game_uid);
        }

        Users.setGame(_msgSender(), game_key);
        return CardTableLib.getValue(PileType.Deck, player_key);

    }

    function StartGame(string memory game_uid) internal {

        bytes32 game_key = keccak256(abi.encode(game_uid));
        if (Games.get(game_key).gameState == GameState.GAME_ENDED) {
            revert("Game already ended");
        }

        bytes32[] memory player_keys = Games.getPlayers(game_key);

        //Choose first player
        Games.setGameState(game_key, GameState.PLAY);
        Games.setFirstPlayer(game_key, player_keys[0]);
        Games.setCurrentPlayer(game_key, player_keys[0]);
        Games.setTurnCount(game_key, 1);
        Games.setTurnDuration(game_key, block.timestamp);
        GamesExtended.setSelector(game_key, SelectorType.None);

        //Init each players

        for (uint8 i = 0; i < player_keys.length; i++) {
            bytes32 player_key = player_keys[i];
            int8 nb = Players.getDcards(player_key);
            PlayerLogicLib.DrawCard(player_key, nb);
        }

        //Start state
        GameLogicLib.StartMainPhase(game_key);
    }


    function GetPlayerByGame(bytes32 game_key) public view returns (bytes32[] memory players){
        return Games.getPlayers(game_key);
    }

    function GetGameExtend(bytes32 game_key) public view returns (uint, bytes32, bytes32, bytes32){
        return (
            uint(GamesExtended.getSelector(game_key)),
            GamesExtended.getSelectorCasterUid(game_key),
            GamesExtended.getSelectorPlayerId(game_key),
            GamesExtended.getSelectorAbility(game_key)
        );
    }

    function GetCard(bytes32 card_key) public view returns (int8 hp, int8 mana, int8 attack, int8 damage){
        return (
            CardOnBoards.getHp(card_key),
            CardOnBoards.getMana(card_key),
            CardOnBoards.getAttack(card_key),
            CardOnBoards.getDamage(card_key)
        );
    }

//    function GetCardOnBoard(bytes32 card_key) public view returns (CardOnBoardsData memory){
//        return CardOnBoards.get(card_key);
//    }

    function getPlayerCards(bytes32 player_key) public view returns (string memory name, bytes32[] memory cards, bytes32[] memory hand, bytes32[] memory deck, bytes32[] memory board, int8 mana, int8 hp) {

        name = Players.getName(player_key);
        mana = Players.getMana(player_key);
        hp = Players.getHp(player_key);

        hand = CardTableLib.getValue(PileType.Hand, player_key);
        deck = CardTableLib.getValue(PileType.Deck, player_key);
        board = CardTableLib.getValue(PileType.Board, player_key);

        bytes32[] memory cards = new bytes32[](hand.length + deck.length);

        for (uint i = 0; i < hand.length; i++) {
            cards[i] = CardOnBoards.getId(hand[i]);
        }

        for (uint i = 0; i < deck.length; i++) {
            cards[hand.length + i] = CardOnBoards.getId(deck[i]);
        }

        return (name, cards, hand, deck, board, mana, hp);
    }

    //    struct CardTuple {
    //        bytes32 card_key;
    //        bytes32 card_id;
    //    }
    //
    //    function getCardOnBoards(bytes32[] memory cards) public view returns (CardTuple[] memory){
    //        CardTuple[] memory result;
    //        return result;
    //    }


}