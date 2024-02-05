using System.Collections;
using System.Collections.Generic;
using Mud;
using UnityEngine;

namespace Mud
{
/* Autogenerated file. Do not edit manually. */
    enum SelectorType
    {
        None,
        SelectTarget,
        SelectorCard,
        SelectorChoice
    }

    enum RarityType
    {
        COMMON,
        UNCOMMON,
        RARE,
        MYTHIC
    }

    enum PackType
    {
        FIXED,
        RANDOM
    }

    enum TeamType
    {
        FIRE,
        FOREST,
        WATER,
        NEUTRAL
    }

    enum GameType
    {
        SOLO,
        ADVENTURE,
        MULTIPLAYER,
        HOST_P2P,
        OBSERVER
    }

    enum GameMode
    {
        CASUAL,
        RANKED
    }

    enum GameState
    {
        INIT,
        PLAY,
        GAME_ENDED
    }

    enum GamePhase
    {
        NONE,
        START_TURN,
        MAIN,
        END_TURN
    }

    enum CardType
    {
        NONE,
        HERO,
        CHARACTER,
        SPELL,
        ARTIFACT,
        SECRET,
        EQUIPMENT
    }

    enum AbilityTrigger
    {
        NONE,
        ONGOING,
        ACTIVATE,
        ON_PLAY,
        ON_PLAY_OTHER,
        START_OF_TURN,
        END_OF_TURN,
        ON_BEFORE_ATTACK,
        ON_AFTER_ATTACK,
        ON_BEFORE_DEFEND,
        ON_AFTER_DEFEND,
        ON_KILL,
        ON_DEATH,
        ON_DEATH_OTHER
    }

    enum AbilityTarget
    {
        None,
        Self,
        PlayerSelf,
        PlayerOpponent,
        AllPlayers,
        AllCardsBoard,
        AllCardsHand,
        AllCardsAllPiles,
        AllSlots,
        AllCardData,
        PlayTarget,
        AbilityTriggerer,
        EquippedCard,
        SelectTarget,
        CardSelector,
        ChoiceSelector,
        LastPlayed,
        LastTargeted,
        LastDestroyed,
        LastSummoned
    }

    enum Team
    {
        FIRE,
        FOREST,
        WATER,
        NEUTRAL
    }

    enum Action
    {
        PlayCard,
        Attack,
        AttackPlayer,
        Move,
        CastAbility,
        SelectCard,
        SelectPlayer,
        SelectSlot,
        SelectChoice,
        CancelSelect,
        EndTurn,
        ChangeMana,
        AddStatus,
        ChangeCard
    }

    enum PileType
    {
        None,
        Board,
        Hand,
        Deck,
        Discard,
        Secret,
        Equipped,
        Temp
    }

    enum EffectStatType
    {
        None,
        Attack,
        HP,
        Mana
    }

    enum ConditionObjType
    {
        ConditionCardType
    }

    enum TraitData
    {
        Dragon,
        Growth,
        SpellDamage,
        Wolf
    }

    enum EffectAttackerType
    {
        Self,
        AbilityTriggerer,
        LastPlayed,
        LastTargeted
    }

    enum Status
    {
        None,
        Armor,
        Attack,
        Deathtouch,
        Flying,
        Fury,
        Hp,
        Intimidate,
        Invicibility,
        Lifesteal,
        Paralysed,
        Poisoned,
        Protected,
        Shell,
        Silenced,
        Sleep,
        SpellImmunity,
        Stealth,
        Taunt,
        Trample
    }
}

static class MudEnum
{
    public static TcgEngine.StatusType CoverStatus(Mud.Status status)
    {
        switch (status)
        {
            case Status.None:
                return TcgEngine.StatusType.None;
            case Status.Armor:
                return TcgEngine.StatusType.Armor;
            case Status.Paralysed:
                return TcgEngine.StatusType.Paralysed;
        }

        return TcgEngine.StatusType.None;
    }
}