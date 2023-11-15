mergeInto(LibraryManager.library, {

    Foo: function () {
        window.alert("Foo!");
    },

    Boo: async function () {
        var s = function (ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        };
        await s(2000);
        window.alert("Boo!");
    },
    addTask: async function(msg){
        await addTask(UTF8ToString(msg));
    }
});