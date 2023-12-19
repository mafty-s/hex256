pragma solidity >=0.8.21;

import "../codegen/common.sol";
import {Cards, Matches, Ability, PlayerCardsBoard} from "../codegen/index.sol";
import {AbilityTrigger, AbilityTarget} from "../codegen/common.sol";

import {EffectLib} from "./EffectLib.sol";
import {PlayerLogicLib} from "./PlayerLogicLib.sol";
import {GameLogicLib} from "./GameLogicLib.sol";
import {BaseLogicLib} from "./BaseLogicLib.sol";
import {Slot, SlotLib} from "./SlotLib.sol";

library AiLogicLib {
    function Think(bytes32 game_key, bytes32 player_key) internal {
        if (!CanPlay(player_key)) {
            return;
        }


        if (BaseLogicLib.IsPlayerTurn(game_key, player_key)) {
            AiTurn(player_key);
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

    function AiTurn(bytes32 player_key) internal {
        //todo
        AiPlayCard(player_key);
        AiPlayCard(player_key);
        AiPlayCard(player_key);
        AiAttackCard(player_key);
        AiAttackCard(player_key);
        AiAttackPlayer(player_key);
        AiEndTurn(player_key);
    }

    function AiPlayCard(bytes32 player_key) internal{
        bytes32 random_card_key = PlayerLogicLib.GetRandomCard(player_key);
        Slot memory random_slot = SlotLib.GetRandomEmptySlot(player_key);

        //todo
    }

    function AiAttackCard(bytes32 player_key) internal {
        //                Card random = player.GetRandomCard(player.cards_board, rand);
        //Card rtarget = game_data.GetRandomBoardCard(rand);
        //if (random != null && rtarget != null)
        //    gameplay.AttackTarget(random, rtarget);
        //todo
    }

    function AiAttackPlayer(bytes32 player_key) internal {
        //todo
    }

    function AiEndTurn(bytes32 player_key) internal {
        //todo
    }

    function CanPlay(bytes32 player_key) internal returns (bool){
        //todo
        return true;
    }
}