// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";

import { IAblilitySystem } from "./IAblilitySystem.sol";
import { IActionSystem } from "./IActionSystem.sol";
import { IAttackSystem } from "./IAttackSystem.sol";
import { IConfigSystem } from "./IConfigSystem.sol";
import { ICounterSystem } from "./ICounterSystem.sol";
import { IDebugSystem } from "./IDebugSystem.sol";
import { IDeckSystem } from "./IDeckSystem.sol";
import { IEndTurnSystem } from "./IEndTurnSystem.sol";
import { IGameStartSystem } from "./IGameStartSystem.sol";
import { IMarketSystem } from "./IMarketSystem.sol";
import { IMatchSystem } from "./IMatchSystem.sol";
import { IMoveSystem } from "./IMoveSystem.sol";
import { IPacksSystem } from "./IPacksSystem.sol";
import { IPlayCardSystem } from "./IPlayCardSystem.sol";
import { ISelectSystem } from "./ISelectSystem.sol";
import { ITasksSystem } from "./ITasksSystem.sol";
import { IUsersSystem } from "./IUsersSystem.sol";

/**
 * @title IWorld
 * @notice This interface integrates all systems and associated function selectors
 * that are dynamically registered in the World during deployment.
 * @dev This is an autogenerated file; do not edit manually.
 */
interface IWorld is
  IBaseWorld,
  IAblilitySystem,
  IActionSystem,
  IAttackSystem,
  IConfigSystem,
  ICounterSystem,
  IDebugSystem,
  IDeckSystem,
  IEndTurnSystem,
  IGameStartSystem,
  IMarketSystem,
  IMatchSystem,
  IMoveSystem,
  IPacksSystem,
  IPlayCardSystem,
  ISelectSystem,
  ITasksSystem,
  IUsersSystem
{

}
