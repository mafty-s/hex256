pragma solidity >=0.8.21;

import {Cards, Games, Ability, Players, PlayerCardsBoard, Ability, CardOnBoards, CardsData, PlayerCardsDeck} from "../codegen/index.sol";
import {AbilityTrigger, AbilityTarget, PileType, EffectStatType} from "../codegen/common.sol";

import {GameLogicLib} from "./GameLogicLib.sol";

library EffectLib {

    function DoEffect(bytes4 selector, bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal returns (bool) {
        (bool success,) = address(this).call(abi.encodeWithSelector(selector, ability_key, caster, target, is_card));
        return success;
    }

    function EffectHeal(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        if (is_card) {
            GameLogicLib.HealCard(target, Ability.getValue(ability_key));
        } else {
            Players.setHp(target, Players.getHp(target) + Ability.getValue(ability_key));
            if (Players.getHp(target) > Players.getHpMax(target)) {
                Players.setHp(target, Players.getHpMax(target));
            }
        }
    }

    function EffectDamage(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        int8 damage = GetDamage(ability_key);
        GameLogicLib.DamageCard(caster, target, damage, true);

        //todo
    }

    function GetDamage(bytes32 ability_key) internal returns (int8){
        int8 value = Ability.getValue(ability_key);
        //todo 加上别的影响
        return value;
    }

    function EffectAddStatCount(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectAddStat(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        int8 value = Ability.getValue(ability_key);
        if (is_card) {
            CardOnBoards.setHp(target, value + CardOnBoards.getHp(target));
        } else {
            Players.setHp(target, value + Players.getHp(target));
        }
        //todo
    }

    function EffectSendPile(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, PileType pile_type) internal {
        if (is_card) {
            if (pile_type == PileType.Deck) {
                //todo
            } else {
                revert("unknown pile type");
            }
        }
    }

    function EffectCreate(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, PileType pile_type, bytes32 card_config_key) internal {
        if (is_card) {

            bytes32 player_key = CardOnBoards.getPlayerId(target);

            bytes32 on_board_card_key = keccak256(abi.encode(card_config_key, player_key, 0));
            CardsData memory card = Cards.get(card_config_key);

            CardOnBoards.setId(on_board_card_key, card_config_key);
            CardOnBoards.setHp(on_board_card_key, card.hp);
            CardOnBoards.setAttack(on_board_card_key, card.attack);
            CardOnBoards.setMana(on_board_card_key, card.mana);
            CardOnBoards.setPlayerId(on_board_card_key, player_key);


            if (pile_type == PileType.Deck) {
                PlayerCardsDeck.pushValue(player_key, on_board_card_key);
            } else {
                revert("unknown pile type");
            }
        }
    }

    function EffectAttack(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectSummon(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectSetStat(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card, EffectStatType effect_stat_type) internal {
        //todo
    }

    function EffectAttackRedirect(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectAddStatRoll(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectAddTrait(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectSetStatCustom(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectClearStatus(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectPlay(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectRoll(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectClearTemp(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectChangeOwner(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectDraw(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        int8 value = Ability.getValue(ability_key);
        if (is_card) {
            bytes32 player_key = CardOnBoards.getPlayerId(target);
            GameLogicLib.DrawCard(player_key, value);
        } else {
            GameLogicLib.DrawCard(target, value);
        }
    }

    function EffectAddAbility(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //target.AddAbility(ability_key);
        if (is_card) {
            CardOnBoards.pushAbility(target, ability_key);
        }
    }

    function EffectRemoveTrait(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectDiscard(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectDestroyEquip(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectExhaust(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectRemoveAbility(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectTransform(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        if (is_card) {
            //logic.TransformCard(target, transform_to);
        }
        //todo
    }

    function EffectMana(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        int8 curr_mana = Players.getMana(target) + Ability.getValue(ability_key);
        Players.setMana(target, curr_mana);
        if (Players.getMana(target) < 0) {
            Players.setMana(target, 0);
        }
    }

    function EffectResetStat(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectDestroy(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

    function EffectShuffle(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) internal {
        //todo
    }

//    function getDoEffectToCardSelector() public pure returns (bytes4) {
//        return bytes4(keccak256("DoEffectToCard(bytes32,bytes32,bytes32)"));
//    }

}