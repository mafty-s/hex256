// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Players, Ability, Games} from "../codegen/index.sol";
import {PileType} from "../codegen/common.sol";
import {Cards, CardOnBoards} from "../codegen/index.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {Slot, SlotLib} from "../libs/SlotLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";
import {ConditionTargetType} from "../codegen/common.sol";
import {CardTableLib} from "../libs/CardTableLib.sol";

contract Effect7System is System {

    event EventEffect(string name, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card);

    function EffectSummonEagle(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectSummonEagle", ability_key, caster, target, is_card);
        bytes32 flame_eagle = 0xeadaa9330dc55ff4f5a4be2783106cf919f0dccf372920ccfd645f6c9dbf8c0d;
        EffectSummon(game_uid, ability_key, caster, target, is_card, flame_eagle);
    }

    function EffectSummonEgg(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectSummonEgg", ability_key, caster, target, is_card);
        bytes32 phoenix_egg = 0xaf3ece100d5f745760efadfedc743cbe6077114f7105f0e642e09d1e8cb38de4;
        EffectSummon(game_uid, ability_key, caster, target, is_card, phoenix_egg);
    }

    function EffectSummonWolf(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectSummonWolf", ability_key, caster, target, is_card);
        bytes32 wolf_baby = 0xc0fd58a3602c8586b2e1583e65cef9c8e3dbc8bc36449e7fe2666856e4a1e554;
        EffectSummon(game_uid, ability_key, caster, target, is_card, wolf_baby);
    }

    //召唤一张卡，比如凤凰死亡的时候会出现凤凰蛋
    function EffectSummon(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card, bytes32 card_config_key) internal {
        if (is_card == ConditionTargetType.Player) {
            GameLogicLib.SummonCardHand(game_uid, target, card_config_key);
        }

        if (is_card == ConditionTargetType.Card) {
            uint16 target_slot_encode = CardOnBoards.getSlot(target);
            bytes32 player = CardOnBoards.getPlayerId(caster);
            bytes32 acard = GameLogicLib.SummonCardHand(game_uid, player, card_config_key);
            GameLogicLib.PlayCard(game_uid, player, acard, target_slot_encode, true);

        }

        if (is_card == ConditionTargetType.Slot) {
            bytes32 player = CardOnBoards.getPlayerId(caster);
            bytes32 acard = GameLogicLib.SummonCardHand(game_uid, player, card_config_key);
        }

        if (is_card == ConditionTargetType.CardData) {
            bytes32 player = CardOnBoards.getPlayerId(caster);
            GameLogicLib.SummonCardHand(game_uid, player, target);
        }
    }
}