// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards} from "../codegen/index.sol";
import {Users} from "../codegen/index.sol";
import {CardRaritySingleton} from "../codegen/index.sol";
import {Packs, PacksData} from "../codegen/index.sol";
import {RarityType} from "../codegen/common.sol";

contract PacksSystem is System {

    constructor() {

    }

    function OpenPack(bytes32 key) public returns (bytes32[] memory){
        address user_key = _msgSender();
        bytes32[] memory res = new bytes32[](5);

        uint256 user_packs_length = Users.lengthPacks(user_key);
        bytes32[] memory user_packs = Users.getPacks(user_key);
        for (uint j = 0; j < user_packs_length; j++) {
            if (user_packs[j] == key) {
                Users.updatePacks(user_key, j, 0);

                uint8[] memory rarities = Packs.getRarities(key);
                for (uint i = 0; i < Packs.getCards(key); i++) {
                    RarityType rarity = getRandomRarity(rarities);
                    bytes32 card_key = getRandomCardByRarity(rarity, i);
                    res[i] = card_key;
                    Users.pushCards(user_key, card_key);
                }

            }
        }

        return res;
    }

    function getRandomCardByRarity(RarityType rarity, uint index) public view returns (bytes32) {

        if (rarity == RarityType.COMMON) {
            bytes32[] memory card_keys = CardRaritySingleton.getCommon();
            require(card_keys.length > 0, "No cards available");
            uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, index))) % card_keys.length;
            bytes32 selectedCard = card_keys[randomIndex];
            return selectedCard;
        }


        if (rarity == RarityType.UNCOMMON) {
            bytes32[] memory card_keys = CardRaritySingleton.getUncommon();
            require(card_keys.length > 0, "No cards available");
            uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, index))) % card_keys.length;
            bytes32 selectedCard = card_keys[randomIndex];
            return selectedCard;
        }


        if (rarity == RarityType.RARE) {
            bytes32[] memory card_keys = CardRaritySingleton.getRare();
            require(card_keys.length > 0, "No cards available");
            uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, index))) % card_keys.length;
            bytes32 selectedCard = card_keys[randomIndex];
            return selectedCard;
        }


        if (rarity == RarityType.MYTHIC) {
            bytes32[] memory card_keys = CardRaritySingleton.getMythic();
            require(card_keys.length > 0, "No cards available");
            uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, index))) % card_keys.length;
            bytes32 selectedCard = card_keys[randomIndex];
            return selectedCard;
        }

        revert("Unknown rarity");
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