// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {IEffectSystem} from "../codegen/world/IEffectSystem.sol";
import {Ability, CardOnBoards, Cards, PlayerActionHistory, ActionHistory, Players} from "../codegen/index.sol";
import {AbilityTrigger, Status, Action, AbilityTarget} from "../codegen/common.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";

contract AbilitySystem is System {
    //使用技能
    function UseAbility(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        //使用效果
        bytes4[] memory effects = Ability.getEffects(ability_key);
        for (uint i = 0; i < effects.length; i++) {
            SystemSwitch.call(
                abi.encodeCall(IEffectSystem.DoEffect, (effects[i], ability_key, caster, target, is_card))
            );
        }
        //添加状态，如嘲讽等
        uint8[] memory status = Ability.getStatus(ability_key);
        bytes32 player_key = CardOnBoards.getPlayerId(target);
        bytes32 game_key = Players.getGame(player_key);
        if (status.length > 0) {
            for (uint i = 0; i < status.length; i++) {
                if (is_card) {
                    CardLogicLib.AddStatus(target, (Status)(status[i]));
                } else {
                    PlayerLogicLib.AddStatus(target, (Status)(status[i]));
                }

                uint256 len = PlayerActionHistory.length(game_key);
                bytes32 action_key = keccak256(abi.encode(game_key, len));
                PlayerActionHistory.push(game_key, action_key);
                ActionHistory.setActionType(action_key, Action.AddStatus);
                ActionHistory.setCardId(action_key, target);
                ActionHistory.setValue(action_key, int8(status[i]));
            }
        }
    }

    //更具trigger技能触发器,触发指定卡的所有技能
    function TriggerCardAbilityType(AbilityTrigger trigger, bytes32 caster, bytes32 target, bool is_card) public {
        bytes32 card_config_id = CardOnBoards.getId(caster);
        bytes32[] memory abilities = Cards.getAbilities(card_config_id);
        for (uint i = 0; i < abilities.length; i++) {
            if (Ability.getTrigger(abilities[i]) == trigger) {
                TriggerCardAbility(abilities[i], caster, target, is_card);
            }
        }
    }

    //触发指定技能
    function TriggerCardAbility(bytes32 ability_key, bytes32 caster, bytes32 triggerer, bool is_card) public {
        bytes32 trigger_card = triggerer != 0x0000000000000000000000000000000000000000000000000000000000000000 ? triggerer : caster; //Triggerer is the caster if not set
        if (!CardLogicLib.HasStatus(trigger_card, Status.Silenced) && AreTriggerConditionsMet(caster, triggerer)) {
            UseAbility(ability_key, caster, trigger_card, is_card);
        }
    }

    function AreTriggerConditionsMet(bytes32 caster, bytes32 trigger_card) public pure returns (bool) {
        return true;
    }

    function ResolveCardAbilitySelector(bytes32 ability_key) internal {
        AbilityTarget target = Ability.getTarget(ability_key);
        if (target == AbilityTarget.SelectTarget) {
            //todo
        }
        //todo
    }

    function IsSelector(AbilityTarget target) internal returns (bool) {
        return target == AbilityTarget.SelectTarget || target == AbilityTarget.CardSelector || target == AbilityTarget.ChoiceSelector;
    }

    function CanTargetCard(bytes32 game_uid, bytes32 caster, bytes32 target) internal returns (bool) {

        if (CardLogicLib.HasStatus(target, Status.Stealth)) {
            return false; //Hidden
        }

        if (CardLogicLib.HasStatus(target, Status.SpellImmunity)) {
            return false; ////Spell immunity
        }

        bool condition_match = AreTargetConditionsMetCard(game_uid, caster, target);
        return condition_match;
    }

}