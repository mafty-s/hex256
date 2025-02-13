// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

import { AbilityTarget } from "./../common.sol";

/**
 * @title IAbilityTargetSystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IAbilityTargetSystem {
  function GetPlayerTargets(
    bytes32 game_uid,
    bytes32 ability_key,
    AbilityTarget target,
    bytes32 caster
  ) external returns (bytes32[] memory);

  function GetCardTargets(
    bytes32 game_uid,
    bytes32 ability_key,
    AbilityTarget target,
    bytes32 caster
  ) external returns (bytes32[] memory);

  function GetSlotTargets(
    bytes32 game_uid,
    bytes32 ability_key,
    AbilityTarget target,
    bytes32 caster
  ) external returns (uint16[] memory);

  function GetCardDataTargets(
    bytes32 game_uid,
    bytes32 ability_key,
    AbilityTarget target,
    bytes32 caster
  ) external returns (bytes32[] memory);
}
