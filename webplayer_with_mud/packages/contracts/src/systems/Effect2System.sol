// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Players, Ability, Games, GamesExtended, PlayerActionHistory, ActionHistory} from "../codegen/index.sol";
import {Action, PileType} from "../codegen/common.sol";
import {MathLib} from "../libs/MathLib.sol";
import {Cards, CardOnBoards} from "../codegen/index.sol";
import {PlayerCardsDeck, PlayerCardsHand, PlayerCardsDiscard, PlayerCardsTemp, PlayerCardsBoard} from "../codegen/index.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {Slot, SlotLib} from "../libs/SlotLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";

contract Effect2System is System {


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

    function EffectShuffleDeck(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        if (!is_card) {
            bytes32[] memory cards = PlayerCardsDeck.getValue(target);
            cards = shuffle(cards);
            PlayerCardsDeck.setValue(target, cards);
        }
    }

    function EffectClearTemp(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        if (is_card) {
            bytes32 player_key = CardOnBoards.getPlayerId(caster);
            bytes32[] memory empty = new bytes32[](0);
            PlayerCardsTemp.set(player_key, empty);
        }
    }


    function EffectCreateTemp(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) public {
        EffectCreate(ability_key, caster, target, is_card, PileType.Temp, false);
    }

    //----------------------------------------------------------------------------------------------------------------

    function EffectCreate(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, PileType create_pile, bool create_opponent) internal {
        if (is_card) {
            bytes32 card_config_id = CardOnBoards.getId(target);
            bytes32 player_key = CardOnBoards.getPlayerId(caster);
            bytes32 game_uid = Players.getGame(player_key);
            if (create_opponent) {
                player_key = GameLogicLib.GetOpponent(game_uid, player_key);
            }
            bytes32 card_uid = GameLogicLib.AddCard(player_key, card_config_id);
            GamesExtended.setLastSummoned(game_uid, card_uid);
            if (create_pile == PileType.Deck) {
                PlayerCardsDeck.pushValue(player_key, card_uid);
            }
            if (create_pile == PileType.Hand) {
                PlayerCardsHand.pushValue(player_key, card_uid);
            }
            if (create_pile == PileType.Discard) {
                PlayerCardsDiscard.pushValue(player_key, card_uid);
            }
            if (create_pile == PileType.Temp) {
                PlayerCardsTemp.pushValue(player_key, card_uid);
            }
        }
    }

    function shuffle(bytes32[] memory array) internal view returns (bytes32[] memory) {
        uint256 arrSize = array.length;
        bytes32[] memory shuffled = new bytes32[](arrSize);

        // Copy the original deck to the shuffled deck array
        for (uint256 i = 0; i < arrSize; i++) {
            shuffled[i] = array[i];
        }

        // Shuffle the deck using Fisher-Yates algorithm
        for (uint256 i = arrSize - 1; i > 0; i--) {
            uint256 j = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, i))) % (i + 1);
            bytes32 temp = shuffled[i];
            shuffled[i] = shuffled[j];
            shuffled[j] = temp;
        }

        return shuffled;
    }

    //召唤一张卡，比如凤凰死亡的时候会出现凤凰蛋
    function EffectSummon(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, bytes32 card_config_key) internal {
//        uint len = CardOnBoards.getLength(caster);

        bytes32 player_key = CardOnBoards.getPlayerId(caster);
        // 创建一张卡

        bytes32 game_key = Players.getGame(player_key);
        bytes32[] memory players = Games.getPlayers(game_key);
        uint8 p = players[0] == player_key ? 0 : 1;

        Slot memory slot = SlotLib.GetRandomEmptySlot(player_key, p);
        uint16 slot_encode = SlotLib.EncodeSlot(slot);

        bytes32 card_uid = GameLogicLib.AddCard(player_key, card_config_key);
        CardOnBoards.setSlot(card_uid, slot_encode);

        SlotLib.SetCardOnSlot(player_key, card_uid, slot.x);
        PlayerCardsBoard.pushValue(player_key, card_uid);
    }

    //把一张牌变为另一张牌
    function EffectTransform(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, bytes32 card_config_key) internal {
        if (is_card) {
            string memory card_name = Cards.getTid(card_config_key);
            CardOnBoards.setId(target, card_config_key);
            CardOnBoards.setName(target,card_name);
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