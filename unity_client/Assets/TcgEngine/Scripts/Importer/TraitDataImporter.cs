using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

namespace TcgEngine
{
    public static class TraitDataImporter
    {
        [MenuItem("TcgEngine/Import TraitData from CSV")]
        public static void ImportFromCSV()
        {
            string filePath = "Assets/Export/TraitData.csv"; // CSV文件路径

            string[] lines = File.ReadAllLines(filePath);

            // 读取表头
            string headerLine = lines[0];
            string[] headers = headerLine.Split(',');

            // 确定字段索引
            int idIndex = Array.IndexOf(headers, "id");
            int titleIndex = Array.IndexOf(headers, "title");
            int iconIndex = Array.IndexOf(headers, "icon");

            // 创建 TraitData 对象列表
            List<TraitData> traitList = new List<TraitData>();

            // 读取数据行
            for (int i = 1; i < lines.Length; i++)
            {
                string dataLine = lines[i];
                string[] data = dataLine.Split(',');

                // 解析数据
                string id = data[idIndex];
                string title = data[titleIndex];
                Sprite icon = GetSprite(data[iconIndex]);

                // 创建 TraitData 对象
                TraitData traitData = ScriptableObject.CreateInstance<TraitData>();
                traitData.id = id;
                traitData.title = title;
                traitData.icon = icon;

                traitList.Add(traitData);
            }

            // 保存导入的数据
            foreach (TraitData traitData in traitList)
            {
                string assetPath = "Assets/TcgEngine/Resources/Traits/" + traitData.id + ".asset";
                AssetDatabase.CreateAsset(traitData, assetPath);
            }

            // 刷新资源数据库以使新创建的 ScriptableObject 文件在项目中可见
            AssetDatabase.Refresh();

            Debug.Log("TraitData imported from CSV: " + filePath);
        }

        private static Sprite GetSprite(string spritePath)
        {
            if (string.IsNullOrEmpty(spritePath))
            {
                return null;
            }
            
            Sprite sprite = AssetDatabase.LoadAssetAtPath<Sprite>(spritePath);
            
            return sprite;
        }
    }
}