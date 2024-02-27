// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Ability} from "../codegen/index.sol";
import {Action, CardTrait} from "../codegen/common.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
//import {GameLogicLib} from "../libs/GameLogicLib.sol";

contract Effect4System is System {

    constructor() {

    }

    event EventEffect(string name,bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card);

    //todo
    function EffectDamage(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        emit EventEffect("EffectDamage", ability_key, caster, target, is_card);
        int8 value = Ability.getValue(ability_key);
//        int8 damage = GetDamage(caster, value, is_card, CardTrait.SpellDamage);
//        if (is_card) {
//            GameLogicLib.DamageCard(caster, target, damage, true);
//        } else {
//            GameLogicLib.DamagePlayer(caster, target, damage, true);
//        }
    }



    //----------------------------------------------------------------------------------------------------------------


    function GetDamage(bytes32 caster, int8 value, bool is_card, CardTrait bonus_damage) internal returns (int8){
        if (is_card) {
            int8 damage = value + CardLogicLib.GetTraitValue(caster, bonus_damage);
            return damage;
        } else {
            int8 damage = value + PlayerLogicLib.GetTraitValue(caster, bonus_damage);
            return damage;
        }
    }
}