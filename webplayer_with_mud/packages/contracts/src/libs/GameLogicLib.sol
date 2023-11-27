// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {CardOnBoards, CardOnBoardsData} from "../codegen/index.sol";
import {Cards, CardsData} from "../codegen/index.sol";

import {CardType, GameType, GameState, GamePhase, PackType, RarityType} from "../codegen/common.sol";

library GameLogicLib {

    //public virtual void DamagePlayer(Card attacker, Player target, int value)
    //{
    ////Damage player
    //target.hp -= value;
    //target.hp = Mathf.Clamp(target.hp, 0, target.hp_max);
    //
    ////Lifesteal
    //Player aplayer = game_data.GetPlayer(attacker.player_id);
    //if (attacker.HasStatus(StatusType.LifeSteal))
    //aplayer.hp += value;
    //}

    function DamagePlayer(bytes32 player, uint256 value) internal {
        //        player.hp -= value;
        //        player.hp = Math.clamp(player.hp, 0, player.hp_max);
        //todo
    }

    function UpdateOngoing() internal {
        //todo
    }

    function HealCard(bytes32 target, uint8 value) internal {
        //todo
    }

    function EquipCard(bytes32 card, bytes32 equipment) internal {
        //todo
    }







    ////Heal a card
    //public virtual void HealCard(Card target, int value)
    //{
    //if (target == null)
    //return;
    //
    //if (target.HasStatus(StatusType.Invincibility))
    //return;
    //
    //target.damage -= value;
    //target.damage = Mathf.Max(target.damage, 0);
    //}

}