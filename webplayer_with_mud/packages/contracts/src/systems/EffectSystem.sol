// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {ConditionTargetType} from "../codegen/common.sol";

contract EffectSystem is System {

    constructor() {

    }

    function DoEffect(bytes4 effect, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        bytes memory data = abi.encodeWithSelector(effect, ability_key, caster, target, is_card);
        SystemSwitch.call(data);
    }

//    function DoOngoingEffects(bytes4 effect_ongoing, bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
//        bytes memory data = abi.encodeWithSelector(effect_ongoing, ability_key, caster, target, is_card);
//        SystemSwitch.call(data);
//    }

}
