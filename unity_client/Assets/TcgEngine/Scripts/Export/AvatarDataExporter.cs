using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

namespace TcgEngine
{
    public static class AvatarDataExporter
    {
        [MenuItem("TcgEngine/Export AvatarData to CSV")]
        public static void ExportToCSV()
        {
            string directoryPath = "Assets/Export"; // CSV文件保存目录
            string filePath = Path.Combine(directoryPath, "AvatarData.csv"); // CSV文件保存路径
            
            AvatarData.Load(); // 加载数据
            
            List<AvatarData> avatarList = AvatarData.GetAll();
            
            // 创建目录
            Directory.CreateDirectory(directoryPath);
            
            using (StreamWriter sw = new StreamWriter(filePath))
            {
                // 写入表头
                sw.WriteLine("ID,Avatar,SortOrder");
                
                // 写入数据行
                foreach (AvatarData avatarData in avatarList)
                {
                    sw.WriteLine(string.Format("{0},{1},{2}", avatarData.id, avatarData.avatar.name, avatarData.sort_order));
                }
            }
            
            Debug.Log("AvatarData exported to CSV: " + filePath);
        }
    }
}
