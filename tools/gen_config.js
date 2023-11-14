const csv = require('csv-parser')
const fs = require('fs')
const results = [];

fs.createReadStream('../unity_client/Assets/Export/CardData.csv')
    .pipe(csv())
    .on('data', (data) => results.push(data))
    .on('end', () => {
        // console.log(results);

        for (let i = 0; i < results.length; i++) {
            let card = results[i];
            let str = 'Cards.set(keccak256(abi.encode("' + card.ID + '")), CardsData({mana : ' + card.Mana + ', attack : ' + card.Attack + ', hp : ' + card.HP + ', cost : '+card.Cost+', createdAt : 1, tid : "'+card.ID+'", cardType : "1", team : "1", rarity : "1"}));';
            console.log(str);
        }

        // [
        //   { NAME: 'Daffy Duck', AGE: '24' },
        //   { NAME: 'Bugs Bunny', AGE: '22' }
        // ]
    });