using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEditor;
using System.Threading.Tasks;
using TcgEngine;


[System.Serializable]
public class MudPlayCard
{
    public string card_uid;
    public int slot_x;
    public int slot_y;
    public int slot_p;
}


[System.Serializable]
public class MovePlayCard
{
    public string card_uid;
    public int slot_x;
    public int slot_y;
    public int slot_p;
}


[System.Serializable]
public class MudUserData
{
    public string owner;
    public int coin;
    public int xp;
    public int createdAt;
    public string[] cards;
    public string[] packs;
    public string id;
    public string avatar;
    public string cardback;
}


[System.Serializable]
public class MudPlayerSettingResult
{
    public string player_name;
    public string[] cards;
    public string[] hand;
    public string[] deck;
    public string[] board;
    public string[] all;
}

public class MudManager : MonoBehaviour
{
    public bool useMud = false;

    private static MudManager instance;
    public string msg = "";
    private Dictionary<string, string> names = new Dictionary<string, string>();

    public static MudManager Get()
    {
        return instance;
    }

    void Awake()
    {
        instance = this;
        DontDestroyOnLoad(gameObject);
    }

    public static string GetCommandString(ushort code)
    {
        switch (code)
        {
            case 0:
                return "None";
            case 1000:
                return "PlayCard";
            case 1010:
                return "Attack";
            case 1012:
                return "AttackPlayer";
            case 1015:
                return "Move";
            case 1020:
                return "CastAbility";
            case 1030:
                return "SelectCard";
            case 1032:
                return "SelectPlayer";
            case 1034:
                return "SelectSlot";
            case 1036:
                return "SelectChoice";
            case 1039:
                return "CancelSelect";
            case 1040:
                return "EndTurn";
            case 1050:
                return "Resign";
            case 1090:
                return "ChatMessage";
            case 1100:
                return "PlayerSettings";
            case 1102:
                return "PlayerSettingsAI";
            case 1105:
                return "GameSettings";
            case 2000:
                return "Connected";
            case 2001:
                return "PlayerReady";
            case 2010:
                return "GameStart";
            case 2012:
                return "GameEnd";
            case 2015:
                return "NewTurn";
            case 2020:
                return "CardPlayed";
            case 2022:
                return "CardSummoned";
            case 2023:
                return "CardTransformed";
            case 2025:
                return "CardDiscarded";
            case 2026:
                return "CardDrawn";
            case 2027:
                return "CardMoved";
            case 2030:
                return "AttackStart";
            case 2032:
                return "AttackEnd";
            case 2034:
                return "AttackPlayerStart";
            case 2036:
                return "AttackPlayerEnd";
            case 2040:
                return "AbilityTrigger";
            case 2042:
                return "AbilityTargetCard";
            case 2043:
                return "AbilityTargetPlayer";
            case 2044:
                return "AbilityTargetSlot";
            case 2048:
                return "AbilityEnd";
            case 2060:
                return "SecretTriggered";
            case 2061:
                return "SecretResolved";
            case 2070:
                return "ValueRolled";
            case 2190:
                return "ServerMessage";
            case 2100:
                return "RefreshAll";
            default:
                return "Unknown";
        }
    }

#if !UNITY_EDITOR && UNITY_WEBGL
    [DllImport("__Internal")]
    private static extern bool hasMudInstalled();

    [DllImport("__Internal")]
    private static extern void addTask(string msg);
    
    [DllImport("__Internal")]
    private static extern void getUser();

    [DllImport("__Internal")]
    private static extern void doApiTask(string url,string json_data);
    
    [DllImport("__Internal")]
    private static extern void buyCard(string card_id,int q);

    [DllImport("__Internal")]
    private static extern void sellCard(string card_id,int q);

    [DllImport("__Internal")]
    private static extern void buyPack(string pack_id,int q);
    
    [DllImport("__Internal")]
    private static extern void openPack(string pack_id);

    [DllImport("__Internal")]
    private static extern string calculateKeccak256Hash(string name);

    [DllImport("__Internal")]
    private static extern string gameSetting(string game_uid);
    
    [DllImport("__Internal")]
    private static extern string playerSetting(string username, string game_uid, string deck_id,bool is_ai,int hp,int mana,int dcards);
    
