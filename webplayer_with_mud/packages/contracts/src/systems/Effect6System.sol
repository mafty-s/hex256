// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Players, Ability, GamesExtended, CardOnBoards} from "../codegen/index.sol";
import {Action, EffectAttackerType} from "../codegen/common.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";
import {SlotLib, Slot} from "../libs/SlotLib.sol";
import {PlayerCardsHand} from "../codegen/index.sol";
import {ConditionTargetType} from "../codegen/common.sol";

contract Effect6System is System {

    constructor() {

    }

    event EventEffect(string name,bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card);

    function EffectAttackRedirect(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectAttackRedirect", ability_key, caster, target, is_card);
        //todo
    }

    function EffectAttack(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectAttack", ability_key, caster, target, is_card);
        RunAttacker(ability_key, caster, target, is_card, EffectAttackerType.Self);
    }


    function EffectDestroyEquip(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectDestroyEquip", ability_key, caster, target, is_card);
        if (is_card == ConditionTargetType.Card) {
            if (CardLogicLib.IsEquipment(target)) {
                GameLogicLib.DiscardCard(target);
            } else {
                bytes32 equipped_uid = CardOnBoards.getEquippedUid(target);
                GameLogicLib.DiscardCard(equipped_uid);
            }
        }
    }


    function EffectHeal(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectHeal", ability_key, caster, target, is_card);
        int8 value = Ability.getValue(ability_key);
        if (is_card == ConditionTargetType.Card) {
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


    function EffectChangeOwnerSelf(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectChangeOwnerSelf", ability_key, caster, target, is_card);
        if (is_card == ConditionTargetType.Card) {
            bytes32 player_key = CardOnBoards.getPlayerId(caster);
            GameLogicLib.ChangeOwner(target, player_key);
        }
    }

    function EffectDiscard(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectDiscard", ability_key, caster, target, is_card);
        if (is_card == ConditionTargetType.Card) {
            GameLogicLib.DiscardCard(target);
        } else {
            int8 value = Ability.getValue(ability_key);
            GameLogicLib.DrawDiscardCard(target, value);
        }
    }

    function EffectPlayCard(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectPlayCard", ability_key, caster, target, is_card);
        if (is_card == ConditionTargetType.Card) {
            bytes32 player_key = CardOnBoards.getPlayerId(caster);
            Slot memory slot = PlayerLogicLib.GetRandomEmptySlot(player_key);

            PlayerLogicLib.RemoveCardFromAllGroups(player_key, target);
            PlayerCardsHand.pushValue(player_key, target);


            if (slot.x == 0 && slot.y == 0) {

            }
            //todo

        }
    }


    //----------------------------------------------------------------------------------------------------------------



    function RunAttacker(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card, EffectAttackerType attack_type) internal {
        bytes32 attacker = GetAttacker(caster, attack_type);
        if (attacker != 0x0000000000000000000000000000000000000000000000000000000000000000) {
            if (is_card == ConditionTargetType.Card) {
                GameLogicLib.AttackTarget(caster, target, false);
            } else {
                GameLogicLib.AttackPlayer(caster, target, false);
            }
        }
    }

    function GetAttacker(bytes32 caster, EffectAttackerType attacker_type) internal view returns (bytes32)
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


}