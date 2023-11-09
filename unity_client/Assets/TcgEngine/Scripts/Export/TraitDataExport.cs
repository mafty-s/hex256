using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

#if UNITY_EDITOR
namespace TcgEngine
{
    public class TraitDataExport
    {
        
        [MenuItem("TcgEngine/Export TraitData to CSV")]
        public static void ExportToCSV()
        {
            string filePath = "Assets/Export/TraitData.csv";

            TraitData.Load(); // 加载数据

            List<TraitData> trait_list = TraitData.trait_list;

            using (StreamWriter sw = new StreamWriter(filePath))
            {
                sw.WriteLine("id,title,icon");

                foreach (TraitData trait in trait_list)
                {
                    string iconPath = (trait.icon != null) ? AssetDatabase.GetAssetPath(trait.icon) : "";
                    sw.WriteLine(string.Format("{0},{1},{2}", trait.id, trait.title, iconPath));
                }
            }

            Debug.Log("TraitData exported to TraitData.csv");
        }
    }
}
#endif