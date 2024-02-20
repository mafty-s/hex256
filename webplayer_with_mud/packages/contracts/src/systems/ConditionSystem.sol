// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Condition, ConditionCardType, CardOnBoards} from "../codegen/index.sol";
import {ConditionCardTypeLib} from "../conditions/ConditionCardTypeLib.sol";
import {ConditionObjType, ConditionStatType} from "../codegen/common.sol";


contract ConditionSystem is System {

    constructor() {

    }

    function SetConditionCardTypeConfig(string memory name, string memory team, string memory has_type, string memory has_trait) public {
        bytes32 key = keccak256(abi.encode(name));
        ConditionCardType.setName(key, name);
        ConditionCardType.setHasType(key, has_type);
        ConditionCardType.setHasTrait(key, has_trait);
        Condition.setName(key, name);
        Condition.setObjType(key, ConditionObjType.ConditionCardType);
    }

    function FilterLowestHp(bytes32 ability, bytes32 caster, bytes32[] memory source) public returns (bytes32[] memory) {
        return FilterLowestStat(ConditionStatType.HP, ability, caster, source);
    }

    function FilterLowestAttack(bytes32 ability, bytes32 caster, bytes32[] memory source) public returns (bytes32[] memory) {
        return FilterLowestStat(ConditionStatType.Attack, ability, caster, source);
    }

    function FilterRandom1(bytes32 ability, bytes32 caster, bytes32[] memory source) public returns (bytes32[] memory) {
        return FilterRandom(1, ability, caster, source);
    }

    function FilterRandom2(bytes32 ability, bytes32 caster, bytes32[] memory source) public returns (bytes32[] memory) {
        return FilterRandom(2, ability, caster, source);
    }

    function FilterRandom3(bytes32 ability, bytes32 caster, bytes32[] memory source) public returns (bytes32[] memory) {
        return FilterRandom(2, ability, caster, source);
    }

    function FilterFirst1(bytes32 ability, bytes32 caster, bytes32[] memory source) public returns (bytes32[] memory) {
        return FilterFirst(1, ability, caster, source);
    }

    function FilterFirst6(bytes32 ability, bytes32 caster, bytes32[] memory source) public returns (bytes32[] memory) {
        return FilterFirst(6, ability, caster, source);
    }

    function FilterFirst7(bytes32 ability, bytes32 caster, bytes32[] memory source) public returns (bytes32[] memory) {
        return FilterFirst(7, ability, caster, source);
    }

    //================================================================================

    function FilterFirst(uint8 amount, bytes32 ability_key, bytes32 caster, bytes32[] memory source) public returns (bytes32[] memory){
        bytes32[] memory result = new bytes32[](amount);
        for (uint i = 0; i < amount; i++) {
            result[i] = source[i];
        }
        return result;
    }

    function FilterRandom(uint8 amount, bytes32 ability_key, bytes32 caster, bytes32[] memory source) public returns (bytes32[] memory){
        source = shuffle(source);
        bytes32[] memory result = new bytes32[](amount);
        for (uint i = 0; i < amount; i++) {
            result[i] = source[i];
        }
        return result;
    }

    //找到属性最低的牌
    function FilterLowestStat(ConditionStatType stat_type, bytes32 ability, bytes32 caster, bytes32[] memory source) internal returns (bytes32[] memory){
        bytes32 result = 0;
        for (uint i = 0; i < source.length; i++) {
            if (result == 0) {
                result = source[i];
            } else {
                if (GetCardStat(source[i], stat_type) < GetCardStat(result, stat_type)) {
                    result = source[i];
                }
            }
        }

        bytes32[] memory dist = new bytes32[](1);
        dist[0] = result;
        return dist;
    }

    function GetCardStat(bytes32 card, ConditionStatType stat_type) internal returns (int8) {
        if (stat_type == ConditionStatType.HP) {
            return CardOnBoards.getHp(card);
        }
        if (stat_type == ConditionStatType.Attack) {
            return CardOnBoards.getAttack(card);
        }
        if (stat_type == ConditionStatType.Mana) {
            return CardOnBoards.getMana(card);
        }
        revert("unknown stat type");
    }


    function shuffle(bytes32[] memory array) internal view returns (bytes32[] memory) {
        uint256 arrSize = array.length;
        bytes32[] memory shuffled = new bytes32[](arrSize);

        // Copy the original deck to the shuffled deck array
        for (uint256 i = 0; i < arrSize; i++) {
            shuffled[i] = array[i];
        }

        // Shuffle the deck using Fisher-Yates algorithm
        for (uint256 i = arrSize - 1; i > 0; i--) {
            uint256 j = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, i))) % (i + 1);
            bytes32 temp = shuffled[i];
            shuffled[i] = shuffled[j];
            shuffled[j] = temp;
        }

        return shuffled;
    }

}