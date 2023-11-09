using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

#if UNITY_EDITOR
namespace TcgEngine
{
    public class AbilityDataExporter
    {
        [MenuItem("TcgEngine/Export AbilityData to CSV")]
        public static void ExportAbilityDataToCSV()
        {
            string directoryPath = "Assets/Export"; // CSV and FX files save directory
            string filePath = Path.Combine(directoryPath, "AbilityData.csv"); // CSV file path

            AbilityData.Load(); // Load the data

            List<AbilityData> abilityList = AbilityData.ability_list;

            // Create the directory if it doesn't exist
            Directory.CreateDirectory(directoryPath);

            using (StreamWriter sw = new StreamWriter(filePath))
            {
                // Write the header
                sw.WriteLine(
                    "ID,Trigger,ConditionsTrigger,Target,FiltersTarget,Effects,Status,Value,Duration,ChainAbilities,ManaCost,Exhaust,Title,Description,BoardFX,CasterFX,TargetFX,CastAudio,TargetAudio,ChargeTarget");

                // Write the data rows
                foreach (AbilityData abilityData in abilityList)
                {
                    string trigger = abilityData.trigger.ToString();
                    string conditionsTrigger = GetConditionsString(abilityData.conditions_trigger);

                    string filtersTarget = GetFilterDataString(abilityData.filters_target);
                    string target = abilityData.target.ToString();
                    string effects = GetEffectsString(abilityData.effects);
                    string status = GetStatusString(abilityData.status);
                    string chainAbilities = GetChainAbilitiesString(abilityData.chain_abilities);

                    sw.WriteLine(string.Format(
                        "{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16},{17},{18},{19}",
                        abilityData.id,
                        trigger,
                        conditionsTrigger,
                        target,
                        filtersTarget,
                        effects,
                        status,
                        abilityData.value,
                        abilityData.duration,
                        chainAbilities,
                        abilityData.mana_cost,
                        abilityData.exhaust,
                        abilityData.title,
                        abilityData.desc.Replace("\"", "").Replace(",", ";"),
                        GetFXPath(abilityData.board_fx),
                        GetFXPath(abilityData.caster_fx),
                        GetFXPath(abilityData.target_fx),
                        GetAudioPath(abilityData.cast_audio),
                        GetAudioPath(abilityData.target_audio),
                        abilityData.charge_target
                    ));
                }
            }

            Debug.Log("AbilityData exported to CSV: " + filePath);
        }

        private static string GetEffectsString(EffectData[] effects)
        {
            string effectsString = "";
            foreach (EffectData effect in effects)
            {
                effectsString += effect.name + "|";
            }

            effectsString = effectsString.TrimEnd('|');
            return effectsString;
        }

        private static string GetStatusString(StatusData[] status)
        {
            string statusString = "";
            foreach (StatusData statusData in status)
            {
                statusString += statusData.name + "|";
            }

            statusString = statusString.TrimEnd('|');
            return statusString;
        }

        private static string GetChainAbilitiesString(AbilityData[] chainAbilities)
        {
            string chainAbilitiesString = "";
            foreach (AbilityData abilityData in chainAbilities)
            {
                chainAbilitiesString += abilityData.id + "|";
            }

            chainAbilitiesString = chainAbilitiesString.TrimEnd('|');
            return chainAbilitiesString;
        }

        private static string GetFXPath(GameObject fx)
        {
            if (fx != null)
            {
                string fxPath = AssetDatabase.GetAssetPath(fx);
                return fxPath;
            }

            return "";
        }

        private static string GetAudioPath(AudioClip audioClip)
        {
            if (audioClip != null)
            {
                string audioPath = AssetDatabase.GetAssetPath(audioClip);
                return audioPath;
            }

            return "";
        }

        private static string GetConditionsString(ConditionData[] conditions)
        {
            string conditionsString = "";
            foreach (ConditionData condition in conditions)
            {
                conditionsString += condition.name + "|";
            }

            conditionsString = conditionsString.TrimEnd('|');
            return conditionsString;
        }

        private static string GetFilterDataString(FilterData[] filters)
        {
            string filterString = "";
            foreach (FilterData filter in filters)
            {
                filterString += filter.name + "|";
            }

            filterString = filterString.TrimEnd('|');
            return filterString;
        }
    }
}
#endif