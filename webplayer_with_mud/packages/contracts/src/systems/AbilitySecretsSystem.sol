// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {IAbilitySystem} from "../codegen/world/IAbilitySystem.sol";
import {IConditionSystem} from "../codegen/world/IConditionSystem.sol";
import {Ability, AbilityExtend, CardOnBoards, Cards, PlayerActionHistory, ActionHistory, Players, Games, GamesExtended, Config} from "../codegen/index.sol";
import {AbilityTrigger, Status, Action, AbilityTarget, SelectorType, ConditionTargetType, GameState} from "../codegen/common.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {Slot, SlotLib} from "../libs/SlotLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";
import {ConditionTargetType} from "../codegen/common.sol";
import {PlayerCardsSecret, Config} from "../codegen/index.sol";

contract AbilitySecretsSystem is System {

    event EventResolveSecret(bytes32 game_uid, AbilityTrigger secret_trigger, bytes32 secret_card, bytes32 trigger);

    function ResolveSecret(bytes32 game_uid, AbilityTrigger secret_trigger, bytes32 secret_card, bytes32 trigger) internal {
        emit EventResolveSecret(game_uid, secret_trigger, secret_card, trigger);

        bytes32 icard = CardOnBoards.getId(secret_card);
        bytes32 player = CardOnBoards.getPlayerId(secret_card);
        if (CardLogicLib.IsSecret(icard))
        {
            bytes32 tplayer = CardOnBoards.getPlayerId(trigger);
//            TriggerCardAbilityType(secret_trigger, secret_card, trigger);
            TriggerCardAbilityType(secret_trigger, game_uid, secret_card, trigger, ConditionTargetType.Card);
            GameLogicLib.DiscardCard(game_uid, secret_card);
        } else {
            revert("not IsSecret");
        }
    }


    event EventTriggerSecrets(AbilityTrigger secret_trigger, bytes32 game_uid, bytes32 trigger_card, bytes32 trigger_player, bytes32 target_player);

    function TriggerSecrets(AbilityTrigger secret_trigger, bytes32 game_uid, bytes32 trigger_card) public returns (bool) {
        if (game_uid == 0) {
            return false;
        }
        if (CardLogicLib.HasStatus(trigger_card, Status.SpellImmunity)) {
            //Spell Immunity, triggerer is the one that trigger the trap, target is the one attacked, so usually the player who played the trap, so we dont check the target
            return false;
        }


        bytes32 trigger_player = CardOnBoards.getPlayerId(trigger_card);

        bytes32[] memory players = Games.getPlayers(game_uid);
        for (uint p = 0; p < players.length; p++) {
            bytes32 other_player = players[p];
            if (other_player != trigger_player) {
                emit EventTriggerSecrets(secret_trigger, game_uid, trigger_card, trigger_player, other_player);

                bytes32[] memory cards_secret = PlayerCardsSecret.getValue(other_player);
                if (cards_secret.length == 0) {
                    return false;
                }
                for (uint i = 0; i < cards_secret.length; i++) {
                    bytes32 card = cards_secret[i];
                    if (card != 0) {
                        bytes32 icard = CardOnBoards.getId(card);
                        if (CardLogicLib.IsSecret(icard) && !CardOnBoards.getExhausted(card)) {
                            if (AreAbilityConditionsMet(secret_trigger, game_uid, card, trigger_card)) {
                                CardOnBoards.setExhausted(card, true);
                                ResolveSecret(game_uid, secret_trigger, card, trigger_card);
                                return true;
                            }
                        }
                    }
                }
            }
        }
        return false;
    }

    function TriggerPlayerSecrets(AbilityTrigger secret_trigger, bytes32 game_uid, bytes32 player) public returns (bool) {
        bytes32[] memory cards_secret = PlayerCardsSecret.getValue(player);
        if (cards_secret.length == 0) {
            return false;
        }
        for (uint i = 0; i < cards_secret.length; i++) {
            bytes32 card = cards_secret[i];
            if (card == 0) {
                return false;
            }
            bytes32 icard = CardOnBoards.getId(card);
            if (CardLogicLib.IsSecret(icard) && !CardOnBoards.getExhausted(card)) {
                if (AreAbilityConditionsMet(secret_trigger, game_uid, card, card)) {
                    CardOnBoards.setExhausted(card, true);
                    ResolveSecret(game_uid, secret_trigger, card, card);
                    return true;
                }}
        }
        return false;
    }

    event EventAreAbilityConditionsMet(AbilityTrigger ability_trigger, bytes32 game_uid, bytes32 caster, bytes32 triggerer, bool result);

    function AreAbilityConditionsMet(AbilityTrigger ability_trigger, bytes32 game_uid, bytes32 caster, bytes32 triggerer) internal returns (bool){
        bytes32[] memory abilities = Config.getAbility();
        for (uint i = 0; i < abilities.length; i++) {
            bytes32 ability = abilities[i];
            AbilityTrigger i_ability_trigger = Ability.getTrigger(ability);
            if (i_ability_trigger == ability_trigger) {
                if (AreTriggerConditionsMet(game_uid, ability, caster, triggerer, ConditionTargetType.Card)) {
                    emit EventAreAbilityConditionsMet(ability_trigger, game_uid, caster, triggerer, true);
                    return true;
                }
            }
        }
        emit EventAreAbilityConditionsMet(ability_trigger, game_uid, caster, triggerer, false);
        return false;
    }

    function AreTriggerConditionsMet(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 trigger_card, ConditionTargetType condition_type) internal returns (bool) {
        bytes4[] memory conditions_trigger = AbilityExtend.getConditionsTrigger(ability_key);
        for (uint i = 0; i < conditions_trigger.length; i++) {
            bytes4 condition = conditions_trigger[i];
            if (condition != 0) {
                if (!abi.decode(SystemSwitch.call(abi.encodeCall(IConditionSystem.IsTriggerConditionMet, (condition, game_uid, ability_key, caster, condition_type))), (bool))) {
                    return false;
                }
                if (!abi.decode(SystemSwitch.call(abi.encodeCall(IConditionSystem.IsTargetConditionMet, (condition, game_uid, ability_key, caster, trigger_card, condition_type))), (bool))) {
                    return false;
                }
            }
        }
        return true;
    }


    function TriggerCardAbilityType(AbilityTrigger trigger, bytes32 game_uid, bytes32 caster, bytes32 target, ConditionTargetType is_card) internal {
        SystemSwitch.call(abi.encodeCall(IAbilitySystem.TriggerCardAbilityType, (trigger, game_uid, caster, target, is_card)));
    }

}