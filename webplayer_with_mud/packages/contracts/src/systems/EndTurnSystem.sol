// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {Cards} from "../codegen/index.sol";
import {Packs, PacksData} from "../codegen/index.sol";
import {Decks, DecksData} from "../codegen/index.sol";
import {CardType, GameType, GameState, GamePhase, PackType, RarityType, AbilityTrigger, GamePhase, Action} from "../codegen/common.sol";
import {BaseLogicLib} from "../libs/BaseLogicLib.sol";
import {Games, GamesData} from "../codegen/index.sol";
import {AiLogicLib} from "../libs/AiLogicLib.sol";
import {PlayerCardsHand, PlayerCardsDeck, PlayerCardsEquip, PlayerCardsBoard, Players} from "../codegen/index.sol";
import {PlayerActionHistory, ActionHistory, ActionHistoryData} from "../codegen/index.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {IAbilitySystem} from "../codegen/world/IAbilitySystem.sol";
import {IOnGoingSystem} from "../codegen/world/IOnGoingSystem.sol";


contract EndTurnSystem is System {


    constructor() {

    }

    function EndTurn(bytes32 game_key, bytes32 player_key) public returns (bytes32 opponent_player_key, bytes32 board_card_key, int8 mana, int8 mana_max){

        if (Games.getGameState(game_key) == GameState.GAME_ENDED) {
            revert("game ended");
        }
        if (Games.getGamePhase(game_key) != GamePhase.MAIN) {
            revert("not main phase");
        }

        Games.setTurnCount(game_key, Games.getTurnCount(game_key) + 1);
        Games.setGamePhase(game_key, GamePhase.END_TURN);

        int8 mana = Players.getMana(player_key);
        int8 mana_max = Players.getManaMax(player_key);
        mana += 1;
        mana_max += 1;
        if (mana > mana_max) {
            mana = Players.getManaMax(player_key);
        }
        Players.setMana(player_key, mana);
        Players.setManaMax(player_key, mana_max);

        //抽张卡出来
        bytes32 board_card_key = 0;
        bytes32[] memory draw_cards = PlayerLogicLib.DrawCard(player_key, 1);
        if (draw_cards.length > 0) {
            board_card_key = draw_cards[0];
        }

        //参考 GameLogic.cs StartTurn StartNextTurn 恢复Mana等

        Games.setCurrentPlayer(game_key, opponent_player_key);
//        Games.setGamePhase(game_key, GamePhase.START_TURN);
        if (Games.getGameType(game_key) == GameType.SOLO || Games.getGameType(game_key) == GameType.ADVENTURE) {
            //AiLogicLib.Think(game_key, opponent_player_key);
        }

//        EndTurnResultData memory result = EndTurnResultData

        uint256 len = PlayerActionHistory.length(game_key);
        bytes32 action_key = keccak256(abi.encode(game_key, len));
        PlayerActionHistory.push(game_key, action_key);
        ActionHistory.setActionType(action_key, Action.EndTurn);
        ActionHistory.setTarget(action_key, board_card_key);
//        ActionHistory.setPlayerId(action_key, player_index);

        bytes32[] memory players = Games.getPlayers(game_key);
        for (uint i = 0; i < players.length; i++) {
            bytes32[] memory cards_onboard = PlayerCardsBoard.getValue(players[i]);
            for (uint c = 0; c < cards_onboard.length; c++) {
                CardLogicLib.ReduceStatusDurations(cards_onboard[c]);
            }
            bytes32[] memory cards_equiped = PlayerCardsEquip.getValue(players[i]);
            for (uint c = 0; c < cards_equiped.length; c++) {
                CardLogicLib.ReduceStatusDurations(cards_equiped[c]);
            }
        }

        SystemSwitch.call(
            abi.encodeCall(IAbilitySystem.TriggerPlayerCardsAbilityType, (player_key, AbilityTrigger.START_OF_TURN))
        );

        SystemSwitch.call(
            abi.encodeCall(IAbilitySystem.TriggerPlayerSecrets, (player_key, AbilityTrigger.START_OF_TURN))
        );

        bytes32 opponent_player_key = getOpponentPlayer(game_key, player_key);

        SystemSwitch.call(
            abi.encodeCall(IOnGoingSystem.UpdateOngoing, (game_key))
        );

        return (opponent_player_key, board_card_key, mana, mana_max);
    }

    function getOpponentPlayer(bytes32 game_key, bytes32 player_key) public view returns (bytes32 opponent_player_key) {
        bytes32[] memory players = Games.getPlayers(game_key);
        require(players.length == 2, "player count must be 2");
        require(players[0] != 0 && players[1] != 0, "player key must not be 0");
        require(players[0] != players[1], "player key must not be same");
        require(players[0] == player_key || players[1] == player_key, "player key must be in game");
        if (players[0] == player_key) {
            return players[1];
        } else {
            return players[0];
        }
    }

}