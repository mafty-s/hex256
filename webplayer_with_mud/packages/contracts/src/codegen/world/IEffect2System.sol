// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

import { ConditionTargetType } from "./../common.sol";

/**
 * @title IEffect2System
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IEffect2System {
  function EffectSummonEagle(
    bytes32 game_uid,
    bytes32 ability_key,
    bytes32 caster,
    bytes32 target,
    ConditionTargetType is_card
  ) external;

  function EffectSummonEgg(
    bytes32 game_uid,
    bytes32 ability_key,
    bytes32 caster,
    bytes32 target,
    ConditionTargetType is_card
  ) external;

  function EffectSummonWolf(
    bytes32 game_uid,
    bytes32 ability_key,
    bytes32 caster,
    bytes32 target,
    ConditionTargetType is_card
  ) external;

  function EffectTransformFish(
    bytes32 game_uid,
    bytes32 ability_key,
    bytes32 caster,
    bytes32 target,
    ConditionTargetType is_card
  ) external;

  function EffectTransformPhoenix(
    bytes32 game_uid,
    bytes32 ability_key,
    bytes32 caster,
    bytes32 target,
    ConditionTargetType is_card
  ) external;

  function EffectSendDeck(
    bytes32 game_uid,
    bytes32 ability_key,
    bytes32 caster,
    bytes32 target,
    ConditionTargetType is_card
  ) external;

  function EffectSendHand(
    bytes32 game_uid,
    bytes32 ability_key,
    bytes32 caster,
    bytes32 target,
    ConditionTargetType is_card
  ) external;

  function EffectShuffleDeck(
    bytes32 game_uid,
    bytes32 ability_key,
    bytes32 caster,
    bytes32 target,
    ConditionTargetType is_card
  ) external;

  function EffectClearTemp(
    bytes32 game_uid,
    bytes32 ability_key,
    bytes32 caster,
    bytes32 target,
    ConditionTargetType is_card
  ) external;

  function EffectCreateTemp(
    bytes32 game_uid,
    bytes32 ability_key,
    bytes32 caster,
    bytes32 target,
    ConditionTargetType is_card
  ) external;
}
