// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {CardOnBoards} from "../codegen/index.sol";
import {CardTableLib} from "./CardTableLib.sol";
import {PileType} from "../codegen/common.sol";

library CardPosLogicLib {
    function IsInHand(bytes32 card_key) internal view returns (bool) {
        return IsIn(card_key,PileType.Hand);
    }

    function IsOnBoard(bytes32 card_key) internal view returns (bool) {
        return IsIn(card_key,PileType.Board);
    }

    function IsInDeck(bytes32 card_key) internal view returns (bool) {
        return IsIn(card_key,PileType.Deck);
    }

    function IsInTemp(bytes32 card_key) internal view returns (bool) {
        return IsIn(card_key,PileType.Temp);
    }

    function IsInDiscard(bytes32 card_key) internal view returns (bool) {
        return IsIn(card_key,PileType.Discard);
    }

    function IsInSecret(bytes32 card_key) internal view returns (bool) {
        return IsIn(card_key,PileType.Secret);
    }

    function IsIn(bytes32 card_key, PileType pile) internal view returns (bool) {
        bytes32 player_key = CardOnBoards.getPlayerId(card_key);
        bytes32[] memory cards = CardTableLib.getValue(pile, player_key);
        for (uint i = 0; i < cards.length; i++) {
            if (cards[i] == card_key) {
                return true;
            }
        }
        return false;
    }
}