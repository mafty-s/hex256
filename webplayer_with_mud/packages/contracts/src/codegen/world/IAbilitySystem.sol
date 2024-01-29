// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

import { AbilityTrigger } from "./../common.sol";

/**
 * @title IAbilitySystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IAbilitySystem {
  function UseAbility(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function TriggerCardAbilityType(AbilityTrigger trigger, bytes32 caster, bytes32 target, bool is_card) external;

  function TriggerCardAbility(bytes32 ability_key, bytes32 caster, bytes32 triggerer, bool is_card) external;

  function AreTriggerConditionsMet(bytes32 caster, bytes32 trigger_card) external pure returns (bool);
}
