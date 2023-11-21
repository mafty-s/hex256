mergeInto(LibraryManager.library, {

    hasMudInstalled: function(){
        return typeof mud !== 'undefined';
    },

    addTask: async function(msg){
        await mud.addTask(UTF8ToString(msg));
    },

    addUser: async function(name){
        await mud.addUser(name);
    },

    getUser: async function(){
        let user = await getUser();
        let returnStr = JSON.stringify(user);
        MyUnityInstance.SendMessage("MudManager","OnUser",returnStr);
    },

    doApiTask:async function(url,json_data){
        await runApiTask(UTF8ToString(url),UTF8ToString(json_data))
        let user = await getUser();
        let returnStr = JSON.stringify(user);
        MyUnityInstance.SendMessage("MudManager","OnUser",returnStr);
    },

    buyCard:async function(card_id,quantity){
        await mud.buyCard(UTF8ToString(card_id),quantity);
        let user = await getUser();
        let returnStr = JSON.stringify(user);
        MyUnityInstance.SendMessage("MudManager","OnUser",returnStr);
        MyUnityInstance.SendMessage("CardZoomPanel","OnSuccess");
    },

    sellCard:async function(card_id,quantity){
        await mud.sellCard(UTF8ToString(card_id),quantity);
        let user = await getUser();
        let returnStr = JSON.stringify(user);
        MyUnityInstance.SendMessage("MudManager","OnUser",returnStr);
        MyUnityInstance.SendMessage("CardZoomPanel","OnSuccess");
    },

    buyPack:async function(pack_id,quantity){
        await mud.buyPack(UTF8ToString(pack_id),quantity);
        let user = await getUser();
        let returnStr = JSON.stringify(user);
        MyUnityInstance.SendMessage("MudManager","OnUser",returnStr);
        MyUnityInstance.SendMessage("PackZoomPanel","OnSuccess");
    },

    openPack:async function(pack_id){
        let result = await mud.openPack(UTF8ToString(pack_id));
        let user = await getUser();
        let returnStr = JSON.stringify(user);
        MyUnityInstance.SendMessage("MudManager","OnUser",returnStr);
        MyUnityInstance.SendMessage("OpenPackMenu","OnSuccess",JSON.stringify(result.tx_result.result));
    },

    gameSetting:async function(game_uid){
        let result = await mud.gameSetting(UTF8ToString(game_uid));
    },

    playerSetting:async function(username,game_uid,deck_id,is_ai,hp,mana,dcards){
        console.log(username,"is_ai",is_ai);
        let result = await mud.playerSetting(UTF8ToString(username),UTF8ToString(game_uid),UTF8ToString(deck_id),is_ai,hp,mana,dcards);
    },

    playCard:async function(game_uid,player_id,card_id,slot_x,slot_y,slot_p,skip){
        console.log("game_uid",UTF8ToString(game_uid));
        console.log("player_id",UTF8ToString(player_id));
        console.log("card_id",UTF8ToString(card_id));

        let slot = {x:slot_x,y:slot_x,p:slot_p};
        let result = await mud.playCard(UTF8ToString(game_uid),UTF8ToString(player_id),UTF8ToString(card_id),slot,skip);
    },

    moveCard:async function(game_uid,player_id,card_id,slot_x,slot_y,slot_p,skip){
        console.log("game_uid",UTF8ToString(game_uid));
        console.log("player_id",UTF8ToString(player_id));
        console.log("card_id",UTF8ToString(card_id));

        let slot = {x:slot_x,y:slot_x,p:slot_p};

        let result = await mud.moveCard(UTF8ToString(game_uid),UTF8ToString(player_id),UTF8ToString(card_id),slot,skip);

    },


    saveDeck:async function(tid,hero,cards){
        console.log("tid",UTF8ToString(tid));
        console.log("hero",UTF8ToString(hero));
        console.log("cards",UTF8ToString(cards));
        let result = await mud.saveDeck(UTF8ToString(tid),UTF8ToString(hero),UTF8ToString(cards));
    },

    AddNumbers: async function (x, y, onSuccess) {
        await new Promise(resolve => setTimeout(resolve, 2000));
        dynCall_vi(onSuccess, x + y);
    },

    calculateKeccak256Hash: function(name){
        var returnStr = window.calculateKeccak256Hash(UTF8ToString(name));
        var bufferSize = lengthBytesUTF8(returnStr) + 1;
        var buffer = _malloc(bufferSize);
        stringToUTF8(returnStr, buffer, bufferSize);
        return buffer;
    }

});