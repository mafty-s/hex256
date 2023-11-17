// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {Decks, DecksData} from "../codegen/index.sol";
import {Matches, MatchesData} from "../codegen/index.sol";
import {Players, PlayersData} from "../codegen/index.sol";
import {PlayerCardsDeck, PlayerCardsHand} from "../codegen/index.sol";
import {CardOnBoards, CardOnBoardsData} from "../codegen/index.sol";

import {GameType, GameState, GamePhase} from "../codegen/common.sol";

//import "../logic/PlayerLogicLib.sol";
//import "../logic/CardLogicLib.sol";
//
import "../libs/BaseLogicLib.sol";
import "../libs/GameLogicLib.sol";

import {Slot} from "../libs/SlotLib.sol";

contract MoveSystem is System {

    constructor() {

    }

    function Move(bytes32 card_key, Slot memory slot) public {

        if (BaseLogicLib.CanMoveCard(card_key, slot)) {
            //todo

            GameLogicLib.UpdateOngoing();
        }


        //        if (game_data.CanMoveCard(card, slot, skip_cost))
        //        {
        //            card.slot = slot;
        //
        //            //Moving doesn't really have any effect in demo so can be done indefinitely
        //            //if(!skip_cost)
        //            //card.exhausted = true;
        //            //card.RemoveStatus(StatusEffect.Stealth);
        //            //player.AddHistory(GameAction.Move, card);
        //
        //            //Also move the equipment
        //            Card equip = game_data.GetEquipCard(card.equipped_uid);
        //            if (equip != null)
        //                equip.slot = slot;
        //
        //
        //            onCardMoved?.Invoke(card, slot);
        //            resolve_queue.ResolveAll(0.2f);
        //        }
    }


}