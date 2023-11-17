// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {CardOnBoards, CardOnBoardsData} from "../codegen/index.sol";
import {Cards, CardsData} from "../codegen/index.sol";

import {CardType, GameType, GameState, GamePhase, PackType, RarityType} from "../codegen/common.sol";

library CardLogicLib {

    function GetAttack(CardOnBoardsData memory card) internal pure returns (uint256) {
        return card.attack + card.attackOngoing;
    }

    function GetHP(CardOnBoardsData memory card) internal pure returns (uint256) {
        return card.hp + card.hpOngoing - card.damage;
    }

    function GetHPMax(CardOnBoardsData memory card) internal pure returns (uint256) {
        return card.hp + card.hpOngoing;
    }

    function GetMana(CardOnBoardsData memory card) internal pure returns (uint256) {
        return card.mana + card.manaOngoing;
    }

    function IsBoardCard(bytes32 card_key) internal view returns (bool) {
        return Cards.getCardType(card_key) == CardType.CHARACTER || Cards.getCardType(card_key) == CardType.ARTIFACT;
    }

    function IsEquipment(bytes32 card_key) internal view returns (bool) {
        return Cards.getCardType(card_key) == CardType.EQUIPMENT;
    }

    function IsSecret(bytes32 card_key) internal view returns (bool) {
        return Cards.getCardType(card_key) == CardType.SPELL;
    }


    //    internal bool IsBoardCard()
    //    {
    //    return type == CardType.Character || type == CardType.Artifact;
    //    }
}