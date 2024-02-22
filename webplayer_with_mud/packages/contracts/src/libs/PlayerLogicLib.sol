// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {Cards, Players} from "../codegen/index.sol";
import {CardType, GameType, GameState, GamePhase, Status, TraitData} from "../codegen/common.sol";
import {PlayerCardsDeck, PlayerCardsHand, PlayerCardsBoard, PlayerCardsDiscard, PlayerCardsSecret, PlayerCardsEquip} from "../codegen/index.sol";
import {BytesArrayTools} from "../utils/BytesArrayTools.sol";
import "./SlotLib.sol";

library PlayerLogicLib {

    function CanAttack(bool skip_cost) internal pure returns (bool) {
        //todo
        return true;
    }

    function CanPayMana(bytes32 player_key, bytes32 card_key) internal view returns (bool) {
        return Players.getMana(player_key) > Cards.getMana(card_key);
    }

    function RemoveCardFromAllGroups(bytes32 player_key, bytes32 card_key) internal {
        RemoveCardFromBoard(player_key, card_key);
        RemoveCardFromHand(player_key, card_key);
        RemoveCardFromDeck(player_key, card_key);
    }

    function AddCardToBoard(bytes32 player_key, bytes32 card_key) internal {
        PlayerCardsBoard.pushValue(player_key, card_key);
    }

    function AddCardToHand(bytes32 player_key, bytes32 card_key) internal {
        PlayerCardsHand.pushValue(player_key, card_key);
    }


    function AddCardToSecret(bytes32 player_key, bytes32 card_key) internal {
        PlayerCardsSecret.pushValue(player_key, card_key);
    }

    function AddCardToEquipment(bytes32 player_key, bytes32 card_key) internal {
        PlayerCardsEquip.pushValue(player_key, card_key);
    }

    function AddCardToDiscard(bytes32 player_key, bytes32 card_key) internal {
        PlayerCardsDiscard.pushValue(player_key, card_key);
    }

    function AddCardToDeck(bytes32 player_key, bytes32 card_key) internal {
        PlayerCardsDeck.pushValue(player_key, card_key);
    }

    function RemoveCardFromBoard(bytes32 player_key, bytes32 card_key) internal {
        PlayerCardsBoard.setValue(player_key, BytesArrayTools.removeElementFromArray(PlayerCardsBoard.getValue(player_key), card_key));
    }


    function RemoveCardFromHand(bytes32 player_key, bytes32 card_key) internal {
        PlayerCardsHand.setValue(player_key, BytesArrayTools.removeElementFromArray(PlayerCardsHand.getValue(player_key), card_key));
    }

    function RemoveCardFromDeck(bytes32 player_key, bytes32 card_key) internal {
        PlayerCardsDeck.setValue(player_key, BytesArrayTools.removeElementFromArray(PlayerCardsDeck.getValue(player_key), card_key));
    }

    function GetRandomCard(bytes32 player_key) internal view returns (bytes32) {
        bytes32[] memory cards = PlayerCardsHand.getValue(player_key);
        if (cards.length == 0) {
            return 0;
        }
        uint rand = uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, cards.length)));
        return cards[rand % cards.length];
    }

    function IsDead(bytes32 player_key) internal view returns (bool) {
        if (PlayerCardsHand.getValue(player_key).length == 0 && PlayerCardsBoard.getValue(player_key).length == 0 && PlayerCardsDeck.getValue(player_key).length == 0) {
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

    function RemoveStatus(bytes32 player_uid, Status status) internal {
        uint32[] memory player_status = Players.getStatus(player_uid);
        for (uint i = 0; i < player_status.length; i++) {
            if (player_status[i] == uint8(status)) {
                Players.updateStatus(player_uid, i, uint8(Status.None));
            }
        }
    }

    function GetTraitValue(bytes32 caster, TraitData trait) internal returns (int8){
        //todo
        return 0;
    }

    function AddTrait(bytes32 caster, TraitData trait) internal {
        //todo
    }

    function DrawCard(bytes32 player_key, int8 card_number) internal returns (bytes32[] memory){
        require(card_number > 0, "card_number must > 0");
        bytes32[] memory draw_cards = new bytes32[](uint256(int256(card_number)));
        for (int8 i = 0; i < card_number; i++) {
            uint256 len = PlayerCardsDeck.length(player_key);
            if (len == 0) {
                break;
            }
            bytes32 card_uid = PlayerCardsDeck.getItemValue(player_key, len - 1);
            draw_cards[uint256(int256(i))] = card_uid;
            PlayerCardsDeck.popValue(player_key);
            PlayerCardsHand.pushValue(player_key, card_uid);
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