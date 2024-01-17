// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards} from "../codegen/index.sol";
//import {Decks, DecksData} from "../codegen/index.sol";
//import {Games, GamesData} from "../codegen/index.sol";
import {Players} from "../codegen/index.sol";
//import {PlayerCardsDeck, PlayerCardsHand} from "../codegen/index.sol";
import {CardOnBoards, PlayCardResultData} from "../codegen/index.sol";

import {GameType, GameState, GamePhase, CardType, AbilityTrigger, Action} from "../codegen/common.sol";

import {PlayerCardsDeck, PlayerCardsHand, PlayerCardsBoard, PlayerCardsDiscard, PlayerCardsSecret, PlayerCardsEquip, CardOnBoards} from "../codegen/index.sol";
import {PlayerActionHistory, ActionHistory, ActionHistoryData} from "../codegen/index.sol";
import "../libs/PlayerLogicLib.sol";
import "../libs/CardLogicLib.sol";
import "../libs/GameLogicLib.sol";
import "../libs/AbilityLib.sol";
import {BaseLogicLib} from "../libs/BaseLogicLib.sol";
import {Slot, SlotLib} from "../libs/SlotLib.sol";


contract PlayCardSystem is System {


    function PlayCard(bytes32 game_key, bytes32 player_key, bytes32 card_key, Slot memory slot, bool skip_cost) public returns (PlayCardResultData memory){

        //        uint8 card_mana = CardOnBoards.getMana(card_key);
        //        PlayersData memory player = Players.get(player_key);
        //
        //        if (!CanPlayCard(player, card, slot, skip_cost)) {
        //            revert("Can't play card");
        //        }

        //todo

        require(CardOnBoards.getId(card_key) != 0, "Card not found");
        require(Players.getOwner(player_key) == _msgSender(), "Not owner");

        if (!skip_cost) {
            PayMana(player_key, card_key);
        }

        PlayerLogicLib.RemoveCardFromAllGroups(player_key, card_key);

        if (CardLogicLib.IsBoardCard(card_key)) {
            PlayerLogicLib.AddCardToBoard(player_key, card_key);
            SlotLib.SetSlot(card_key, slot);
            CardOnBoards.setExhausted(card_key, true);
        } else if (CardLogicLib.IsEquipment(card_key)) {
            bytes32 bearer = BaseLogicLib.GetSlotCard(game_key, slot);
            GameLogicLib.EquipCard(bearer, card_key);
            CardOnBoards.setExhausted(card_key, true);
        } else if (CardLogicLib.IsSecret(card_key)) {
            PlayerLogicLib.AddCardToSecret(card_key, player_key);
        } else {
            PlayerLogicLib.AddCardToDiscard(card_key, player_key);
            SlotLib.SetSlot(card_key, slot);
        }

        GameLogicLib.UpdateOngoing();

        AbilityLib.TriggerCardAbilityTypeOneCard(game_key, AbilityTrigger.ON_PLAY, card_key);
        AbilityLib.TriggerOtherCardsAbilityType(AbilityTrigger.ON_PLAY_OTHER, card_key);

        //        if (game_data.CanPlayCard(card, slot, skip_cost))
        //        {
        //            Player player = game_data.GetPlayer(card.player_id);
        //
        //            //Cost
        //            if (!skip_cost)
        //                player.PayMana(card);
        //
        //            //Play card
        //            player.RemoveCardFromAllGroups(card);
        //
        //            //Add to board
        //            CardData icard = card.CardData;
        //            if (icard.IsBoardCard())
        //            {
        //                player.cards_board.Add(card);
        //                card.slot = slot;
        //                card.exhausted = true; //Cant attack first turn
        //            }
        //            else if (icard.IsEquipment())
        //            {
        //                Card bearer = game_data.GetSlotCard(slot);
        //                EquipCard(bearer, card);
        //                card.exhausted = true;
        //            }
        //            else if (icard.IsSecret())
        //            {
        //                player.cards_secret.Add(card);
        //            }
        //            else
        //            {
        //                player.cards_discard.Add(card);
        //                card.slot = slot; //Save slot in case spell has PlayTarget
        //            }
        //
        //            //History
        //            if(!is_ai_predict && !icard.IsSecret())
        //                player.AddHistory(GameAction.PlayCard, card);
        //
        //            //Update ongoing effects
        //            game_data.last_played = card.uid;
        //            UpdateOngoing();
        //
        //            //Trigger abilities
        //            TriggerSecrets(AbilityTrigger.OnPlayOther, card); //After playing card
        //            TriggerCardAbilityType(AbilityTrigger.OnPlay, card);
        //            TriggerOtherCardsAbilityType(AbilityTrigger.OnPlayOther, card);
        //
        //            onCardPlayed?.Invoke(card, slot);
        //            resolve_queue.ResolveAll(0.3f);

        uint8 mana_cost = CardOnBoards.getMana(card_key);
        uint8 player_mana = Players.getMana(player_key);
        require(player_mana >= mana_cost, "not enough mana");
        player_mana -= mana_cost;
        Players.setMana(player_key, player_mana);

        uint16 slot_encode = SlotLib.EncodeSlot(slot);
        uint256 len = PlayerActionHistory.length(player_key);
        bytes32 action_key = keccak256(abi.encode(player_key, len));
        PlayerActionHistory.push(player_key, action_key);
        ActionHistory.setActionType(action_key, Action.PlayCard);
        ActionHistory.setCardId(action_key, card_key);
        ActionHistory.setSlot(action_key, slot_encode);
        //todo ActionHistory.setPlayer(action_key, player_key);

        PlayCardResultData memory result = PlayCardResultData(
            mana_cost,
            player_mana
        );
        return result;

    }


    function PayMana(bytes32 player_key, bytes32 card_key) public {
        //        PlayersData memory player = Players.get(player_key);
        uint8 player_mana = Players.getMana(player_key);
        Players.setMana(player_key, player_mana - Cards.get(card_key).mana);
    }

}