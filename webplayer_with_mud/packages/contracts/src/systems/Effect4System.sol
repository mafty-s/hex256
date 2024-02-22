// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Ability} from "../codegen/index.sol";
import {Action, TraitData} from "../codegen/common.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
//import {GameLogicLib} from "../libs/GameLogicLib.sol";

contract Effect4System is System {

    constructor() {

    }

    //todo
    function EffectDamage(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        int8 value = Ability.getValue(ability_key);
//        int8 damage = GetDamage(caster, value, is_card, TraitData.SpellDamage);
//        if (is_card) {
//            GameLogicLib.DamageCard(caster, target, damage, true);
//        } else {
//            GameLogicLib.DamagePlayer(caster, target, damage, true);
//        }
    }



    //----------------------------------------------------------------------------------------------------------------


    function GetDamage(bytes32 caster, int8 value, bool is_card, TraitData bonus_damage) internal returns (int8){
        if (is_card) {
            int8 damage = value + CardLogicLib.GetTraitValue(caster, bonus_damage);
            return damage;
        } else {
            int8 damage = value + PlayerLogicLib.GetTraitValue(caster, bonus_damage);
            return damage;
        }
    }
}