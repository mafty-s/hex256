// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Players, Ability, PlayerActionHistory, ActionHistory, CardOnBoards, Cards, GamesExtended} from "../codegen/index.sol";
import {Action, EffectStatType, EffectAttackerType, Status} from "../codegen/common.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {ConditionTargetType} from "../codegen/common.sol";

contract Effect5System is System {

    constructor() {

    }

    event EventEffect(string name, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card);


    function EffectRollD6(bytes32 game_key, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectRollD6", ability_key, caster, target, is_card);
        int8 min = 1;
        int8 max = 6;
        int8 value = int8(uint8(uint256(keccak256(abi.encodePacked(block.prevrandao, block.prevrandao, msg.sender))) % (uint8(max - min + 1))) + uint8(min));
        GamesExtended.setRolledValue(game_key, value);

        uint256 len = PlayerActionHistory.length(game_key);
        bytes32 action_key = keccak256(abi.encode(game_key, len));
        PlayerActionHistory.push(game_key, action_key);
        ActionHistory.setActionType(action_key, Action.Dice);
        ActionHistory.setValue(action_key, value);
//        ActionHistory.setCardId(action_key, attacker_key);
//        ActionHistory.setTarget(action_key, bytes32(target));
    }

    function EffectAddAttackRoll(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectAddAttackRoll", ability_key, caster, target, is_card);
        EffectAddStatRoll(ability_key, caster, target, is_card, EffectStatType.Attack);
    }

    //===========

    //随机属性加成
    function EffectAddStatRoll(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card, EffectStatType stat) internal {
        bytes32 player_key = CardOnBoards.getPlayerId(caster);
        bytes32 game_key = Players.getGame(player_key);
        int8 value = GamesExtended.getRolledValue(game_key);
        if (is_card == ConditionTargetType.Card) {
            if (stat == EffectStatType.HP) {
                CardOnBoards.setHp(target, value + CardOnBoards.getHp(target));
            }
            if (stat == EffectStatType.Mana) {
                CardOnBoards.setMana(target, value + CardOnBoards.getMana(target));
            }
        } else {
            if (stat == EffectStatType.HP) {
                Players.setHp(target, value + Players.getHp(target));
            }
            if (stat == EffectStatType.Mana) {
                Players.setMana(target, value + Players.getMana(target));
            }
        }
    }

}