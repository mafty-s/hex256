// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {Packs, PacksData} from "../codegen/index.sol";
import {Decks, DecksData} from "../codegen/index.sol";
import {CardType, GameType, GameState, GamePhase, PackType, RarityType, AbilityTrigger, GamePhase} from "../codegen/common.sol";

import {AbilityLib} from "../libs/AbilityLib.sol";
import {BaseLogicLib} from "../libs/BaseLogicLib.sol";
import {Matches, MatchesData} from "../codegen/index.sol";
import {AiLogicLib} from "../libs/AiLogicLib.sol";
import {EndTurnResultData ,PlayerCardsHand,PlayerCardsDeck,Players} from "../codegen/index.sol";

contract EndTurnSystem is System {


    constructor() {

    }

    function EndTurn(bytes32 game_key, uint8 player_index) public returns ( EndTurnResultData memory result) {
        Matches.setTurnCount(game_key, Matches.getTurnCount(game_key) + 1);
        Matches.setGamePhase(game_key, GamePhase.END_TURN);

        bytes32 player_key = Matches.getPlayers(game_key)[player_index];
        uint8 opponent_index = player_index == 0 ? 1 : 0;
        bytes32 opponent_player_key = Matches.getPlayers(game_key)[opponent_index];

        //todo 恢复mana
        uint8 mana = Players.getMana(player_key);
        mana += 1;
        if(mana > Players.getManaMax(player_key)){
            mana = Players.getManaMax(player_key);
        }
        Players.setMana(player_key,mana);

        //抽张卡出来
        bytes32 board_card_key = 0;

        bytes32[] memory cards = PlayerCardsDeck.getValue(player_key);
        if(cards.length>0){
            board_card_key = cards[cards.length - 1];
            PlayerCardsDeck.popValue(player_key);
            PlayerCardsHand.pushValue(player_key, board_card_key);
        }

        //参考 GameLogic.cs StartTurn StartNextTurn 恢复Mana等

        Matches.setCurrentPlayer(game_key, opponent_player_key);
//        Matches.setGamePhase(game_key, GamePhase.START_TURN);
        if (Matches.getGameType(game_key) == GameType.SOLO || Matches.getGameType(game_key) == GameType.ADVENTURE) {
            //AiLogicLib.Think(game_key, opponent_player_key);
        }

        EndTurnResultData memory result = EndTurnResultData(
            opponent_player_key,
            board_card_key,
            mana
        );
        return result;
    }

}