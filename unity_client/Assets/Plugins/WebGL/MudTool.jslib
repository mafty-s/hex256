mergeInto(LibraryManager.library, {

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