mergeInto(LibraryManager.library, {

    hasMudInstalled: function () {
        return typeof mud !== 'undefined';
    },

    addTask: async function (msg) {
        if(typeof mud === 'undefined'){
            return;
        }
        await mud.addTask(UTF8ToString(msg));
    },

    addUser: async function (name) {
        if(typeof mud === 'undefined'){
            return;
        }
        await mud.addUser(name);
    },

    getUser: async function () {
        let user = await getUser();
        let returnStr = JSON.stringify(user);
        MyUnityInstance.SendMessage("MudManager", "OnUser", returnStr);
    },

    doApiTask: async function (url, json_data) {
        await runApiTask(UTF8ToString(url), UTF8ToString(json_data))
        let user = await getUser();
        let returnStr = JSON.stringify(user);
        MyUnityInstance.SendMessage("MudManager", "OnUser", returnStr);
    },

    buyCard: async function (card_id, quantity) {
        if(typeof mud === 'undefined'){
            return;
        }
        await mud.buyCard(UTF8ToString(card_id), quantity);
        let user = await getUser();
        let returnStr = JSON.stringify(user);
        MyUnityInstance.SendMessage("MudManager", "OnUser", returnStr);
        MyUnityInstance.SendMessage("CardZoomPanel", "OnSuccess");
    },

    sellCard: async function (card_id, quantity) {
        if(typeof mud === 'undefined'){
            return;
        }
        await mud.sellCard(UTF8ToString(card_id), quantity);
        let user = await getUser();
        let returnStr = JSON.stringify(user);
        MyUnityInstance.SendMessage("MudManager", "OnUser", returnStr);
        MyUnityInstance.SendMessage("CardZoomPanel", "OnSuccess");
    },

    buyPack: async function (pack_id, quantity) {
        if(typeof mud === 'undefined'){
            return;
        }
        await mud.buyPack(UTF8ToString(pack_id), quantity);
        let user = await getUser();
        let returnStr = JSON.stringify(user);
        MyUnityInstance.SendMessage("MudManager", "OnUser", returnStr);
        MyUnityInstance.SendMessage("PackZoomPanel", "OnSuccess");
    },

    openPack: async function (pack_id) {
        if(typeof mud === 'undefined'){
            return;
        }
        let result = await mud.openPack(UTF8ToString(pack_id));
        let user = await getUser();
        let returnStr = JSON.stringify(user);
        MyUnityInstance.SendMessage("MudManager", "OnUser", returnStr);
        MyUnityInstance.SendMessage("OpenPackMenu", "OnSuccess", JSON.stringify(result.tx_result.result));
    },

    gameSetting: async function (game_uid) {
        let result = await gameSetting(UTF8ToString(game_uid));
        let returnStr = JSON.stringify(result.res);
        console.log(returnStr);
        MyUnityInstance.SendMessage("Client", "OnGameSettingSuccess", returnStr);
    },

    playerSetting: async function (username, game_uid, deck_id, is_ai, hp, mana, dcards, pid, shuffle) {
        if(typeof mud === 'undefined'){
            return;
        }
        let result = await mud.playerSetting(UTF8ToString(username), UTF8ToString(game_uid), UTF8ToString(deck_id), is_ai, hp, mana, dcards, pid, shuffle);
        console.log("playerSetting result", result);

        let returnStr = JSON.stringify(result.res);
        MyUnityInstance.SendMessage("Client", "OnPlayerSettingSuccess", returnStr);

    },

    playCard: async function (game_uid, player_id, card_id, slot_x, slot_y, slot_p, skip, card_key) {
        if(typeof mud === 'undefined'){
            return;
        }
        console.log("playCard=====================================");
        console.log("game_uid", UTF8ToString(game_uid));
        console.log("player_id", UTF8ToString(player_id));
        console.log("card_id", UTF8ToString(card_id));
        console.log("card_key", UTF8ToString(card_key));

        let slot = {x: slot_x, y: slot_y, p: slot_p};
        let result = await mud.playCard(UTF8ToString(game_uid), UTF8ToString(player_id), UTF8ToString(card_id), slot, skip, UTF8ToString(card_key));
        // console.log("playCard result", result);

        // let returnStr = JSON.stringify(result.result);
        // MyUnityInstance.SendMessage("Client", "OnPlayCardSuccess", returnStr);
    },

    moveCard: async function (game_uid, player_id, card_id, slot_x, slot_y, slot_p, skip, card_key) {
        if(typeof mud === 'undefined'){
            return;
        }
        console.log("moveCard=====================================");

        console.log("game_uid", UTF8ToString(game_uid));
        console.log("player_id", UTF8ToString(player_id));
        console.log("card_id", UTF8ToString(card_id));
        console.log("card_key", UTF8ToString(card_key));

        let slot = {x: slot_x, y: slot_y, p: slot_p};

        let result = await mud.moveCard(UTF8ToString(game_uid), UTF8ToString(player_id), UTF8ToString(card_id), slot, skip, UTF8ToString(card_key));

        console.log("moveCard result", result);

        let returnStr = JSON.stringify(result.result);

        MyUnityInstance.SendMessage("Client", "OnMoveCardSuccess", returnStr);
    },

    attackCard: async function (game_uid, player_id, attacker_key, target_key, slot_x, slot_y, slot_p, skip,) {
        if(typeof mud === 'undefined'){
            return;
        }
        console.log("attackCard=====================================");

        console.log("game_uid", UTF8ToString(game_uid));
        console.log("player_id", UTF8ToString(player_id));
        console.log("attacker_key", UTF8ToString(attacker_key));
        console.log("target_key", UTF8ToString(target_key));

        let slot = {x: slot_x, y: slot_x, p: slot_p};


        let result = await mud.attackCard(UTF8ToString(game_uid), UTF8ToString(player_id), UTF8ToString(attacker_key), slot, skip, UTF8ToString(target_key));

        console.log("attackCard result", result);

        MyUnityInstance.SendMessage("Client", "OnAttackCardSuccess", JSON.stringify(result));

    },

    attackPlayer: async function (game_uid, cardkey, target_id) {
        if(typeof mud === 'undefined'){
            return;
        }
        console.log("attackPlayer=====================================");
        console.log("game_uid", UTF8ToString(game_uid));
        console.log("cardkey", UTF8ToString(cardkey));
        let result = await mud.attackPlayer(UTF8ToString(game_uid), UTF8ToString(cardkey), target_id);
        console.log("attackPlayer result", result);

        MyUnityInstance.SendMessage("Client", "OnAttackPlayerSuccess", JSON.stringify(result));
    },

    saveDeck: async function (tid, hero, cards) {
        if(typeof mud === 'undefined'){
            return;
        }
        console.log("tid", UTF8ToString(tid));
        console.log("hero", UTF8ToString(hero));
        console.log("cards", UTF8ToString(cards));
        let result = await mud.saveDeck(UTF8ToString(tid), UTF8ToString(hero), UTF8ToString(cards));
    },

    AddNumbers: async function (x, y, onSuccess) {
        await new Promise(resolve => setTimeout(resolve, 2000));
        dynCall_vi(onSuccess, x + y);
    },

    calculateKeccak256Hash: function (name) {
        var returnStr = window.calculateKeccak256Hash(UTF8ToString(name));
        var bufferSize = lengthBytesUTF8(returnStr) + 1;
        var buffer = _malloc(bufferSize);
        stringToUTF8(returnStr, buffer, bufferSize);
        return buffer;
    },

    endTurn: async function (game_uid, player_name, player_id) {
        if(typeof mud === 'undefined'){
            return;
        }
        console.log("player_name", UTF8ToString(player_name));

        let result = await mud.endTurn(UTF8ToString(game_uid), UTF8ToString(player_name), player_id);
        // console.log(result);

        // let returnStr = JSON.stringify(result);
        // MyUnityInstance.SendMessage("Client", "OnEndTurnSuccess", returnStr);
    },

    startMatchmaking: async function (game_uid, nb_players) {
        if(typeof mud === 'undefined'){
            return;
        }
        console.log("startMatchmaking=====================================");
        let result = await mud.startMatchmaking(UTF8ToString(game_uid), nb_players);
        console.log(result);
        let returnStr = JSON.stringify(result);
        MyUnityInstance.SendMessage("Menu", "OnStartMatchmakingSuccess", returnStr);
        if (result.players.length == result.nb_players) {
            await new Promise(resolve => setTimeout(resolve, 2000));
            MyUnityInstance.SendMessage("Client", "OnStartMatchmakingSuccess", returnStr);
        }
    },

    checkMatchmaking: async function (match_id) {
        if(typeof mud === 'undefined'){
            return;
        }
        console.log("checkMatchmaking=====================================");
        let result = await mud.checkMatchmaking(match_id);
        console.log(result);
        let returnStr = JSON.stringify(result);
        MyUnityInstance.SendMessage("Menu", "OnStartMatchmakingSuccess", returnStr);
        if (result.players.length == result.nb_players) {
            await new Promise(resolve => setTimeout(resolve, 2000));
            MyUnityInstance.SendMessage("Client", "OnStartMatchmakingSuccess", returnStr);
        }
    },

    checkPlayerSetting: async function (username, game_uid) {
        if(typeof mud === 'undefined'){
            return;
        }
        console.log("checkPlayerSetting=====================================");
        console.log("username", UTF8ToString(username));
        console.log("game_uid", UTF8ToString(game_uid));
        let result = await mud.checkPlayerSetting(UTF8ToString(username), UTF8ToString(game_uid));
        console.log(result);
        let returnStr = JSON.stringify(result);
        MyUnityInstance.SendMessage("Client", "OnPlayerSettingSuccess", returnStr);
    },

    checkAction: async function (username, game_uid) {
        if(typeof mud === 'undefined'){
            return;
        }
        //console.log("checkAction=====================================");
        //console.log("username", UTF8ToString(username));
        //console.log("game_uid", UTF8ToString(game_uid));
        let result = await mud.checkAction(UTF8ToString(username), UTF8ToString(game_uid));
        //console.log(result);
        if (result != null) {
            let returnStr = JSON.stringify(result);
            MyUnityInstance.SendMessage("Client", "OnActionHistorySuccess", returnStr);
        }
    },

    selectCard: async function (game_uid, card_id,card_uid) {
        if(typeof mud === 'undefined'){
            return;
        }
        let result = await mud.selectCard(UTF8ToString(game_uid), UTF8ToString(card_id), UTF8ToString(card_uid));
        if (result != null) {
                    let returnStr = JSON.stringify(result);
            MyUnityInstance.SendMessage("Client", "OnSelectCardSuccess", returnStr);
        }
        
    },

    selectPlayer: async function (game_uid, caster) {
        if(typeof mud === 'undefined'){
            return;
        }
        let result = await mud.selectplayer(UTF8ToString(game_uid), UTF8ToString(caster));
    },

    selectSlot: async function (game_uid, slot_x, slot_y, slot_p) {
        if(typeof mud === 'undefined'){
            return;
        }
        let result = await mud.selectSlot(UTF8ToString(game_uid), slot_x, slot_y, slot_p);
    },

    selectChoice: async function(game_uid ,choice){
        if(typeof mud === 'undefined'){
            return;
        }
        let result = await mud.selectSlot(UTF8ToString(game_uid), choice);
    },

    cancelSelection: async function (game_uid) {
        if(typeof mud === 'undefined'){
            return;
        }
        let result = await mud.cancelSelection(UTF8ToString(game_uid));
    },

    castAbility: async function(game_uid,caster,ability){
        if(typeof mud === 'undefined'){
            return;
        }
        let result = await mud.castAbility(UTF8ToString(game_uid),UTF8ToString(caster),UTF8ToString(ability));
    },

    resign: async function(player){
        if(typeof mud === 'undefined'){
            return;
        }
        let result = await mud.resign(UTF8ToString(player));
    },

    walletAddress: function(){
        let returnStr = window.walletAddress;
        let size = lengthBytesUTF8(returnStr);
        let buffer = _malloc(size);
        stringToUTF8(returnStr,buffer,size);
        return buffer;
    }

});