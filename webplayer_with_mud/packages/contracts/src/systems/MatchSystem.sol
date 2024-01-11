// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {MatchingSingleton,Matches,MatchesData} from "../codegen/index.sol";


contract MatchSystem is System {

    function StartMatchmaking(string memory game_uid, uint256 nplayer ) public {
        bytes32 matching = MatchingSingleton.getValue();
        if(matching == bytes32(0)){
//            MatchingSingleton.setValue(game_uid);
        }
    }
}