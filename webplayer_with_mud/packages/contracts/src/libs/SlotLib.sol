pragma solidity >=0.8.21;


    struct Slot {
        uint8 x;
        uint8 y;
        uint8 p;
    }

library SlotLib {
    uint8 constant x_min = 1; // Don't change this, should start at 1 (0,0,0 represent invalid slot)
    uint8 constant x_max = 5; // Number of slots in a row/zone

    uint8 constant  y_min = 1; // Don't change this, should start at 1 (0,0,0 represent invalid slot)
    uint8 constant  y_max = 1; // Set this to the number of rows/locations you want to have

    bool  constant ignore_p = false; // Set to true if you don't want to use P value

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
}