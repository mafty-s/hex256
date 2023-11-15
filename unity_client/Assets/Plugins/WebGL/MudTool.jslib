mergeInto(LibraryManager.library, {

    addTask: async function(msg){
        await addTask(UTF8ToString(msg));
    },

    getUser: async function(){
        let user = await getUser();
        let returnStr = JSON.stringify(user);
        MyUnityInstance.SendMessage("MudManager","OnUser",returnStr);
    },

    buyCard:async function(card_id,quantity){
        await mud.buyCard(card_id,quantity);
        let user = await getUser();
        let returnStr = JSON.stringify(user);
        MyUnityInstance.SendMessage("MudManager","OnUser",returnStr);
    },

    AddNumbers: async function (x, y, onSuccess) {
        await new Promise(resolve => setTimeout(resolve, 2000));
        dynCall_vi(onSuccess, x + y);
    },


});