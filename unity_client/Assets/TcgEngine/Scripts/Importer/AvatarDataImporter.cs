using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

namespace TcgEngine
{
    public static class AvatarDataImporter
    {
        [MenuItem("TcgEngine/Import AvatarData from CSV")]
        public static void ImportFromCSV()
        {
            string filePath = "Assets/Export/AvatarData.csv"; // CSV文件路径
            
            string[] lines = File.ReadAllLines(filePath);

            // 读取表头
            string headerLine = lines[0];
            string[] headers = headerLine.Split(',');

            // 确定字段索引
            int idIndex = Array.IndexOf(headers, "ID");
            int avatarIndex = Array.IndexOf(headers, "Avatar");
            int sortOrderIndex = Array.IndexOf(headers, "SortOrder");

            // 创建 AvatarData 对象列表
            List<AvatarData> avatarList = new List<AvatarData>();

            // 读取数据行
            for (int i = 1; i < lines.Length; i++)
            {
                string dataLine = lines[i];
                string[] data = dataLine.Split(',');

                // 解析数据
                string id = data[idIndex];
                string iconPath = data[avatarIndex];
                int sortOrder = int.Parse(data[sortOrderIndex]);

                // 创建 AvatarData 对象
                AvatarData avatarData = ScriptableObject.CreateInstance<AvatarData>();
                avatarData.id = id;
                //avatarData.avatar = Resources.Load<Sprite>(avatarName);
                avatarData.avatar = AssetDatabase.LoadAssetAtPath<Sprite>(iconPath);
                avatarData.sort_order = sortOrder;

                avatarList.Add(avatarData);
            }

            // 保存导入的数据
            foreach (AvatarData avatarData in avatarList)
            {
                string assetPath = "Assets/TcgEngine/Resources/Avatars/" + avatarData.id + ".asset";
                AssetDatabase.CreateAsset(avatarData, assetPath);
            }

            // 刷新资源数据库以使新创建的 ScriptableObject 文件在项目中可见
            AssetDatabase.Refresh();

            Debug.Log("AvatarData imported from CSV: " + filePath);
        }
    }
}