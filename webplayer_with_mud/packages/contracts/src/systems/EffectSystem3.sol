// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {Players, Ability, Games, PlayerActionHistory, ActionHistory, CardOnBoards, Cards} from "../codegen/index.sol";
import {Action, TraitData, EffectStatType} from "../codegen/common.sol";
import {MathLib} from "../libs/MathLib.sol";

contract EffectSystem3 is System {

    function EffectAddAbilityActivateBurst(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        bytes32 activate_burst = 0x35a83131763a5fd836c655a2cbcf566b8f349f0ed26c06bc8b698efb92ef1030;
        EffectAddAbility(ability_key, caster, target, is_card, activate_burst);
        //todo ongoing
    }

    function EffectAddAbilityDefendDiscard(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        bytes32 defend_discard = 0x0e67649232712026af124aca3537a9624ff2cd6cffcd36c4deea1e50cab4a10d;
        EffectAddAbility(ability_key, caster, target, is_card, defend_discard);
        //todo ongoing
    }

    function EffectAddAbilityPlaySacrifice(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        bytes32 play_other_sacrifice = 0x073e02d870681a1b050e79c53ce983f1b49eae0008ee39f631254c8e51794b28;
        EffectAddAbility(ability_key, caster, target, is_card, play_other_sacrifice);
        //todo ongoing
    }

    function EffectAddAbilitySufferDamage(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        bytes32  attack_suffer_damage = 0x5d55feec727e654c7cd81cd35b65fc49c8dbc7da7a038d31b5cf32a2b58afb05;
        EffectAddAbility(ability_key, caster, target, is_card, attack_suffer_damage);
        //todo ongoing
    }

    //----------------------------------------------------------------------------------------------------------------
    //在卡牌上附加一个能力
    function EffectAddAbility(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, bytes32 ab) internal {

    }

}