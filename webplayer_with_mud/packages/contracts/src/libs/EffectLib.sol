pragma solidity >=0.8.21;

import {Cards, Matches, Ability, Players, PlayerCardsBoard} from "../codegen/index.sol";
import {AbilityTrigger, AbilityTarget} from "../codegen/common.sol";

import {GameLogicLib} from "./GameLogicLib.sol";

library EffectLib {

    function DoEffect(bytes4 selector, bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal returns (bool) {
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

    function EffectAddStatCount(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectAddStat(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectSendPile(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectCreate(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectAttack(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectSummon(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectSetStat(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectAttackRedirect(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectAddStatRoll(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectAddTrait(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectSetStatCustom(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectClearStatus(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectPlay(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectRoll(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectClearTemp(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectChangeOwner(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectDraw(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectAddAbility(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectRemoveTrait(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectDiscard(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectDestroyEquip(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectExhaust(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectRemoveAbility(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectTransform(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        if(is_card){
            //logic.TransformCard(target, transform_to);
        }
        //todo
    }

    function EffectMana(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        uint8 curr_mana = Players.getMana(target) + Ability.getValue(ability_key);
        Players.setMana(target, curr_mana);
        if (Players.getMana(target) < 0) {
            Players.setMana(target, 0);
        }
    }

    function EffectResetStat(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectDestroy(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectShuffle(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

//    function getDoEffectToCardSelector() public pure returns (bytes4) {
//        return bytes4(keccak256("DoEffectToCard(bytes32,bytes32,bytes32)"));
//    }

}