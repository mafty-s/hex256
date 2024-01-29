// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Players, Ability, Games, PlayerActionHistory, ActionHistory} from "../codegen/index.sol";
import {Action, PileType} from "../codegen/common.sol";
import {MathLib} from "../libs/MathLib.sol";
import {Cards, CardsData, CardOnBoards} from "../codegen/index.sol";
import {PlayerCardsDeck, PlayerCardsHand, PlayerCardsDiscard, PlayerCardsTemp} from "../codegen/index.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";

contract EffectSystem2 is System {


    function EffectSummonEagle(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        bytes32 flame_eagle = 0xeadaa9330dc55ff4f5a4be2783106cf919f0dccf372920ccfd645f6c9dbf8c0d;
        EffectSummon(ability_key, caster, target, is_card, flame_eagle);
    }

    function EffectSummonEgg(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        bytes32 phoenix_egg = 0xaf3ece100d5f745760efadfedc743cbe6077114f7105f0e642e09d1e8cb38de4;
        EffectSummon(ability_key, caster, target, is_card, phoenix_egg);
    }

    function EffectSummonWolf(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        bytes32 wolf_baby = 0xc0fd58a3602c8586b2e1583e65cef9c8e3dbc8bc36449e7fe2666856e4a1e554;
        EffectSummon(ability_key, caster, target, is_card, wolf_baby);
    }

    function EffectTransformFish(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        bytes32 fish = 0x922d0a331fd751dd3f9f56ab05f7acb5b6a7080eb367ecbe613cc632beee0576;
        EffectTransform(ability_key, caster, target, is_card, fish);
    }

    function EffectTransformPhoenix(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        bytes32 phoenix = 0x45a23f50c4a44900e19828c071b86545a4e54f3522a680d87ff84742258a9071;
        EffectTransform(ability_key, caster, target, is_card, phoenix);
    }

    function EffectSendDeck(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        EffectSendPile(ability_key, caster, target, is_card, PileType.Deck);
    }

    function EffectSendHand(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        EffectSendPile(ability_key, caster, target, is_card, PileType.Hand);
    }

    //----------------------------------------------------------------------------------------------------------------

    //召唤一张卡，比如凤凰死亡的时候会出现凤凰蛋
    function EffectSummon(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, bytes32 card_config_key) internal {
//        uint len = CardOnBoards.getLength(caster);

        bytes32 player_key = CardOnBoards.getPlayerId(caster);
        // 创建一张卡
        CardsData memory card = Cards.get(card_config_key);
        bytes32 on_board_card_key = keccak256(abi.encodePacked(caster, card.tid));
        CardOnBoards.setId(on_board_card_key, card_config_key);
        CardOnBoards.setHp(on_board_card_key, card.hp);
        CardOnBoards.setAttack(on_board_card_key, card.attack);
        CardOnBoards.setMana(on_board_card_key, card.mana);
        CardOnBoards.setPlayerId(on_board_card_key, player_key);

        //todo 创建一个随机slot
        //todo 放到牌区
    }

    //把一张牌变为另一张牌
    function EffectTransform(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, bytes32 card_config_key) internal {
        if (is_card) {
            CardOnBoards.setId(target, card_config_key);
        }
    }

    //将卡牌移动到指定区域，手牌区、弃牌区、显示区等
    function EffectSendPile(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, PileType pile_type) internal {
        bytes32 player_key = CardOnBoards.getPlayerId(target);
        if (pile_type == PileType.Deck) {
            PlayerLogicLib.RemoveCardFromAllGroups(player_key, target);
            PlayerCardsDeck.pushValue(player_key, target);
        } else if (pile_type == PileType.Hand) {
            PlayerLogicLib.RemoveCardFromAllGroups(player_key, target);
            PlayerCardsHand.pushValue(player_key, target);
        } else if (pile_type == PileType.Discard) {
            PlayerLogicLib.RemoveCardFromAllGroups(player_key, target);
            PlayerCardsDiscard.pushValue(player_key, target);
        } else if (pile_type == PileType.Temp) {
            PlayerLogicLib.RemoveCardFromAllGroups(player_key, target);
            PlayerCardsTemp.pushValue(player_key, target);
        }
    }
}