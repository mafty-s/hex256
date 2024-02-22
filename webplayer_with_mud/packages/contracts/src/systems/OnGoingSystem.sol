// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {IEffectSystem} from "../codegen/world/IEffectSystem.sol";
import {IConditionSystem} from "../codegen/world/IConditionSystem.sol";
import {IFilterSystem} from "../codegen/world/IFilterSystem.sol";
import {Ability, AbilityExtend, CardOnBoards, Cards, PlayerActionHistory, ActionHistory, Players, Games, GamesExtended, Config} from "../codegen/index.sol";
import {AbilityTrigger, Status, Action, AbilityTarget, SelectorType, ConditionTargetType} from "../codegen/common.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {PlayerCardsBoard, PlayerCardsHand, PlayerCardsEquip} from "../codegen/index.sol";
import {Slot, SlotLib} from "../libs/SlotLib.sol";

contract OnGoingSystem is System {
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
                UpdateOngoingAbilities(player_key, cards_board[c], players);
            }

            bytes32[] memory cards_equip = PlayerCardsEquip.getValue(player_key);
            for (uint c = 0; c < cards_equip.length; c++) {
                UpdateOngoingAbilities(player_key, cards_equip[c], players);
            }

            bytes32[] memory cards_hand = PlayerCardsHand.getValue(player_key);
            for (uint c = 0; c < cards_hand.length; c++) {
                UpdateOngoingAbilities(player_key, cards_hand[c], players);
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

                //Status bonus
                uint32[] memory status_list = CardOnBoards.getStatus(cards_board[c]);

                for (uint cs = 0; cs < status_list.length; cs++) {
                    (uint8 status_id, uint8 duration, uint8 value,uint8 unuse) = splitUint32(status_list[cs]);
                    AddOngoingStatusBonus(cards_board[c], (Status)(status_id),  int8(value));
                }
                uint32[] memory status_ongoing_list = CardOnBoards.getOngoingStatus(cards_board[c]);
                for (uint csg = 0; csg < status_ongoing_list.length; csg++) {
                    (uint8 status_id, uint8 duration, uint8 value,uint8 unuse) = splitUint32(status_ongoing_list[csg]);
                    AddOngoingStatusBonus(cards_board[c], (Status)(status_id), int8(value));
                }
            }
        }
        return;

        //Kill stuff with 0 hp
        for (uint i = 0; i < players.length; i++) {
            bytes32 player_key = players[i];
            bytes32[] memory cards_board = PlayerCardsBoard.getValue(player_key);
            for (uint c = 0; c < cards_board.length; c++) {
                if (CardLogicLib.GetHP(cards_board[c]) <= 0)
                {
                    //todo
                }
                //todo
            }
        }
        //Clear cards
        //todo
    }

    function AddOngoingStatusBonus(bytes32 card_key, Status status, int8 value) internal {
        if (status == Status.Attack) {
            CardOnBoards.setAttackOngoing(card_key, CardOnBoards.getAttackOngoing(card_key) + value);
        }
        if (status == Status.Hp) {
            CardOnBoards.setHpOngoing(card_key, CardOnBoards.getHpOngoing(card_key) + value);
        }
    }

    function UpdateOngoingAbilities(bytes32 player_key, bytes32 card_key, bytes32[] memory players) public {

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
                        DoOngoingEffects(ability_key, card_key, player_key, false);
                    }

                    if (target == AbilityTarget.AllPlayers || target == AbilityTarget.PlayerOpponent)
                    {
                        //todo
                    }

                    if (target == AbilityTarget.EquippedCard)
                    {
                        bytes32 equipped_uid = CardOnBoards.getEquippedUid(card_key);
                        if (CardLogicLib.IsEquipment(card_config_id)) {
                            //Get bearer of the equipment
                            bytes32 target = PlayerLogicLib.GetBearerCard(player_key, card_key);
                            if (target != 0) {
                                DoOngoingEffects(ability_key, card_key, target, true);
                            }
                        } else if (equipped_uid != 0) {
                            //Get equipped card
                            DoOngoingEffects(ability_key, card_key, equipped_uid, true);
                        }
                    }

                    if (target == AbilityTarget.AllCardsAllPiles || target == AbilityTarget.AllCardsHand || target == AbilityTarget.AllCardsBoard)
                    {
                        for (uint tp = 0; tp < players.length; tp++)
                        {
                            //Hand Cards
                            if (target == AbilityTarget.AllCardsAllPiles || target == AbilityTarget.AllCardsHand)
                            {
                                bytes32[] memory cards_board = PlayerCardsBoard.getValue(players[tp]);
                                for (uint tc = 0; tc < cards_board.length; tc++) {
                                    DoOngoingEffects(ability_key, card_key, cards_board[tc], true);
                                }

                                //todo
                            }
                            //Board Cards
                            if (target == AbilityTarget.AllCardsAllPiles || target == AbilityTarget.AllCardsBoard)
                            {
                                //todo
                            }
                            //Equip Cards
                            if (target == AbilityTarget.AllCardsAllPiles)
                            {
                                //todo
                            }
                        }

                    }

                }
            }
        }


    }


    function splitUint32(uint32 value) internal pure returns (uint8, uint8, uint8, uint8) {
        uint8 a = uint8((value >> 24) & 0xFF);
        uint8 b = uint8((value >> 16) & 0xFF);
        uint8 c = uint8((value >> 8) & 0xFF);
        uint8 d = uint8(value & 0xFF);
        return (a, b, c, d);
    }
}