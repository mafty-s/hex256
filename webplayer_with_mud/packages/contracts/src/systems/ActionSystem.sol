// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {PlayerActionHistory, ActionHistory, ActionHistoryData} from "../codegen/index.sol";

contract ActionSystem is System {

    constructor() {

    }

    function GetAction(bytes32 player_key) public view returns (uint256,ActionHistoryData memory){
        uint256 len = PlayerActionHistory.length(player_key);
        require(len > 0, "no action");
        bytes32 key = PlayerActionHistory.getItemValue(player_key, len - 1);
        return (len,ActionHistory.get(key));
    }
}