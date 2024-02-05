// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {CardOnBoards, CardOnBoardsData} from "../codegen/index.sol";
import {Cards, CardsData, Ability} from "../codegen/index.sol";
import {CardType, GameType, GameState, GamePhase, PackType, RarityType, Status, TraitData} from "../codegen/common.sol";
import {PlayerCardsBoard} from "../codegen/index.sol";
import {AbilityTrigger, AbilityTarget} from "../codegen/common.sol";
import {MathLib} from "./MathLib.sol";

library CardLogicLib {

    function GetAttack(CardOnBoardsData memory card) internal pure returns (int8) {
        return card.attack + card.attackOngoing;
    }

    function GetHP(CardOnBoardsData memory card) internal pure returns (int8) {
        return card.hp + card.hpOngoing - card.damage;
    }

    function GetHPMax(CardOnBoardsData memory card) internal pure returns (int8) {
        return card.hp + card.hpOngoing;
    }

    function GetMana(CardOnBoardsData memory card) internal pure returns (int8) {
        return card.mana + card.manaOngoing;
    }

    function IsBoardCard(bytes32 card_key) internal view returns (bool) {
        return Cards.getCardType(card_key) == CardType.CHARACTER || Cards.getCardType(card_key) == CardType.ARTIFACT;
    }


    function IsEquipment(bytes32 card_key) internal view returns (bool) {
        return Cards.getCardType(card_key) == CardType.EQUIPMENT;
    }

    function IsSecret(bytes32 card_key) internal view returns (bool) {
        return Cards.getCardType(card_key) == CardType.SECRET;
    }

    function IsSpell(bytes32 card_key) internal view returns (bool) {
        return Cards.getCardType(card_key) == CardType.SPELL;
    }

    function IsOnBoard(bytes32 card_key) internal view returns (bool) {
//        bytes32 player_key = CardOnBoards.getPlayerId(card_key);
//        bytes32[] memory cards = PlayerCardsBoard.getValue(player_key);
//        for (uint i = 0; i < cards.length; i++) {
//            if (cards[i] == card_key) {
//                return true;
//            }
//        }
//        return false;
        //todo
        return true;
    }

    function IsCharacter(bytes32 card_key) internal view returns (bool) {
        return Cards.getCardType(card_key) == CardType.CHARACTER;
    }

    function IsRequireTargetSpell(bytes32 card_key) internal view returns (bool) {
        return Cards.getCardType(card_key) == CardType.SPELL && HasAbility(card_key, AbilityTrigger.ON_PLAY, AbilityTarget.PlayTarget);
    }

    function HasAbility(bytes32 card_key, AbilityTrigger trigger, AbilityTarget target) internal view returns (bool) {
        bytes32[] memory abilities = Cards.getAbilities(card_key);
        for (uint i = 0; i < abilities.length; i++) {
            AbilityTrigger i_trigger = Ability.getTrigger(abilities[i]);
            AbilityTarget i_target = Ability.getTarget(abilities[i]);
            if (i_trigger == trigger && i_target == target) {
                return true;
            }
        }
        return false;
    }

    function HasStatus(bytes32 card_uid, Status status) internal view returns (bool) {
        uint32[] memory card_status = CardOnBoards.getStatus(card_uid);
        uint len = CardOnBoards.lengthStatus(card_uid);
        for (uint i = 0; i < len; i++) {
            (uint8 status_id, uint8 duration, uint8 value,uint8 unuse) = MathLib.splitUint32(card_status[i]);
            if (status_id == uint8(status)) {
                return true;
            }
        }
        return false;
    }

    function AddStatus(bytes32 card_uid, Status status,uint8 duration,uint8 value) internal {
        CardOnBoards.pushStatus(card_uid, uint8(status));
    }

    function RemoveStatus(bytes32 card_uid, Status status) internal {
        uint32[] memory card_status = CardOnBoards.getStatus(card_uid);
        uint len = CardOnBoards.lengthStatus(card_uid);
        for (uint i = 0; i < len; i++) {
            (uint8 status_id, uint8 duration, uint8 value,uint8 unuse) = MathLib.splitUint32(card_status[i]);
            if (status_id == uint8(status)) {
                CardOnBoards.updateStatus(card_uid, i, uint8(Status.None));
            }
        }
    }

    function ClearStatus(bytes32 card_uid) internal {
        uint32[] memory card_status = new uint32[](0);
        CardOnBoards.setStatus(card_uid, card_status);
    }

    function GetTraitValue(bytes32 caster, TraitData trait) internal returns (int8){
        //todo
        return 0;
    }

    function AddTrait(bytes32 caster, TraitData trait) internal {
        //todo
    }
}