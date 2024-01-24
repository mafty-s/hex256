// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {Slot}  from "../libs/SlotLib.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {ConditionObjType} from "../codegen/common.sol";
import {ConditionCardTypeLib} from "./ConditionCardTypeLib.sol";

library ConditionLib {

    function IsTargetConditionMetCard(bytes32 game_uid, bytes32 ability, bytes32 caster, bytes32 target) internal {
        //todo
    }

    function IsTargetConditionMetPlayer(bytes32 game_uid, bytes32 ability, bytes32 caster, bytes32 player) internal pure returns (bool) {
        return false;
    }

    function IsTargetConditionMetSlot(bytes32 game_uid, bytes32 ability, bytes32 caster, Slot memory slot) internal pure returns (bool) {
        return false;
    }

    function IsTargetConditionMetCardConfig(ConditionObjType conditionObjType, bytes32 game_uid, bytes32 ability, bytes32 caster, bytes32 target) internal view returns (bool) {
        if (conditionObjType == ConditionObjType.ConditionCardType) {
            return ConditionCardTypeLib.IsTargetConditionMetCardConfig(game_uid, ability, caster, target);
        }
        revert("unknown ConditionObjType");
    }


}