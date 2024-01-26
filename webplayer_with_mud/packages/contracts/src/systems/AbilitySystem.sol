// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {IEffectSystem} from "../codegen/world/IEffectSystem.sol";
import {Ability} from "../codegen/index.sol";

contract AbilitySystem is System {

    constructor() {

    }

    function UseAbility(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        bytes4[] memory effects = Ability.getEffects(ability_key);
        for (uint i = 0; i < effects.length; i++) {
            SystemSwitch.call(
                abi.encodeCall(IEffectSystem.DoEffect, (effects[i], ability_key, caster, target, is_card))
            );
        }
    }


}