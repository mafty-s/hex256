using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

namespace TcgEngine
{
    public static class CardDataImporter
    {
        [MenuItem("TcgEngine/Import CardData from CSV")]
        public static void ImportFromCSV()
        {
            string filePath = "Assets/Export/CardData.csv"; // CSV文件路径

            string[] lines = File.ReadAllLines(filePath);

            // 读取表头
            string headerLine = lines[0];
            string[] headers = headerLine.Split(',');

            // 确定字段索引
            int idIndex = Array.IndexOf(headers, "ID");
            int titleIndex = Array.IndexOf(headers, "Title");
            int typeIndex = Array.IndexOf(headers, "Type");
            int teamIndex = Array.IndexOf(headers, "Team");
            int rarityIndex = Array.IndexOf(headers, "Rarity");
            int manaIndex = Array.IndexOf(headers, "Mana");
            int attackIndex = Array.IndexOf(headers, "Attack");
            int hpIndex = Array.IndexOf(headers, "HP");
            int traitsIndex = Array.IndexOf(headers, "Traits");
            int abilitiesIndex = Array.IndexOf(headers, "Abilities");
            int textIndex = Array.IndexOf(headers, "Text");
            int descIndex = Array.IndexOf(headers, "Description");
            int deckbuildingIndex = Array.IndexOf(headers, "DeckBuilding");
            int costIndex = Array.IndexOf(headers, "Cost");
            int packsIndex = Array.IndexOf(headers, "Packs");
            int artFullIndex = Array.IndexOf(headers, "ArtFull");
            int artBoardIndex = Array.IndexOf(headers, "ArtBoard");

            // 创建 CardData 对象列表
            List<CardData> cardList = new List<CardData>();

            // 读取数据行
            for (int i = 1; i < lines.Length; i++)
            {
                string dataLine = lines[i];
                string[] data = dataLine.Split(',');

                // 解析数据
                string id = data[idIndex];
                string title = data[titleIndex];
                CardType type = (CardType)Enum.Parse(typeof(CardType), data[typeIndex]);
                TeamData team = GetTeamData(data[teamIndex]);
                RarityData rarity = GetRarityData(data[rarityIndex]);
                int mana = int.Parse(data[manaIndex]);
                int attack = int.Parse(data[attackIndex]);
                int hp = int.Parse(data[hpIndex]);
                TraitData[] traits = GetTraitDataArray(data[traitsIndex]);
                AbilityData[] abilities = GetAbilityDataArray(data[abilitiesIndex]);
                string text = data[textIndex];
                string desc = data[descIndex];
                bool deckbuilding = bool.Parse(data[deckbuildingIndex]);
                int cost = int.Parse(data[costIndex]);
                PackData[] packs = GetPackDataArray(data[packsIndex]);
                Sprite artFull = GetSprite(data[artFullIndex]);
                Sprite artBoard = GetSprite(data[artBoardIndex]);

                // 创建 CardData 对象
                CardData cardData = ScriptableObject.CreateInstance<CardData>();
                cardData.id = id;
                cardData.title = title;
                cardData.type = type;
                cardData.team = team;
                cardData.rarity = rarity;
                cardData.mana = mana;
                cardData.attack = attack;
                cardData.hp = hp;
                cardData.traits = traits;
                cardData.abilities = abilities;
                cardData.text = text;
                cardData.desc = desc;
                cardData.deckbuilding = deckbuilding;
                cardData.cost = cost;
                cardData.packs = packs;
                cardData.art_full = artFull;
                cardData.art_board = artBoard;

                cardList.Add(cardData);
            }

            // 保存导入的数据
            foreach (CardData cardData in cardList)
            {
                string assetPath = "Assets/TcgEngine/Resources/CardData/" + cardData.id + ".asset";
                AssetDatabase.CreateAsset(cardData, assetPath);
            }

            // 刷新资源数据库以使新创建的 ScriptableObject 文件在项目中可见
            AssetDatabase.Refresh();

            Debug.Log("CardData imported from CSV: " + filePath);
        }

        private static TeamData GetTeamData(string teamName)
        {
            return Resources.Load<TeamData>("Teams/" + teamName);
        }

        private static RarityData GetRarityData(string rarityName)
        {
            return Resources.Load<RarityData>("RarityData/" + rarityName);
        }

        private static AbilityData[] GetAbilityDataArray(string abilities)
        {
            string[] abilityIds = abilities.Split('|');
            AbilityData[] abilityDataArray = new AbilityData[abilityIds.Length];

            for (int i = 0; i < abilityIds.Length; i++)
            {
                string abilityId = abilityIds[i];
                abilityDataArray[i] = Resources.Load<AbilityData>("Abilities/" + abilityId);
            }

            return abilityDataArray;
        }
        
        private static TraitData[] GetTraitDataArray(string traits)
        {
            string[] traitIds = traits.Split('|');
            TraitData[] traitDataArray = new TraitData[traitIds.Length];

            for (int i = 0; i < traitIds.Length; i++)
            {
                string traitId = traitIds[i];
                traitDataArray[i] = Resources.Load<TraitData>("Traits/" + traitId);
            }

            return traitDataArray;
        }

        private static PackData[] GetPackDataArray(string packs)
        {
            string[] packIds = packs.Split('|');
            PackData[] packDataArray = new PackData[packIds.Length];

            for (int i = 0; i < packIds.Length; i++)
            {
                string packId = packIds[i];
                packDataArray[i] = Resources.Load<PackData>("Packs/" + packId);
            }

            return packDataArray;
        }
        
        private static Sprite GetSprite(string spriteName)
        {
            string spritePath = "Sprites/" + spriteName; // Path to the sprite asset

            // Load the sprite from the Resources folder
            Sprite sprite = Resources.Load<Sprite>(spritePath);

            return sprite;
        }
    }
}