// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

import { Slot } from "./../../libs/SlotLib.sol";

/**
 * @title IPlayCardSystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IPlayCardSystem {
  function PlayCard(bytes32 player_key, bytes32 card_key, Slot memory slot, bool skip_cost) external;

  function PayMana(bytes32 player_key, bytes32 card_key) external;
}
