// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {IAbilitySystem} from "../codegen/world/IAbilitySystem.sol";
import {IPlayCardSystem} from "../codegen/world/IPlayCardSystem.sol";
import {Decks, Users, Cards, Ability, CardOnBoards} from "../codegen/index.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";


contract DebugSystem is System {

    function IsBoardCard(bytes32 key) public view returns (bool) {
        return CardLogicLib.IsBoardCard(key);
    }

    function IsEquipment(bytes32 key) public view returns (bool) {
        return CardLogicLib.IsEquipment(key);
    }

//    function TestCoinCard() public {
//        bytes32 card_config_key = 0x379e857b757fe42b9362aaf0320578c5478aaa53e6f499d323918ccf58e818e8;
//        bytes32 player_key = 0xffff857b757fe42b9362aaf0320578c5478aaa53e6f499d323918ccf58e8ffff;
//        CardsData memory card = Cards.get(card_config_key);
//
//
//        bytes32 on_board_card_key = keccak256(abi.encode(card_config_key, player_key, 0));
//        CardOnBoards.setId(on_board_card_key, card_config_key);
//        CardOnBoards.setHp(on_board_card_key, card.hp);
//        CardOnBoards.setAttack(on_board_card_key, card.attack);
//        CardOnBoards.setMana(on_board_card_key, card.mana);
//        CardOnBoards.setPlayerId(on_board_card_key, player_key);
//
//        bytes32 ability_key = card.abilities[0];
////        string memory ability_name = Ability.getId(ability_key);
//
//        SystemSwitch.call(
//            abi.encodeCall(IAbilitySystem.UseAbility, (ability_key, on_board_card_key, on_board_card_key, false))
//        );
//
//
//
//
//    }

}