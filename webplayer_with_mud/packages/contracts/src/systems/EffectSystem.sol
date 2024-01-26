// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {CounterSingleton} from "../codegen/index.sol";

contract EffectSystem is System {

    constructor() {

    }

    function gain_mana(bytes32 ability_key, bytes32 target) public returns (bool){
        CounterSingleton.setValue(CounterSingleton.getValue() + 1);
        return true;
    }


}
