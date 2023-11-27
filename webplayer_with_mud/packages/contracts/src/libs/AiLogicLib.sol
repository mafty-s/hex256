pragma solidity >=0.8.21;

import "../codegen/common.sol";
import {Cards, Matches, Ability, PlayerCardsBoard} from "../codegen/index.sol";
import {AbilityTrigger, AbilityTarget} from "../codegen/common.sol";

import {EffectLib} from "./EffectLib.sol";
import {PlayerLogicLib} from "./PlayerLogicLib.sol";
import {GameLogicLib} from "./GameLogicLib.sol";
import {BaseLogicLib} from "./BaseLogicLib.sol";

library AiLogicLib {
    function Think(bytes32 game_key, bytes32 player_key) internal {
        if (!CanPlay(player_key)) {
            return;
        }


        if (BaseLogicLib.IsPlayerTurn(game_key, player_key)) {
            AiTurn();
        }
//
//        if (game_data.IsPlayerTurn(player) && !gameplay.IsResolving())
//        {
//            if(!is_playing && game_data.selector == SelectorType.None && game_data.current_player == player_id)
//            {
//                is_playing = true;
//                TimeTool.StartCoroutine(AiTurn());
//            }


    }

    function AiTurn() internal {
        //todo
        AiPlayCard();
        AiPlayCard();
        AiPlayCard();
        AiAttackCard();
        AiAttackCard();
        AiAttackPlayer();
        AiEndTurn();
    }

    function AiPlayCard() internal{
        //todo
    }

    function AiAttackCard() internal {
        //todo
    }

    function AiAttackPlayer() internal {
        //todo
    }

    function AiEndTurn() internal {
        //todo
    }

    function CanPlay(bytes32 player_key) internal returns (bool){
        //todo
        return true;
    }
}pl;ol;;]\\\\\\\\\\\
w333eghwj