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
import {ConditionTargetType} from "../codegen/common.sol";

contract AbilitySystem is System {

    //更具trigger技能触发器,触发指定卡的所有技能
    event EventTriggerCardAbilityType(AbilityTrigger trigger, bytes32 game_uid, bytes32 caster, bytes32 target, ConditionTargetType is_card);

    function TriggerCardAbilityType(AbilityTrigger trigger, bytes32 game_uid, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        if (game_uid == 0 || caster == 0) {
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
        emit EventTriggerCardAbilityType(trigger, game_uid, caster, target, is_card);
    }

    function TriggerOtherCardsAbilityType(AbilityTrigger trigger, bytes32 game_uid, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        //todo
    }


    event EventTriggerPlayerCardsAbilityType(AbilityTrigger trigger, bytes32 game_uid, bytes32 player_key);

    function TriggerPlayerCardsAbilityType(AbilityTrigger trigger, bytes32 game_uid, bytes32 player_key) public {
        if (game_uid == 0 || player_key == 0) {
            return;
        }

        bytes32 hero = Players.getHero(player_key);
        if (hero != 0) {
            TriggerCardAbilityType(trigger, game_uid, hero, 0, ConditionTargetType.Card);
        }
        bytes32[] memory cards_board = PlayerCardsBoard.getValue(player_key);
        if (cards_board.length > 0) {
            for (uint i = 0; i < cards_board.length; i++) {
                bytes32 card = cards_board[i];
                TriggerCardAbilityType(trigger, game_uid, card, card, ConditionTargetType.Card);
            }
        }

        emit EventTriggerPlayerCardsAbilityType(trigger, game_uid, player_key);
    }


//触发指定技能
    event EventTriggerCardAbility(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 triggerer, ConditionTargetType is_card);

    function TriggerCardAbility(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 triggerer, ConditionTargetType is_card) public {
        if (game_uid == 0 || ability_key == 0 || caster == 0) {
            return;
        }
        if (triggerer == 0) {
            triggerer = caster;        //Triggerer is the caster if not set
        }
        if (!CardLogicLib.HasStatus(triggerer, Status.Silenced) && AreTriggerConditionsMet(game_uid, ability_key, caster, triggerer, ConditionTargetType.Card)) {
//            UseAbility(game_uid, ability_key, caster, triggerer, is_card);
            ResolveCardAbility(game_uid, ability_key, caster, triggerer);
        }
        emit EventTriggerCardAbility(game_uid, ability_key, caster, triggerer, is_card);
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

    function GetCardDataTargets(bytes32 game_uid, bytes32 ability_key, AbilityTarget target, bytes32 caster) internal returns (bytes32[] memory){
        bytes32[] memory targets = abi.decode(
            SystemSwitch.call(
                abi.encodeCall(IAbilityTargetSystem.GetCardDataTargets, (game_uid, ability_key, target, caster))
            ),
            (bytes32[])
        );

        return targets;
    }

    function GetSlotTargets(bytes32 game_uid, bytes32 ability_key, AbilityTarget target, bytes32 caster) internal returns (uint16[] memory){
        uint16[] memory targets = abi.decode(
            SystemSwitch.call(
                abi.encodeCall(IAbilityTargetSystem.GetSlotTargets, (game_uid, ability_key, target, caster))
            ),
            (uint16[])
        );

        return targets;
    }

    function GetPlayerTargets(bytes32 game_uid, bytes32 ability_key, AbilityTarget target, bytes32 caster) internal returns (bytes32[] memory){
        bytes32[] memory targets = abi.decode(
            SystemSwitch.call(
                abi.encodeCall(IAbilityTargetSystem.GetPlayerTargets, (game_uid, ability_key, target, caster))
            ),
            (bytes32[])
        );

        return targets;
    }

    function CanTarget(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) internal returns (bool) {
        if (is_card == ConditionTargetType.Card) {
            if (CardLogicLib.HasStatus(target, Status.Stealth)) {
                return false; //Hidden
            }

            if (CardLogicLib.HasStatus(target, Status.SpellImmunity)) {
                return false; ////Spell immunity
            }
        }
        return AreTargetConditionsMet(game_uid, ability_key, caster, bytes32(uint256(target)), ConditionTargetType.Slot); //No additional conditions for slots
    }

    function ResolveCardAbilitySelector(bytes32 game_uid, bytes32 ability_key, AbilityTarget target, bytes32 caster) internal returns (bool){
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

    event EventResolveCardAbility(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 triggerer);

    function ResolveCardAbility(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 triggerer) internal {
        if (!CardLogicLib.CanDoAbilities(caster))
            return; //Silenced card cant cast

        emit EventResolveCardAbility(game_uid, ability_key, caster, triggerer);

        bytes32 triggerer_uid = CardOnBoards.getPlayerId(triggerer);
        GamesExtended.setAbilityTriggerer(game_uid, triggerer_uid);

        AbilityTarget target_type = Ability.getTarget(ability_key);
//
        bool is_selector = ResolveCardAbilitySelector(game_uid, ability_key, target_type, caster);
        if (is_selector)
            return; //Wait for player to select

        ResolveCardAbilityPlayTarget(game_uid, ability_key, target_type, caster);
        ResolveCardAbilityPlayers(game_uid, ability_key, target_type, caster);
        ResolveCardAbilityCards(game_uid, ability_key, target_type, caster);
        ResolveCardAbilitySlots(game_uid, ability_key, target_type, caster);
        ResolveCardAbilityCardData(game_uid, ability_key, target_type, caster);
        ResolveCardAbilityNoTarget(game_uid, ability_key, target_type, caster);
        AfterAbilityResolved(game_uid, ability_key, caster);
    }


    function DoEffects(bytes32 game_uid, bytes32 ability_key, AbilityTarget target_type, bytes32 caster, bytes32 target, ConditionTargetType is_card) internal {
        if (target == 0) {
            bytes4[] memory effects = Ability.getEffects(ability_key);
            if (effects.length > 0) {
                for (uint i = 0; i < effects.length; i++) {
                    bytes memory data = abi.encodeWithSelector(effects[i], game_uid, ability_key, caster, caster, is_card);
                    SystemSwitch.call(data);
                }
            }
        } else {
            bytes4[] memory effects = Ability.getEffects(ability_key);
            if (effects.length > 0) {
                for (uint i = 0; i < effects.length; i++) {
                    bytes memory data = abi.encodeWithSelector(effects[i], game_uid, ability_key, caster, target, is_card);
                    SystemSwitch.call(data);
                }
            }

// 添加状态，如嘲讽等
            uint8[] memory status = Ability.getStatus(ability_key);
            if (status.length > 0) {
                uint8 duration = Ability.getDuration(ability_key);
                uint8 value = uint8(Ability.getValue(ability_key));
                for (uint i = 0; i < status.length; i++) {
                    if (is_card == ConditionTargetType.Card) {
                        CardLogicLib.AddStatus(target, (Status)(status[i]), duration, value);
                    }
                    if (is_card == ConditionTargetType.Player) {
                        PlayerLogicLib.AddStatus(target, (Status)(status[i]), duration, value);
                    }
                }
            }
        }
    }

    function ResolveCardAbilityNoTarget(bytes32 game_uid, bytes32 ability_key, AbilityTarget target_type, bytes32 caster_key) internal
    {
        if (target_type == AbilityTarget.None) {
            DoEffects(game_uid, ability_key, target_type, caster_key, 0, ConditionTargetType.None);
        }
    }

    function ResolveCardAbilityPlayTarget(bytes32 game_uid, bytes32 ability_key, AbilityTarget target_type, bytes32 caster_key) internal
    {
        if (target_type == AbilityTarget.PlayTarget) {
            uint16 slot_encode = CardOnBoards.getSlot(caster_key);
            bytes32 slot_card = SlotLib.GetSlotCard(game_uid, slot_encode);
            Slot memory slot = SlotLib.DecodeSlot(slot_encode);


            if (SlotLib.IsPlayerSlot(slot))
            {
//todo
//                Player tplayer = game_data.GetPlayer(slot.p);
//                if (iability.CanTarget(game_data, caster, tplayer))
//                    ResolveEffectTarget(iability, caster, tplayer);
            }
            else if (slot_card != 0)
            {
//todo
//                if (iability.CanTarget(game_data, caster, slot_card))
//                    ResolveEffectTarget(iability, caster, slot_card);
            }
            else
            {
//todo
//                if (iability.CanTarget(game_data, caster, slot))
//                    ResolveEffectTarget(iability, caster, slot);
            }

        }
    }

    function ResolveCardAbilitySlots(bytes32 game_uid, bytes32 ability_key, AbilityTarget target_type, bytes32 caster_key) internal
    {
        uint16[] memory targets = GetSlotTargets(game_uid, ability_key, target_type, caster_key);

//        for (uint i = 0; i < targets.length; i++) {
//            bytes32 target = targets[i];
//            if (slot != Slot.None) {
//            }
//        }
    }

    function ResolveCardAbilityCardData(bytes32 game_uid, bytes32 ability_key, AbilityTarget target_type, bytes32 caster_key) internal
    {
        bytes32[] memory targets = GetCardDataTargets(game_uid, ability_key, target_type, caster_key);
        for (uint t = 0; t < targets.length; t++) {
            if (targets[t] != 0) {
                bytes32 target = targets[t];
                DoEffects(game_uid, ability_key, target_type, caster_key, 0, ConditionTargetType.CardData);
            }
        }
    }

    function ResolveCardAbilityCards(bytes32 game_uid, bytes32 ability_key, AbilityTarget target_type, bytes32 caster_key) internal
    {
//目标
        bytes32[] memory targets = GetCardTargets(game_uid, ability_key, target_type, caster_key);

//Resolve effects
        for (uint t = 0; t < targets.length; t++) {
            if (targets[t] != 0) {
                bytes32 target = targets[t];
                ResolveEffectTarget(game_uid, ability_key, caster_key, target, target_type, ConditionTargetType.Card);
            }
        }
    }

    function ResolveCardAbilityPlayers(bytes32 game_uid, bytes32 ability_key, AbilityTarget target_type, bytes32 caster_key) internal {
        bytes32[] memory targets = GetPlayerTargets(game_uid, ability_key, target_type, caster_key);
        for (uint i = 0; i < targets.length; i++) {
            bytes32 target = targets[i];
            ResolveEffectTarget(game_uid, ability_key, caster_key, target, target_type, ConditionTargetType.Player);
        }
    }

    function ResolveEffectTarget(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, AbilityTarget target_type, ConditionTargetType is_card) public {
//使用效果
        DoEffects(game_uid, ability_key, target_type, caster, target, is_card);
//        GamesExtended.setLastTarget(game_uid, target);
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
                    TriggerCardAbility(game_uid, chain_ability, caster, 0, ConditionTargetType.Card);
                }
            }
        }
    }


}