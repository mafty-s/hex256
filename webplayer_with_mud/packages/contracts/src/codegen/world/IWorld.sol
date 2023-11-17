// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";

import { IAttackSystem } from "./IAttackSystem.sol";
import { IConfigSystem } from "./IConfigSystem.sol";
import { ICounterSystem } from "./ICounterSystem.sol";
import { IGameStartSystem } from "./IGameStartSystem.sol";
import { IMarketSystem } from "./IMarketSystem.sol";
import { IMoveSystem } from "./IMoveSystem.sol";
import { IPacksSystem } from "./IPacksSystem.sol";
import { IPlayCardSystem } from "./IPlayCardSystem.sol";
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
  IAttackSystem,
  IConfigSystem,
  ICounterSystem,
  IGameStartSystem,
  IMarketSystem,
  IMoveSystem,
  IPacksSystem,
  IPlayCardSystem,
  ITasksSystem,
  IUsersSystem
{

}
