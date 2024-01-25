// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Condition, ConditionCardType} from "../codegen/index.sol";
import {ConditionCardTypeLib} from "../conditions/ConditionCardTypeLib.sol";
import {ConditionObjType} from "../codegen/common.sol";


contract ConditionSystem is System {

    constructor() {

    }

    function SetConditionCardTypeConfig(string memory name, string memory team, string memory has_type, string memory has_trait) public {
        bytes32 key = keccak256(abi.encode(name));
        ConditionCardType.setName(key, name);
        ConditionCardType.setHasType(key, has_type);
        ConditionCardType.setHasTrait(key, has_trait);
        Condition.setName(key, name);
        Condition.setObjType(key, ConditionObjType.ConditionCardType);
    }

}