// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {CardOnBoards, CardOnBoardsData} from "../codegen/index.sol";
import {Cards, Ability} from "../codegen/index.sol";
import {CardType, GameType, GameState, GamePhase, PackType, RarityType, Status, TraitData} from "../codegen/common.sol";
import {AbilityTrigger, AbilityTarget} from "../codegen/common.sol";
//import {UintLib} from "./UintLib.sol";

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
        return Cards.getCardType(card_key) == CardType.Character || Cards.getCardType(card_key) == CardType.Artifact;
    }


    function IsEquipment(bytes32 card_key) internal view returns (bool) {
        return Cards.getCardType(card_key) == CardType.Equipment;
    }

    function IsSecret(bytes32 card_key) internal view returns (bool) {
        return Cards.getCardType(card_key) == CardType.Secret;
    }

    function IsSpell(bytes32 card_key) internal view returns (bool) {
        return Cards.getCardType(card_key) == CardType.Spell;
    }


    function IsCharacter(bytes32 card_key) internal view returns (bool) {
        return Cards.getCardType(card_key) == CardType.Character;
    }

    function IsRequireTargetSpell(bytes32 card_key) internal view returns (bool) {
        return Cards.getCardType(card_key) == CardType.Spell && HasAbility(card_key, AbilityTrigger.ON_PLAY, AbilityTarget.PlayTarget);
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
            (uint8 status_id, uint8 duration, uint8 value,uint8 unuse) = splitUint32(card_status[i]);
            if (status_id == uint8(status)) {
                return true;
            }
        }
        return false;
    }

    function GetStatus(bytes32 card_uid, Status status) internal view returns (Status, uint8, uint8){
        uint32[] memory card_status = CardOnBoards.getStatus(card_uid);
        uint len = CardOnBoards.lengthStatus(card_uid);
        for (uint i = 0; i < len; i++) {
            (uint8 status_id, uint8 duration, uint8 value,uint8 unuse) = splitUint32(card_status[i]);
            if (status_id == uint8(status)) {
                return (status, duration, value);
            }
        }
        return (Status.None, 0, 0);
    }


    function AddStatus(bytes32 card_uid, Status status, uint8 duration, uint8 value) internal {
        uint32 payload = combineUint32(uint8(status), duration, value, 0);
        CardOnBoards.pushStatus(card_uid, payload);
    }


    function AddOngoingStatus(bytes32 card_uid, Status status, uint8 duration, uint8 value) internal {
        uint32 payload = combineUint32(uint8(status), duration, value, 0);
        CardOnBoards.pushOngoingStatus(card_uid, payload);
    }

    function ClearOngoing(bytes32 card_uid) internal {
        if (card_uid == 0) {
            return;
        }
        uint32[] memory card_status = new uint32[](0);
        CardOnBoards.setOngoingStatus(card_uid, card_status);
    }

    function RemoveStatus(bytes32 card_uid, Status status) internal {
        uint32[] memory card_status = CardOnBoards.getStatus(card_uid);
        uint len = CardOnBoards.lengthStatus(card_uid);
        for (uint i = 0; i < len; i++) {
            (uint8 status_id, uint8 duration, uint8 value,uint8 unuse) = splitUint32(card_status[i]);
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

    function CanDoAbilities(bytes32 card_uid) internal view returns (bool){
        if (HasStatus(card_uid, Status.Silenced))
            return false;
        return true;
    }
}