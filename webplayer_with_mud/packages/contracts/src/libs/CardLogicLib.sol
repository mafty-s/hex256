// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {CardOnBoards} from "../codegen/index.sol";
import {Cards, Ability} from "../codegen/index.sol";
import {CardType, GameType, GameState, GamePhase, PackType, RarityType, Status, CardTrait} from "../codegen/common.sol";
import {AbilityTrigger, AbilityTarget} from "../codegen/common.sol";
//import {UintLib} from "./UintLib.sol";

library CardLogicLib {

    function GetAttack(bytes32 card_key) internal view returns (int8) {
        int8 attack = CardOnBoards.getAttack(card_key);
        int8 attackOngoing = CardOnBoards.getAttackOngoing(card_key);
        return attack + attackOngoing;
    }

    function GetHP(bytes32 card_key) internal view returns (int8) {
        int8 hp = CardOnBoards.getHp(card_key);
        int8 hpOngoing = CardOnBoards.getHpOngoing(card_key);
        int8 damage = CardOnBoards.getDamage(card_key);
        return hp + hpOngoing - damage;
    }

    function GetHPMax(bytes32 card_key) internal view returns (int8) {
        int8 hp = CardOnBoards.getHp(card_key);
        int8 hpOngoing = CardOnBoards.getHpOngoing(card_key);
        return hp + hpOngoing;
    }

    function GetMana(bytes32 card_key) internal view returns (int8) {
        int8 mana = CardOnBoards.getMana(card_key);
        int8 manaOngoing = CardOnBoards.getManaOngoing(card_key);
        return mana + manaOngoing;
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
        for (uint i = 0; i < card_status.length; i++) {
            (uint8 status_id, uint8 duration, uint8 value,uint8 unuse) = splitUint32(card_status[i]);
            if (status_id == uint8(status)) {
                return true;
            }
        }
        return false;
    }

    function GetStatusValue(bytes32 card_uid, Status status) internal view returns (uint8){
        uint32[] memory card_status = CardOnBoards.getStatus(card_uid);
        for (uint i = 0; i < card_status.length; i++) {
            (uint8 status_id, uint8 duration, uint8 value,uint8 unuse) = splitUint32(card_status[i]);
            if (status_id == uint8(status)) {
                return value;
            }
        }
        return 0;
    }

    function GetStatus(bytes32 card_uid, Status status) internal view returns (Status, uint8, uint8){
        uint32[] memory card_status = CardOnBoards.getStatus(card_uid);
        for (uint i = 0; i < card_status.length; i++) {
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

    function GetTraitValue(bytes32 caster, CardTrait trait) internal view returns (int8){
        uint16[] memory traits = CardOnBoards.getTrait(caster);
        for (uint i = 0; i < traits.length; i++) {
            uint16 trait_data = traits[i];
            (uint8 trait_id,uint8 trait_value) = splitUint16(trait_data);
            if (trait == (CardTrait)(trait_id)) {
                return int8(trait_value);
            }
        }
        return 0;
    }

    function GetTrait(bytes32 caster, CardTrait trait) internal view returns (uint256, uint16){
        uint16[] memory traits = CardOnBoards.getTrait(caster);
        for (uint i = 0; i < traits.length; i++) {
            uint16 trait_data = traits[i];
            (uint8 trait_id,uint8 trait_value) = splitUint16(trait_data);
            if (trait == (CardTrait)(trait_id)) {
                return (i, trait_data);
            }
        }
        return (0, 0);
    }

    function SetTrait(bytes32 caster, CardTrait trait, uint8 value) internal {
//        uint16 trait_data = (uint16(uint8(trait)) << 8) | uint16(value);
        uint16 trait_data = combineUint16(uint8(trait), value);
        CardOnBoards.pushTrait(caster, trait_data);
    }

    function AddTrait(bytes32 caster, CardTrait trait, int8 value) internal {
        (uint256 trait_index, uint16 trait_data) = GetTrait(caster, trait);
        if (trait_data != 0) {
            (uint8 trait_id,uint8 trait_value) = splitUint16(trait_data);
            trait_value = trait_value + uint8(value);
            uint16 new_trait_data = combineUint16(trait_id, trait_value);
            CardOnBoards.updateTrait(caster, trait_index, new_trait_data);
        } else {
            SetTrait(caster, trait, (uint8)(value));
        }
    }

    function combineUint32(uint8 a, uint8 b, uint8 c, uint8 d) internal pure returns (uint32) {
        uint32 result = (uint32(a) << 24) | (uint32(b) << 16) | (uint32(c) << 8) | uint32(d);
        return result;
    }

    function combineUint16(uint8 a, uint8 b) public pure returns (uint16) {
        uint16 value = (uint16(a) << 8) | uint16(b);
        return value;
    }

    function splitUint16(uint16 value) public pure returns (uint8, uint8) {
        uint8 a = uint8((value >> 8) & 0xFF);
        uint8 b = uint8(value & 0xFF);
        return (a, b);
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

    function ReduceStatusDurations(bytes32 card_uid) internal {
        uint32[] memory status = CardOnBoards.getStatus(card_uid);
        for (uint i = 0; i < status.length; i++) {
            (uint8 status_id, uint8 duration, uint8 value,uint8 unuse) = splitUint32(status[i]);
            if (status_id != uint8(Status.None)) {
                duration -= 1;
                if (duration <= 0) {
                    RemoveStatus(card_uid, Status(status_id));
                } else {
                    uint32 status = combineUint32(status_id, duration, value, 0);
                    CardOnBoards.updateStatus(card_uid, i, status);
                }
            }
        }
    }

    function Refresh(bytes32 card_key) internal {
        CardOnBoards.setExhausted(card_key, false);
    }
}