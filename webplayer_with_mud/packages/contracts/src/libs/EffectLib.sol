pragma solidity >=0.8.21;

import {Cards, Matches, Ability, Players, PlayerCardsBoard} from "../codegen/index.sol";
import {AbilityTrigger, AbilityTarget} from "../codegen/common.sol";

import {GameLogicLib} from "./GameLogicLib.sol";

library EffectLib {

    function selectorCall(bytes4 selector, bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal returns (bool) {
        (bool success,) = address(this).call(abi.encodeWithSelector(selector, ability_key, caster, target, is_card));
        return success;
    }

    function EffectHeal(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        if (is_card) {
            GameLogicLib.HealCard(target, Ability.getValue(ability_key));
        } else {
            Players.setHp(target, Players.getHp(target) + Ability.getValue(ability_key));
            if (Players.getHp(target) > Players.getHpMax(target)) {
                Players.setHp(target, Players.getHpMax(target));
            }
        }
    }

    function EffectDamage(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    ////
    function getDoEffectToCardSelector() public pure returns (bytes4) {
        return bytes4(keccak256("DoEffectToCard(bytes32,bytes32,bytes32)"));
    }

}