// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {IEffectSystem} from "../codegen/world/IEffectSystem.sol";
import {IConditionSystem} from "../codegen/world/IConditionSystem.sol";
import {IFilterSystem} from "../codegen/world/IFilterSystem.sol";
import {IAbilityTargetSystem} from "../codegen/world/IAbilityTargetSystem.sol";
import {Ability, AbilityExtend, CardOnBoards, Cards, PlayerActionHistory, ActionHistory, Players, Games, GamesExtended, Config} from "../codegen/index.sol";
import {AbilityTrigger, Status, Action, AbilityTarget, SelectorType, ConditionTargetType, GameState} from "../codegen/common.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {PlayerCardsBoard} from "../codegen/index.sol";
import {Slot, SlotLib} from "../libs/SlotLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";

contract AbilitySystem is System {
    //使用技能
    function UseAbility(bytes32 game_key, bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        if (ability_key == 0 || caster == 0) {
            return;
        }

        //Pay cost
//        if (iability.trigger == AbilityTrigger.Activate)
//        {
//            player.mana -= iability.mana_cost;
//            caster.exhausted = caster.exhausted || iability.exhaust;
//        }

        //如果是选择器
        bool is_selector = ResolveCardAbilitySelector(game_key, ability_key, caster);
        if (is_selector) {
            uint256 len = PlayerActionHistory.length(game_key);
            bytes32 action_key = keccak256(abi.encode(game_key, len));
            PlayerActionHistory.push(game_key, action_key);
            ActionHistory.setActionType(action_key, Action.SelectChoice);
            return; //Wait for player to select
        }

        AbilityTarget target_type = Ability.getTarget(ability_key);

        //目标
        bytes32[] memory targets;
        if (target_type == AbilityTarget.PlayTarget) {
            targets = new bytes32[](1);
            targets[0] = target;
        } else {
            targets = GetCardTargets(game_key, ability_key, target_type, caster);
        }

        //使用效果
        bytes4[] memory effects = Ability.getEffects(ability_key);
        if (effects.length > 0 && ability_key != 0 && caster != 0 && targets.length > 0) {
            for (uint i = 0; i < effects.length; i++) {
                for (uint t = 0; t < targets.length; t++) {
                    if (targets[t] != 0) {
                        bytes memory data = abi.encodeWithSelector(effects[i], ability_key, caster, targets[t], is_card);
                        SystemSwitch.call(data);
                    }
                }
            }
        }
        //添加状态，如嘲讽等
        uint8[] memory status = Ability.getStatus(ability_key);
        if (status.length > 0) {
            uint8 duration = Ability.getDuration(ability_key);
            uint8 value = uint8(Ability.getValue(ability_key));
            for (uint i = 0; i < status.length; i++) {
                if (is_card) {
                    CardLogicLib.AddStatus(target, (Status)(status[i]), duration, value);
                } else {
                    PlayerLogicLib.AddStatus(target, (Status)(status[i]), duration, value);
                }

//                uint256 len = PlayerActionHistory.length(game_key);
//                bytes32 action_key = keccak256(abi.encode(game_key, len));
//                PlayerActionHistory.push(game_key, action_key);
//                ActionHistory.setActionType(action_key, Action.AddStatus);
//                ActionHistory.setCardId(action_key, target);
//                ActionHistory.setValue(action_key, int8(status[i]));
            }
        }

        AfterAbilityResolved(game_key, ability_key, caster);

    }

    //更具trigger技能触发器,触发指定卡的所有技能
    function TriggerCardAbilityType(AbilityTrigger trigger, bytes32 game_uid, bytes32 caster, bytes32 target, bool is_card) public {
        if (caster == 0) {
            return;
        }
        bytes32 card_config_id = CardOnBoards.getId(caster);
        bytes32[] memory abilities = Cards.getAbilities(card_config_id);
        if (abilities.length > 0) {
            for (uint i = 0; i < abilities.length; i++) {
                if (Ability.getTrigger(abilities[i]) == trigger) {
                    TriggerCardAbility(game_uid, abilities[i], caster, target, is_card);
                }
            }
        }
    }

    function TriggerPlayerCardsAbilityType(AbilityTrigger trigger, bytes32 game_uid, bytes32 player_key) public {
        bytes32 hero = Players.getHero(player_key);
        if (hero != 0) {
            TriggerCardAbilityType(trigger, game_uid, hero, 0, true);
        }
        bytes32[] memory cards_board = PlayerCardsBoard.getValue(player_key);
        if (cards_board.length > 0) {
            for (uint i = 0; i < cards_board.length; i++) {
                bytes32 card = cards_board[i];
                TriggerCardAbilityType(trigger, game_uid, card, card, true);
            }
        }
    }

    function TriggerPlayerSecrets(bytes32 caster, AbilityTrigger trigger) public {
        //todo
    }

    //触发指定技能
    function TriggerCardAbility(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 triggerer, bool is_card) public {
        bytes32 trigger_card = triggerer != 0 ? triggerer : caster; //Triggerer is the caster if not set
//    todo    if (!CardLogicLib.HasStatus(trigger_card, Status.Silenced) && AreTriggerConditionsMetCard(caster, triggerer)) {
        if (!CardLogicLib.HasStatus(trigger_card, Status.Silenced) && AreTriggerConditionsMet(game_uid, ability_key, caster, triggerer, ConditionTargetType.Card)) {
            UseAbility(game_uid, ability_key, caster, trigger_card, is_card);
        }
    }

    function AreTriggerConditionsMet(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 trigger, ConditionTargetType condition_type) internal returns (bool) {
        bytes4[] memory conditions_trigger = AbilityExtend.getConditionsTrigger(ability_key);
        for (uint i = 0; i < conditions_trigger.length; i++) {
            bytes4 condition = conditions_trigger[i];
            if (condition != 0) {
                if (!abi.decode(SystemSwitch.call(abi.encodeCall(IConditionSystem.IsTriggerConditionMet, (condition, game_uid, ability_key, caster, condition_type))), (bool))) {
                    return false;
                }
                if (!abi.decode(SystemSwitch.call(abi.encodeCall(IConditionSystem.IsTargetConditionMet, (condition, game_uid, ability_key, caster, trigger, condition_type))), (bool))) {
                    return false;
                }
            }
        }
        return true;
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

    function IsSelector(AbilityTarget target) internal returns (bool) {
        return target == AbilityTarget.SelectTarget || target == AbilityTarget.CardSelector || target == AbilityTarget.ChoiceSelector;
    }

    function GetCardTargets(bytes32 game_uid, bytes32 ability_key, AbilityTarget target, bytes32 caster) internal returns (bytes32[] memory){
        bytes32[] memory targets = abi.decode(
            SystemSwitch.call(
                abi.encodeCall(IAbilityTargetSystem.GetCardTargets, (game_uid, ability_key, target, caster))
            ),
            (bytes32[])
        );

        return targets;
    }


    function ResolveCardAbilitySelector(bytes32 game_uid, bytes32 ability_key, bytes32 caster) internal returns (bool){
        AbilityTarget target = Ability.getTarget(ability_key);
        if (target == AbilityTarget.SelectTarget) {
            //Wait for target
            GoToSelectTarget(game_uid, ability_key, caster);
            return true;
        } else if (target == AbilityTarget.CardSelector) {
            GoToSelectorCard(game_uid, ability_key, caster);
            return true;
        } else if (target == AbilityTarget.ChoiceSelector) {
            GoToSelectorChoice(game_uid, ability_key, caster);
            return true;
        }
        return false;
    }

    function GoToSelectTarget(bytes32 game_uid, bytes32 ability_key, bytes32 caster) internal {
        bytes32 player_key = CardOnBoards.getPlayerId(caster);
        GamesExtended.setSelector(game_uid, SelectorType.SelectTarget);
        GamesExtended.setSelectorPlayerId(game_uid, player_key);
        GamesExtended.setSelectorAbility(game_uid, ability_key);
        GamesExtended.setSelectorCasterUid(game_uid, caster);
    }

    function GoToSelectorCard(bytes32 game_uid, bytes32 ability_key, bytes32 caster) internal {
        bytes32 player_key = CardOnBoards.getPlayerId(caster);
        GamesExtended.setSelector(game_uid, SelectorType.SelectorCard);
        GamesExtended.setSelectorPlayerId(game_uid, player_key);
        GamesExtended.setSelectorAbility(game_uid, ability_key);
        GamesExtended.setSelectorCasterUid(game_uid, caster);
    }

    function GoToSelectorChoice(bytes32 game_uid, bytes32 ability_key, bytes32 caster) internal {
        bytes32 player_key = CardOnBoards.getPlayerId(caster);
        GamesExtended.setSelector(game_uid, SelectorType.SelectorChoice);
        GamesExtended.setSelectorPlayerId(game_uid, player_key);
        GamesExtended.setSelectorAbility(game_uid, ability_key);
        GamesExtended.setSelectorCasterUid(game_uid, caster);
    }

    function ResolveCardAbilityPlayers(bytes32 ability_key, bytes32 caster_key) internal {
        //todo
//        bytes32[] memory targets = GetPlayerTargets(ability_key, caster_key);
//        for (uint i = 0; i < targets.length; i++) {
//            bytes32 target = targets[i];
////            ResolveEffectTarget(ability_key, caster_key, target);
//        }
    }

    function ResolveEffectTarget(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        //使用效果
        bytes4[] memory effects = Ability.getEffects(ability_key);
        if (effects.length > 0) {
            for (uint i = 0; i < effects.length; i++) {
//                SystemSwitch.call(
//                    abi.encodeCall(IEffectSystem.DoEffect, (effects[i], ability_key, caster, target, is_card))
//                );
                bytes memory data = abi.encodeWithSelector(effects[i], ability_key, caster, target, is_card);
                SystemSwitch.call(data);
            }
        }
        GamesExtended.setLastTarget(game_uid, target);
    }

    function AfterAbilityResolved(bytes32 game_uid, bytes32 ability_key, bytes32 caster) public {
        bytes32 player_key = CardOnBoards.getPlayerId(caster);
        AbilityTrigger trigger = Ability.getTrigger(ability_key);
        AbilityTarget target = Ability.getTarget(ability_key);
        if (trigger == AbilityTrigger.ACTIVATE) {
            Players.setMana(player_key, Players.getMana(player_key) - (int8)(Ability.getManaCost(ability_key)));
            CardOnBoards.setExhausted(caster, CardOnBoards.getExhausted(caster) || Ability.getExhaust(ability_key));
        }

        GameLogicLib.CheckForWinner(game_uid);

        //Chain ability
        if (target != AbilityTarget.ChoiceSelector && Games.getGameState(game_uid) != GameState.GAME_ENDED)
        {
            bytes32[] memory chain_abilities = AbilityExtend.getChainAbilities(ability_key);
            for (uint i = 0; i < chain_abilities.length; i++) {
                bytes32 chain_ability = chain_abilities[i];
                if (chain_ability != 0) {
                    TriggerCardAbility(game_uid, chain_ability, caster, 0, true);
                }
            }
        }
    }


}