// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {CardOnBoards, CardOnBoardsData} from "../codegen/index.sol";
import {Games, Cards, CardsData} from "../codegen/index.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {MathLib} from "./MathLib.sol";
import {CardType, GameType, GameState, GamePhase, PackType, RarityType, Status} from "../codegen/common.sol";

library GameLogicLib {

    function DamageCard(bytes32 attacker, bytes32 target, int8 value, bool spell_damage) internal {
        if (CardLogicLib.HasStatus(target, Status.INVINCIBILITY)) {
            return;
        }
        bytes32 attack_card_config_key = CardOnBoards.getId(attacker);
        if (CardLogicLib.HasStatus(target, Status.SPELL_IMMUNITY) && Cards.getCardType(attack_card_config_key) != CardType.CHARACTER) {
            return;
        }

        //Shell
        bool doublelife = CardLogicLib.HasStatus(target, Status.SHELL);
        if (doublelife && value > 0) {
            CardLogicLib.RemoveStatus(target, Status.SHELL);
            return;
        }

        //Armor
        if (!spell_damage && CardLogicLib.HasStatus(target, Status.ARMOR)) {
            //todo value = Mathf.Max(value - target.GetStatusValue(StatusType.Armor), 0);
        }

        //Damage
        int8 target_hp = CardOnBoards.getHp(target);
        int8 damage_max = MathLib.min_int8(value, target_hp);
        int8 extra = value - target_hp;
        CardOnBoards.setDamage(target, value + CardOnBoards.getDamage(target));

        //Remove sleep on damage
        //todo target.RemoveStatus(StatusType.Sleep);


    }

    function DamagePlayer(bytes32 player, uint256 value) internal {
        //        player.hp -= value;
        //        player.hp = Math.clamp(player.hp, 0, player.hp_max);
        //todo
    }

    function UpdateOngoing() internal {
        //todo
    }

    function HealCard(bytes32 target, int8 value) internal {
        //todo
    }

    function EquipCard(bytes32 card, bytes32 equipment) internal {
        //todo
    }

    function DrawCard(bytes32 player, int8 card_number) internal {
        //todo
    }

    function CheckForWinner(bytes32 game_key) internal {
        uint8 count_alive = 0;
        bytes32 alive = 0;
        bytes32[] memory players = Games.getPlayers(game_key);
        for (uint8 i = 0; i < players.length; i++) {
            bytes32 player = players[i];
            if (!PlayerLogicLib.IsDead(player)) {
                alive = player;
                count_alive++;
            }
        }
        if (count_alive == 0) {
            EndGame(game_key, 0);
        } else if (count_alive == 1) {
            EndGame(game_key, alive);
        }
    }

    function EndGame(bytes32 game_key, bytes32 winner) internal {
//        if (game_data.state != GameState.GameEnded)
//        {
//            game_data.state = GameState.GameEnded;
//            game_data.phase = GamePhase.None;
//            game_data.selector = SelectorType.None;
//            game_data.current_player = winner; //Winner player
//            resolve_queue.Clear();
//            Player player = game_data.GetPlayer(winner);
//            onGameEnd?.Invoke(player);
//        }
        //todo
        if (Games.getGameState(game_key) != GameState.GAME_ENDED) {
            Games.setGameState(game_key, GameState.GAME_ENDED);
            Games.setGamePhase(game_key, GamePhase.NONE);
            Games.setCurrentPlayer(game_key, winner);
        }
    }

    ////Heal a card
    //public virtual void HealCard(Card target, int value)
    //{
    //if (target == null)
    //return;
    //
    //if (target.HasStatus(StatusType.Invincibility))
    //return;
    //
    //target.damage -= value;
    //target.damage = Mathf.Max(target.damage, 0);
    //}

}