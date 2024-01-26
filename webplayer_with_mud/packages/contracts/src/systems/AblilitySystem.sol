// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
//import {AbilityLib} from "../libs/AbilityLib.sol";
import {EffectLib} from "../libs/EffectLib.sol";

contract AblilitySystem is System {

    constructor() {

    }

    function DoEffects(bytes32 ability_key, bytes32 caster_key, bytes32 target_key) public {
        bytes4 selector = 0x3f9d84e9;
        (bool success,) = address(this).call(abi.encodeWithSelector(selector, ability_key, caster_key));

    }


}