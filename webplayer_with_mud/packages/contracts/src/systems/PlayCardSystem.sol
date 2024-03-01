// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {IAbilitySystem} from "../codegen/world/IAbilitySystem.sol";
import {IAbilitySecretsSystem} from "../codegen/world/IAbilitySecretsSystem.sol";
import {IOnGoingSystem} from "../codegen/world/IOnGoingSystem.sol";
import {Cards, Players, CardOnBoards, Games} from "../codegen/index.sol";
import {GameType, GameState, GamePhase, CardType, AbilityTrigger, Action} from "../codegen/common.sol";
import {PlayerActionHistory, ActionHistory, ActionHistoryData} from "../codegen/index.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";
import {BaseLogicLib} from "../libs/BaseLogicLib.sol";
import {Slot, SlotLib} from "../libs/SlotLib.sol";
import {ConditionTargetType} from "../codegen/common.sol";

contract PlayCardSystem is System {


    function PlayCard(bytes32 game_key, bytes32 player_key, bytes32 card_key, uint16 slot_encode, bool skip_cost) public returns (int8, int8){

        //        uint8 card_mana = CardOnBoards.getMana(card_key);
        //        PlayersData memory player = Players.get(player_key);
        //
        //        if (!CanPlayCard(player, card, slot, skip_cost)) {
        //            revert("Can't play card");
        //        }

        //todo

        require(CardOnBoards.getId(card_key) != 0, "Card not found");
        require(Players.getOwner(player_key) == _msgSender(), "Not owner");

        Slot memory slot = SlotLib.DecodeSlot(slot_encode);

        int8 mana_cost = 0;
        int8 player_mana = 0;
        if (!skip_cost) {
//            PayMana(player_key, card_key);

            mana_cost = CardOnBoards.getMana(card_key);
            player_mana = Players.getMana(player_key);
            require(player_mana >= mana_cost, "not enough mana");
            player_mana -= mana_cost;
            Players.setMana(player_key, player_mana);
        }

        PlayerLogicLib.RemoveCardFromAllGroups(player_key, card_key);

        bytes32 card_config_key = CardOnBoards.getId(card_key);
        bytes32[] memory players = Games.getPlayers(game_key);

        if (CardLogicLib.IsBoardCard(card_config_key)) {
            PlayerLogicLib.AddCardToBoard(player_key, card_key);
            CardOnBoards.setExhausted(card_key, true);
            SlotLib.SetCardOnSlot(player_key, card_key, slot.x);
            CardOnBoards.setSlot(card_key, slot_encode);
            //使用触发器触发技能
            SystemSwitch.call(
                abi.encodeCall(IAbilitySystem.TriggerCardAbilityType, (
                    AbilityTrigger.ON_PLAY, game_key, card_key, 0, ConditionTargetType.Card))
            );
        } else if (CardLogicLib.IsEquipment(card_config_key)) {
//            bytes32 bearer = BaseLogicLib.GetSlotCard(game_key, slot);
//            GameLogicLib.EquipCard(bearer, card_key);
            bytes32 card_on_slot = SlotLib.GetCardOnSlot(player_key, slot.x);
            if (card_on_slot == 0) {
                revert("try equipment buf slot is empty");
            }
            CardOnBoards.setExhausted(card_key, true);
            CardOnBoards.setEquippedUid(card_on_slot, card_key);

            PlayerLogicLib.RemoveCardFromAllGroups(player_key, card_key);
            PlayerLogicLib.AddCardToEquipment(player_key, card_key);

        } else if (CardLogicLib.IsSecret(card_config_key)) {
            PlayerLogicLib.AddCardToSecret(player_key, card_key);
        } else if (CardLogicLib.IsSpell(card_config_key)) {

            PlayerLogicLib.RemoveCardFromAllGroups(player_key, card_key);
            PlayerLogicLib.AddCardToDiscard(player_key, card_key);

            if (slot.x != 0) {
                bytes32 slot_player = slot.p == 0 ? players[0] : players[1];
                bytes32 card_on_slot = SlotLib.GetCardOnSlot(slot_player, slot.x);
                SystemSwitch.call(
                    abi.encodeCall(IAbilitySystem.TriggerCardAbilityType, (AbilityTrigger.ON_PLAY, game_key, card_key, card_on_slot, ConditionTargetType.Card))
                );
            } else {
                SystemSwitch.call(
                    abi.encodeCall(IAbilitySystem.TriggerCardAbilityType, (AbilityTrigger.ON_PLAY, game_key, card_key, 0, ConditionTargetType.Card))
                );
            }

        } else {
            PlayerLogicLib.AddCardToDiscard(player_key, card_key);
        }

//        uint16 slot_encode = SlotLib.EncodeSlot(slot);
        if (!CardLogicLib.IsSecret(card_config_key)) {
            uint256 len = PlayerActionHistory.length(game_key);
            bytes32 action_key = keccak256(abi.encode(game_key, len));
            PlayerActionHistory.push(game_key, action_key);
            ActionHistory.setActionType(action_key, Action.PlayCard);
            ActionHistory.setCardId(action_key, card_key);
            ActionHistory.setSlot(action_key, slot_encode);
            ActionHistory.setPlayerId(action_key, players[0] == player_key ? 0 : 1);
        }

        SystemSwitch.call(
            abi.encodeCall(IOnGoingSystem.UpdateOngoing, (game_key))
        );

        SystemSwitch.call(
            abi.encodeCall(IAbilitySecretsSystem.TriggerSecrets, (AbilityTrigger.ON_PLAY_OTHER, game_key, card_key))
        );

        return (mana_cost, player_mana);
    }


    function PayMana(bytes32 player_key, bytes32 card_key) public {
        //        PlayersData memory player = Players.get(player_key);
        int8 player_mana = Players.getMana(player_key);
        Players.setMana(player_key, player_mana - Cards.get(card_key).mana);
    }

}