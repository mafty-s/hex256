// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {Decks, DecksData} from "../codegen/index.sol";
import {Matches, MatchesData} from "../codegen/index.sol";
import {Players, PlayersData} from "../codegen/index.sol";
import {PlayerCardsDeck, PlayerCardsHand} from "../codegen/index.sol";
import {CardOnBoards, CardOnBoardsData} from "../codegen/index.sol";

import {GameType, GameState, GamePhase} from "../codegen/common.sol";

//import "../logic/PlayerLogicLib.sol";
//import "../logic/CardLogicLib.sol";


contract GameStartSystem is System {


    function GameSetting(string memory game_uid) public {

    }

    function PlayerSetting(string memory username, string memory game_uid, string memory desk_id, bool is_ai) public {

        bytes32 desk_key = keccak256(abi.encode(desk_id));
        bytes32 match_key = keccak256(abi.encode(game_uid));
        bytes32 player_key = keccak256(abi.encode(game_uid, username));

        //        DecksData memory deck = Decks.get(desk_key);

        Matches.pushPlayers(match_key, player_key);
        Players.set(player_key, PlayersData({owner : address(0), hp : 20, mana : 2, hpMax : 20, manaMax : 2, name : username, deck : desk_id, isAI : is_ai}));


        bytes32[] memory cards = Decks.getCards(desk_key);
        for (uint i = 0; i < cards.length; i++) {
            bytes32 card_key = keccak256(abi.encode(cards[i], player_key));
            CardsData memory card = Cards.get(cards[i]);
            //            CardOnBoards.set(card_key, CardOnBoardsData({id : card_key, name : card.tid, hp : card.hp, hpOngoing : 0, attack : card.attack, attackOngoing : 0, mana : card.mana, manaOngoing : 0, damage : 0, exhausted : false, equippedUid : 0, playerId : player_key}));
            CardOnBoards.setId(card_key, card_key);
            //            CardOnBoards.setName(card_key,card.tid);
            CardOnBoards.setHp(card_key, card.hp);
            //            CardOnBoards.setHpOngoing(card_key,0);
            CardOnBoards.setAttack(card_key, card.attack);
            //            CardOnBoards.setAttackOngoing(card_key,0);
            CardOnBoards.setMana(card_key, card.mana);
            //            CardOnBoards.setManaOngoing(card_key,0);
            //            CardOnBoards.setDamage(card_key,0);
            //            CardOnBoards.setExhausted(card_key,false);
            //            CardOnBoards.setEquippedUid(card_key,0);
            CardOnBoards.setPlayerId(card_key, player_key);

            PlayerCardsDeck.pushValue(player_key, card_key);
        }


        if (Matches.getPlayers(match_key).length == 2) {
            StartGame(game_uid);
        }

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
            PlayersData memory player = Players.get(player_key);
            //todo
            Players.setHp(player_key, player.hpMax);
            Players.setMana(player_key, player.manaMax);
            DrawCard(player_key, 5);
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

}