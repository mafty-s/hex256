pragma solidity >=0.8.21;

import "../codegen/common.sol";
import {Cards, Matches, Ability, Players, PlayerCardsBoard} from "../codegen/index.sol";
import {AbilityTrigger, AbilityTarget} from "../codegen/common.sol";

import "../libs/GameLogicLib.sol";

library EffectHeal {

    function DoEffectToPlayer(bytes32 ability_key, bytes32 caster, bytes32 target) internal {
        Players.setHp(target, Players.getHp(target) + Ability.getValue(ability_key));
        if(Players.getHp(target) > Players.getHpMax(target)){
            Players.setHp(target, Players.getHpMax(target));
        }
    }

    function DoEffectToCard(bytes32 ability_key, bytes32 caster, bytes32 target) internal {
        GameLogicLib.HealCard(target, Ability.getValue(ability_key));
    }
}