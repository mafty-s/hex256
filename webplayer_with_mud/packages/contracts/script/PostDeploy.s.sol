// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {StoreSwitch} from "@latticexyz/store/src/StoreSwitch.sol";

import {IWorld} from "../src/codegen/world/IWorld.sol";

import {Decks, Ability, AbilityExtend} from "../src/codegen/index.sol";

contract PostDeploy is Script {
    function run(address worldAddress) external {
        // Specify a store so that you can use tables directly in PostDeploy
        StoreSwitch.setStoreAddress(worldAddress);

//         Load the private key from the `PRIVATE_KEY` environment variable (in .env)
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

//         Start broadcasting transactions from the deployer account
        vm.startBroadcast(deployerPrivateKey);

//        bytes32[] memory a = new bytes32[](1);
//
//
//        IWorld(worldAddress).initDeck("", bytes32(0), a);

        vm.stopBroadcast();
    }


}
