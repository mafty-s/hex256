// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {FunctionSelectors} from "@latticexyz/world/src/codegen/tables/FunctionSelectors.sol";
import {ResourceId} from "@latticexyz/world/src/WorldResourceId.sol";
import {Condition, ConditionCardType, CardOnBoards, Cards, Games, GamesExtended, Players} from "../codegen/index.sol";
import {Status, ConditionStatType, CardType, CardTeam, ConditionPlayerType, PileType, CardTrait, ConditionOperatorInt, ConditionOperatorBool, ConditionTargetType} from "../codegen/common.sol";
import {IFilterSystem} from "../codegen/world/IFilterSystem.sol";

contract FilterSystem is System {

    constructor() {

    }
    function IsFilterFunctionExist(bytes4 selector) public view returns (bool){
        (ResourceId systemId, bytes4 systemFunctionSelector) = FunctionSelectors.get(selector);
        if (ResourceId.unwrap(systemId) == 0) {
            return false;
        }
        return true;
    }

    function FilterTargets(bytes4 filter, bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32[] memory source, ConditionTargetType condition_type) public returns (bytes32[] memory)
    {
        bytes memory call_data = abi.encodeWithSelector(filter, ability_key, caster, source, condition_type);
        bytes memory result_data = SystemSwitch.call(call_data);

        (bytes32[] memory dest) = abi.decode(result_data, (bytes32[]));
        return dest;
    }

    ////=========================


    function FilterLowestHp(bytes32 ability, bytes32 caster, bytes32[] memory source, ConditionTargetType condition_type) public view returns (bytes32[] memory) {
        return FilterLowestStat(ConditionStatType.HP, ability, caster, source, condition_type);
    }

    function FilterLowestAttack(bytes32 ability, bytes32 caster, bytes32[] memory source, ConditionTargetType condition_type) public view returns (bytes32[] memory) {
        return FilterLowestStat(ConditionStatType.Attack, ability, caster, source, condition_type);
    }

    function FilterRandom_1(bytes32 ability, bytes32 caster, bytes32[] memory source, ConditionTargetType condition_type) public view returns (bytes32[] memory) {
//        return source;
        return FilterRandom(1, ability, caster, source);
    }

    function FilterRandom_2(bytes32 ability, bytes32 caster, bytes32[] memory source, ConditionTargetType condition_type) public view returns (bytes32[] memory) {
        return FilterRandom(2, ability, caster, source);
    }

    function FilterRandom_3(bytes32 ability, bytes32 caster, bytes32[] memory source, ConditionTargetType condition_type) public view returns (bytes32[] memory) {
        return FilterRandom(2, ability, caster, source);
    }

    function FilterFirst_1(bytes32 ability, bytes32 caster, bytes32[] memory source, ConditionTargetType condition_type) public view returns (bytes32[] memory) {
        return FilterFirst(1, ability, caster, source);
    }

    function FilterFirst_6(bytes32 ability, bytes32 caster, bytes32[] memory source, ConditionTargetType condition_type) public view returns (bytes32[] memory) {
        return FilterFirst(6, ability, caster, source);
    }

    function FilterFirst_7(bytes32 ability, bytes32 caster, bytes32[] memory source, ConditionTargetType condition_type) public view returns (bytes32[] memory) {
        return FilterFirst(7, ability, caster, source);
    }

    ////=========================

    function FilterFirst(uint8 amount, bytes32 ability_key, bytes32 caster, bytes32[] memory source) internal pure returns (bytes32[] memory){
        if (source.length == 0) {
            return source;
        }
        uint min = source.length <= (uint)(amount) ? source.length : (uint)(amount);
        bytes32[] memory result = new bytes32[](min);
        for (uint i = 0; i < min; i++) {
            result[i] = source[i];
        }
        return result;
    }

    function FilterRandom(uint8 amount, bytes32 ability_key, bytes32 caster, bytes32[] memory source) internal view returns (bytes32[] memory){
        if (source.length == 0) {
            return source;
        }
        uint min = source.length <= (uint)(amount) ? source.length : (uint)(amount);
        source = shuffle(source);
        bytes32[] memory result = new bytes32[](min);
        for (uint i = 0; i < min; i++) {
            result[i] = source[i];
        }
        return result;
    }

    //找到属性最低的牌
    function FilterLowestStat(ConditionStatType stat_type, bytes32 ability, bytes32 caster, bytes32[] memory source, ConditionTargetType condition_type) internal view returns (bytes32[] memory){
//        return source;
        if (source.length == 0) {
            return source;
        }
        if (condition_type != ConditionTargetType.Card) {
            return source;
        }
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

    function FilterHighestStat(ConditionStatType stat_type, bytes32 ability, bytes32 caster, bytes32[] memory source, ConditionTargetType condition_type) internal view returns (bytes32[] memory){
        if (source.length == 0) {
            return source;
        }
        if (condition_type != ConditionTargetType.Card) {
            return source;
        }
        bytes32 result = 0;
        for (uint i = 0; i < source.length; i++) {
            if (result == 0) {
                result = source[i];
            } else {
                if (GetCardStat(source[i], stat_type) > GetCardStat(result, stat_type)) {
                    result = source[i];
                }
            }
        }

        bytes32[] memory dist = new bytes32[](1);
        dist[0] = result;
        return dist;
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

    function GetCardStat(bytes32 card, ConditionStatType stat_type) internal view returns (int8) {
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


}