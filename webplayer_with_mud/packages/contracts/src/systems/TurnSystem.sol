// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {Cards} from "../codegen/index.sol";
import {Packs, PacksData} from "../codegen/index.sol";
import {Decks, DecksData} from "../codegen/index.sol";
import {CardType, GameType, GameState, GamePhase, PackType, RarityType, AbilityTrigger, GamePhase, Action, Status, SelectorType} from "../codegen/common.sol";
import {BaseLogicLib} from "../libs/BaseLogicLib.sol";
import {Games, GamesExtended} from "../codegen/index.sol";
import {AiLogicLib} from "../libs/AiLogicLib.sol";
import {PlayerCardsHand, PlayerCardsDeck, PlayerCardsEquip, PlayerCardsBoard, Players} from "../codegen/index.sol";
import {PlayerActionHistory, ActionHistory, ActionHistoryData} from "../codegen/index.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";
import {IAbilitySystem} from "../codegen/world/IAbilitySystem.sol";
import {IOnGoingSystem} from "../codegen/world/IOnGoingSystem.sol";


contract TurnSystem is System {


    constructor() {

    }

    function EndTurn(bytes32 game_key) public {

        if (Games.getGameState(game_key) == GameState.GAME_ENDED) {
            revert("game ended");
        }
        if (Games.getGamePhase(game_key) != GamePhase.MAIN) {
            revert("not main phase");
        }

        Games.setGamePhase(game_key, GamePhase.END_TURN);

        bytes32 player_key = Games.getCurrentPlayer(game_key);

//        EndTurnResultData memory result = EndTurnResultData

//        uint256 len = PlayerActionHistory.length(game_key);
//        bytes32 action_key = keccak256(abi.encode(game_key, len));
//        PlayerActionHistory.push(game_key, action_key);
//        ActionHistory.setActionType(action_key, Action.EndTurn);
//        ActionHistory.setTarget(action_key, board_card_key);
//        ActionHistory.setPlayerId(action_key, player_index);

        bytes32[] memory players = Games.getPlayers(game_key);
        for (uint i = 0; i < players.length; i++) {
            bytes32[] memory cards_onboard = PlayerCardsBoard.getValue(players[i]);
            for (uint c = 0; c < cards_onboard.length; c++) {
                CardLogicLib.ReduceStatusDurations(cards_onboard[c]);
            }
            bytes32[] memory cards_equipped = PlayerCardsEquip.getValue(players[i]);
            for (uint c = 0; c < cards_equipped.length; c++) {
                CardLogicLib.ReduceStatusDurations(cards_equipped[c]);
            }
        }

        SystemSwitch.call(
            abi.encodeCall(IAbilitySystem.TriggerPlayerCardsAbilityType, (AbilityTrigger.END_OF_TURN, game_key, player_key))
        );

        SystemSwitch.call(
            abi.encodeCall(IAbilitySystem.TriggerPlayerSecrets, (player_key, AbilityTrigger.END_OF_TURN))
        );

        StartNextTurn(game_key);
    }

    function StartOfTurn(bytes32 game_key) internal {
        if (Games.getGameState(game_key) == GameState.GAME_ENDED) {
            revert("game ended");
        }
        ClearTurnData(game_key);
        Games.setGamePhase(game_key, GamePhase.START_TURN);
        bytes32 player_key = Games.getCurrentPlayer(game_key);

        //Cards draw
        uint turn_count = Games.getTurnCount(game_key);
        bytes32 first_player_key = Games.getFirstPlayer(game_key);
        if (turn_count > 1 && player_key == first_player_key) {
            PlayerLogicLib.DrawCard(player_key, 1);
        }

        //Mana
        int8 mana = Players.getMana(player_key);
        int8 mana_max = Players.getManaMax(player_key);
        mana += 1;
        mana_max += 1;
        if (mana > mana_max) {
            mana = mana_max;
        }
        Players.setMana(player_key, mana);
        Players.setManaMax(player_key, mana_max);

        //Turn timer and history
        PlayerActionHistory.setValue(game_key, new bytes32[](0));
        Games.setTurnDuration(game_key, block.timestamp);

        //Player poison
        if (PlayerLogicLib.HasStatus(player_key, Status.Poisoned)) {
            int8 hp = Players.getHp(player_key);
            hp -= (int8)(PlayerLogicLib.GetStatusValue(player_key, Status.Poisoned));
            Players.setHp(player_key, hp);
        }

        bytes32 hero = Players.getHero(player_key);
        if (hero != 0) {
            CardLogicLib.ReduceStatusDurations(hero);
        }

        //Refresh Cards and Status Effects
        bytes32[] memory cards_board = PlayerCardsBoard.getValue(player_key);
        if (cards_board.length > 0) {
            for (uint i = 0; i < cards_board.length; i++) {
                CardLogicLib.Refresh(cards_board[i]);

                if (CardLogicLib.HasStatus(cards_board[i], Status.Poisoned)) {
                    GameLogicLib.DamageTargetCard(cards_board[i], CardLogicLib.GetStatusValue(cards_board[i], Status.Poisoned));
                }
            }
        }


        SystemSwitch.call(
            abi.encodeCall(IAbilitySystem.TriggerPlayerCardsAbilityType, (AbilityTrigger.START_OF_TURN, game_key, player_key))
        );

        SystemSwitch.call(
            abi.encodeCall(IAbilitySystem.TriggerPlayerSecrets, (player_key, AbilityTrigger.START_OF_TURN))
        );

        SystemSwitch.call(
            abi.encodeCall(IOnGoingSystem.UpdateOngoing, (game_key))
        );

        GameLogicLib.StartMainPhase(game_key);
    }

    function StartNextTurn(bytes32 game_uid) internal {
        if (Games.getGameState(game_uid) == GameState.GAME_ENDED) {
            return;
        }
        bytes32 current_player = Games.getCurrentPlayer(game_uid);
        bytes32 opponent_player = GameLogicLib.GetOpponent(game_uid, current_player);
        Games.setCurrentPlayer(game_uid, opponent_player);
        if (current_player == Games.getFirstPlayer(game_uid)) {
            Games.setTurnCount(game_uid, Games.getTurnCount(game_uid) + 1);
        }
        GameLogicLib.CheckForWinner(game_uid);
        StartOfTurn(game_uid);
    }

//public virtual void StartNextTurn()

//
//protected virtual void ClearTurnData()
//{
//game_data.selector = SelectorType.None;
//resolve_queue.Clear();
//card_array.Clear();
//player_array.Clear();
//slot_array.Clear();
//card_data_array.Clear();
//game_data.last_played = null;
//game_data.last_destroyed = null;
//game_data.last_target = null;
//game_data.last_summoned = null;
//game_data.ability_triggerer = null;
//game_data.ability_played.Clear();
//game_data.cards_attacked.Clear();
//}

    function ClearTurnData(bytes32 game_uid) internal {
        //todo
        GamesExtended.setSelector(game_uid, SelectorType.None);
        GamesExtended.setLastPlayed(game_uid, 0);
        GamesExtended.setLastDestroyed(game_uid, 0);
        GamesExtended.setLastTarget(game_uid, 0);
        GamesExtended.setLastSummoned(game_uid, 0);
        GamesExtended.setAbilityTriggerer(game_uid, 0);
    }
}