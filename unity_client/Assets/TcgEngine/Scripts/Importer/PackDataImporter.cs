using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

namespace TcgEngine
{
    public static class PackDataImporter
    {
        [MenuItem("TcgEngine/Import PackData from CSV")]
        public static void ImportFromCSV()
        {
            string filePath = "Assets/Export/PackData.csv"; // CSV文件路径

            string[] lines = File.ReadAllLines(filePath);

            // 读取表头
            string headerLine = lines[0];
            string[] headers = headerLine.Split(',');

            // 确定字段索引
            int idIndex = Array.IndexOf(headers, "ID");
            int typeIndex = Array.IndexOf(headers, "Type");
            int cardsIndex = Array.IndexOf(headers, "Cards");
            int rarities1stIndex = Array.IndexOf(headers, "Rarities_1st");
            int raritiesIndex = Array.IndexOf(headers, "Rarities");
            int variantsIndex = Array.IndexOf(headers, "Variants");
            int titleIndex = Array.IndexOf(headers, "Title");
            int descIndex = Array.IndexOf(headers, "Description");
            int sortOrderIndex = Array.IndexOf(headers, "SortOrder");
            int availableIndex = Array.IndexOf(headers, "Available");
            int costIndex = Array.IndexOf(headers, "Cost");
            int packImgIndex = Array.IndexOf(headers, "PackImg");
            int cardBackImgIndex = Array.IndexOf(headers, "CardBackImg");

            // 创建 PackData 对象列表
            List<PackData> packList = new List<PackData>();

            // 读取数据行
            for (int i = 1; i < lines.Length; i++)
            {
                string dataLine = lines[i];
                string[] data = dataLine.Split(',');

                // 解析数据
                string id = data[idIndex];
                PackType type = (PackType)Enum.Parse(typeof(PackType), data[typeIndex]);
                int cards = int.Parse(data[cardsIndex]);

                PackRarity[] rarities1st = ParsePackRarities(data[rarities1stIndex]);
                PackRarity[] rarities = ParsePackRarities(data[raritiesIndex]);
                PackVariant[] variants = ParsePackVariants(data[variantsIndex]);

                string title = data[titleIndex];
                string desc = data[descIndex];
                int sortOrder = int.Parse(data[sortOrderIndex]);
                bool available = bool.Parse(data[availableIndex]);
                int cost = int.Parse(data[costIndex]);

                Sprite packImg = null;
                if (!string.IsNullOrEmpty(data[packImgIndex]))
                    packImg = AssetDatabase.LoadAssetAtPath<Sprite>(data[packImgIndex]);

                Sprite cardBackImg = null;
                if (!string.IsNullOrEmpty(data[cardBackImgIndex]))
                    cardBackImg = AssetDatabase.LoadAssetAtPath<Sprite>(data[cardBackImgIndex]);

                // 创建 PackData 对象
                PackData packData = ScriptableObject.CreateInstance<PackData>();
                packData.id = id;
                packData.type = type;
                packData.cards = cards;
                packData.rarities_1st = rarities1st;
                packData.rarities = rarities;
                packData.variants = variants;
                packData.title = title;
                packData.desc = desc;
                packData.sort_order = sortOrder;
                packData.available = available;
                packData.cost = cost;
                packData.pack_img = packImg;
                packData.cardback_img = cardBackImg;

                packList.Add(packData);
            }

            // 保存导入的数据
            foreach (PackData packData in packList)
            {
                string assetPath = "Assets/PackData/" + packData.id + ".asset";
                AssetDatabase.CreateAsset(packData, assetPath);
            }

            // 刷新资源数据库以使新创建的 ScriptableObject 文件在项目中可见
            AssetDatabase.Refresh();

            Debug.Log("PackData imported from CSV: " + filePath);
        }

        private static PackRarity[] ParsePackRarities(string raritiesString)
        {
            string[] rarityData = raritiesString.Split(',');
            PackRarity[] rarities = new PackRarity[rarityData.Length];

            for (int i = 0; i < rarityData.Length; i++)
            {
                string[] rarityInfo = rarityData[i].Split(':');
                string rarity = rarityInfo[0];
                int probability = int.Parse(rarityInfo[1]);

                PackRarity packRarity = new PackRarity();
                 
                packRarity.rarity = ScriptableObject.CreateInstance<RarityData>();
                packRarity.probability = probability;

                rarities[i] = packRarity;
            }

            return rarities;
        }
        
        private static PackVariant[] ParsePackVariants(string variantsString)
        {
            string[] variantData = variantsString.Split(',');
            PackVariant[] variants = new PackVariant[variantData.Length];

            for (int i = 0; i < variantData.Length; i++)
            {
                string[] variantInfo = variantData[i].Split(':');
                string variant = variantInfo[0];
                float probability = float.Parse(variantInfo[1]);

                PackVariant packVariant = new PackVariant();
                //packVariant.variant = variant;
                //packVariant.probability = probability;

                variants[i] = packVariant;
            }

            return variants;
        }
    }
}