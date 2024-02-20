// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {CardOnBoards} from "../codegen/index.sol";
import {PlayerCardsBoard, PlayerCardsHand, PlayerCardsEquip, PlayerCardsEquip, PlayerCardsDeck, PlayerCardsTemp, PlayerCardsDiscard, PlayerCardsSecret} from "../codegen/index.sol";

library CardPosLogicLib {
    function IsInHand(bytes32 card_key) internal view returns (bool) {
        bytes32 player_key = CardOnBoards.getPlayerId(card_key);
        bytes32[] memory cards = PlayerCardsHand.getValue(player_key);
        for (uint i = 0; i < cards.length; i++) {
            if (cards[i] == card_key) {
                return true;
            }
        }
        return false;
    }

    function IsOnBoard(bytes32 card_key) internal view returns (bool) {
        bytes32 player_key = CardOnBoards.getPlayerId(card_key);
        bytes32[] memory cards = PlayerCardsBoard.getValue(player_key);
        for (uint i = 0; i < cards.length; i++) {
            if (cards[i] == card_key) {
                return true;
            }
        }
        return false;
    }

    function IsInDeck(bytes32 card_key) internal view returns (bool) {
        bytes32 player_key = CardOnBoards.getPlayerId(card_key);
        bytes32[] memory cards = PlayerCardsDeck.getValue(player_key);
        for (uint i = 0; i < cards.length; i++) {
            if (cards[i] == card_key) {
                return true;
            }
        }
        return false;
    }

    function IsInTemp(bytes32 card_key) internal view returns (bool) {
        bytes32 player_key = CardOnBoards.getPlayerId(card_key);
        bytes32[] memory cards = PlayerCardsTemp.getValue(player_key);
        for (uint i = 0; i < cards.length; i++) {
            if (cards[i] == card_key) {
                return true;
            }
        }
        return false;
    }

    function IsInDiscard(bytes32 card_key) internal view returns (bool) {
        bytes32 player_key = CardOnBoards.getPlayerId(card_key);
        bytes32[] memory cards = PlayerCardsDiscard.getValue(player_key);
        for (uint i = 0; i < cards.length; i++) {
            if (cards[i] == card_key) {
                return true;
            }
        }
        return false;
    }

    function IsInSecret(bytes32 card_key) internal view returns (bool) {
        bytes32 player_key = CardOnBoards.getPlayerId(card_key);
        bytes32[] memory cards = PlayerCardsSecret.getValue(player_key);
        for (uint i = 0; i < cards.length; i++) {
            if (cards[i] == card_key) {
                return true;
            }
        }
        return false;
    }
}