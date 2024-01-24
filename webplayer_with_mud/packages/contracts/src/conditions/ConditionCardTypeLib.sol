// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {Slot}  from "../libs/SlotLib.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {CardType, RarityType, PackType, AbilityTrigger, AbilityTarget} from "../codegen/common.sol";

library ConditionCardTypeLib {

    function IsTargetConditionMetCard(bytes32 game_uid, bytes32 ability, bytes32 caster, bytes32 target) internal {
        //todo
    }

    function IsTargetConditionMetPlayer(bytes32 game_uid, bytes32 ability, bytes32 caster, bytes32 player) internal pure returns (bool) {
        return false;
    }

    function IsTargetConditionMetSlot(bytes32 game_uid, bytes32 ability, bytes32 caster, Slot memory slot) internal pure returns (bool) {
        return false;
    }

    function IsTargetConditionMetCardConfig(bytes32 game_uid, bytes32 ability, bytes32 caster, bytes32 target) internal view returns (bool) {
        bool is_type = Cards.getCardType(target) == CardType.NONE;
        bool is_team = Cards.lengthTeam(target) == 0;

        return is_type && is_team;
    }


}