    [DllImport("__Internal")]
    private static extern string playCard(string game_id, string player_id, string card_id, int slot_x, int slot_y, int slot_p,bool skip_cost,string card_key);

    [DllImport("__Internal")]
    private static extern string moveCard(string game_id, string player_id, string card_id, int slot_x, int slot_y, int slot_p,bool skip_cost,string card_key);

    [DllImport("__Internal")]
    private static extern string saveDeck(string tid, string name, string cards);
    
    [DllImport("__Internal")]
    private static extern string attackCard(string game_id, string player_id, string attacker_id,string target_id);

#endif

    public static void SendTask(ushort code)
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        string msg = GetCommandString(code);
            addTask(msg);
#endif
    }

    void Start()
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        this.useMud = hasMudInstalled();

        if (useMud == false)
        {
            return;
        }
        getUser();

        CardData.Load(); // 加载数据

        List<CardData> cardList = new List<CardData>(CardData.card_dict.Values);
        foreach (CardData cardData in cardList)
        {
            names.Add(calculateKeccak256Hash(cardData.id), cardData.id);
        }
        
        PackData.Load(); // 加载数据

        List<PackData> packList = new List<PackData>(PackData.pack_list);
        foreach (PackData packData in packList)
        {
            names.Add(calculateKeccak256Hash(packData.id), packData.id);
        }
#endif
    }

    public void OnUser(string msg)
    {
        if (useMud == false)
        {
            return;
        }

        this.msg = msg;
        Debug.Log("user from MudManager onUser :" + msg);
    }

    public void PrintUser()
    {
        if (useMud == false)
        {
            return;
        }

        Debug.Log(this.msg);
    }

    public MudUserData GetUserData()
    {
        if (useMud == false)
        {
            return null;
        }

        MudUserData playerData = JsonUtility.FromJson<MudUserData>(this.msg);

        // Access the decoded data
        Debug.Log("Owner: " + playerData.owner);
        Debug.Log("Coins: " + playerData.coin);
        Debug.Log("XP: " + playerData.xp);
        Debug.Log("Created At: " + playerData.createdAt);
        Debug.Log("ID: " + playerData.id);
        Debug.Log("Avatar: " + playerData.avatar);
        Debug.Log("Cardback: " + playerData.cardback);

        return playerData;
    }

    public void BuyCard(string card_id, int q)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        buyCard(card_id,q);
#endif
    }

    public void SellCard(string card_id, int q)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        sellCard(card_id,q);
#endif
    }

    public void BuyPack(string pack_id, int q)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        buyPack(pack_id,q);
#endif
    }

    public void OpenPack(string pack_id)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        openPack(pack_id);
#endif
    }

    public void DoApiTask(string url, string json_data)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        doApiTask(url,json_data);
#endif
    }

    public void GameSetting(string game_uid, int nb_players, string level)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        gameSetting(game_uid);
#endif
    }

    public void PlayerSetting(string username, string game_uid, string deck_id, bool is_ai, int hp, int mana,
        int dcards)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        playerSetting(username,game_uid,deck_id,is_ai,hp,mana,dcards);
#endif
    }

    public string GetCardIdByHex(string hex)
    {
        if (names.ContainsKey(hex))
        {
            return names[hex];
        }
        else
        {
            return "Unknown";
        }
    }

    //game_id, player_id, card_id, slot, skip_cost
    public void PlayCard(string game_id, string player_id, string card_id, int slot_x, int slot_y, int slot_p,
        bool skip_cost, string card_key)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        playCard(game_id,player_id,card_id,slot_x,slot_y,slot_p,skip_cost,card_key);
#endif
    }

    public void MoveCard(string game_id, string player_id, string card_id, int slot_x, int slot_y, int slot_p,
        bool skip_cost, string card_key)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        moveCard(game_id,player_id,card_id,slot_x,slot_y,slot_p,skip_cost,card_key);
#endif
    }

    public void AttackCard(string game_id, string player_id, string attacker_id, string target_id)
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        attackCard(game_id,player_id,attacker_id,target_id);
#endif
    }

    public void AttackPlayer(string game_uid,string attacker_id,int target_id)
    {
        
    }

    public void CastAbility()
    {
    }

    public void EndTurn(string game_uid, string player_name)
    {
        
    }

    public void SaveDeck(string tid, string hero, string cards)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        saveDeck(tid,hero,cards);
#endif
    }
}