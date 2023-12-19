using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;

namespace TcgEngine
{
    /// <summary>
    /// Test authenticator just generates a random ID to use as user id
    /// This is very useful to test the game in multiplayer without needing to login each time
    /// Unity Services features won't work in test mode (Relay, Cloud Saves...)
    /// Use Anonymous mode to test those features (after connecting your project ID in services window)
    /// </summary>
    public class AuthenticatorTest : Authenticator
    {
        private UserData udata = null;

        public override async Task<bool> Login(string username)
        {
            this.user_id = username; //User username as ID for save file consistency when testing
            this.username = username;
            logged_in = true;
            await Task.Yield(); //Do nothing
            PlayerPrefs.SetString("tcg_user", username); //Save last user
            return true;
        }

        public override async Task<bool> RefreshLogin()
        {
            // string username = PlayerPrefs.GetString("tcg_user", "");
            // if (!string.IsNullOrEmpty(username))
            // {
            //     bool success = await Login(username);
            //     return success;
            // }

            return false;
        }

        public override async Task<UserData> LoadUserData()
        {
            // string user = PlayerPrefs.GetString("tcg_user", "");
            // string file = username + ".user";
            // if (!string.IsNullOrEmpty(user) && SaveTool.DoesFileExist(file))
            // {
            //     udata = SaveTool.LoadFile<UserData>(file);
            // }


            if (udata == null)
            {
                udata = new UserData();
                udata.username = username;
                udata.id = username;
            }

            Debug.Log("LoadUserData:" + MudManager.Get().msg);
            MudUserData mud_userdata = MudManager.Get().GetUserData();
            if (mud_userdata != null)
            {
                udata.username = mud_userdata.id;
                udata.coins = mud_userdata.coin;
                List<UserCardData> cardList = new List<UserCardData>();
                for (int i = 0; i < mud_userdata.cards.Length; i++)
                {
                    string hex = mud_userdata.cards[i];
                    string card_id = MudManager.Get().GetCardIdByHex(hex);
                    if (card_id != "Unknown")
                    {
                        cardList.Add(new UserCardData(card_id, "normal"));
                        udata.cards = cardList.ToArray();
                    }
                }

                List<UserCardData> packList = new List<UserCardData>();
                for (int i = 0; i < mud_userdata.packs.Length; i++)
                {
                    string hex = mud_userdata.packs[i];
                    string pack_id = MudManager.Get().GetCardIdByHex(hex);
                    if (pack_id != "Unknown")
                    {
                        packList.Add(new UserCardData(pack_id, "normal"));
                        udata.packs = packList.ToArray();
                    }
                }
            }
            else
            {
                return null;
            }

            await Task.Yield(); //Do nothing
            return udata;
        }

        public override async Task<bool> SaveUserData()
        {
            if (udata != null && SaveTool.IsValidFilename(username))
            {
                string file = username + ".user";
                SaveTool.SaveFile<UserData>(file, udata);
                await Task.Yield(); //Do nothing
                return true;
            }

            return false;
        }

        public override void Logout()
        {
            base.Logout();
            udata = null;
            PlayerPrefs.DeleteKey("tcg_user");
        }

        public override UserData GetUserData()
        {
            return udata;
        }
    }
}