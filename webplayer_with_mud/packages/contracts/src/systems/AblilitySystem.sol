// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {AbilityLib} from "../libs/AbilityLib.sol";

contract AblilitySystem is System {

    constructor() {

    }

    function DoEffects(bytes32 ability_key, bytes32 caster_key, bytes32 target_key) public {
        AbilityLib.DoEffects(ability_key, caster_key, target_key);
    }


}