using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;

namespace TcgEngine
{
    /// <summary>
    /// This authenticator require external UserLogin API asset
    /// It works with an actual web API and database containing all user info
    /// </summary>
    public class AuthenticatorApi : Authenticator
    {
        private int permission = 0;

        public override async Task Initialize()
        {
            await base.Initialize();
        }

        public override async Task<bool> Login(string username, string password)
        {
            LoginResponse res = await Client.Login(username, password);
            if (res.success)
            {
                this.logged_in = true;
                this.user_id = res.id;
                this.username = res.username;
                permission = res.permission_level;
            }

            return res.success;
        }

        public override async Task<bool> RefreshLogin()
        {
            LoginResponse res = await Client.RefreshLogin();
            if (res.success)
            {
                this.logged_in = true;
                this.user_id = res.id;
                this.username = res.username;
            }

            return res.success;
        }

        public override async Task<bool> Register(string username, string email, string password)
        {
            RegisterResponse res = await Client.Register(username, email, password);

            if (res.success)
                await Login(username, password);

#if !UNITY_EDITOR && UNITY_WEBGL
            //todo
#endif

            return res.success;
        }

        public override async Task<UserData> LoadUserData()
        {
            UserData res = await Client.LoadUserData();
#if !UNITY_EDITOR && UNITY_WEBGL
            Debug.Log("LoadUserData:" + MudManager.Get().msg);
            res.username = MudManager.Get().GetUserData().id;
            res.coins = MudManager.Get().GetUserData().coin;
            List<UserCardData> cardList = new List<UserCardData>();
            for (int i = 0; i<MudManager.Get().GetUserData().cards.Length; i++)
            {
                string hex = MudManager.Get().GetUserData().cards[i];
                string card_id = MudManager.Get().GetCardIdByHex(hex);
                cardList.Add(new UserCardData(card_id, "normal"));
                res.cards = cardList.ToArray();
            }
            List<UserCardData> packList = new List<UserCardData>();
            for (int i = 0; i<MudManager.Get().GetUserData().packs.Length; i++)
            {
                string hex = MudManager.Get().GetUserData().packs[i];
                string card_id = MudManager.Get().GetCardIdByHex(hex);
                packList.Add(new UserCardData(card_id, "normal"));
                res.packs = packList.ToArray();
            }
#endif
            return res;
        }

        public override async Task<bool> SaveUserData()
        {
            //Do nothing, saved on each api request, no need to save to disk
            await Task.Yield();
            return false;
        }

        public override void Logout()
        {
            base.Logout();
            Client.Logout();
            permission = 0;
        }

        public override UserData GetUserData()
        {
            return Client.UserData;
        }

        public override bool IsSignedIn()
        {
            return Client.IsLoggedIn();
        }

        public override bool IsExpired()
        {
            return Client.IsExpired();
        }

        public override int GetPermission()
        {
            return permission;
        }

        public override string GetError()
        {
            return Client.GetLastError();
        }

        public ApiClient Client
        {
            get { return ApiClient.Get(); }
        }
    }
}