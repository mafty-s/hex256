// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

// Import schema type
import { SchemaType } from "@latticexyz/schema-type/src/solidity/SchemaType.sol";

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { FieldLayout, FieldLayoutLib } from "@latticexyz/store/src/FieldLayout.sol";
import { Schema, SchemaLib } from "@latticexyz/store/src/Schema.sol";
import { PackedCounter, PackedCounterLib } from "@latticexyz/store/src/PackedCounter.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";
import { RESOURCE_TABLE, RESOURCE_OFFCHAIN_TABLE } from "@latticexyz/store/src/storeResourceTypes.sol";

// Import user types
import { CardType, CardTeam, CardTrait } from "./../common.sol";

ResourceId constant _tableId = ResourceId.wrap(
  bytes32(abi.encodePacked(RESOURCE_TABLE, bytes14(""), bytes16("Cards")))
);
ResourceId constant CardsTableId = _tableId;

FieldLayout constant _fieldLayout = FieldLayout.wrap(
  0x0007070201010101010101000000000000000000000000000000000000000000
);

struct CardsData {
  int8 mana;
  int8 attack;
  int8 hp;
  CardType cardType;
  CardTeam team;
  CardTrait trait;
  bool deckbuilding;
  string tid;
  bytes32[] abilities;
}

