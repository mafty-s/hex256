using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using TcgEngine;
using UnityEngine;
using UnityEditor;
using LitJson;

[System.Serializable]
public class MudCardInfo
{
    public string key;
    public int slot;
    public int hp;
    public int hpOngoing;
    public int attack;
    public int attackOngoing;
    public int mana;
    public int manaOngoing;
    public int damage;
    public bool exhausted;
    public string equippedUid;
    public string id;
    public string playerId;
    public string[] status;
    public string[] ability;
    public string[] trait;
}

public class MudPlayerInfo
{
    public string owner;
    public int hp;
    public int mana;
    public int hpMax;
    public int manaMax;
    public bool isAI;
    public int dcards;
    public string game;
    public string name;
    public string[] deck;
    public string[] status;
    public string[] hand;
}

[System.Serializable]
public class MudGame
{
    public int gameType;
    public int gameState;
    public int gamePhase;
    public string firstPlayer;
    public string currentPlayer;
    public int turnCount;
    public int nbPlayer;
    public string level;
    public string uid;
    public string[] players;
    public MudPlayerInfo[] player_objs;
    public MudCardInfo[] cards;

    public static MudGame FromJson(string str)
    {
        return JsonHelper.FromJson<MudGame>(str) as MudGame;
    }
}

public static class JsonHelper
{
    public static T FromJson<T>(string str)
    {
        T t = JsonMapper.ToObject<T>(str);
        ISupportInitialize iS = t as ISupportInitialize;
        if (iS == null)
        {
            return t;
        }

        iS.EndInit();
        return t;
    }

    public static object FromJson(Type type, string str)
    {
        object t = JsonMapper.ToObject<Type>(str);
        ISupportInitialize iS = t as ISupportInitialize;
        if (iS == null)
        {
            return t;
        }

        iS.EndInit();
        return t;
    }
}

public class MudRefresh
{
    public static void RefreshGame(MudGame mud_game, TcgEngine.Game gamedata)
    {
        gamedata.turn_count = mud_game.turnCount;
        foreach (var card in mud_game.cards)
        {
            RefreshCard(card, gamedata.GetCard(card.key));
        }

        foreach (var player in mud_game.player_objs)
        {
            int id = getPlayerIdFromName(player.name, gamedata);
            Debug.Log("find player" + player.name + ":" + id);
            if (id != -1)
            {
                RefreshPlayer(player, gamedata.GetPlayer(id), gamedata);
            }
        }
    }

    public static int getPlayerIdFromName(string name, TcgEngine.Game gamedata)
    {
        for (int i = 0; i < gamedata.players.Length; i++)
        {
            if (gamedata.players[i].username == name)
            {
                return i;
            }
        }

        return -1;
    }

    public static void RefreshPlayer(MudPlayerInfo mud_player, TcgEngine.Player player, TcgEngine.Game gamedata)
    {
        Debug.Log("RefreshPlayer");
        Debug.Log(player.mana);
        Debug.Log(mud_player.mana);
        player.hp = mud_player.hp;
        player.hp_max = mud_player.hpMax;
        player.mana = mud_player.mana;
        player.mana_max = mud_player.manaMax;
        player.is_ai = mud_player.isAI;

        player.cards_deck.Clear();
        foreach (var card in mud_player.deck)
        {
            player.cards_deck.Add(gamedata.GetCard(card));
        }

        player.cards_hand.Clear();
        foreach (var card in mud_player.hand)
        {
            player.cards_hand.Add(gamedata.GetCard(card));
        }
    }

    public static void RefreshCard(MudCardInfo mud_card, TcgEngine.Card card)
    {
        Debug.Log("RefreshCard" + mud_card.key);
        card.hp = mud_card.hp;
        card.hp_ongoing = mud_card.hpOngoing;
        card.attack = mud_card.attack;
        card.attack_ongoing = mud_card.attackOngoing;
        card.mana = mud_card.mana;
        card.mana_ongoing = mud_card.manaOngoing;
        card.damage = mud_card.damage;
        card.exhausted = mud_card.exhausted;
        card.equipped_uid = mud_card.equippedUid;
        //card.player_id = mud_card.playerId;
    }
}