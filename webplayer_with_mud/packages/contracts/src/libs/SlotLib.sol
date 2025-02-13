pragma solidity >=0.8.21;


    struct Slot {
        uint8 x;
        uint8 y;
        uint8 p;
    }

import {CardOnBoards, PlayerSlots} from "../codegen/index.sol";

library SlotLib {
    uint8 constant x_min = 1; // Don't change this, should start at 1 (0,0,0 represent invalid slot)
    uint8 constant x_max = 5; // Number of slots in a row/zone

    uint8 constant  y_min = 1; // Don't change this, should start at 1 (0,0,0 represent invalid slot)
    uint8 constant  y_max = 1; // Set this to the number of rows/locations you want to have

    bool  constant ignore_p = false; // Set to true if you don't want to use P value


    function NewSlot(uint8 x, uint8 y, uint8 p) internal pure returns (Slot memory) {
        Slot memory slot = Slot({x: x, y: y, p: p});
        return slot;
    }

    function GetAll() internal pure returns (Slot[] memory) {
        Slot[] memory slots = new Slot[](10);
        slots[0] = NewSlot(1, 1, 0);
        slots[1] = NewSlot(1, 1, 1);
        slots[2] = NewSlot(2, 1, 0);
        slots[3] = NewSlot(2, 1, 1);
        slots[4] = NewSlot(3, 1, 0);
        slots[5] = NewSlot(3, 1, 1);
        slots[6] = NewSlot(4, 1, 0);
        slots[7] = NewSlot(4, 1, 1);
        slots[8] = NewSlot(5, 1, 0);
        slots[9] = NewSlot(5, 1, 1);
        return slots;
    }

    function EncodeSlot(Slot memory slot) internal pure returns (uint16) {
        uint16 x = uint16(slot.x);
        uint16 y = uint16(slot.y);
        uint16 p = uint16(slot.p);

        return x + (y * 10) + (p * 100);
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

//    function GetAllInP(int8 p) internal pure returns (Slot[] memory) {
//        Slot[] memory slots = new Slot[](x_max * y_max * 2);
//        uint8 index = 0;
//        for (uint8 y = y_min; y <= y_max; y++) {
//            for (uint8 x = x_min; x <= x_max; x++) {
//                for (uint8 p = 0; p <= 1; p++) {
//                    Slot memory slot = SlotLib.NewSlot(x, y, p);
//                    slots[index] = slot;
//                    index++;
//                }
//            }
//        }
//        return slots;
//    }

    function SetSlot(bytes32 card_key, Slot memory slot) internal {
        CardOnBoards.setSlot(card_key, EncodeSlot(slot));
    }

    function GetSlotCard(bytes32 game_key, uint16 slot_encode) internal view returns (bytes32) {
//todo
//        return CardOnBoards.getSlotCard(game_key, EncodeSlot(slot));
        return 0;
    }



    function ToSlot32(Slot memory slot) internal pure returns (bytes32) {
        uint16 encode = EncodeSlot(slot);
        return bytes32(uint256(encode));
    }

    function DecodeSlot(uint16 encode) internal pure returns (Slot memory){
        uint8 x = DecodeSlotX(encode);
        uint8 y = DecodeSlotY(encode);
        uint8 p = DecodeSlotP(encode);
        return NewSlot(x, y, p);
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

    function IsInDistanceStraight(Slot memory origin, Slot memory slot, uint8 dist) internal pure returns (bool) {
        uint8 r = (origin.x - slot.x) + (origin.y - slot.y) + (origin.p - slot.p);
        return r <= dist;
    }

    function IsInDistance(Slot memory origin, Slot memory slot, uint8 dist) internal pure returns (bool) {
        uint8 dx = (origin.x - slot.x);
        uint8 dy = (origin.y - slot.y);
        uint8 dp = (origin.p - slot.p);
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

    function GetRandomEmptySlot(bytes32 player_key, uint8 p) internal view returns (Slot memory) {
        Slot[] memory slots = GetEmptySlots(player_key, p);
        if (slots.length == 0) {
            Slot memory slot = SlotLib.NewSlot(0, 0, 0);
            return slot;
        }
        uint rand = uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, slots.length)));
        return slots[rand % slots.length];
    }

    function GetEmptySlots(bytes32 player_key, uint8 p) internal view returns (Slot[] memory) {
        uint num = 0;
        if (PlayerSlots.getA(player_key) == 0) {
            num++;
        }
        if (PlayerSlots.getB(player_key) == 0) {
            num++;
        }
        if (PlayerSlots.getC(player_key) == 0) {
            num++;
        }
        if (PlayerSlots.getD(player_key) == 0) {
            num++;
        }
        if (PlayerSlots.getE(player_key) == 0) {
            num++;
        }
        Slot[] memory slots = new Slot[](num);

        uint8 i = 0;
        uint8 y = 1;//todo
        if (PlayerSlots.getA(player_key) == 0) {
            slots[i] = NewSlot(1, y, p);
            i++;
        }
        if (PlayerSlots.getB(player_key) == 0) {
            slots[i] = NewSlot(2, y, p);
            i++;
        }
        if (PlayerSlots.getC(player_key) == 0) {
            slots[i] = NewSlot(3, y, p);
            i++;
        }
        if (PlayerSlots.getD(player_key) == 0) {
            slots[i] = NewSlot(4, y, p);
            i++;
        }
        if (PlayerSlots.getE(player_key) == 0) {
            slots[i] = NewSlot(5, y, p);
            i++;
        }
        return slots;
    }

    function SetCardOnSlot(bytes32 player_key, bytes32 card_key, uint x) internal {
        if (x == 1) {
            PlayerSlots.setA(player_key, card_key);
        } else if (x == 2) {
            PlayerSlots.setB(player_key, card_key);
        } else if (x == 3) {
            PlayerSlots.setC(player_key, card_key);
        } else if (x == 4) {
            PlayerSlots.setD(player_key, card_key);
        } else if (x == 5) {
            PlayerSlots.setE(player_key, card_key);
        } else {
            revert("SetCardOnSlot Invalid slot");
        }
    }

    function GetCardOnSlot(bytes32 player_key, uint x) internal view returns (bytes32) {
        if (x == 1) {
            return PlayerSlots.getA(player_key);
        }
        if (x == 2) {
            return PlayerSlots.getB(player_key);
        }
        if (x == 3) {
            return PlayerSlots.getC(player_key);
        }
        if (x == 4) {
            return PlayerSlots.getD(player_key);
        }
        if (x == 5) {
            return PlayerSlots.getE(player_key);
        }
        revert("GetCardOnSlot Invalid slot");
    }

    function ClearCardFromSlot(bytes32 player_key, bytes32 card_key) internal {
        if (PlayerSlots.getA(player_key) == card_key) {
            PlayerSlots.setA(player_key, 0);
        }
        if (PlayerSlots.getB(player_key) == card_key) {
            PlayerSlots.setB(player_key, 0);
        }
        if (PlayerSlots.getC(player_key) == card_key) {
            PlayerSlots.setC(player_key, 0);
        }
        if (PlayerSlots.getD(player_key) == card_key) {
            PlayerSlots.setD(player_key, 0);
        }
        if (PlayerSlots.getE(player_key) == card_key) {
            PlayerSlots.setE(player_key, 0);
        }
    }
}