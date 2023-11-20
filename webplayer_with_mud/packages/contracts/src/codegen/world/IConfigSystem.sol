// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

import { CardType, RarityType, PackType, AbilityTrigger, AbilityTarget } from "./../common.sol";
import { CardsData } from "./../index.sol";

/**
 * @title IConfigSystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IConfigSystem {
  function initCard(
    string memory name,
    uint8 mana,
    uint8 attack,
    uint8 hp,
    uint32 cost,
    bytes32[] memory abilities,
    CardType cardType,
    RarityType rarity
  ) external returns (bytes32 key);

  function getCard(string memory id) external view returns (CardsData memory _table);

  function setCard(string memory id, CardsData calldata data) external;

  function initPack(
    string memory name,
    PackType _packType,
    uint8 _cards,
    uint8[] memory _rarities,
    uint32 _cost
  ) external returns (bytes32 key);

  function initDeck(string memory name, bytes32 hero, bytes32[] memory _cards) external returns (bytes32 key);

  function initAbility(
    string memory id,
    AbilityTrigger trigger,
    AbilityTarget target,
    uint8 value,
    uint8 manaCost,
    uint8 duration,
    bool exhaust,
    bytes32[] memory effects
  ) external returns (bytes32 key);
}
