// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {Cards, Players} from "../codegen/index.sol";
import {CardType, GameType, GameState, GamePhase} from "../codegen/common.sol";

import {PlayerCardsDeck, PlayerCardsHand, PlayerCardsBoard, PlayerCardsDiscard, PlayerCardsSecret, PlayerCardsEquip} from "../codegen/index.sol";

library PlayerLogicLib {

    function CanAttack(bool skip_cost) internal pure returns (bool) {
        return true;
    }

    function CanPayMana(bytes32 player_key, bytes32 card_key) internal view returns (bool) {
        return Players.getMana(player_key) > Cards.getMana(card_key);
    }

    function RemoveCardFromAllGroups(bytes32 player_key, bytes32 card_key) internal {
        //        RemoveCardFromBoard(player_key, card_key);
        //        RemoveCardFromHand(player_key, card_key);
        //        RemoveCardFromDeck(player_key, card_key);
    }

    function AddCardToBoard(bytes32 player_key, bytes32 card_key) internal {
        PlayerCardsDeck.pushValue(player_key, card_key);
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
        //        bytes32[] memory cards = PlayerCardsBoard.getValue(player_key);
        //        uint256 cardIndex = findCardIndex(cards, card_key);
        //
        //        if (cardIndex < cards.length) {
        //            // Shift remaining elements to fill the gap
        //            for (uint256 i = cardIndex; i < cards.length - 1; i++) {
        //                cards[i] = cards[i + 1];
        //            }
        //
        //            // Resize the array to remove the last element
        //            bytes32[] memory resizedCards = new bytes32[](cards.length - 1);
        //            for (uint256 i = 0; i < resizedCards.length; i++) {
        //                resizedCards[i] = cards[i];
        //            }
        //
        //            PlayerCardsBoard.setValue(player_key, resizedCards);
        //        }
    }


    function RemoveCardFromHand(bytes32 player_key, bytes32 card_key) internal {
        //todo

    }

    function RemoveCardFromDeck(bytes32 player_key, bytes32 card_key) internal {
        //todo

    }


}