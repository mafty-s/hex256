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
import {PlayerCardsBoard} from "../codegen/index.sol";
import {Slot, SlotLib} from "../libs/SlotLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";
import {ConditionTargetType} from "../codegen/common.sol";
import {PlayerCardsSecret} from "../codegen/index.sol";

contract AbilitySecretsSystem is System {
    function ResolveSecret(bytes32 game_uid, AbilityTrigger secret_trigger, bytes32 secret_card, bytes32 trigger) public {
        bytes32 icard = CardOnBoards.getId(secret_card);
        bytes32 player = CardOnBoards.getPlayerId(secret_card);
        if (CardLogicLib.IsSecret(icard))
        {
            bytes32 tplayer = CardOnBoards.getPlayerId(trigger);
            TriggerCardAbilityType(secret_trigger, game_uid, secret_card, trigger, ConditionTargetType.Card);
            GameLogicLib.DiscardCard(game_uid, secret_card);
        }
    }


    function TriggerSecrets(AbilityTrigger trigger, bytes32 game_uid, bytes32 trigger_card) public returns (bool) {
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
            if (players[p] != trigger_player) {
                bytes32 other_player = players[p];
                bytes32[] memory cards_secret = PlayerCardsSecret.getValue(other_player);
                for (uint i = 0; i < cards_secret.length; i++) {
                    bytes32 card = cards_secret[i];
                    if (card != 0) {
                        bytes32 icard = CardOnBoards.getId(card);
                        if (CardLogicLib.IsSecret(icard) && !CardOnBoards.getExhausted(card)) {
                            if (AreTargetConditionsMet(game_uid, 0, card, card, ConditionTargetType.Card)) {
                                CardOnBoards.setExhausted(card, true);
                                ResolveSecret(game_uid, trigger, card, card);
                                return true;
                            }
                        }
                    }
                }
            }
        }
        return false;
    }

    function TriggerPlayerSecrets(AbilityTrigger trigger, bytes32 game_uid, bytes32 player) public returns (bool) {
        bytes32[] memory cards_secret = PlayerCardsSecret.getValue(player);
        for (uint i = cards_secret.length; i >= 0; i--) {
            bytes32 card = cards_secret[i];
            bytes32 icard = CardOnBoards.getId(card);
            if (CardLogicLib.IsSecret(icard) && !CardOnBoards.getExhausted(card)) {
                if (AreTargetConditionsMet(game_uid, 0, card, card, ConditionTargetType.Card)) {
                    CardOnBoards.setExhausted(card, true);
                    ResolveSecret(game_uid, trigger, card, card);
                    return true;
                }}
        }
        return false;
    }

    function AreTargetConditionsMet(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType condition_type) internal returns (bool) {
        bytes4[] memory conditions_target = AbilityExtend.getConditionsTarget(ability_key);
        for (uint i = 0; i < conditions_target.length; i++) {
            bytes4 condition = conditions_target[i];
            if (condition != 0) {
                if (!abi.decode(SystemSwitch.call(abi.encodeCall(IConditionSystem.IsTargetConditionMet, (condition, game_uid, ability_key, caster, target, condition_type))), (bool))) {
                    return false;
                }
            }
        }
        return true;
    }

    function TriggerCardAbilityType(AbilityTrigger trigger, bytes32 game_uid, bytes32 caster, bytes32 target, ConditionTargetType is_card) internal {
        abi.encodeCall(IAbilitySystem.TriggerCardAbilityType, (trigger, game_uid, caster, target, is_card));
    }

}