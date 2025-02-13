// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {Cards, Players} from "../codegen/index.sol";
import {CardType, GameType, GameState, GamePhase, Status, CardTrait, PileType} from "../codegen/common.sol";
import {CardOnBoards} from "../codegen/index.sol";
import {Slot, SlotLib} from "./SlotLib.sol";
import {CardTableLib} from "./CardTableLib.sol";

library PlayerLogicLib {


    function CanAttack(bool skip_cost) internal pure returns (bool) {
        //todo
        return true;
    }

    function CanPayMana(bytes32 player_key, bytes32 card_key) internal view returns (bool) {
        return Players.getMana(player_key) > Cards.getMana(card_key);
    }

    function RemoveCardFromAllGroups(bytes32 player, bytes32 card) internal {
        RemoveCardFrom(PileType.Board, player, card);
        RemoveCardFrom(PileType.Hand, player, card);
        RemoveCardFrom(PileType.Deck, player, card);
        RemoveCardFrom(PileType.Discard, player, card);
        RemoveCardFrom(PileType.Secret, player, card);
        RemoveCardFrom(PileType.Equipped, player, card);
        RemoveCardFrom(PileType.Temp, player, card);
    }

    function RemoveCardFrom(PileType pile, bytes32 player, bytes32 card) internal {
        bytes32[] memory cards = CardTableLib.getValue(pile, player);
        cards = CardTableLib.removeElementFromArray(cards, card);
        CardTableLib.setValue(pile, player, cards);
    }

    function AddCardTo(PileType pile, bytes32 player_key, bytes32 card_key) internal {
        CardTableLib.pushValue(pile, player_key, card_key);
    }

    function AddCardToBoard(bytes32 player_key, bytes32 card_key) internal {
        AddCardTo(PileType.Board, player_key, card_key);
    }

    function AddCardToHand(bytes32 player_key, bytes32 card_key) internal {
        AddCardTo(PileType.Hand, player_key, card_key);
    }

    function AddCardToSecret(bytes32 player_key, bytes32 card_key) internal {
        AddCardTo(PileType.Secret, player_key, card_key);
    }

    function AddCardToEquipment(bytes32 player_key, bytes32 card_key) internal {
        AddCardTo(PileType.Equipped, player_key, card_key);
    }

    function AddCardToDiscard(bytes32 player_key, bytes32 card_key) internal {
        AddCardTo(PileType.Discard, player_key, card_key);
    }

    function AddCardToDeck(bytes32 player_key, bytes32 card_key) internal {
        AddCardTo(PileType.Deck, player_key, card_key);
    }

    function GetRandomCard(bytes32 player_key) internal view returns (bytes32) {
        bytes32[] memory cards = CardTableLib.getValue(PileType.Hand, player_key);
        if (cards.length == 0) {
            return 0;
        }
        uint rand = uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, cards.length)));
        return cards[rand % cards.length];
    }

    function IsDead(bytes32 player_key) internal view returns (bool) {
        if (
            CardTableLib.length(PileType.Hand, player_key) == 0 &&
            CardTableLib.length(PileType.Board, player_key) == 0 &&
            CardTableLib.length(PileType.Deck, player_key) == 0
        ) {
            return true;
        }
        if (Players.getHp(player_key) <= 0) {
            return true;
        }
        return false;
    }

    function GetRandomEmptySlot(bytes32 player_key) internal pure returns (Slot memory) {
        Slot memory slot = SlotLib.NewSlot(0, 0, 0);
        Slot[] memory slots = SlotLib.GetAll();
        for (uint i = 0; i < slots.length; i++) {
            //todo
        }
        return slot;
    }

    function AddOngoingStatus(bytes32 player_uid, Status status, uint8 value) internal {
        //todo value
        Players.pushOngoingStatus(player_uid, uint8(status));
    }

    function AddStatus(bytes32 player_uid, Status status, uint8 duration, uint8 value) internal {
        uint32 payload = combineUint32(uint8(status), duration, value, 0);
        Players.pushStatus(player_uid, payload);
    }

    function GetStatus(bytes32 player_uid, Status status) internal view returns (Status, uint8, uint8){
        uint32[] memory player_status = Players.getStatus(player_uid);
        for (uint i = 0; i < player_status.length; i++) {
            (uint8 status_id, uint8 duration, uint8 value,uint8 unuse) = splitUint32(player_status[i]);
            if (status_id == uint8(status)) {
                return (status, duration, value);
            }
        }
        return (Status.None, 0, 0);
    }

    function ClearStatus(bytes32 player_uid) internal {
        uint32[] memory status = new uint32[](0);
        Players.setStatus(player_uid, status);
    }

    function HasStatus(bytes32 player_uid, Status status) internal view returns (bool) {
        uint32[] memory player_status = Players.getStatus(player_uid);
        for (uint i = 0; i < player_status.length; i++) {
            (uint8 status_id, uint8 duration, uint8 value,uint8 unuse) = splitUint32(player_status[i]);
            if (status_id == uint8(status)) {
                return true;
            }
        }
        return false;
    }

    function GetStatusValue(bytes32 player_uid, Status status) internal view returns (uint8){
        uint32[] memory player_status = Players.getStatus(player_uid);
        for (uint i = 0; i < player_status.length; i++) {
            (uint8 status_id, uint8 duration, uint8 value,uint8 unuse) = splitUint32(player_status[i]);
            if (status_id == uint8(status)) {
                return value;
            }
        }
        return 0;
    }

    function RemoveStatus(bytes32 player_uid, Status status) internal {
        uint32[] memory player_status = Players.getStatus(player_uid);
        for (uint i = 0; i < player_status.length; i++) {
            if (player_status[i] == uint8(status)) {
                Players.updateStatus(player_uid, i, uint8(Status.None));
            }
        }
    }

    function GetTraitValue(bytes32 caster, CardTrait trait) internal view returns (int8){
        uint16[] memory traits = Players.getTrait(caster);
        for (uint i = 0; i < traits.length; i++) {
            uint16 trait_data = traits[i];
            uint8 trait_id = uint8(trait_data);
            uint8 trait_value = uint8(trait_data >> 8);
            if (trait == (CardTrait)(trait_id)) {
                return int8(trait_value);
            }
        }
        return 0;
    }

    function GetTrait(bytes32 caster, CardTrait trait) internal view returns (uint256, uint16){
        uint16[] memory traits = Players.getTrait(caster);
        for (uint i = 0; i < traits.length; i++) {
            uint16 trait_data = traits[i];
            uint8 trait_id = uint8(trait_data);
            uint8 trait_value = uint8(trait_data >> 8);
            if (trait == (CardTrait)(trait_id)) {
                return (i, trait_data);
            }
        }
        return (0, 0);
    }

    function SetTrait(bytes32 caster, CardTrait trait, uint8 value) internal {
        uint16 trait_data = (uint16(uint8(trait)) << 8) | uint16(value);
        CardOnBoards.pushTrait(caster, trait_data);
    }

    function AddTrait(bytes32 caster, CardTrait trait, int8 value) internal {
        (uint256 trait_index, uint16 trait_data) = GetTrait(caster, trait);
        if (trait_data != 0) {
            uint8 trait_id = uint8(trait_data);
            uint8 trait_value = uint8(trait_data >> 8);
            trait_value = trait_value + uint8(value);
            uint16 new_trait_data = (uint16(trait_id) << 8) | uint16(trait_value);
            Players.updateTrait(caster, trait_index, new_trait_data);
        } else {
            SetTrait(caster, trait, (uint8)(value));
        }
    }

    function DrawCard(bytes32 player_key, int8 card_number) internal returns (bytes32[] memory){
        require(card_number > 0, "card_number must > 0");
        uint nb = uint256(int256(card_number));
        bytes32[] memory draw_cards = new bytes32[](nb);
        for (uint i = 0; i < nb; i++) {
            uint256 len = CardTableLib.length(PileType.Deck, player_key);
            if (len == 0) {
                break;
            }
            bytes32 card_uid = CardTableLib.getItem(PileType.Deck, player_key, len - 1);
            draw_cards[i] = card_uid;
            CardTableLib.popValue(PileType.Deck, player_key);
            AddCardToHand(player_key, card_uid);
        }
        return draw_cards;
    }

    function GetBearerCard(bytes32 player_key, bytes32 equipment) internal returns (bytes32){

        return 0;
    }

    function combineUint32(uint8 a, uint8 b, uint8 c, uint8 d) internal pure returns (uint32) {
        uint32 result = (uint32(a) << 24) | (uint32(b) << 16) | (uint32(c) << 8) | uint32(d);
        return result;
    }

    function splitUint32(uint32 value) internal pure returns (uint8, uint8, uint8, uint8) {
        uint8 a = uint8((value >> 24) & 0xFF);
        uint8 b = uint8((value >> 16) & 0xFF);
        uint8 c = uint8((value >> 8) & 0xFF);
        uint8 d = uint8(value & 0xFF);
        return (a, b, c, d);
    }



//public Card GetBearerCard(Card equipment)
//{
//foreach (Card card in cards_board)
//{
//if (card != null && card.equipped_uid == equipment.uid)
//return card;
//}
//return null;
//}
}