// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {Players, Ability, Games, PlayerActionHistory, ActionHistory, CardOnBoards, Cards} from "../codegen/index.sol";
import {Action, TraitData, EffectStatType, EffectAttackerType, Status} from "../codegen/common.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";

contract EffectSystem is System {

    constructor() {

    }

    function DoEffect(bytes4 effect, bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        bytes memory data = abi.encodeWithSelector(effect, ability_key, caster, target, is_card);
        SystemSwitch.call(data);
    }

//    function EffectAddAttackRoll(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
//        int8 dice = 6;
//        int8 value = MathLib.RollRandomValueInt8(1, dice);
//        EffectAddStat(ability_key, caster, target, is_card, EffectStatType.Attack);
//    }

    function EffectAddAttack(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        EffectAddStat(ability_key, caster, target, is_card, EffectStatType.Attack);
    }

    function EffectAddGrowth(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        EffectAddTrait(ability_key, caster, target, is_card, TraitData.Growth);
    }

    function EffectAddHP(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        EffectAddStat(ability_key, caster, target, is_card, EffectStatType.HP);
    }

    function EffectAddMana(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        EffectAddStat(ability_key, caster, target, is_card, EffectStatType.Mana);
    }

    function EffectAddSpellDamage(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        EffectAddTrait(ability_key, caster, target, is_card, TraitData.SpellDamage);
    }


    function EffectClearParalyse(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        if (is_card) {
            CardLogicLib.RemoveStatus(target, Status.Paralysed);
        } else {
            PlayerLogicLib.RemoveStatus(target, Status.Paralysed);
        }
    }

    function EffectClearTaunt(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        if (is_card) {
            CardLogicLib.RemoveStatus(target, Status.Taunt);
        } else {
            PlayerLogicLib.RemoveStatus(target, Status.Taunt);
        }
    }

    function EffectClearStatusAll(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        if (is_card) {
            CardLogicLib.ClearStatus(target);
        } else {
            PlayerLogicLib.ClearStatus(target);
        }
    }

    function EffectDestroy(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        if (is_card) {
            if (CardLogicLib.IsOnBoard(target)) {
                //todo
            }
        }
        //todo
    }

    function EffectDiscard(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        //todo
    }

    function EffectDraw(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        //todo
    }


    function EffectGainMana(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        bytes32 player_key = CardOnBoards.getPlayerId(caster);
        EffectMana(ability_key, caster, player_key, is_card);
    }


    function EffectPlayCard(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        //todo
    }

    function EffectRemoveAbilityAuraHelp(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
//        bytes32 auraHelp
        //todo 这个技能TCG没有实现
    }

    function EffectResetStats(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        //todo
    }

    function EffectRollD6(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        //todo
    }


    function EffectSetAttack(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        EffectSetStat(ability_key, caster, target, is_card, EffectStatType.Attack);
    }

    function EffectSetHP(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        EffectSetStat(ability_key, caster, target, is_card, EffectStatType.HP);
    }

    function EffectSetMana(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        EffectSetStat(ability_key, caster, target, is_card, EffectStatType.Mana);
        //todo
    }

    //设置耗尽
    function EffectExhaust(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        if (is_card) {
            bytes32 player_key = CardOnBoards.getPlayerId(target);
            CardOnBoards.setExhausted(player_key, true);
        }
    }

    function EffectUnexhaust(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        if (is_card) {
            bytes32 player_key = CardOnBoards.getPlayerId(target);
            CardOnBoards.setExhausted(player_key, false);
        }
    }

    //----------------------------------------------------------------------------------------------------------------

    //mana相关
    function EffectMana(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        int8 curr_mana = Players.getMana(target) + Ability.getValue(ability_key);
        Players.setMana(target, curr_mana);
        if (Players.getMana(target) < 0) {
            Players.setMana(target, 0);
        }

        bytes32 game_key = Players.getGame(target);
        uint256 len = PlayerActionHistory.length(game_key);
        bytes32 action_key = keccak256(abi.encode(game_key, len));
        PlayerActionHistory.push(game_key, action_key);
        ActionHistory.setActionType(action_key, Action.ChangeMana);
        ActionHistory.setCardId(action_key, caster);
        ActionHistory.setValue(action_key, curr_mana);
        //ActionHistory.setPlayerId(action_key, players[0] == player_key ? 0 : 1);
    }

    //添加特性
    function EffectAddTrait(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, TraitData trait) internal {
        if (is_card){
            CardLogicLib.AddTrait(target, trait);
        }else {
            PlayerLogicLib.AddTrait(target, trait);
        }
    }

    //设置属性点
    function EffectSetStat(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, EffectStatType stat) internal {

        int8 value = Ability.getValue(ability_key);

        if (is_card) {
            if (stat == EffectStatType.HP) {
                CardOnBoards.setHp(target, value + CardOnBoards.getHp(target));
            }
            if (stat == EffectStatType.Mana) {
                CardOnBoards.setMana(target, value + CardOnBoards.getMana(target));
            }
            if (stat == EffectStatType.Attack) {
                CardOnBoards.setAttack(target, value);
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

    //属性点加成
    function EffectAddStat(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, EffectStatType stat) internal {
        int8 value = Ability.getValue(ability_key);
        if (is_card) {
            if (stat == EffectStatType.HP) {
                CardOnBoards.setHp(target, value + CardOnBoards.getHp(target));
            }
            if (stat == EffectStatType.Mana) {
                //todo
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
