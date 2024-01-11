// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {Decks, DecksData} from "../codegen/index.sol";
import {Matches, MatchesData} from "../codegen/index.sol";
import {Players, PlayersData} from "../codegen/index.sol";
import {PlayerCardsDeck, PlayerCardsHand, PlayerCardsBoard, PlayerCardsDiscard, PlayerCardsEquip, PlayerCardsSecret} from "../codegen/index.sol";
import {CardOnBoards, CardOnBoardsData} from "../codegen/index.sol";

import {GameType, GameState, GamePhase} from "../codegen/common.sol";

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

    function PlayerSetting(string memory username, string memory game_uid, string memory desk_id, bool is_ai, uint8 hp, uint8 mana, uint8 dcards,bool need_shuffle) public returns (bytes32[] memory) {

        bytes32 desk_key = keccak256(abi.encode(desk_id));
        bytes32 match_key = keccak256(abi.encode(game_uid));
        bytes32 player_key = keccak256(abi.encode(game_uid, username));

        //        DecksData memory deck = Decks.get(desk_key);

        Matches.pushPlayers(match_key, player_key);
        Players.set(player_key, PlayersData({owner: _msgSender(), dcards: dcards, hp: hp, mana: mana, hpMax: hp, manaMax: mana, name: username, deck: desk_id, isAI: is_ai}));



        bytes32[] memory cards = Decks.getCards(desk_key);
        if(need_shuffle){
            cards = shuffle(cards);
        }

        for (uint i = 0; i < cards.length; i++) {
            bytes32 on_board_card_key = keccak256(abi.encode(cards[i], player_key, i));
            CardsData memory card = Cards.get(cards[i]);
            CardOnBoards.setId(on_board_card_key, cards[i]);
            CardOnBoards.setHp(on_board_card_key, card.hp);
            CardOnBoards.setAttack(on_board_card_key, card.attack);
            CardOnBoards.setMana(on_board_card_key, card.mana);
            CardOnBoards.setPlayerId(on_board_card_key, player_key);

            PlayerCardsDeck.pushValue(player_key, on_board_card_key);
        }


        if (Matches.getPlayers(match_key).length == 2) {
            StartGame(game_uid);
        }

        return PlayerCardsDeck.getValue(player_key);

    }


    function StartGame(string memory game_uid) internal {

        bytes32 match_key = keccak256(abi.encode(game_uid));
        if (Matches.get(match_key).gameState == GameState.GAME_ENDED) {
            revert("Game already ended");
        }

        bytes32[] memory player_keys = Matches.getPlayers(match_key);

        //Choose first player
        Matches.setGameState(match_key, GameState.PLAY);
        Matches.setFirstPlayer(match_key, player_keys[uint8(block.prevrandao % 2)]);
        Matches.setCurrentPlayer(match_key, Matches.getFirstPlayer(match_key));
        Matches.setTurnCount(match_key, 1);

        //Init each players

        for (uint8 i = 0; i < player_keys.length; i++) {
            bytes32 player_key = player_keys[i];
            DrawCard(player_key, Players.getDcards(player_key));
        }

        //Start state
        StartTurn(match_key);
    }


    function DrawCard(bytes32 player_key, uint nb) internal {
        for (uint i = 0; i < nb; i++) {
            bytes32[] memory cards = PlayerCardsDeck.getValue(player_key);
            bytes32 card_key = cards[cards.length - 1];
            PlayerCardsDeck.popValue(player_key);
            PlayerCardsHand.pushValue(player_key, card_key);
        }
    }

    function StartTurn(bytes32 match_key) internal {
        if (Matches.get(match_key).gameState == GameState.GAME_ENDED) {
            revert("Game already ended");
        }
        ClearTurnData();
        Matches.setGamePhase(match_key, GamePhase.START_TURN);

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

    function testRevert() public {
        revert("Can't play card");
    }

    function getPlayerCards(bytes32 player_key) public view returns (string memory name, bytes32[] memory cards, bytes32[] memory hand, bytes32[] memory deck, bytes32[] memory board) {

        name = Players.getName(player_key);

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

        return (name, cards, hand, deck, board);
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