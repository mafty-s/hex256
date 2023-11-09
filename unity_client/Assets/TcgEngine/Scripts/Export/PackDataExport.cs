using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

#if UNITY_EDITOR
namespace TcgEngine
{
    public class PackDataExporter
    {
        [MenuItem("TcgEngine/Export PackData to CSV")]
        public static void ExportPackDataToCSV()
        {
            string directoryPath = "Assets/Export"; // CSV文件保存目录
            string filePath = Path.Combine(directoryPath, "PackData.csv"); // CSV文件保存路径

            PackData.Load(); // 加载数据
            
            List<PackData> packList = PackData.pack_list;

            // 创建目录
            Directory.CreateDirectory(directoryPath);

            using (StreamWriter sw = new StreamWriter(filePath))
            {
                // 写入表头
                sw.WriteLine("ID,Type,Cards,Rarities_1st,Rarities,Variants,Title,Description,SortOrder,Available,Cost,PackImg,CardBackImg");

                // 写入数据行
                foreach (PackData packData in packList)
                {
                    string rarities1st = GetPackRaritiesString(packData.rarities_1st);
                    string rarities = GetPackRaritiesString(packData.rarities);
                    string variants = GetPackVariantsString(packData.variants);
                    
                    string pack_img = (packData.pack_img != null) ? AssetDatabase.GetAssetPath(packData.pack_img) : "";
                    string cardback_img = (packData.cardback_img != null) ? AssetDatabase.GetAssetPath(packData.cardback_img) : "";


                    sw.WriteLine(string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12}",
                        packData.id,
                        packData.type,
                        packData.cards,
                        rarities1st,
                        rarities,
                        variants,
                        packData.title,
                        packData.desc,
                        packData.sort_order,
                        packData.available,
                        packData.cost,
                        pack_img,
                        cardback_img
                        ));
                    }
            }

            Debug.Log("PackData exported to CSV: " + filePath);
        }

        private static string GetPackRaritiesString(PackRarity[] rarities)
        {
            string raritiesString = "";
            foreach (PackRarity packRarity in rarities)
            {
                raritiesString += packRarity.rarity.id + ":" + packRarity.probability + "|";
            }
            raritiesString = raritiesString.TrimEnd('|');
            return raritiesString;
        }

        private static string GetPackVariantsString(PackVariant[] variants)
        {
            string variantsString = "";
            foreach (PackVariant packVariant in variants)
            {
                variantsString += packVariant.variant.id + ":" + packVariant.probability + "|";
            }
            variantsString = variantsString.TrimEnd('|');
            return variantsString;
        }
    }
}
#endif