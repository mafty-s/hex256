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
import { SelectorType } from "./../common.sol";

ResourceId constant _tableId = ResourceId.wrap(
  bytes32(abi.encodePacked(RESOURCE_TABLE, bytes14(""), bytes16("GamesExtended")))
);
ResourceId constant GamesExtendedTableId = _tableId;

FieldLayout constant _fieldLayout = FieldLayout.wrap(
  0x00e2090001202020202020200100000000000000000000000000000000000000
);

struct GamesExtendedData {
  SelectorType selector;
  bytes32 selectorPlayerId;
  bytes32 selectorCasterUid;
  bytes32 selectorAbility;
  bytes32 abilityTriggerer;
  bytes32 lastPlayed;
  bytes32 lastTarget;
  bytes32 lastDestroyed;
  int8 rolledValue;
}

library GamesExtended {
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
    _valueSchema[0] = SchemaType.UINT8;
    _valueSchema[1] = SchemaType.BYTES32;
    _valueSchema[2] = SchemaType.BYTES32;
    _valueSchema[3] = SchemaType.BYTES32;
    _valueSchema[4] = SchemaType.BYTES32;
    _valueSchema[5] = SchemaType.BYTES32;
    _valueSchema[6] = SchemaType.BYTES32;
    _valueSchema[7] = SchemaType.BYTES32;
    _valueSchema[8] = SchemaType.INT8;

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
    fieldNames[0] = "selector";
    fieldNames[1] = "selectorPlayerId";
    fieldNames[2] = "selectorCasterUid";
    fieldNames[3] = "selectorAbility";
    fieldNames[4] = "abilityTriggerer";
    fieldNames[5] = "lastPlayed";
    fieldNames[6] = "lastTarget";
    fieldNames[7] = "lastDestroyed";
    fieldNames[8] = "rolledValue";
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
   * @notice Get selector.
   */
  function getSelector(bytes32 key) internal view returns (SelectorType selector) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return SelectorType(uint8(bytes1(_blob)));
  }

  /**
   * @notice Get selector.
   */
  function _getSelector(bytes32 key) internal view returns (SelectorType selector) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return SelectorType(uint8(bytes1(_blob)));
  }

  /**
   * @notice Set selector.
   */
  function setSelector(bytes32 key, SelectorType selector) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked(uint8(selector)), _fieldLayout);
  }

  /**
   * @notice Set selector.
   */
  function _setSelector(bytes32 key, SelectorType selector) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked(uint8(selector)), _fieldLayout);
  }

  /**
   * @notice Get selectorPlayerId.
   */
  function getSelectorPlayerId(bytes32 key) internal view returns (bytes32 selectorPlayerId) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Get selectorPlayerId.
   */
  function _getSelectorPlayerId(bytes32 key) internal view returns (bytes32 selectorPlayerId) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Set selectorPlayerId.
   */
  function setSelectorPlayerId(bytes32 key, bytes32 selectorPlayerId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((selectorPlayerId)), _fieldLayout);
  }

  /**
   * @notice Set selectorPlayerId.
   */
  function _setSelectorPlayerId(bytes32 key, bytes32 selectorPlayerId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((selectorPlayerId)), _fieldLayout);
  }

  /**
   * @notice Get selectorCasterUid.
   */
  function getSelectorCasterUid(bytes32 key) internal view returns (bytes32 selectorCasterUid) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Get selectorCasterUid.
   */
  function _getSelectorCasterUid(bytes32 key) internal view returns (bytes32 selectorCasterUid) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Set selectorCasterUid.
   */
  function setSelectorCasterUid(bytes32 key, bytes32 selectorCasterUid) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((selectorCasterUid)), _fieldLayout);
  }

  /**
   * @notice Set selectorCasterUid.
   */
  function _setSelectorCasterUid(bytes32 key, bytes32 selectorCasterUid) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((selectorCasterUid)), _fieldLayout);
  }

  /**
   * @notice Get selectorAbility.
   */
  function getSelectorAbility(bytes32 key) internal view returns (bytes32 selectorAbility) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Get selectorAbility.
   */
  function _getSelectorAbility(bytes32 key) internal view returns (bytes32 selectorAbility) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Set selectorAbility.
   */
  function setSelectorAbility(bytes32 key, bytes32 selectorAbility) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((selectorAbility)), _fieldLayout);
  }

  /**
   * @notice Set selectorAbility.
   */
  function _setSelectorAbility(bytes32 key, bytes32 selectorAbility) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((selectorAbility)), _fieldLayout);
  }

  /**
   * @notice Get abilityTriggerer.
   */
  function getAbilityTriggerer(bytes32 key) internal view returns (bytes32 abilityTriggerer) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Get abilityTriggerer.
   */
  function _getAbilityTriggerer(bytes32 key) internal view returns (bytes32 abilityTriggerer) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Set abilityTriggerer.
   */
  function setAbilityTriggerer(bytes32 key, bytes32 abilityTriggerer) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((abilityTriggerer)), _fieldLayout);
  }

  /**
   * @notice Set abilityTriggerer.
   */
  function _setAbilityTriggerer(bytes32 key, bytes32 abilityTriggerer) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((abilityTriggerer)), _fieldLayout);
  }

  /**
   * @notice Get lastPlayed.
   */
  function getLastPlayed(bytes32 key) internal view returns (bytes32 lastPlayed) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 5, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Get lastPlayed.
   */
  function _getLastPlayed(bytes32 key) internal view returns (bytes32 lastPlayed) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 5, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Set lastPlayed.
   */
  function setLastPlayed(bytes32 key, bytes32 lastPlayed) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 5, abi.encodePacked((lastPlayed)), _fieldLayout);
  }

  /**
   * @notice Set lastPlayed.
   */
  function _setLastPlayed(bytes32 key, bytes32 lastPlayed) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 5, abi.encodePacked((lastPlayed)), _fieldLayout);
  }

  /**
   * @notice Get lastTarget.
   */
  function getLastTarget(bytes32 key) internal view returns (bytes32 lastTarget) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 6, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Get lastTarget.
   */
  function _getLastTarget(bytes32 key) internal view returns (bytes32 lastTarget) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 6, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Set lastTarget.
   */
  function setLastTarget(bytes32 key, bytes32 lastTarget) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 6, abi.encodePacked((lastTarget)), _fieldLayout);
  }

  /**
   * @notice Set lastTarget.
   */
  function _setLastTarget(bytes32 key, bytes32 lastTarget) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 6, abi.encodePacked((lastTarget)), _fieldLayout);
  }

  /**
   * @notice Get lastDestroyed.
   */
  function getLastDestroyed(bytes32 key) internal view returns (bytes32 lastDestroyed) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 7, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Get lastDestroyed.
   */
  function _getLastDestroyed(bytes32 key) internal view returns (bytes32 lastDestroyed) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 7, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Set lastDestroyed.
   */
  function setLastDestroyed(bytes32 key, bytes32 lastDestroyed) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 7, abi.encodePacked((lastDestroyed)), _fieldLayout);
  }

  /**
   * @notice Set lastDestroyed.
   */
  function _setLastDestroyed(bytes32 key, bytes32 lastDestroyed) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 7, abi.encodePacked((lastDestroyed)), _fieldLayout);
  }

  /**
   * @notice Get rolledValue.
   */
  function getRolledValue(bytes32 key) internal view returns (int8 rolledValue) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 8, _fieldLayout);
    return (int8(uint8(bytes1(_blob))));
  }

  /**
   * @notice Get rolledValue.
   */
  function _getRolledValue(bytes32 key) internal view returns (int8 rolledValue) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 8, _fieldLayout);
    return (int8(uint8(bytes1(_blob))));
  }

  /**
   * @notice Set rolledValue.
   */
  function setRolledValue(bytes32 key, int8 rolledValue) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 8, abi.encodePacked((rolledValue)), _fieldLayout);
  }

  /**
   * @notice Set rolledValue.
   */
  function _setRolledValue(bytes32 key, int8 rolledValue) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 8, abi.encodePacked((rolledValue)), _fieldLayout);
  }

  /**
   * @notice Get the full data.
   */
  function get(bytes32 key) internal view returns (GamesExtendedData memory _table) {
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
  function _get(bytes32 key) internal view returns (GamesExtendedData memory _table) {
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
    SelectorType selector,
    bytes32 selectorPlayerId,
    bytes32 selectorCasterUid,
    bytes32 selectorAbility,
    bytes32 abilityTriggerer,
    bytes32 lastPlayed,
    bytes32 lastTarget,
    bytes32 lastDestroyed,
    int8 rolledValue
  ) internal {
    bytes memory _staticData = encodeStatic(
      selector,
      selectorPlayerId,
      selectorCasterUid,
      selectorAbility,
      abilityTriggerer,
      lastPlayed,
      lastTarget,
      lastDestroyed,
      rolledValue
    );

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(
    bytes32 key,
    SelectorType selector,
    bytes32 selectorPlayerId,
    bytes32 selectorCasterUid,
    bytes32 selectorAbility,
    bytes32 abilityTriggerer,
    bytes32 lastPlayed,
    bytes32 lastTarget,
    bytes32 lastDestroyed,
    int8 rolledValue
  ) internal {
    bytes memory _staticData = encodeStatic(
      selector,
      selectorPlayerId,
      selectorCasterUid,
      selectorAbility,
      abilityTriggerer,
      lastPlayed,
      lastTarget,
      lastDestroyed,
      rolledValue
    );

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(bytes32 key, GamesExtendedData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.selector,
      _table.selectorPlayerId,
      _table.selectorCasterUid,
      _table.selectorAbility,
      _table.abilityTriggerer,
      _table.lastPlayed,
      _table.lastTarget,
      _table.lastDestroyed,
      _table.rolledValue
    );

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(bytes32 key, GamesExtendedData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.selector,
      _table.selectorPlayerId,
      _table.selectorCasterUid,
      _table.selectorAbility,
      _table.abilityTriggerer,
      _table.lastPlayed,
      _table.lastTarget,
      _table.lastDestroyed,
      _table.rolledValue
    );

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

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
    returns (
      SelectorType selector,
      bytes32 selectorPlayerId,
      bytes32 selectorCasterUid,
      bytes32 selectorAbility,
      bytes32 abilityTriggerer,
      bytes32 lastPlayed,
      bytes32 lastTarget,
      bytes32 lastDestroyed,
      int8 rolledValue
    )
  {
    selector = SelectorType(uint8(Bytes.slice1(_blob, 0)));

    selectorPlayerId = (Bytes.slice32(_blob, 1));

    selectorCasterUid = (Bytes.slice32(_blob, 33));

    selectorAbility = (Bytes.slice32(_blob, 65));

    abilityTriggerer = (Bytes.slice32(_blob, 97));

    lastPlayed = (Bytes.slice32(_blob, 129));

    lastTarget = (Bytes.slice32(_blob, 161));

    lastDestroyed = (Bytes.slice32(_blob, 193));

    rolledValue = (int8(uint8(Bytes.slice1(_blob, 225))));
  }

  /**
   * @notice Decode the tightly packed blobs using this table's field layout.
   * @param _staticData Tightly packed static fields.
   *
   *
   */
  function decode(
    bytes memory _staticData,
    PackedCounter,
    bytes memory
  ) internal pure returns (GamesExtendedData memory _table) {
    (
      _table.selector,
      _table.selectorPlayerId,
      _table.selectorCasterUid,
      _table.selectorAbility,
      _table.abilityTriggerer,
      _table.lastPlayed,
      _table.lastTarget,
      _table.lastDestroyed,
      _table.rolledValue
    ) = decodeStatic(_staticData);
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
    SelectorType selector,
    bytes32 selectorPlayerId,
    bytes32 selectorCasterUid,
    bytes32 selectorAbility,
    bytes32 abilityTriggerer,
    bytes32 lastPlayed,
    bytes32 lastTarget,
    bytes32 lastDestroyed,
    int8 rolledValue
  ) internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        selector,
        selectorPlayerId,
        selectorCasterUid,
        selectorAbility,
        abilityTriggerer,
        lastPlayed,
        lastTarget,
        lastDestroyed,
        rolledValue
      );
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dyanmic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    SelectorType selector,
    bytes32 selectorPlayerId,
    bytes32 selectorCasterUid,
    bytes32 selectorAbility,
    bytes32 abilityTriggerer,
    bytes32 lastPlayed,
    bytes32 lastTarget,
    bytes32 lastDestroyed,
    int8 rolledValue
  ) internal pure returns (bytes memory, PackedCounter, bytes memory) {
    bytes memory _staticData = encodeStatic(
      selector,
      selectorPlayerId,
      selectorCasterUid,
      selectorAbility,
      abilityTriggerer,
      lastPlayed,
      lastTarget,
      lastDestroyed,
      rolledValue
    );

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

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
