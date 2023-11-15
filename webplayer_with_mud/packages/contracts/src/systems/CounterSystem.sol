// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {CounterSingleton, CounterSingletonTableId} from "../codegen/index.sol";

contract CounterSystem is System {

    constructor() {

    }

    function incr() public returns (uint256 res) {
        CounterSingleton.setValue(CounterSingleton.getValue() + 1);
        res = CounterSingleton.getValue();
    }

}