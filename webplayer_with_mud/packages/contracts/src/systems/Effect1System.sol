// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Players, Ability, PlayerActionHistory, ActionHistory, CardOnBoards, Cards} from "../codegen/index.sol";
import {Action, CardTrait, EffectStatType, EffectAttackerType, Status} from "../codegen/common.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";

contract Effect1System is System {

    constructor() {

    }

//    function DoOngoingEffects(bytes4 effect_ongoing, bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
//        bytes memory data = abi.encodeWithSelector(effect_ongoing, ability_key, caster, target, is_card);
//        SystemSwitch.call(data);
//    }

    event EventEffect(string name,bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card);

    function EffectAddAttack(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        emit EventEffect("EffectAddAttack",ability_key, caster, target, is_card);
        EffectAddStat(ability_key, caster, target, is_card, EffectStatType.Attack);
    }

    function EffectAddGrowth(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        emit EventEffect("EffectAddGrowth",ability_key, caster, target, is_card);
        EffectAddTrait(ability_key, caster, target, is_card, CardTrait.Growth);
    }

    function EffectAddHp(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        emit EventEffect("EffectAddHp",ability_key, caster, target, is_card);
        EffectAddStat(ability_key, caster, target, is_card, EffectStatType.HP);
    }

    function EffectAddMana(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        emit EventEffect("EffectAddMana",ability_key, caster, target, is_card);
        EffectAddStat(ability_key, caster, target, is_card, EffectStatType.Mana);
    }

    function EffectAddSpellDamage(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        emit EventEffect("EffectAddSpellDamage",ability_key, caster, target, is_card);
        EffectAddTrait(ability_key, caster, target, is_card, CardTrait.SpellDamage);
    }


    function EffectClearParalyse(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        emit EventEffect("EffectClearParalyse",ability_key, caster, target, is_card);
        if (is_card) {
            CardLogicLib.RemoveStatus(target, Status.Paralysed);
        } else {
            PlayerLogicLib.RemoveStatus(target, Status.Paralysed);
        }
    }

    function EffectClearTaunt(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        emit EventEffect("EffectClearTaunt",ability_key, caster, target, is_card);
        if (is_card) {
            CardLogicLib.RemoveStatus(target, Status.Taunt);
        } else {
            PlayerLogicLib.RemoveStatus(target, Status.Taunt);
        }
    }

    function EffectClearStatusAll(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        emit EventEffect("EffectClearStatusAll",ability_key, caster, target, is_card);
        if (is_card) {
            CardLogicLib.ClearStatus(target);
        } else {
            PlayerLogicLib.ClearStatus(target);
        }
    }

    function EffectDestroy(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        emit EventEffect("EffectDestroy",ability_key, caster, target, is_card);
        if (is_card) {
            bytes32 player_key = CardOnBoards.getPlayerId(target);
            PlayerLogicLib.RemoveCardFromAllGroups(player_key, target);
            PlayerLogicLib.AddCardToDiscard(player_key, target);
        }
    }

    function EffectDraw(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        emit EventEffect("EffectDraw",ability_key, caster, target, is_card);
        int8 value = Ability.getValue(ability_key);
        if (is_card) {
            bytes32 player_key = CardOnBoards.getPlayerId(target);
            PlayerLogicLib.DrawCard(player_key, value);
        } else {
            PlayerLogicLib.DrawCard(target, value);
        }
    }


    function EffectGainMana(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        emit EventEffect("EffectGainMana",ability_key, caster, target, is_card);
        bytes32 player_key = CardOnBoards.getPlayerId(caster);
        EffectMana(ability_key, caster, player_key, is_card);
    }


    function EffectRemoveAbilityAuraHelp(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
//        bytes32 auraHelp
        //todo 这个技能TCG没有实现
    }

    function EffectResetStats(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        //todo
    }


    function EffectSetAttack(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        EffectSetStat(ability_key, caster, target, is_card, EffectStatType.Attack);
    }

    function EffectSetHp(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        EffectSetStat(ability_key, caster, target, is_card, EffectStatType.HP);
    }

    function EffectSetMana(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        EffectSetStat(ability_key, caster, target, is_card, EffectStatType.Mana);
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
        int8 value = Ability.getValue(ability_key);
        int8 curr_mana = Players.getMana(target);
        int8 mana_max = Players.getManaMax(target);
        curr_mana = curr_mana + value;
        if (curr_mana > mana_max) {
            curr_mana = mana_max;
        }
        Players.setMana(target, curr_mana);

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
    function EffectAddTrait(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, CardTrait trait) internal {
        int8 value = Ability.getValue(ability_key);
        if (is_card) {
            CardLogicLib.AddTrait(target, trait, value);
        } else {
            PlayerLogicLib.AddTrait(target, trait, value);
        }
    }

    //设置属性点
    function EffectSetStat(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, EffectStatType stat) internal {

        int8 value = Ability.getValue(ability_key);

        if (is_card) {
            if (stat == EffectStatType.HP) {
                CardOnBoards.setHp(target, value);
                CardOnBoards.setDamage(target, 0);
            }
            if (stat == EffectStatType.Mana) {
                CardOnBoards.setMana(target, value);
            }
            if (stat == EffectStatType.Attack) {
                CardOnBoards.setAttack(target, value);
            }
        } else {
            if (stat == EffectStatType.HP) {
                Players.setHp(target, value);
            }
            if (stat == EffectStatType.Mana) {
                if (value < 0) {
                    Players.setMana(target, 0);
                } else {
                    Players.setMana(target, value);
                }
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
                CardOnBoards.setMana(target, value + CardOnBoards.getMana(target));
            }
            if (stat == EffectStatType.Attack) {
                CardOnBoards.setAttack(target, value + CardOnBoards.getAttack(target));
            }

            bytes32 game_key = Players.getGame(target);
            uint256 len = PlayerActionHistory.length(game_key);
            bytes32 action_key = keccak256(abi.encode(game_key, len));
            PlayerActionHistory.push(game_key, action_key);
            ActionHistory.setActionType(action_key, Action.ChangeCard);
            ActionHistory.setPayload(ability_key, abi.encodePacked(caster, value));
        } else {
            if (stat == EffectStatType.HP) {
                int8 hp = Players.getHp(target);
                int8 hp_max = Players.getHpMax(target);
                if (hp + value > hp_max) {
                    Players.setHp(target, hp_max);
                } else {
                    Players.setHp(target, hp + value);
                }
            }
            if (stat == EffectStatType.Mana) {
                int8 mana = Players.getMana(target);
                int8 mana_max = Players.getManaMax(target);
                if (mana + value > mana_max) {
                    Players.setMana(target, mana_max);
                } else {
                    Players.setMana(target, mana + value);
                }
            }
        }
    }


}
