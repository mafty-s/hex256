// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {IEffectSystem} from "../codegen/world/IEffectSystem.sol";
import {IConditionSystem} from "../codegen/world/IConditionSystem.sol";
import {IFilterSystem} from "../codegen/world/IFilterSystem.sol";
import {Ability, AbilityExtend, CardOnBoards, Cards, PlayerActionHistory, ActionHistory, Players, Games, GamesExtended, Config} from "../codegen/index.sol";
import {AbilityTrigger, Status, Action, AbilityTarget, SelectorType, ConditionTargetType, GameState} from "../codegen/common.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {PlayerCardsBoard, PlayerCardsHand, PlayerCardsEquip} from "../codegen/index.sol";
import {Slot, SlotLib} from "../libs/SlotLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";

contract AbilitySystem is System {
    //使用技能
    function UseAbility(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {

        //Pay cost
//        if (iability.trigger == AbilityTrigger.Activate)
//        {
//            player.mana -= iability.mana_cost;
//            caster.exhausted = caster.exhausted || iability.exhaust;
//        }

        bytes32 player_key = CardOnBoards.getPlayerId(target);
        bytes32 game_key = Players.getGame(player_key);
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

    function TriggerPlayerCardsAbilityType(bytes32 caster, AbilityTrigger trigger) public {
        //todo
    }

    function TriggerPlayerSecrets(bytes32 caster, AbilityTrigger trigger) public {
        //todo
    }

    //触发指定技能
    function TriggerCardAbility(bytes32 ability_key, bytes32 caster, bytes32 triggerer, bool is_card) public {
        bytes32 trigger_card = triggerer != 0 ? triggerer : caster; //Triggerer is the caster if not set
//    todo    if (!CardLogicLib.HasStatus(trigger_card, Status.Silenced) && AreTriggerConditionsMetCard(caster, triggerer)) {
        if (!CardLogicLib.HasStatus(trigger_card, Status.Silenced)) {
            UseAbility(ability_key, caster, trigger_card, is_card);
        }
    }


    function AreTargetConditionsMet(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 trigger_card, ConditionTargetType condition_type) public returns (bool) {
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


    function IsSelector(AbilityTarget target) internal returns (bool) {
        return target == AbilityTarget.SelectTarget || target == AbilityTarget.CardSelector || target == AbilityTarget.ChoiceSelector;
    }

    function CanTargetCard(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target) internal returns (bool) {

        if (CardLogicLib.HasStatus(target, Status.Stealth)) {
            return false; //Hidden
        }

        if (CardLogicLib.HasStatus(target, Status.SpellImmunity)) {
            return false; ////Spell immunity
        }

        bool condition_match = AreTargetConditionsMet(game_uid, ability_key, caster, target, ConditionTargetType.Card);
        return condition_match;
    }

    //Can target check additional restrictions and is usually for SelectTarget or PlayTarget abilities
    function CanTargetPlayer(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target) internal returns (bool){
        return AreTargetConditionsMet(game_uid, ability_key, caster, target, ConditionTargetType.Player);
    }

    function CanTargetSlot(bytes32 game_uid, bytes32 ability_key, bytes32 caster, uint16 target) internal returns (bool){
        return AreTargetConditionsMet(game_uid, ability_key, caster, bytes32(uint256(target)), ConditionTargetType.Slot); //No additional conditions for slots
    }

    function CanTarget(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal returns (bool) {
        if (is_card) {
            return CanTargetCard(game_uid, ability_key, caster, target);
        } else {
            return CanTargetPlayer(game_uid, ability_key, caster, target);
        }
    }

    //Return player targets,  memory_array is used for optimization and avoid allocating new memory
    function GetPlayerTargets(bytes32 game_uid, bytes32 ability_key, AbilityTarget target, bytes32 caster) internal returns (bytes32[] memory){
        bytes32[] memory players = Games.getPlayers(game_uid);
        bytes32[] memory targets;
        if (target == AbilityTarget.PlayerSelf) {
            targets = new bytes32[](1);
            bytes32 player_key = CardOnBoards.getPlayerId(caster);
            targets[0] = player_key;
        } else if (target == AbilityTarget.PlayerOpponent) {
            targets = new bytes32[](1);
            bytes32 player_key = CardOnBoards.getPlayerId(caster);
            bytes32 opponent_key = player_key == players[0] ? players[1] : players[0];
            targets[0] = opponent_key;
        } else if (target == AbilityTarget.AllPlayers) {
            targets = players;
        }

        //Filter targets
        bytes4[] memory filters_target = AbilityExtend.getFiltersTarget(ability_key);
        if (filters_target.length > 0 && targets.length > 0)
        {
            for (uint i = 0; i < filters_target.length; i++) {
                bytes4 filter = filters_target[i];
                if (filter != 0) {
                    targets = abi.decode(
                        SystemSwitch.call(
                            abi.encodeCall(IFilterSystem.FilterTargets, (filter, game_uid, ability_key, caster, targets, ConditionTargetType.Player))
                        ),
                        (bytes32[])
                    );
                }
            }
        }


        return targets;
    }

    //Return cards targets,  memory_array is used for optimization and avoid allocating new memory
    function GetCardTargets(bytes32 game_uid, bytes32 ability_key, AbilityTarget target, bytes32 caster) internal returns (bytes32[] memory){
        uint numTargets = 0;
        bytes32[] memory players = Games.getPlayers(game_uid);
        bytes32[] memory targets;

        if (target == AbilityTarget.Self) {
            targets = new bytes32[](1);
            if (AreTargetConditionsMet(game_uid, ability_key, caster, caster, ConditionTargetType.Card)) {
                targets[numTargets] = caster;
                numTargets++;
            }
        }

        if (target == AbilityTarget.AllCardsBoard || target == AbilityTarget.SelectTarget)
        {

//            targets = new bytes32[](0);
            bytes32[] memory cards_board_a = PlayerCardsBoard.getValue(players[0]);
            bytes32[] memory cards_board_b = PlayerCardsBoard.getValue(players[1]);

            targets = new bytes32[](cards_board_a.length + cards_board_b.length);
            for (uint i = 0; i < cards_board_a.length; i++) {
                if (cards_board_a[i] != 0 && AreTargetConditionsMet(game_uid, ability_key, caster, cards_board_a[i], ConditionTargetType.Card)) {
                    if (numTargets > targets.length) {
                        revert("numTargets>targets.length");
                    }
                    targets[numTargets] = cards_board_a[i];
                    numTargets++;
                }
            }
            for (uint x = 0; x < cards_board_b.length; x++) {
                if (cards_board_b[x] != 0 && AreTargetConditionsMet(game_uid, ability_key, caster, cards_board_b[x], ConditionTargetType.Card)) {
                    if (numTargets > targets.length) {
                        revert("numTargets>targets.length");
                    }
                    targets[numTargets] = cards_board_b[x];
                    numTargets++;
                }
            }
        }

        if (target == AbilityTarget.AllCardsHand)
        {
            bytes32[] memory cards_board_a = PlayerCardsHand.getValue(players[0]);
            bytes32[] memory cards_board_b = PlayerCardsHand.getValue(players[1]);

            targets = new bytes32[](cards_board_a.length + cards_board_b.length);
            for (uint i = 0; i < cards_board_a.length; i++) {
                if (AreTargetConditionsMet(game_uid, ability_key, caster, cards_board_a[i], ConditionTargetType.Card)) {
                    targets[numTargets] = cards_board_a[i];
                    numTargets++;
                }
            }
            for (uint i = 0; i < cards_board_b.length; i++) {
                if (AreTargetConditionsMet(game_uid, ability_key, caster, cards_board_b[i], ConditionTargetType.Card)) {
                    targets[numTargets] = cards_board_b[i];
                    numTargets++;
                }
            }
        }

        if (target == AbilityTarget.AllCardsAllPiles || target == AbilityTarget.CardSelector)
        {
            //todo
            revert("not implemented");
        }

        if (target == AbilityTarget.LastPlayed)
        {
            targets = new bytes32[](1);
            bytes32 last_played = GamesExtended.getLastPlayed(game_uid);
            if (last_played != 0 && AreTargetConditionsMet(game_uid, ability_key, caster, last_played, ConditionTargetType.Card)) {
                targets[numTargets] = last_played;
                numTargets++;
            }
        }

        if (target == AbilityTarget.LastDestroyed)
        {
            targets = new bytes32[](1);
            bytes32 last_destroyed = GamesExtended.getLastDestroyed(game_uid);
            if (last_destroyed != 0 && AreTargetConditionsMet(game_uid, ability_key, caster, last_destroyed, ConditionTargetType.Card)) {
                targets[numTargets] = last_destroyed;
                numTargets++;
            }
        }

        if (target == AbilityTarget.LastTargeted)
        {
            targets = new bytes32[](1);
            bytes32 last_target = GamesExtended.getLastTarget(game_uid);
            if (last_target != 0 && AreTargetConditionsMet(game_uid, ability_key, caster, last_target, ConditionTargetType.Card)) {
                targets[numTargets] = last_target;
                numTargets++;
            }
        }

        bytes4[] memory filters_target = AbilityExtend.getFiltersTarget(ability_key);
        if (filters_target.length > 0 && targets.length > 0)
        {
            for (uint i = 0; i < filters_target.length; i++) {
                bytes4 filter = filters_target[i];
                if (filter != 0) {
                    targets = abi.decode(
                        SystemSwitch.call(
                            abi.encodeCall(IFilterSystem.FilterTargets, (filter, game_uid, ability_key, caster, targets, ConditionTargetType.Card))
                        ),
                        (bytes32[])
                    );
                }
            }
        }

        return targets;
    }

    function GetSlotTargets(bytes32 game_uid, bytes32 ability_key, AbilityTarget target, bytes32 caster) internal {
        bytes32[] memory targets;

        if (target == AbilityTarget.AllSlots)
        {
            Slot[] memory slots = SlotLib.GetAll();
            for (uint i = 0; i < slots.length; i++) {
                //todo
//                if (CanTargetSlot(game_uid, ability_key, caster, slots[i].id)) {
//                    targets.push(bytes32(uint256(slots[i].id)));
//                }
            }
        }
        //Filter targets
        bytes4[] memory filters_target = AbilityExtend.getFiltersTarget(ability_key);
        if (filters_target.length > 0 && targets.length > 0)
        {
            for (uint i = 0; i < filters_target.length; i++) {
                bytes4 filter = filters_target[i];
                if (filter != 0) {
                    targets = abi.decode(
                        SystemSwitch.call(
                            abi.encodeCall(IFilterSystem.FilterTargets, (filter, game_uid, ability_key, caster, targets, ConditionTargetType.Slot))
                        ),
                        (bytes32[])
                    );
                }
            }
        }

    }

    function GetCardDataTargets(bytes32 game_uid, bytes32 ability_key, AbilityTarget target, bytes32 caster) internal returns (bytes32[] memory){
        uint numTargets = 0;
        bytes32[] memory targets;
        if (target == AbilityTarget.AllCardData) {
            bytes32[] memory cards = Config.getCards();
            targets = new bytes32[](cards.length);
            for (uint i = 0; i < cards.length; i++) {
                if (AreTargetConditionsMet(game_uid, ability_key, caster, cards[i], ConditionTargetType.CardData)) {
                    targets[numTargets] = cards[i];
                    numTargets++;
                }
            }
        }
        //Filter targets
        bytes4[] memory filters_target = AbilityExtend.getFiltersTarget(ability_key);
        if (filters_target.length > 0 && targets.length > 0)
        {
            for (uint i = 0; i < filters_target.length; i++) {
                bytes4 filter = filters_target[i];
                if (filter != 0) {
                    targets = abi.decode(
                        SystemSwitch.call(
                            abi.encodeCall(IFilterSystem.FilterTargets, (filter, game_uid, ability_key, caster, targets, ConditionTargetType.CardData))
                        ),
                        (bytes32[])
                    );
                }
            }
        }

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
                    TriggerCardAbility(chain_ability, caster, 0, true);
                }
            }
        }
    }


}