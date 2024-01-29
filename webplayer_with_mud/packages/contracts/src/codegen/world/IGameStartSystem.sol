// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IGameStartSystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IGameStartSystem {
  function GameSetting(string memory game_uid) external;

  function PlayerSetting(
    string memory username,
    string memory game_uid,
    string memory desk_id,
    bool is_ai,
    int8 hp,
    int8 mana,
    uint8 dcards,
    bool need_shuffle
  ) external returns (bytes32[] memory);

  function getPlayerCards(
    bytes32 player_key
  )
    external
    view
    returns (
      string memory name,
      bytes32[] memory cards,
      bytes32[] memory hand,
      bytes32[] memory deck,
      bytes32[] memory board,
      int8 mana,
      int8 hp
    );
}
