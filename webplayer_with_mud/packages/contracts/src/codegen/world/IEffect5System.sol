// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

import { ConditionTargetType } from "./../common.sol";

/**
 * @title IEffect5System
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IEffect5System {
  function EffectRollD6(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) external;

  function EffectAddAttackRoll(
    bytes32 ability_key,
    bytes32 caster,
    bytes32 target,
    ConditionTargetType is_card
  ) external;
}
