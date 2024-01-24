pragma solidity >=0.8.21;


    struct Slot {
        uint8 x;
        uint8 y;
        uint8 p;
    }

import {CardOnBoards} from "../codegen/index.sol";

library SlotLib {
    uint8 constant x_min = 1; // Don't change this, should start at 1 (0,0,0 represent invalid slot)
    uint8 constant x_max = 5; // Number of slots in a row/zone

    uint8 constant  y_min = 1; // Don't change this, should start at 1 (0,0,0 represent invalid slot)
    uint8 constant  y_max = 1; // Set this to the number of rows/locations you want to have

    bool  constant ignore_p = false; // Set to true if you don't want to use P value


    function NewSlot(uint8 x, uint8 y, uint8 p) internal pure returns (Slot memory) {
        Slot memory slot = Slot({x : x, y : y, p : p});
        return slot;
    }

    function SetSlot(bytes32 card_key, Slot memory slot) internal {
        CardOnBoards.setSlot(card_key, EncodeSlot(slot));
    }

    function GetSlotCard(bytes32 game_key, Slot memory slot) internal view returns (bytes32) {
        //todo
        //        return CardOnBoards.getSlotCard(game_key, EncodeSlot(slot));
        return 0;
    }

    function EncodeSlot(Slot memory slot) internal pure returns (uint16) {
        return uint16(slot.x) + (uint16(slot.y) * 10) + (uint16(slot.p) * 100);
    }

    function DecodeSlotX(uint16 slot) internal pure returns (uint8) {
        return uint8(slot % 10);
    }

    function DecodeSlotY(uint16 slot) internal pure returns (uint8) {
        return uint8((slot / 10) % 10);
    }

    function DecodeSlotP(uint16 slot) internal pure returns (uint8) {
        return uint8(slot / 100);
    }


    function IsInRangeX(Slot memory slot, uint8 range) internal pure returns (bool) {
        return (slot.x >= (x_min + range)) && (slot.x <= (x_max - range));
    }

    function IsPlayerSlot(Slot memory slot) internal pure returns (bool) {
        return slot.x == 0 && slot.y == 0;
    }

    function IsValid(Slot memory slot) internal pure returns (bool) {
        return slot.x >= x_min && slot.x <= x_max && slot.y >= y_min && slot.y <= y_max;
    }

    function IsInRangeY(Slot memory slot, uint8 range) internal pure returns (bool) {
        return (slot.y >= (y_min + range)) && (slot.y <= (y_max - range));
    }

    function IsInRangeP(Slot memory slot, uint8 range) internal pure returns (bool) {
        return (slot.p >= range);
    }

    function IsInDistanceStraight(Slot memory slot, uint8 dist) internal pure returns (bool) {
        uint8 r = (slot.x - x_min) + (slot.y - y_min) + slot.p;
        return r <= dist;
    }

    function IsInDistance(Slot memory slot, uint8 dist) internal pure returns (bool) {
        uint8 dx = (slot.x - x_min);
        uint8 dy = (slot.y - y_min);
        uint8 dp = slot.p;
        return dx <= dist && dy <= dist && dp <= dist;
    }

    function GetDistance(Slot memory slot, Slot memory slot2) internal pure returns (uint8) {
        uint8 dx = (slot.x - x_min);
        uint8 dy = (slot.y - y_min);
        uint8 dp = slot.p;
        uint8 dx2 = (slot2.x - x_min);
        uint8 dy2 = (slot2.y - y_min);
        uint8 dp2 = slot2.p;
        return (dx - dx2) + (dy - dy2) + (dp - dp2);
    }

    function GetDistanceStraight(Slot memory slot, Slot memory slot2) internal pure returns (uint8) {
        uint8 dx = (slot.x - x_min);
        uint8 dy = (slot.y - y_min);
        uint8 dp = slot.p;
        uint8 dx2 = (slot2.x - x_min);
        uint8 dy2 = (slot2.y - y_min);
        uint8 dp2 = slot2.p;
        return (dx - dx2) + (dy - dy2) + (dp - dp2);
    }

    function GetRandomEmptySlot(bytes32 player_key) internal view returns (Slot memory) {
        Slot[] memory slots = GetEmptySlots(player_key);
        if (slots.length == 0) {
            Slot memory slot = SlotLib.NewSlot(0,0,0);
            return slot;
        }
        uint rand = uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, slots.length)));
        return slots[rand % slots.length];
    }

    function GetEmptySlots(bytes32 player_key) internal view returns (Slot[] memory) {
        Slot[] memory slots = new Slot[](x_max * y_max * 2);
        //todo
//        uint8 index = 0;
//        for (uint8 x = x_min; x <= x_max; x++) {
//            for (uint8 y = y_min; y <= y_max; y++) {
//                for (uint8 p = 0; p <= 1; p++) {
//                    Slot memory slot = SlotLib.NewSlot(x, y, p);
//                    if (CardOnBoards.getSlotCard(player_key, EncodeSlot(slot)) == 0) {
//                        slots[index] = slot;
//                        index++;
//                    }
//                }
//            }
//        }
        return slots;

    }
}