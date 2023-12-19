// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {Cards, Players} from "../codegen/index.sol";
import {CardType, GameType, GameState, GamePhase} from "../codegen/common.sol";
import {PlayerCardsDeck, PlayerCardsHand, PlayerCardsBoard, PlayerCardsDiscard, PlayerCardsSecret, PlayerCardsEquip} from "../codegen/index.sol";
import {BytesArrayTools} from "../utils/BytesArrayTools.sol";

library PlayerLogicLib {

    function CanAttack(bool skip_cost) internal pure returns (bool) {
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
        uint rand = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, cards.length)));
        return cards[rand % cards.length];
    }

    function IsDead(bytes32 player_key) internal view returns (bool) {
        if (PlayerCardsHand.getValue(player_key).length == 0 && PlayerCardsBoard.getValue(player_key).length == 0 && PlayerCardsDeck.getValue(player_key).length == 0){
            return true;
        }
        if(Players.getHp(player_key) <= 0){
            return true;
        }
        return false;
    }

}