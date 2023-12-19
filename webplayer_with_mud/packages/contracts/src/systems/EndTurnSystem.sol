// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {Packs, PacksData} from "../codegen/index.sol";
import {Decks, DecksData} from "../codegen/index.sol";
import {CardType, GameType, GameState, GamePhase, PackType, RarityType, AbilityTrigger} from "../codegen/common.sol";

import {AbilityLib} from "../libs/AbilityLib.sol";
import {BaseLogicLib} from "../libs/BaseLogicLib.sol";

contract EndTurnSystem is System {

    constructor() {

    }

    function EndTurn(bytes32 game_key) public {
        //todo
        
    }
}