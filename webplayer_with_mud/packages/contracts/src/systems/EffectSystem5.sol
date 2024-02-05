// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Players, Ability, PlayerActionHistory, ActionHistory, CardOnBoards, Cards, GamesExtended} from "../codegen/index.sol";
import {Action, TraitData, EffectStatType, EffectAttackerType, Status} from "../codegen/common.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";

contract EffectSystem5 is System {

    constructor() {

    }

    function EffectRollD6(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        int8 min = 1;
        int8 max = 6;
        int8 value = int8(uint8(uint256(keccak256(abi.encodePacked(block.prevrandao, block.prevrandao, msg.sender))) % (uint8(max - min + 1))) + uint8(min));
        bytes32 player_key = CardOnBoards.getPlayerId(caster);
        bytes32 game_key = Players.getGame(player_key);
        GamesExtended.setRolledValue(game_key, value);
    }

    function EffectAddAttackRoll(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        EffectAddStatRoll(ability_key, caster, target, is_card, EffectStatType.Attack);
    }

    //===========


    //随机属性加成
    function EffectAddStatRoll(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, EffectStatType stat) internal {
        bytes32 player_key = CardOnBoards.getPlayerId(caster);
        bytes32 game_key = Players.getGame(player_key);
        int8 value = GamesExtended.getRolledValue(game_key);
        if (is_card) {
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