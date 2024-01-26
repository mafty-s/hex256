// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {Decks, Users, CardsData, Cards, Ability} from "../codegen/index.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {EffectLib} from "../libs/EffectLib.sol";
import {IWorld} from "../codegen/world/IWorld.sol";
import {IEffectSystem} from "../codegen/world/IEffectSystem.sol";
import {IDebugSystem} from "../codegen/world/IDebugSystem.sol";

contract DebugSystem is System {

    function IsBoardCard(bytes32 key) public view returns (bool) {
        return CardLogicLib.IsBoardCard(key);
    }

    function IsEquipment(bytes32 key) public view returns (bool) {
        return CardLogicLib.IsEquipment(key);
    }

    function TestCoinCard() public returns (address, bool, bytes4){
//        bytes32 card_config_key = 0x379e857b757fe42b9362aaf0320578c5478aaa53e6f499d323918ccf58e818e8;
//        CardsData memory card_data = Cards.get(card_config_key);
//        bytes32 ability_key = card_data.abilities[0];
//        string memory ability_name = Ability.getId(ability_key);
//        EffectLib.test(ability_key, card_config_key);
//        (bool success,) = address(this).call(abi.encodeWithSelector(IDebugSystem.TestPure.selector));

        bool success = abi.decode(
            SystemSwitch.call(
                abi.encodeCall(IDebugSystem.TestPure, ())
            ),
            (bool)
        );

        return (address(this), success, IDebugSystem.TestPure.selector);
    }

    function TestPure() public pure returns (bool){
        return true;
    }
}