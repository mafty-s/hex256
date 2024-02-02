// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SlotLib, Slot} from "../libs/SlotLib.sol";

contract SlotSystem is System {

    function GetAllSlot(int8 p) public pure returns (Slot[] memory) {
        return SlotLib.GetAll(p);
    }

    function GetRandomEmptySlot(bytes32 player_key) public view returns(Slot memory){
        return SlotLib.GetRandomEmptySlot(player_key);
    }
}