// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {IEffectSystem} from "../codegen/world/IEffectSystem.sol";
import {Ability, CardOnBoards, Cards, PlayerActionHistory, ActionHistory, Players, Games, GamesExtended} from "../codegen/index.sol";
import {AbilityTrigger, Status, Action, AbilityTarget, SelectorType} from "../codegen/common.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {PlayerCardsBoard, PlayerCardsHand, PlayerCardsEquip} from "../codegen/index.sol";

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

        //使用效果
        bytes4[] memory effects = Ability.getEffects(ability_key);
        if (effects.length > 0 && ability_key != 0 && caster != 0 && target != 0) {
            for (uint i = 0; i < effects.length; i++) {
//                SystemSwitch.call(abi.encodeCall(IEffectSystem.DoEffect, (effects[i], ability_key, caster, target, is_card)));
                bytes memory data = abi.encodeWithSelector(effects[i], ability_key, caster, target, is_card);
                SystemSwitch.call(data);
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
                    PlayerLogicLib.AddStatus(target, (Status)(status[i]));
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


    function AreTargetConditionsMetCard(bytes32 game_uid, bytes32 caster, bytes32 trigger_card) public pure returns (bool) {
        return true;
    }

    function AreTargetConditionsMetPlayer(bytes32 game_uid, bytes32 caster, bytes32 trigger_player) public pure returns (bool) {
        //todo
        return true;
    }

    function AreTargetConditionsMetSlot(bytes32 game_uid, bytes32 caster, uint16 slot) public pure returns (bool) {
        //todo
        return true;
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

    //Can target check additional restrictions and is usually for SelectTarget or PlayTarget abilities
    function CanTargetPlayer(bytes32 game_uid, bytes32 caster, bytes32 target) internal returns (bool){
        return AreTargetConditionsMetPlayer(game_uid, caster, target);
    }

    function CanTargetSlot(bytes32 game_uid, bytes32 caster, uint16 target) internal returns (bool){

        return AreTargetConditionsMetSlot(game_uid, caster, target); //No additional conditions for slots
    }

    function CanTarget(bytes32 game_uid, bytes32 caster, bytes32 target, bool is_card) internal returns (bool) {
        if (is_card) {
            return CanTargetCard(game_uid, caster, target);
        } else {
            return CanTargetPlayer(game_uid, caster, target);
        }
    }

    //Return player targets,  memory_array is used for optimization and avoid allocating new memory
    function GetPlayerTargets(bytes32 ability_key, bytes32 caster_key) internal returns (bytes32[] memory){

        AbilityTarget target = Ability.getTarget(ability_key);
        bytes32[] memory targets = new bytes32[](1);
        //todo
        if (target == AbilityTarget.PlayerSelf) {
            bytes32 player_key = CardOnBoards.getPlayerId(caster_key);
            targets[0] = player_key;
        }

        return targets;
    }

    //Return cards targets,  memory_array is used for optimization and avoid allocating new memory
    function GetCardTargets(bytes32 game_uid, bytes32 ability_key, bytes32 caster) internal returns (bytes32[] memory){
        AbilityTarget target = Ability.getTarget(ability_key);
        uint numTargets = 0;
        bytes32[] memory players = Games.getPlayers(game_uid);
//        bytes32[] memory card_a = Players.
//        bytes32[] memory card_b = CardLogicLib.GetCardsOnBoard(players[1]);
        bytes32[] memory targets = new bytes32[](1);


        if (target == AbilityTarget.Self) {
            if (AreTargetConditionsMetCard(game_uid, caster, caster)) {
                targets[numTargets] = caster;
                numTargets++;
            }
        }

        if (target == AbilityTarget.AllCardsBoard || target == AbilityTarget.SelectTarget)
        {

//            for (uint i = 0; i < card_a.length; i++) {
//                if (AreTargetConditionsMetCard(game_uid, caster, card_a[i])) {
//                    targets[numTargets] = card_a[i];
//                    numTargets++;
//                }
//            }
        }

        if (target == AbilityTarget.AllCardsHand)
        {

        }

        if (target == AbilityTarget.AllCardsAllPiles || target == AbilityTarget.CardSelector)
        {

        }

        if (target == AbilityTarget.LastPlayed)
        {

        }

        if (target == AbilityTarget.LastDestroyed)
        {

        }

        if (target == AbilityTarget.LastTargeted)
        {

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
        bytes32[] memory targets = GetPlayerTargets(ability_key, caster_key);
        for (uint i = 0; i < targets.length; i++) {
            bytes32 target = targets[i];
//            ResolveEffectTarget(ability_key, caster_key, target);
        }
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

//public void DoOngoingEffects(GameLogic logic, Card caster, Card target)
//{
//foreach (EffectData effect in effects)
//effect?.DoOngoingEffect(logic, this, caster, target);
//foreach (StatusData stat in status)
//target.AddOngoingStatus(stat, value);
//}
    function DoOngoingEffects(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {

        //使用效果
        bytes4[] memory effects = Ability.getEffects(ability_key);
        if (effects.length > 0 && ability_key != 0 && caster != 0 && target != 0) {
            for (uint i = 0; i < effects.length; i++) {
//                SystemSwitch.call(abi.encodeCall(IEffectSystem.DoEffect, (effects[i], ability_key, caster, target, is_card)));
//                bytes memory data = abi.encodeWithSelector(effects[i], ability_key, caster, target, is_card);
//                SystemSwitch.call(data);
                //todo
            }
        }
        //添加状态，如嘲讽等
        uint8[] memory status = Ability.getStatus(ability_key);
        if (status.length > 0) {
            uint8 duration = Ability.getDuration(ability_key);
            uint8 value = uint8(Ability.getValue(ability_key));
            for (uint i = 0; i < status.length; i++) {
                if (is_card) {
                    CardLogicLib.AddOngoingStatus(target, (Status)(status[i]), duration, value);
                } else {
                    PlayerLogicLib.AddOngoingStatus(target, (Status)(status[i]), value);
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


    function UpdateOngoing(bytes32 game_key) public {
        bytes32[] memory players = Games.getPlayers(game_key);
        //清除之前的状态
        for (uint i = 0; i < players.length; i++) {

            bytes32 player_key = players[i];

            bytes32[] memory cards_board = PlayerCardsBoard.getValue(player_key);
            for (uint c = 0; c < cards_board.length; c++) {
                CardLogicLib.ClearOngoing(cards_board[c]);
            }

            bytes32[] memory cards_equip = PlayerCardsEquip.getValue(player_key);
            for (uint c = 0; c < cards_equip.length; c++) {
                CardLogicLib.ClearOngoing(cards_equip[c]);
            }

            bytes32[] memory cards_hand = PlayerCardsHand.getValue(player_key);
            for (uint c = 0; c < cards_hand.length; c++) {
                CardLogicLib.ClearOngoing(cards_hand[c]);
            }

        }
        //调用UpdateOngoingAbilities
        for (uint i = 0; i < players.length; i++) {
            bytes32 player_key = players[i];

            bytes32[] memory cards_board = PlayerCardsBoard.getValue(player_key);
            for (uint c = 0; c < cards_board.length; c++) {
                UpdateOngoingAbilities(player_key, cards_board[c]);
            }

            bytes32[] memory cards_equip = PlayerCardsEquip.getValue(player_key);
            for (uint c = 0; c < cards_equip.length; c++) {
                UpdateOngoingAbilities(player_key, cards_equip[c]);
            }

            bytes32[] memory cards_hand = PlayerCardsHand.getValue(player_key);
            for (uint c = 0; c < cards_hand.length; c++) {
                UpdateOngoingAbilities(player_key, cards_hand[c]);
            }
        }
        //Stats bonus 状态奖励
        for (uint i = 0; i < players.length; i++) {
            bytes32 player_key = players[i];
            bytes32[] memory cards_board = PlayerCardsBoard.getValue(player_key);
            for (uint c = 0; c < cards_board.length; c++) {
                //Taunt effect
                if (CardLogicLib.HasStatus(cards_board[c], Status.Protection) && !CardLogicLib.HasStatus(cards_board[c], Status.Stealth))
                {
                    PlayerLogicLib.AddOngoingStatus(player_key, Status.Protected, 0);
                }
            }
        }

    }


    function AddOngoingStatusBonus(bytes32 card_key, Status status, int8 value) internal {
        if (status == Status.Attack) {
            CardOnBoards.setAttackOngoing(card_key, CardOnBoards.getAttackOngoing(card_key) + value);
        }
        if (status == Status.Hp) {
            CardOnBoards.setHpOngoing(card_key, CardOnBoards.getHpOngoing(card_key) + value);
        }
    }

    function UpdateOngoingAbilities(bytes32 player_key, bytes32 card_key) public {

        if (card_key == 0 || !CardLogicLib.CanDoAbilities(card_key))
            return;

        bytes32 card_config_id = CardOnBoards.getId(card_key);
        bytes32[] memory cabilities = Cards.getAbilities(card_config_id);
        for (uint i = 0; i < cabilities.length; i++) {
            bytes32 ability_key = cabilities[i];

            if (ability_key != 0) {
                AbilityTrigger trigger = Ability.getTrigger(ability_key);
                if (trigger == AbilityTrigger.ONGOING) {
                    AbilityTarget target = Ability.getTarget(ability_key);

                    if (target == AbilityTarget.Self)
                    {
                        DoOngoingEffects(ability_key, card_key, card_key, true);
                    }

                    if (target == AbilityTarget.PlayerSelf)
                    {
                        //todo
                    }

                    if (target == AbilityTarget.AllPlayers || target == AbilityTarget.PlayerOpponent)
                    {
                        //todo
                    }

                    if (target == AbilityTarget.EquippedCard)
                    {
                        //todo
                    }

                    if (target == AbilityTarget.AllCardsAllPiles || target == AbilityTarget.AllCardsHand || target == AbilityTarget.AllCardsBoard)
                    {
                        //todo
                    }

                }
            }
        }


    }

}