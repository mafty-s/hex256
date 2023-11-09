using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

#if UNITY_EDITOR
namespace TcgEngine
{
    public static class RarityDataImporter
    {
        [MenuItem("TcgEngine/Import RarityData from CSV")]
        public static void ImportFromCSV()
        {
            string filePath = "Assets/Export/RarityData.csv"; // CSV文件路径

            string[] lines = File.ReadAllLines(filePath);

            // 读取表头
            string headerLine = lines[0];
            string[] headers = headerLine.Split(',');

            // 确定字段索引
            int idIndex = Array.IndexOf(headers, "ID");
            int titleIndex = Array.IndexOf(headers, "Title");
            int rankIndex = Array.IndexOf(headers, "Rank");
            int iconIndex = Array.IndexOf(headers, "Icon");

            // 创建 RarityData 对象列表
            List<RarityData> rarityList = new List<RarityData>();

            // 读取数据行
            for (int i = 1; i < lines.Length; i++)
            {
                string dataLine = lines[i];
                string[] data = dataLine.Split(',');

                // 解析数据
                string id = data[idIndex];
                string title = data[titleIndex];
                int rank = int.Parse(data[rankIndex]);
                string iconPath = data[iconIndex];

                // 创建 RarityData 对象
                RarityData rarityData = ScriptableObject.CreateInstance<RarityData>();
                rarityData.id = id;
                rarityData.title = title;
                rarityData.rank = rank;
                rarityData.icon = AssetDatabase.LoadAssetAtPath<Sprite>(iconPath);

                rarityList.Add(rarityData);
            }

            // 保存导入的数据
            foreach (RarityData rarityData in rarityList)
            {
                string assetPath = "Assets/TcgEngine/Resources/Rarities/" +rarityData.rank + "-" + rarityData.id + ".asset";
                AssetDatabase.CreateAsset(rarityData, assetPath);
            }

            // 刷新资源数据库以使新创建的 ScriptableObject 文件在项目中可见
            AssetDatabase.Refresh();

            Debug.Log("RarityData imported from CSV: " + filePath);
        }
    }
}
#endif