library Cards {
  /**
   * @notice Get the table values' field layout.
   * @return _fieldLayout The field layout for the table.
   */
  function getFieldLayout() internal pure returns (FieldLayout) {
    return _fieldLayout;
  }

  /**
   * @notice Get the table's key schema.
   * @return _keySchema The key schema for the table.
   */
  function getKeySchema() internal pure returns (Schema) {
    SchemaType[] memory _keySchema = new SchemaType[](1);
    _keySchema[0] = SchemaType.BYTES32;

    return SchemaLib.encode(_keySchema);
  }

  /**
   * @notice Get the table's value schema.
   * @return _valueSchema The value schema for the table.
   */
  function getValueSchema() internal pure returns (Schema) {
    SchemaType[] memory _valueSchema = new SchemaType[](9);
    _valueSchema[0] = SchemaType.INT8;
    _valueSchema[1] = SchemaType.INT8;
    _valueSchema[2] = SchemaType.INT8;
    _valueSchema[3] = SchemaType.UINT8;
    _valueSchema[4] = SchemaType.UINT8;
    _valueSchema[5] = SchemaType.UINT8;
    _valueSchema[6] = SchemaType.BOOL;
    _valueSchema[7] = SchemaType.STRING;
    _valueSchema[8] = SchemaType.BYTES32_ARRAY;

    return SchemaLib.encode(_valueSchema);
  }

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](1);
    keyNames[0] = "key";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](9);
    fieldNames[0] = "mana";
    fieldNames[1] = "attack";
    fieldNames[2] = "hp";
    fieldNames[3] = "cardType";
    fieldNames[4] = "team";
    fieldNames[5] = "trait";
    fieldNames[6] = "deckbuilding";
    fieldNames[7] = "tid";
    fieldNames[8] = "abilities";
  }

  /**
   * @notice Register the table with its config.
   */
  function register() internal {
    StoreSwitch.registerTable(_tableId, _fieldLayout, getKeySchema(), getValueSchema(), getKeyNames(), getFieldNames());
  }

  /**
   * @notice Register the table with its config.
   */
  function _register() internal {
    StoreCore.registerTable(_tableId, _fieldLayout, getKeySchema(), getValueSchema(), getKeyNames(), getFieldNames());
  }

  /**
   * @notice Get mana.
   */
  function getMana(bytes32 key) internal view returns (int8 mana) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (int8(uint8(bytes1(_blob))));
  }

  /**
   * @notice Get mana.
   */
  function _getMana(bytes32 key) internal view returns (int8 mana) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (int8(uint8(bytes1(_blob))));
  }

  /**
   * @notice Set mana.
   */
  function setMana(bytes32 key, int8 mana) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((mana)), _fieldLayout);
  }

  /**
   * @notice Set mana.
   */
  function _setMana(bytes32 key, int8 mana) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((mana)), _fieldLayout);
  }

  /**
   * @notice Get attack.
   */
  function getAttack(bytes32 key) internal view returns (int8 attack) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (int8(uint8(bytes1(_blob))));
  }

  /**
   * @notice Get attack.
   */
  function _getAttack(bytes32 key) internal view returns (int8 attack) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (int8(uint8(bytes1(_blob))));
  }

  /**
   * @notice Set attack.
   */
  function setAttack(bytes32 key, int8 attack) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((attack)), _fieldLayout);
  }

  /**
   * @notice Set attack.
   */
  function _setAttack(bytes32 key, int8 attack) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((attack)), _fieldLayout);
  }

  /**
   * @notice Get hp.
   */
  function getHp(bytes32 key) internal view returns (int8 hp) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (int8(uint8(bytes1(_blob))));
  }

  /**
   * @notice Get hp.
   */
  function _getHp(bytes32 key) internal view returns (int8 hp) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (int8(uint8(bytes1(_blob))));
  }

  /**
   * @notice Set hp.
   */
  function setHp(bytes32 key, int8 hp) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((hp)), _fieldLayout);
  }

  /**
   * @notice Set hp.
   */
  function _setHp(bytes32 key, int8 hp) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((hp)), _fieldLayout);
  }

  /**
   * @notice Get cardType.
   */
  function getCardType(bytes32 key) internal view returns (CardType cardType) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return CardType(uint8(bytes1(_blob)));
  }

  /**
   * @notice Get cardType.
   */
  function _getCardType(bytes32 key) internal view returns (CardType cardType) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return CardType(uint8(bytes1(_blob)));
  }

  /**
   * @notice Set cardType.
   */
  function setCardType(bytes32 key, CardType cardType) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked(uint8(cardType)), _fieldLayout);
  }

  /**
   * @notice Set cardType.
   */
  function _setCardType(bytes32 key, CardType cardType) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked(uint8(cardType)), _fieldLayout);
  }

  /**
   * @notice Get team.
   */
  function getTeam(bytes32 key) internal view returns (CardTeam team) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return CardTeam(uint8(bytes1(_blob)));
  }

  /**
   * @notice Get team.
   */
  function _getTeam(bytes32 key) internal view returns (CardTeam team) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return CardTeam(uint8(bytes1(_blob)));
  }

  /**
   * @notice Set team.
   */
  function setTeam(bytes32 key, CardTeam team) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked(uint8(team)), _fieldLayout);
  }

  /**
   * @notice Set team.
   */
  function _setTeam(bytes32 key, CardTeam team) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked(uint8(team)), _fieldLayout);
  }

  /**
   * @notice Get trait.
   */
  function getTrait(bytes32 key) internal view returns (CardTrait trait) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 5, _fieldLayout);
    return CardTrait(uint8(bytes1(_blob)));
  }

  /**
   * @notice Get trait.
   */
  function _getTrait(bytes32 key) internal view returns (CardTrait trait) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 5, _fieldLayout);
    return CardTrait(uint8(bytes1(_blob)));
  }

  /**
   * @notice Set trait.
   */
  function setTrait(bytes32 key, CardTrait trait) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 5, abi.encodePacked(uint8(trait)), _fieldLayout);
  }

  /**
   * @notice Set trait.
   */
  function _setTrait(bytes32 key, CardTrait trait) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 5, abi.encodePacked(uint8(trait)), _fieldLayout);
  }

  /**
   * @notice Get deckbuilding.
   */
  function getDeckbuilding(bytes32 key) internal view returns (bool deckbuilding) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 6, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Get deckbuilding.
   */
  function _getDeckbuilding(bytes32 key) internal view returns (bool deckbuilding) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 6, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Set deckbuilding.
   */
  function setDeckbuilding(bytes32 key, bool deckbuilding) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 6, abi.encodePacked((deckbuilding)), _fieldLayout);
  }

  /**
   * @notice Set deckbuilding.
   */
  function _setDeckbuilding(bytes32 key, bool deckbuilding) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 6, abi.encodePacked((deckbuilding)), _fieldLayout);
  }

  /**
   * @notice Get tid.
   */
  function getTid(bytes32 key) internal view returns (string memory tid) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 0);
    return (string(_blob));
  }

  /**
   * @notice Get tid.
   */
  function _getTid(bytes32 key) internal view returns (string memory tid) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 0);
    return (string(_blob));
  }

  /**
   * @notice Set tid.
   */
  function setTid(bytes32 key, string memory tid) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 0, bytes((tid)));
  }

  /**
   * @notice Set tid.
   */
  function _setTid(bytes32 key, string memory tid) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setDynamicField(_tableId, _keyTuple, 0, bytes((tid)));
  }

  /**
   * @notice Get the length of tid.
   */
  function lengthTid(bytes32 key) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get the length of tid.
   */
  function _lengthTid(bytes32 key) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get an item of tid.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemTid(bytes32 key, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (string(_blob));
    }
  }

  /**
   * @notice Get an item of tid.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemTid(bytes32 key, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (string(_blob));
    }
  }

  /**
   * @notice Push a slice to tid.
   */
  function pushTid(bytes32 key, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 0, bytes((_slice)));
  }

  /**
   * @notice Push a slice to tid.
   */
  function _pushTid(bytes32 key, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 0, bytes((_slice)));
  }

  /**
   * @notice Pop a slice from tid.
   */
  function popTid(bytes32 key) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Pop a slice from tid.
   */
  function _popTid(bytes32 key) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Update a slice of tid at `_index`.
   */
  function updateTid(bytes32 key, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update a slice of tid at `_index`.
   */
  function _updateTid(bytes32 key, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get abilities.
   */
  function getAbilities(bytes32 key) internal view returns (bytes32[] memory abilities) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 1);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /**
   * @notice Get abilities.
   */
  function _getAbilities(bytes32 key) internal view returns (bytes32[] memory abilities) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 1);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /**
   * @notice Set abilities.
   */
  function setAbilities(bytes32 key, bytes32[] memory abilities) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 1, EncodeArray.encode((abilities)));
  }

  /**
   * @notice Set abilities.
   */
  function _setAbilities(bytes32 key, bytes32[] memory abilities) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setDynamicField(_tableId, _keyTuple, 1, EncodeArray.encode((abilities)));
  }

  /**
   * @notice Get the length of abilities.
   */
  function lengthAbilities(bytes32 key) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 1);
    unchecked {
      return _byteLength / 32;
    }
  }

  /**
   * @notice Get the length of abilities.
   */
  function _lengthAbilities(bytes32 key) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 1);
    unchecked {
      return _byteLength / 32;
    }
  }

  /**
   * @notice Get an item of abilities.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemAbilities(bytes32 key, uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 1, _index * 32, (_index + 1) * 32);
      return (bytes32(_blob));
    }
  }

  /**
   * @notice Get an item of abilities.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemAbilities(bytes32 key, uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 1, _index * 32, (_index + 1) * 32);
      return (bytes32(_blob));
    }
  }

  /**
   * @notice Push an element to abilities.
   */
  function pushAbilities(bytes32 key, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 1, abi.encodePacked((_element)));
  }

  /**
   * @notice Push an element to abilities.
   */
  function _pushAbilities(bytes32 key, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 1, abi.encodePacked((_element)));
  }

  /**
   * @notice Pop an element from abilities.
   */
  function popAbilities(bytes32 key) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 1, 32);
  }

  /**
   * @notice Pop an element from abilities.
   */
  function _popAbilities(bytes32 key) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 1, 32);
  }

  /**
   * @notice Update an element of abilities at `_index`.
   */
  function updateAbilities(bytes32 key, uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 1, uint40(_index * 32), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update an element of abilities at `_index`.
   */
  function _updateAbilities(bytes32 key, uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 1, uint40(_index * 32), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get the full data.
   */
  function get(bytes32 key) internal view returns (CardsData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    (bytes memory _staticData, PackedCounter _encodedLengths, bytes memory _dynamicData) = StoreSwitch.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Get the full data.
   */
  function _get(bytes32 key) internal view returns (CardsData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    (bytes memory _staticData, PackedCounter _encodedLengths, bytes memory _dynamicData) = StoreCore.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function set(
    bytes32 key,
    int8 mana,
    int8 attack,
    int8 hp,
    CardType cardType,
    CardTeam team,
    CardTrait trait,
    bool deckbuilding,
    string memory tid,
    bytes32[] memory abilities
  ) internal {
    bytes memory _staticData = encodeStatic(mana, attack, hp, cardType, team, trait, deckbuilding);

    PackedCounter _encodedLengths = encodeLengths(tid, abilities);
    bytes memory _dynamicData = encodeDynamic(tid, abilities);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(
    bytes32 key,
    int8 mana,
    int8 attack,
    int8 hp,
    CardType cardType,
    CardTeam team,
    CardTrait trait,
    bool deckbuilding,
    string memory tid,
    bytes32[] memory abilities
  ) internal {
    bytes memory _staticData = encodeStatic(mana, attack, hp, cardType, team, trait, deckbuilding);

    PackedCounter _encodedLengths = encodeLengths(tid, abilities);
    bytes memory _dynamicData = encodeDynamic(tid, abilities);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(bytes32 key, CardsData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.mana,
      _table.attack,
      _table.hp,
      _table.cardType,
      _table.team,
      _table.trait,
      _table.deckbuilding
    );

    PackedCounter _encodedLengths = encodeLengths(_table.tid, _table.abilities);
    bytes memory _dynamicData = encodeDynamic(_table.tid, _table.abilities);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(bytes32 key, CardsData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.mana,
      _table.attack,
      _table.hp,
      _table.cardType,
      _table.team,
      _table.trait,
      _table.deckbuilding
    );

    PackedCounter _encodedLengths = encodeLengths(_table.tid, _table.abilities);
    bytes memory _dynamicData = encodeDynamic(_table.tid, _table.abilities);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Decode the tightly packed blob of static data using this table's field layout.
   */
  function decodeStatic(
    bytes memory _blob
  )
    internal
    pure
    returns (int8 mana, int8 attack, int8 hp, CardType cardType, CardTeam team, CardTrait trait, bool deckbuilding)
  {
    mana = (int8(uint8(Bytes.slice1(_blob, 0))));

    attack = (int8(uint8(Bytes.slice1(_blob, 1))));

    hp = (int8(uint8(Bytes.slice1(_blob, 2))));

    cardType = CardType(uint8(Bytes.slice1(_blob, 3)));

    team = CardTeam(uint8(Bytes.slice1(_blob, 4)));

    trait = CardTrait(uint8(Bytes.slice1(_blob, 5)));

    deckbuilding = (_toBool(uint8(Bytes.slice1(_blob, 6))));
  }

  /**
   * @notice Decode the tightly packed blob of dynamic data using the encoded lengths.
   */
  function decodeDynamic(
    PackedCounter _encodedLengths,
    bytes memory _blob
  ) internal pure returns (string memory tid, bytes32[] memory abilities) {
    uint256 _start;
    uint256 _end;
    unchecked {
      _end = _encodedLengths.atIndex(0);
    }
    tid = (string(SliceLib.getSubslice(_blob, _start, _end).toBytes()));

    _start = _end;
    unchecked {
      _end += _encodedLengths.atIndex(1);
    }
    abilities = (SliceLib.getSubslice(_blob, _start, _end).decodeArray_bytes32());
  }

  /**
   * @notice Decode the tightly packed blobs using this table's field layout.
   * @param _staticData Tightly packed static fields.
   * @param _encodedLengths Encoded lengths of dynamic fields.
   * @param _dynamicData Tightly packed dynamic fields.
   */
  function decode(
    bytes memory _staticData,
    PackedCounter _encodedLengths,
    bytes memory _dynamicData
  ) internal pure returns (CardsData memory _table) {
    (
      _table.mana,
      _table.attack,
      _table.hp,
      _table.cardType,
      _table.team,
      _table.trait,
      _table.deckbuilding
    ) = decodeStatic(_staticData);

    (_table.tid, _table.abilities) = decodeDynamic(_encodedLengths, _dynamicData);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(bytes32 key) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(bytes32 key) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(
    int8 mana,
    int8 attack,
    int8 hp,
    CardType cardType,
    CardTeam team,
    CardTrait trait,
    bool deckbuilding
  ) internal pure returns (bytes memory) {
    return abi.encodePacked(mana, attack, hp, cardType, team, trait, deckbuilding);
  }

  /**
   * @notice Tightly pack dynamic data lengths using this table's schema.
   * @return _encodedLengths The lengths of the dynamic fields (packed into a single bytes32 value).
   */
  function encodeLengths(
    string memory tid,
    bytes32[] memory abilities
  ) internal pure returns (PackedCounter _encodedLengths) {
    // Lengths are effectively checked during copy by 2**40 bytes exceeding gas limits
    unchecked {
      _encodedLengths = PackedCounterLib.pack(bytes(tid).length, abilities.length * 32);
    }
  }

  /**
   * @notice Tightly pack dynamic (variable length) data using this table's schema.
   * @return The dynamic data, encoded into a sequence of bytes.
   */
  function encodeDynamic(string memory tid, bytes32[] memory abilities) internal pure returns (bytes memory) {
    return abi.encodePacked(bytes((tid)), EncodeArray.encode((abilities)));
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dyanmic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    int8 mana,
    int8 attack,
    int8 hp,
    CardType cardType,
    CardTeam team,
    CardTrait trait,
    bool deckbuilding,
    string memory tid,
    bytes32[] memory abilities
  ) internal pure returns (bytes memory, PackedCounter, bytes memory) {
    bytes memory _staticData = encodeStatic(mana, attack, hp, cardType, team, trait, deckbuilding);

    PackedCounter _encodedLengths = encodeLengths(tid, abilities);
    bytes memory _dynamicData = encodeDynamic(tid, abilities);

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(bytes32 key) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    return _keyTuple;
  }
}

/**
 * @notice Cast a value to a bool.
 * @dev Boolean values are encoded as uint8 (1 = true, 0 = false), but Solidity doesn't allow casting between uint8 and bool.
 * @param value The uint8 value to convert.
 * @return result The boolean value.
 */
function _toBool(uint8 value) pure returns (bool result) {
  assembly {
    result := value
  }
}
