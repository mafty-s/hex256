// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {Users, UsersData} from "../codegen/index.sol";

contract MarketSystem is System {


    function buyCard(string memory card_id) public {
        //        Cards card = CardsData.get(keccak256(abi.encode(card_id)));
        //Users user = UsersData.get(keccak256(abi.encode(msg.sender)));

        bytes32 user_key = keccak256(abi.encode(msg.sender));



        uint256 coin = Users.getCoin(user_key);
        Users.setCoin(user_key, coin - 100);
        Users.pushCards(user_key, 1);

        //user.coin = user.coin - card.cost;
        //todo
    }

    function buyPack(string memory pack_id) public {
        //todo
    }

}