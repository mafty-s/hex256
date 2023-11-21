// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Decks, Users} from "../codegen/index.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";

contract DebugSystem is System {

    function IsBoardCard(bytes32 key) public view returns (bool) {
        return CardLogicLib.IsBoardCard(key);
    }

    function IsEquipment(bytes32 key) public view returns (bool) {
        return CardLogicLib.IsEquipment(key);
    }

}