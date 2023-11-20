const csv = require('csv-parser')
const fs = require('fs')
const results = [];

fs.createReadStream('../unity_client/Assets/Export/AbilityData.csv')
    .pipe(csv())
    .on('data', (data) => results.push(data))
    .on('end', () => {
        // console.log(results);

        // const initAbility = async (id: string, value: number, manaCost: number, duration: number, exhaust: boolean, effect: string[]) => {

        for (let i = 0; i < results.length; i++) {
            let ability = results[i];
            const str = `initAbility('${ability.ID}', '${ability.Trigger}','${ability.Target}',${ability.Value}, ${ability.ManaCost}, ${ability.Duration}, ${ability.Exhaust.toLowerCase()},'${ability.Effects}');`;
            console.log(str);
        }

    });