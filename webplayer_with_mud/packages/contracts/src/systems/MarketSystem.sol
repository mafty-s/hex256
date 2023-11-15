// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {Users, UsersData} from "../codegen/index.sol";

contract MarketSystem is System {


    function buyCard(string memory card_id, uint8 quantity) public {
        bytes32 user_key = keccak256(abi.encode(_msgSender()));
        bytes32 card_key = keccak256(abi.encode(card_id));

        uint32 cost = Cards.getCost(card_key);
        uint256 coin = Users.getCoin(user_key);
        Users.setCoin(user_key, coin - cost * quantity);
        Users.pushCards(user_key, card_key);

        //user.coin = user.coin - card.cost;
        //todo
    }

    function buyPack(string memory pack_id) public {
        //todo
    }

}