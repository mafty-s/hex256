// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {Users, UsersData} from "../codegen/index.sol";
import {CardCommonSingleton} from "../codegen/index.sol";
import {Packs, PacksData} from "../codegen/index.sol";
import {RarityType} from "../codegen/common.sol";

contract PacksSystem is System {

    constructor() {

    }

    function OpenPack(bytes32 key) public returns (bytes32[] memory){
        bytes32[] memory res = new bytes32[](5);
        bytes32 user_key = keccak256(abi.encode(_msgSender()));
        uint8 cards = Packs.getCards(key);
        uint8[] memory rarities = Packs.getRarities(key);
        for (uint i = 0; i < cards; i++) {
            RarityType rarity = getRandomRarity(rarities);
            bytes32 card_key = getRandomCardByRarity(rarity,i);
            res[i] = card_key;
            Users.pushCards(user_key, card_key);
        }
        return res;
    }

    function getRandomCardByRarity(RarityType rarity, uint index) public view returns (bytes32) {

        if (rarity == RarityType.COMMON) {
            //todo
        }

        bytes32[] memory card_keys = CardCommonSingleton.getValue();
        require(card_keys.length > 0, "No cards available");
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, index))) % card_keys.length;
        bytes32 selectedCard = card_keys[randomIndex];
        return selectedCard;
    }


    function getRandomRarity(uint8[] memory rarities) public view returns (RarityType) {
        uint256 totalWeight = 0;
        for (uint8 i = 0; i < rarities.length; i++) {
            totalWeight += rarities[i];
        }

        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao))) % totalWeight;

        uint256 cumulativeWeight = 0;
        for (uint8 i = 0; i < rarities.length; i++) {
            cumulativeWeight += rarities[i];
            if (randomNumber < cumulativeWeight) {
                return RarityType(i);
            }
        }

        revert("Random index calculation error");
    }
}