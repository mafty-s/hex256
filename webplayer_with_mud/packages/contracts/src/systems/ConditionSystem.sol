// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {Condition, ConditionCardType, CardOnBoards, Games} from "../codegen/index.sol";
import {Status, ConditionObjType, ConditionStatType, CardType, CardTeam, ConditionPlayerType, PileType, CardTrait, ConditionOperatorInt, ConditionOperatorBool, ConditionTargetType} from "../codegen/common.sol";
import {CardPosLogicLib} from "../libs/CardPosLogicLib.sol";

contract ConditionSystem is System {

    constructor() {

    }

    function IsTargetConditionMet(bytes32 game_uid, bytes32 ability, bytes32 caster)
    {

    }

    function IsTargetConditionMetCard(bytes32 game_uid, bytes32 ability, bytes32 caster, bytes32 target)
    {

    }

    function IsTargetConditionMetPlayer(bytes32 game_uid, bytes32 ability, bytes32 caster, bytes32 target)
    {

    }

    function IsTargetConditionMetSlot(bytes32 game_uid, bytes32 ability, bytes32 caster, uint16 target)
    {

    }

////=========================

//
//    function SetConditionCardTypeConfig(string memory name, string memory team, string memory has_type, string memory has_trait) public {
//        bytes32 key = keccak256(abi.encode(name));
//        ConditionCardType.setName(key, name);
//        ConditionCardType.setHasType(key, has_type);
//        ConditionCardType.setHasTrait(key, has_trait);
//        Condition.setName(key, name);
//        Condition.setObjType(key, ConditionObjType.ConditionCardType);
//    }

    function FilterTargets(bytes32 ability, bytes32 caster, bytes32[] memory source) public returns (bytes32[] memory) {
        //todo
        return source;
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

    //(Game data, AbilityData ability, Card caster, CardData target)
//{
//bool is_type = target.type == has_type || has_type == CardType.None;
//bool is_team = target.team == has_team || has_team == null;
//bool is_trait = target.HasTrait(has_trait) || has_trait == null;
//return (is_type && is_team && is_trait);

    function HasBoardCardEnemy() public {
        //todo
    }

    function HasBoardCardSelf() public {
        //todo
    }

    function HasBoardCharacters2() public {
        //todo
    }

    function HasDiscardSpell() public {
        //todo
    }

    function IsAlly() public {
        //todo
    }

    function IsArtifact(bytes32 ability_key, bytes32 caster, bytes32 target) public returns (bool){
        return ConditionCardType(CardType.Artifact, CardTeam.None, CardTrait.None, ability_key, caster, target);
    }

    function IsSpell(bytes32 ability_key, bytes32 caster, bytes32 target) public returns (bool){
        return ConditionCardType(CardType.Spell, CardTeam.None, CardTrait.None, ability_key, caster, target);
    }

    function IsEquipment(bytes32 ability_key, bytes32 caster, bytes32 target) public returns (bool){
        return ConditionCardType(CardType.Equipment, CardTeam.None, CardTrait.None, ability_key, caster, target);
    }

    function IsCharacter(bytes32 ability_key, bytes32 caster, bytes32 target) public returns (bool){
        return ConditionCardType(CardType.Character, CardTeam.None, CardTrait.None, ability_key, caster, target);
    }

    function IsHero(bytes32 ability_key, bytes32 caster, bytes32 target) public returns (bool){
        return ConditionCardType(CardType.Hero, CardTeam.None, CardTrait.None, ability_key, caster, target);
    }

    function IsSlot() public {
        //todo
    }

    function IsSlotX1() public {
        //todo

    }

    function IsSlotSameP() public {
        //todo

    }

    function IsSlotNextTo() public {
        //todo

    }

    function IsSlotInRange() public {
        //todo

    }

    function IsSlotEmpty() public {
        //todo

    }

    function IsPlayer() public {
        //todo

    }

    function IsAI() public {
        //todo

    }

    function IsWolf(bytes32 ability_key, bytes32 caster, bytes32 target) public returns (bool){
        return ConditionCardType(CardType.None, CardTeam.None, CardTrait.Wolf, ability_key, caster, target);
    }

    function IsDragon(bytes32 ability_key, bytes32 caster, bytes32 target) public returns (bool){
        return ConditionCardType(CardType.None, CardTeam.None, CardTrait.Dragon, ability_key, caster, target);
    }

    function IsGreen(bytes32 ability_key, bytes32 caster, bytes32 target) public returns (bool){
        return ConditionCardType(CardType.None, CardTeam.Green, CardTrait.None, ability_key, caster, target);
    }

    function IsRed(bytes32 ability_key, bytes32 caster, bytes32 target) public returns (bool){
        return ConditionCardType(CardType.None, CardTeam.Red, CardTrait.None, ability_key, caster, target);
    }

    function IsBlue(bytes32 ability_key, bytes32 caster, bytes32 target) public returns (bool){
        return ConditionCardType(CardType.None, CardTeam.Blue, CardTrait.None, ability_key, caster, target);
    }

    function IsAttackL4(bytes32 ability_key, bytes32 caster, bytes32 target) public returns (bool){
        return ConditionStat(ConditionStatType.Attack, ConditionOperatorInt.LessEqual, 4, ability_key, caster, target);
    }

    //=======================================//=======================================//=======================================

    function ConditionCardType(CardType has_type, CardTeam has_team, CardTrait has_trait, bytes32 ability_key, bytes32 caster, bytes32 target) internal returns (bool){
        bytes32 card_config_id = CardOnBoards.getId(target);
        bool is_type = has_type == CardType.None;
        bool is_team = has_team == CardTeam.None;
        bool is_trait = has_trait == CardTrait.None;
        return (is_type && is_team && is_trait);
    }

    function ConditionCount(ConditionPlayerType target, PileType pile, ConditionOperatorInt oper, CardType has_type, CardTeam has_team, int8 value) internal returns (bool)
    {
        int8 count = 0;

        if (target == ConditionPlayerType.Self || target == ConditionPlayerType.Both)
        {
//            Player player =  data.GetPlayer(caster.player_id);
//            count += CountPile(player, pile);
        }
        if (target == ConditionPlayerType.Opponent || target == ConditionPlayerType.Both)
        {
//            Player player = data.GetOpponentPlayer(caster.player_id);
//            count += CountPile(player, pile);
        }
        return CompareInt(count, oper, value);

    }

    function ConditionDeckbuilding() internal {
        //todo

    }

    function ConditionExhaust(ConditionOperatorBool oper) internal {
        //todo

    }

    function ConditionOnce() internal {
        //todo

    }

    function ConditionOwner() internal {
        //todo

    }

    function ConditionSlotDist(uint8 distance, bool diagonals) public {
        //todo

    }

    function ConditionTurn(ConditionOperatorBool oper, bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target) internal returns (bool){
//        bool yourturn = caster.player_id == data.current_player;
//        return CompareBool(yourturn, oper);
        //todo
        return false;
    }

    function ConditionStatus(Status has_status, int8 value, ConditionOperatorBool oper, bytes32 ability_key, bytes32 caster, bytes32 target) internal returns (bool){
//        bool hstatus = target.HasStatus(has_status) && target.GetStatusValue(has_status) >= value;

        //todo
        return false;
    }

    function ConditionOwnerAI() internal {

    }

    function ConditionPlayerStat() internal {

    }

    function ConditionCardPile(PileType pile_type, ConditionOperatorBool oper, bytes32 ability_key, bytes32 caster, bytes32 target) internal returns (bool){
        if (target == 0) {
            return false;
        }
        if (pile_type == PileType.Hand) {
            return CompareBool(CardPosLogicLib.IsInHand(target), oper);
        }

        if (pile_type == PileType.Board) {
            return CompareBool(CardPosLogicLib.IsOnBoard(target), oper);
        }

        if (pile_type == PileType.Deck) {
            return CompareBool(CardPosLogicLib.IsInDeck(target), oper);
        }

        if (pile_type == PileType.Discard) {
            return CompareBool(CardPosLogicLib.IsInDiscard(target), oper);
        }

        if (pile_type == PileType.Secret) {
            return CompareBool(CardPosLogicLib.IsInSecret(target), oper);
        }

        if (pile_type == PileType.Temp) {
            return CompareBool(CardPosLogicLib.IsInTemp(target), oper);
        }

        return false;
    }

    function ConditionStat(ConditionStatType stat_type, ConditionOperatorInt oper, int8 value, bytes32 ability_key, bytes32 caster, bytes32 target) internal returns (bool) {
        if (stat_type == ConditionStatType.Attack)
        {
            return CompareInt(CardOnBoards.getAttack(target), oper, value);
        }

        if (stat_type == ConditionStatType.HP)
        {
            return CompareInt(CardOnBoards.getHp(target), oper, value);
        }

        if (stat_type == ConditionStatType.Mana)
        {
            return CompareInt(CardOnBoards.getMana(target), oper, value);
        }

        return false;
    }

    function CompareBool(bool condition, ConditionOperatorBool oper) public returns (bool)
    {
        if (oper == ConditionOperatorBool.IsFalse)
            return !condition;
        return condition;
    }


    function CompareInt(int8 ival1, ConditionOperatorInt oper, int8 ival2) public returns (bool){
        if (oper == ConditionOperatorInt.Equal)
        {
            return ival1 == ival2;
        }
        if (oper == ConditionOperatorInt.NotEqual)
        {
            return ival1 != ival2;
        }
        if (oper == ConditionOperatorInt.GreaterEqual)
        {
            return ival1 >= ival2;
        }
        if (oper == ConditionOperatorInt.LessEqual)
        {
            return ival1 <= ival2;
        }
        if (oper == ConditionOperatorInt.Greater)
        {
            return ival1 > ival2;
        }
        if (oper == ConditionOperatorInt.Less)
        {
            return ival1 < ival2;
        }
        return false;
    }


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

    function FilterHighestStat(ConditionStatType stat_type, bytes32 ability, bytes32 caster, bytes32[] memory source) internal returns (bytes32[] memory){
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