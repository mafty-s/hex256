// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {PlayerActionHistory, ActionHistory, ActionHistoryData} from "../codegen/index.sol";

contract ActionSystem is System {

    constructor() {

    }

    function GetAction(bytes32 game_key, uint256 i) public view returns (uint256,ActionHistoryData memory){
        uint256 len = PlayerActionHistory.length(game_key);
        bytes32 key = PlayerActionHistory.getItemValue(game_key, i);
        return (len,ActionHistory.get(key));
    }
}