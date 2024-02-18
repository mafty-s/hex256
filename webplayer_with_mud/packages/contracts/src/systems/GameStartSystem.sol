// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {Decks, DecksData} from "../codegen/index.sol";
import {Games, GamesData, GamesExtended} from "../codegen/index.sol";
import {Players, PlayersData} from "../codegen/index.sol";
import {PlayerCardsDeck, PlayerCardsHand, PlayerCardsBoard, PlayerCardsDiscard, PlayerCardsEquip, PlayerCardsSecret, PlayerCardsTemp} from "../codegen/index.sol";
import {CardOnBoards, CardOnBoardsData} from "../codegen/index.sol";
import {GameType, GameState, GamePhase, SelectorType} from "../codegen/common.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";

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



    function PlayerSetting(string memory username, string memory game_uid, string memory desk_id, bool is_ai, int8 hp, int8 mana, int8 dcards, bool need_shuffle) public returns (bytes32[] memory) {

        bytes32 desk_key = keccak256(abi.encode(desk_id));
        bytes32 game_key = keccak256(abi.encode(game_uid));
        bytes32 player_key = keccak256(abi.encode(game_uid, username));

        //        DecksData memory deck = Decks.get(desk_key);


        Games.pushPlayers(game_key, player_key);

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

        bytes32[] memory cards = Decks.getCards(desk_key);
        if (need_shuffle) {
            cards = shuffle(cards);
        }

        PlayerCardsDiscard.setValue(player_key, new bytes32[](0));
        PlayerCardsEquip.setValue(player_key, new bytes32[](0));
        PlayerCardsSecret.setValue(player_key, new bytes32[](0));
        PlayerCardsTemp.setValue(player_key, new bytes32[](0));
        PlayerCardsBoard.setValue(player_key, new bytes32[](0));
        PlayerCardsDeck.setValue(player_key, new bytes32[](0));

        for (uint i = 0; i < cards.length; i++) {
            bytes32 on_board_card_key = GameLogicLib.AddCard(player_key, cards[i]);
            PlayerCardsDeck.pushValue(player_key, on_board_card_key);
        }


        if (Games.getPlayers(game_key).length == 2) {
            StartGame(game_uid);
        }


        return PlayerCardsDeck.getValue(player_key);

    }

    function StartGame(string memory game_uid) internal {

        bytes32 game_key = keccak256(abi.encode(game_uid));
        if (Games.get(game_key).gameState == GameState.GAME_ENDED) {
            revert("Game already ended");
        }

        bytes32[] memory player_keys = Games.getPlayers(game_key);

        //Choose first player
        Games.setGameState(game_key, GameState.PLAY);
        Games.setFirstPlayer(game_key, player_keys[uint8(block.prevrandao % 2)]);
        Games.setCurrentPlayer(game_key, Games.getFirstPlayer(game_key));
        Games.setTurnCount(game_key, 1);
        GamesExtended.setSelector(game_key, SelectorType.None);

        //Init each players

        for (uint8 i = 0; i < player_keys.length; i++) {
            bytes32 player_key = player_keys[i];
            int8 nb = Players.getDcards(player_key);
            PlayerLogicLib.DrawCard(player_key, nb);
        }

        //Start state
        StartTurn(game_key);
    }

    function StartTurn(bytes32 game_key) internal {
        if (Games.get(game_key).gameState == GameState.GAME_ENDED) {
            revert("Game already ended");
        }
        ClearTurnData();
        Games.setGamePhase(game_key, GamePhase.START_TURN);

        //todo

        //
        //        Player player = game_data.GetActivePlayer();
        //
        //        //Cards draw
        //        if (game_data.turn_count > 1 || player.player_id != game_data.first_player)
        //        {
        //            DrawCard(player, GameplayData.Get().cards_per_turn);
        //        }
        //
        //        //Mana
        //        player.mana_max += GameplayData.Get().mana_per_turn;
        //        player.mana_max = Mathf.Min(player.mana_max, GameplayData.Get().mana_max);
        //        player.mana = player.mana_max;
        //
        //        //Turn timer and history
        //        game_data.turn_timer = GameplayData.Get().turn_duration;
        //        player.history_list.Clear();
        //
        //        //Player poison
        //        if (player.HasStatus(StatusType.Poisoned))
        //            player.hp -= player.GetStatusValue(StatusType.Poisoned);
        //
        //        if (player.hero != null)
        //            player.hero.Refresh();
        //
        //        //Refresh Cards and Status Effects
        //        for (int i = player.cards_board.Count - 1; i >= 0; i--)
        //        {
        //            Card card = player.cards_board[i];
        //
        //            if(!card.HasStatus(StatusType.Sleep))
        //                card.Refresh();
        //
        //            if (card.HasStatus(StatusType.Poisoned))
        //                DamageCard(card, card.GetStatusValue(StatusType.Poisoned));
        //        }
        //
        //        //Ongoing Abilities
        //        UpdateOngoing();
        //
        //        //StartTurn Abilities
        //        TriggerPlayerCardsAbilityType(player, AbilityTrigger.StartOfTurn);
        //        TriggerPlayerSecrets(player, AbilityTrigger.StartOfTurn);
        //
        //        resolve_queue.AddCallback(StartMainPhase);
        //        resolve_queue.ResolveAll(0.2f);

    }

    function ClearTurnData() internal {
        //todo
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

        hand = PlayerCardsHand.getValue(player_key);
        deck = PlayerCardsDeck.getValue(player_key);
        board = PlayerCardsBoard.getValue(player_key);

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