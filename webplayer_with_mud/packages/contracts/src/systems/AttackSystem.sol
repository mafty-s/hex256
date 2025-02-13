// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {Cards, CardOnBoards, Games, PlayerCardsDiscard, Players, Users} from "../codegen/index.sol";
import {PlayerActionHistory, ActionHistory, ActionHistoryData} from "../codegen/index.sol";
import {CardType, GameType, GameState, GamePhase, PackType, RarityType, AbilityTrigger, Action, Status} from "../codegen/common.sol";
import {IAbilitySystem} from "../codegen/world/IAbilitySystem.sol";
import {IAbilitySecretsSystem} from "../codegen/world/IAbilitySecretsSystem.sol";
import {BaseLogicLib} from "../libs/BaseLogicLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";
import {SlotLib} from "../libs/SlotLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {ConditionTargetType} from "../codegen/common.sol";

contract AttackSystem is System {

    constructor() {

    }

    function AttackTarget(bytes32 game_key, bytes32 attacker_key, bytes32 target_key, bool skip_cost) public returns (int8 target_hp) {

        int8 target_hp = CardOnBoards.getHp(target_key);

        if (!BaseLogicLib.CanAttackTarget(attacker_key, target_key, skip_cost))
        {
            revert("Can not attack target");
        }

//        if(!CardLogicLib.IsOnBoard(target_key)){
//            revert("target is not on board");
//        }

        //使用触发器触发技能
        SystemSwitch.call(
            abi.encodeCall(IAbilitySecretsSystem.TriggerPlayerSecrets, (AbilityTrigger.ON_BEFORE_ATTACK, game_key, attacker_key))
        );
        SystemSwitch.call(
            abi.encodeCall(IAbilitySystem.TriggerCardAbilityType, (AbilityTrigger.ON_BEFORE_ATTACK, game_key, attacker_key, target_key, ConditionTargetType.Card))
        );
        SystemSwitch.call(
            abi.encodeCall(IAbilitySystem.TriggerCardAbilityType, (AbilityTrigger.ON_BEFORE_DEFEND, game_key, target_key, attacker_key, ConditionTargetType.Card))
        );

        int8 attacker_attack = CardOnBoards.getAttack(attacker_key);
//        target_hp = target_hp - attacker_attack;

//        if (target_key == 0x45a23f50c4a44900e19828c071b86545a4e54f3522a680d87ff84742258a9071) {
//            target_hp = 0;//
//        }
//
//        if (attacker_key == 0x45a23f50c4a44900e19828c071b86545a4e54f3522a680d87ff84742258a9071) {
//            target_hp = 1;//
//        }

//        if (target_hp <= 0) {
//            target_hp = 0;
//            GameLogicLib.KillCard(game_key, target_key);
//            SystemSwitch.call(
//                abi.encodeCall(IAbilitySystem.TriggerCardAbilityType, (AbilityTrigger.ON_DEATH, game_key, target_key, target_key, ConditionTargetType.Card))
//            );
//            bytes32 target_player = CardOnBoards.getPlayerId(target_key);
//            PlayerLogicLib.RemoveCardFromAllGroups(target_player, target_key);
//            SlotLib.ClearCardFromSlot(target_player, target_key);
//            PlayerCardsDiscard.pushValue(target_player, target_key);
//        }

//        CardOnBoards.setHp(target_key, target_hp);
        GameLogicLib.DamageCardByTarget(game_key, attacker_key, target_key, attacker_attack, false);

        bytes32[] memory players = Games.getPlayers(game_key);

        //uint16 slot_encode = SlotLib.EncodeSlot(slot);
        uint256 len = PlayerActionHistory.length(game_key);
        bytes32 action_key = keccak256(abi.encode(game_key, len));
        PlayerActionHistory.push(game_key, action_key);
        ActionHistory.setActionType(action_key, Action.Attack);
        ActionHistory.setCardId(action_key, attacker_key);
        ActionHistory.setTarget(action_key, target_key);
        //ActionHistory.setSlot(action_key, slot_encode);
        ActionHistory.setPlayerId(action_key, players[0] == attacker_key ? 0 : 1);

        //使用触发器触发技能
        SystemSwitch.call(
            abi.encodeCall(IAbilitySystem.TriggerCardAbilityType, (AbilityTrigger.ON_AFTER_ATTACK, game_key, attacker_key, target_key, ConditionTargetType.Card))
        );
        SystemSwitch.call(
            abi.encodeCall(IAbilitySystem.TriggerCardAbilityType, (AbilityTrigger.ON_AFTER_DEFEND, game_key, target_key, attacker_key, ConditionTargetType.Card))
        );
        SystemSwitch.call(
            abi.encodeCall(IAbilitySecretsSystem.TriggerPlayerSecrets, (AbilityTrigger.ON_AFTER_ATTACK, game_key, attacker_key))
        );
        SystemSwitch.call(
            abi.encodeCall(IAbilitySecretsSystem.TriggerPlayerSecrets, (AbilityTrigger.ON_AFTER_DEFEND, game_key, target_key))
        );

        CardOnBoards.setExhausted(attacker_key, true);

        return (
            target_hp
        );
    }


    function AttackPlayer(bytes32 game_key, bytes32 attacker_key, uint256 target, bool skip_cost) public {

        bytes32 target_key = Games.getPlayers(game_key)[target];

        if (BaseLogicLib.CanAttackTarget(attacker_key, target_key, skip_cost))
        {
            //
            //            Player player = game_data.GetPlayer(attacker.player_id);
            //            if(!is_ai_predict)
            //                player.AddHistory(GameAction.Attack, attacker, target);
            //
            //            //Trigger before attack abilities
            //            TriggerCardAbilityType(AbilityTrigger.OnBeforeAttack, attacker, target);
            //            TriggerCardAbilityType(AbilityTrigger.OnBeforeDefend, target, attacker);
            //            TriggerSecrets(AbilityTrigger.OnBeforeAttack, attacker);
            //            TriggerSecrets(AbilityTrigger.OnBeforeDefend, target);
            //
            //            //Resolve attack
            //            resolve_queue.AddAttack(attacker, target, ResolveAttack, skip_cost);
            //            resolve_queue.ResolveAll();
            //        }
            //todo

//            AbilityLib.TriggerCardAbilityTypePlayer(AbilityTrigger.ON_BEFORE_ATTACK, attacker_key, target_key);
//            AbilityLib.TriggerCardAbilityTypePlayer(AbilityTrigger.ON_BEFORE_DEFEND, target_key, attacker_key);

            SystemSwitch.call(
                abi.encodeCall(IAbilitySystem.TriggerCardAbilityType, (
                    AbilityTrigger.ON_BEFORE_ATTACK, game_key, attacker_key, target_key, ConditionTargetType.Player))
            );

        }
        int8 attacker_attack = CardOnBoards.getAttack(attacker_key);
        int8 target_hp = Players.getHp(target_key);
        target_hp = target_hp - attacker_attack;
        if (target_hp <= 0) {
            target_hp = 0;
        }
        Players.setHp(target_key, target_hp);

        uint256 len = PlayerActionHistory.length(game_key);
        bytes32 action_key = keccak256(abi.encode(game_key, len));
        PlayerActionHistory.push(game_key, action_key);
        ActionHistory.setActionType(action_key, Action.AttackPlayer);
        ActionHistory.setCardId(action_key, attacker_key);
        ActionHistory.setTarget(action_key, bytes32(target));

        SystemSwitch.call(
            abi.encodeCall(IAbilitySystem.TriggerCardAbilityType, (
                AbilityTrigger.ON_AFTER_ATTACK, game_key, attacker_key, target_key, ConditionTargetType.Player))
        );

        CardOnBoards.setExhausted(attacker_key, true);
        GameLogicLib.CheckForWinner(game_key);
    }

    function CastAbility(bytes32 game_uid, bytes32 caster, bytes32 ability_key) public {
        CardLogicLib.RemoveStatus(caster, Status.Stealth);
        SystemSwitch.call(abi.encodeCall(IAbilitySystem.TriggerCardAbility, (game_uid, ability_key, caster, 0, ConditionTargetType.Card)));
    }

    function CanCastAbility(bytes32 game_uid, bytes32 card, bytes32 ability_key) internal returns (bool){
        if (game_uid == 0 || card == 0 || ability_key == 0) {
            return false;
        }

        return true;
    }

//public virtual bool CanCastAbility(Card card, AbilityData ability)
//{
//if (ability == null || card == null || !card.CanDoActivatedAbilities())
//return false; //This card cant cast
//
//if (ability.trigger != AbilityTrigger.Activate)
//return false; //Not an activated ability
//
//Player player = GetPlayer(card.player_id);
//if (!player.CanPayAbility(card, ability))
//return false; //Cant pay for ability
//
//if (!ability.AreTriggerConditionsMet(this, card))
//return false; //Conditions not met
//
//return true;
//}

    function Resign() public {
        bytes32 game_uid = Users.getGame(_msgSender());
        if (Games.getGameState(game_uid) != GameState.GAME_ENDED)
        {
            bytes32[] memory players = Games.getPlayers(game_uid);
            address player_0_owner = Players.getOwner(players[0]);
            address player_1_owner = Players.getOwner(players[1]);
            bytes32 winner = player_0_owner == _msgSender() ? players[1] : players[0];
            GameLogicLib.EndGame(game_uid, winner);
        }
    }
}