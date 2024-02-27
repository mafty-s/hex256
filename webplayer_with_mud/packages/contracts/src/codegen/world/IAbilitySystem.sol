// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

import { AbilityTrigger } from "./../common.sol";

/**
 * @title IAbilitySystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IAbilitySystem {
  function TriggerCardAbilityType(
    AbilityTrigger trigger,
    bytes32 game_uid,
    bytes32 caster,
    bytes32 target,
    bool is_card
  ) external;

  function TriggerPlayerCardsAbilityType(AbilityTrigger trigger, bytes32 game_uid, bytes32 player_key) external;

  function TriggerPlayerSecrets(bytes32 caster, AbilityTrigger trigger) external;

  function TriggerCardAbility(
    bytes32 game_uid,
    bytes32 ability_key,
    bytes32 caster,
    bytes32 triggerer,
    bool is_card
  ) external;

  function UseAbility(bytes32 game_key, bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function ResolveEffectTarget(
    bytes32 game_uid,
    bytes32 ability_key,
    bytes32 caster,
    bytes32 target,
    bool is_card
  ) external;

  function AfterAbilityResolved(bytes32 game_uid, bytes32 ability_key, bytes32 caster) external;
}
