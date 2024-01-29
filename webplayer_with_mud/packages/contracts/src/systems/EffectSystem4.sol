// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Players, Ability, GamesExtended, PlayerActionHistory, ActionHistory, CardOnBoards} from "../codegen/index.sol";
import {Action, EffectAttackerType, TraitData} from "../codegen/common.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";

contract EffectSystem4 is System {

    constructor() {

    }

    function EffectAttackRedirect(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        //todo
    }

    function EffectAttack(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        RunAttacker(ability_key, caster, target, is_card, EffectAttackerType.Self);
    }


    function EffectDamage(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        int8 value = Ability.getValue(ability_key);
        int8 damage = GetDamage(caster, value, is_card, TraitData.SpellDamage);
        if (is_card) {
            GameLogicLib.DamageCard(caster, target, damage, true);
        } else {
            GameLogicLib.DamagePlayer(caster, target, damage, true);
        }
    }

    function EffectDestroyEquip(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        if (is_card) {
            if (CardLogicLib.IsEquipment(target)) {
                GameLogicLib.DiscardCard(target);
            } else {
                bytes32 equipped_uid = CardOnBoards.getEquippedUid(target);
                GameLogicLib.DiscardCard(equipped_uid);
            }
        }
    }


    function EffectHeal(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        int8 value = Ability.getValue(ability_key);
        if (is_card) {
            GameLogicLib.HealCard(target, value);
        } else {
            int8 hp = Players.getHp(target);
            int8 hp_max = Players.getHpMax(target);
            if (hp > hp_max) {
                hp = hp_max;
            }
            Players.setHp(target, hp);
        }
    }

    //----------------------------------------------------------------------------------------------------------------
    function RunAttacker(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, EffectAttackerType attack_type) internal {
        bytes32 attacker = GetAttacker(caster, attack_type);
        if (attacker != 0x0000000000000000000000000000000000000000000000000000000000000000) {
            if (is_card) {
                GameLogicLib.AttackTarget(caster, target, false);
            } else {
                GameLogicLib.AttackPlayer(caster, target, false);
            }
        }
    }

    function GetAttacker(bytes32 caster, EffectAttackerType attacker_type) internal returns (bytes32)
    {
        bytes32 player_key = CardOnBoards.getPlayerId(caster);
        bytes32 game_key = Players.getGame(player_key);
        if (attacker_type == EffectAttackerType.Self)
            return caster;
        if (attacker_type == EffectAttackerType.AbilityTriggerer) {
            return GamesExtended.getAbilityTriggerer(game_key);
        }
        if (attacker_type == EffectAttackerType.LastPlayed) {
            return GamesExtended.getLastPlayed(game_key);
        }
        if (attacker_type == EffectAttackerType.LastTargeted) {
            return GamesExtended.getLastTarget(game_key);
        }
        return 0x0000000000000000000000000000000000000000000000000000000000000000;
    }

    function GetDamage(bytes32 caster, int8 value, bool is_card, TraitData bonus_damage) internal returns (int8){
        int8 damage = value + CardLogicLib.GetTraitValue(caster, bonus_damage);
        return damage;
    }
}