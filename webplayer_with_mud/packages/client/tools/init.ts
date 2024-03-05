import {Contract, ethers, JsonRpcProvider, Wallet} from 'ethers';
// import IWorldAbi from "../../contracts/out/IWorld.sol/IWorld.abi.json";
import * as fs from 'fs';

// @ts-ignore
// const loadJSON = (path) => JSON.parse(fs.readFileSync(new URL("../../contracts/out/IWorld.sol/IWorld.abi.json")));

const loadJSON = (path) => JSON.parse(fs.readFileSync(new URL(path, import.meta.url)));

const sleep = (ms) => {
    return new Promise(resolve => setTimeout(resolve, ms));
}

const calculateKeccak256Hash = (name) => {
    const encodedName = ethers.AbiCoder.defaultAbiCoder().encode(['string'], [name]);
    const keccakHash = ethers.keccak256(encodedName);
    return keccakHash;
}

let createDeck = async (name, hero, cards) => {
    let cards_arr = cards.split('|');
    let cards_keys = [];
    for (let i = 0; i < cards_arr.length; i++) {
        let card_id = cards_arr[i];
        let card_key = calculateKeccak256Hash(card_id);
        cards_keys.push(card_key);
    }
    let tx = await world_contract.initDeck(name, calculateKeccak256Hash(hero), cards_keys, {
        nonce: nonce++,
    });
    tx.wait().then((receipt) => {
        console.log("deck", name, receipt.hash);
    });
}

const initCard = async (name, mana, attack, hp, cost, abilities_str, cardType, rarity, is_deckbuilding, trait) => {
    // const cardTypeCode = getCardType((cardType));
    // let rarity_str = convertToEnumFormat(rarity);
    // const rarityCode = getRarityType(rarity_str.substr(2,));
    // const traitCode = getCardTrait(convertToCamelCase(trait));
    // const tx = await worldContract.initCard([name, mana, attack, hp, cost, arrStr2Bytes32(abilities_str), cardTypeCode, rarityCode, is_deckbuilding, traitCode],{
    //     nonce:nonce++
    // });
    // tx.wait().then((receipt) => {
    //     console.log("initCard", name, receipt.hash);
    // });
};

let nonce = 0;
let world_contract = null;

async function init() {
    let private_key = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";
    let provider = new JsonRpcProvider("http://127.0.0.1:8545");
    let wallet = new Wallet(private_key, provider);

    const world_abi = loadJSON('../../contracts/out/IWorld.sol/IWorld.abi.json');

    let world_address = "0x6e9474e9c83676b9a71133ff96db43e7aa0a4342";
    world_contract = new Contract(world_address, world_abi, wallet);

    nonce = await provider.getTransactionCount(wallet.address);
    console.log("nonce", nonce);

    await createDeck('fire_deck', 'hero_fire', 'phoenix|phoenix|phoenix|phoenix|phoenix|phoenix|phoenix|hell_hound|ashes_snake|fire_element|wolf_furious|phoenix|dragon_red|spell_burn|spell_burn|potion_red|potion_red|trap_explosive|spell_armageddon|town_volcano');
    await createDeck('forest_deck', 'hero_forest', 'wolf_alpha|wolf_alpha|wolf_stalker|wolf_stalker|tree_angry|tree_angry|owl|raccoon|armored_beast|bear|sasquatch|unicorn|dragon_green|spell_roots|spell_roots|potion_green|potion_green|spell_growth|trap_spike|town_forest');
    await createDeck('water_deck', 'hero_water', 'fish|crab_mana|crab_mana|turtle|turtle|poison_frog|eel|eel|pufferfish|killer_whale|kraken|sea_monster|dragon_blue|spell_wave|spell_wave|spell_storm|potion_blue|potion_blue|trap_fish|town_underwater');
    await createDeck('test_deck', 'hero_fire', 'wolf_alpha|wolf_alpha|wolf_stalker|wolf_stalker|tree_angry|tree_angry|armored_beast|armored_beast|raccoon|raccoon|owl|owl|bear|bear|sasquatch|unicorn|dragon_green|trap_spike|spell_roots|spell_growth|potion_green|town_forest|imp|imp|lava_beast|lava_beast|fire_chicken|fire_chicken|firefox|firefox|wolf_furious|wolf_furious|fire_element|fire_element|phoenix|dragon_red|spell_burn|spell_armageddon|potion_red|trap_explosive|town_volcano|fish|fish|turtle|turtle|crab_mana|crab_mana|eel|pufferfish|pufferfish|killer_whale|killer_whale|sea_monster|kraken|dragon_blue|potion_blue|spell_wave|spell_storm|trap_fish|town_underwater|seagull|seagull|shark|spell_flood|spell_treasure|spell_treasure|octopus|bull_heat|dark_stallion|reaper|spell_aerial_strike|spell_stones|spell_stones|mammoth|gorilla|snake_venom|snake_venom|spell_hibernate|spell_stomp|spell_stomp|bay|cave|woodland|spell_split|spell_extinct|spell_submerge|equip_sword|equip_shield|equip_ring|dragon_egg');
    await createDeck('level1_ai', '', 'coin|coin|coin');
    await createDeck('level1_player', '', 'spell_growth|spell_growth|crab_mana|crab_mana|coin');
    await createDeck('level2_ai', '', 'imp|imp|spell_stones|fire_chicken|fire_chicken|spell_burn');
    await createDeck('level2_player', '', 'eel|potion_green|potion_green|potion_green|potion_green|potion_green');
    await createDeck('level3_ai', '', 'potion_red|hell_hound|hell_hound|hell_hound|spell_burn');
    await createDeck('level3_player', '', 'phoenix|phoenix|phoenix|phoenix|snake_venom|mammoth');
    await createDeck('level4_ai', '', 'ashes_snake|spell_stones|ashes_snake|spell_stones|ashes_snake|phoenix');
    await createDeck('level4_player', '', 'snake_venom|snake_venom|snake_venom|snake_venom|snake_venom|snake_venom|snake_venom|snake_venom');
    await createDeck('level5_ai', '', 'fire_chicken|firefox|town_volcano|hell_hound|spell_burn|fire_chicken|fire_chicken');
    await createDeck('level5_player', '', 'owl|town_forest|spell_roots|raccoon|snake_venom|tree_angry|potion_green');

    await initCard('ashes_snake', 5, 6, 4, 100, 'stealth', 'Character', '2-uncommon', true, '');
    await initCard('bull_heat', 3, 2, 5, 100, 'add_spell_damage1', 'Character', '1-common', true, '');
    await initCard('cave', 2, 0, 5, 100, 'aura_ability_red', 'Artifact', '3-rare', true, '');
    await initCard('dark_stallion', 4, 4, 5, 100, 'activate_roll_send_hand', 'Character', '2-uncommon', true, '');
    await initCard('dragon_red', 7, 9, 7, 100, 'spell_immunity', 'Character', '4-mythic', true, 'dragon');
    await initCard('equip_sword', 2, 0, 2, 100, 'equip_attack1|equip_attack_no_damage|equip_attack_use', 'Equipment', '2-uncommon', true, '');
    await initCard('fire_chicken', 2, 1, 1, 100, 'death_egg', 'Character', '1-common', true, '');
    await initCard('fire_element', 5, 7, 3, 100, 'play_damage_all2', 'Character', '2-uncommon', true, '');
    await initCard('firefox', 4, 4, 4, 100, 'activate_select_discard_spell', 'Character', '2-uncommon', true, '');
    await initCard('hell_hound', 4, 4, 2, 100, 'fury', 'Character', '1-common', true, '');
    await initCard('imp', 2, 2, 1, 100, 'play_deal_damage1', 'Character', '1-common', true, '');
    await initCard('lava_beast', 3, 2, 3, 100, 'after_spell_attack2', 'Character', '1-common', true, '');
    await initCard('phoenix', 6, 6, 6, 100, 'activate_damage2|death_egg', 'Character', '4-mythic', true, '');
    await initCard('potion_red', 2, 0, 0, 100, 'spell_attack1|spell_fury', 'Spell', '1-common', true, '');
    await initCard('reaper', 6, 6, 6, 100, 'turn_kill_lowest', 'Character', '3-rare', true, '');
    await initCard('spell_aerial_strike', 3, 0, 0, 100, 'spell_summon_eagle', 'Spell', '4-mythic', true, '');
    await initCard('spell_armageddon', 5, 0, 0, 100, 'spell_destroy_all', 'Spell', '3-rare', true, '');
    await initCard('spell_burn', 4, 0, 0, 100, 'spell_destroy', 'Spell', '1-common', true, '');
    await initCard('spell_split', 2, 0, 0, 100, 'spell_add_attack_suffer', 'Spell', '3-rare', true, '');
    await initCard('spell_stones', 2, 0, 0, 100, 'spell_damage1|spell_draw1', 'Spell', '2-uncommon', true, '');
    await initCard('town_volcano', 3, 0, 7, 100, 'town_aura_red', 'Artifact', '1-common', true, '');
    await initCard('trap_explosive', 3, 0, 0, 100, 'trap_damage_all2', 'Secret', '2-uncommon', true, '');
    await initCard('wolf_furious', 5, 3, 4, 100, 'fury|turn_add_attack1', 'Character', '3-rare', true, 'wolf');
    await initCard('armored_beast', 4, 3, 6, 100, 'taunt', 'Character', '1-common', true, '');
    await initCard('bear', 5, 4, 5, 100, 'play_choice_taunt_fury', 'Character', '2-uncommon', true, '');
    await initCard('dragon_green', 7, 7, 9, 100, 'spell_immunity', 'Character', '4-mythic', true, 'dragon');
    await initCard('equip_shield', 2, 0, 2, 100, 'equip_armor2|equip_taunt|equip_defend_use', 'Equipment', '2-uncommon', true, '');
    await initCard('gorilla', 4, 0, 6, 100, 'play_roll_attack', 'Character', '2-uncommon', true, '');
    await initCard('mammoth', 6, 7, 6, 100, 'trample', 'Character', '3-rare', true, '');
    await initCard('owl', 3, 2, 3, 100, 'play_silence', 'Character', '2-uncommon', true, '');
    await initCard('potion_green', 2, 0, 0, 100, 'spell_hp2|spell_taunt', 'Spell', '1-common', true, '');
    await initCard('raccoon', 2, 2, 3, 100, 'play_select_discard', 'Character', '1-common', true, '');
    await initCard('sasquatch', 5, 6, 4, 100, 'turn_stealth', 'Character', '3-rare', true, '');
    await initCard('snake_venom', 2, 1, 3, 100, 'attack_poison|defend_poison', 'Character', '1-common', true, '');
    await initCard('spell_extinct', 2, 0, 0, 100, 'spell_add_play_extinct', 'Spell', '3-rare', true, '');
    await initCard('spell_growth', 5, 0, 0, 100, 'spell_ally_attack_2|spell_ally_hp_2', 'Spell', '3-rare', true, '');
    await initCard('spell_hibernate', 3, 0, 0, 100, 'spell_hibernate', 'Spell', '4-mythic', true, '');
    await initCard('spell_roots', 3, 0, 0, 100, 'spell_paralyse', 'Spell', '1-common', true, '');
    await initCard('spell_stomp', 2, 0, 0, 100, 'spell_kill_lowest_hp', 'Spell', '2-uncommon', true, '');
    await initCard('town_forest', 3, 0, 7, 100, 'town_aura_green', 'Artifact', '1-common', true, '');
    await initCard('trap_spike', 3, 0, 0, 100, 'trap_paralyse3', 'Secret', '2-uncommon', true, '');
    await initCard('tree_angry', 3, 3, 5, 100, 'regen_all', 'Character', '1-common', true, '');
    await initCard('unicorn', 6, 5, 6, 100, 'play_boost2|activate_send_hand', 'Character', '4-mythic', true, '');
    await initCard('wolf_alpha', 3, 3, 2, 100, 'play_summon_wolf|aura_wolf', 'Character', '2-uncommon', true, 'wolf');
    await initCard('wolf_stalker', 3, 4, 2, 100, 'stealth', 'Character', '1-common', true, 'wolf');
    await initCard('woodland', 2, 0, 5, 100, 'turn_green_heal', 'Artifact', '3-rare', true, '');
    await initCard('hero_fire', 0, 0, 0, 100, 'activate_fire', 'Hero', '4-mythic', false, '');
    await initCard('hero_forest', 0, 0, 0, 100, 'activate_forest', 'Hero', '4-mythic', false, '');
    await initCard('hero_water', 0, 0, 0, 100, 'activate_water', 'Hero', '4-mythic', false, '');
    await initCard('coin', 0, 0, 0, 100, 'spell_coin', 'Spell', '1-common', false, '');
    await initCard('dragon_egg', 2, 0, 0, 100, 'spell_dragon_create', 'Spell', '4-mythic', true, '');
    await initCard('flame_eagle', 1, 1, 1, 100, 'flying|play_haste', 'Character', '1-common', false, '');
    await initCard('phoenix_egg', 0, 0, 3, 100, 'egg_growth', 'Artifact', '1-common', false, '');
    await initCard('wolf_baby', 1, 1, 1, 100, '', 'Character', '1-common', false, 'wolf');
    await initCard('bay', 2, 0, 5, 100, 'death_blue_draw', 'Artifact', '3-rare', true, '');
    await initCard('crab_mana', 2, 3, 1, 100, 'attack_player_mana2', 'Character', '1-common', true, '');
    await initCard('dragon_blue', 7, 8, 8, 100, 'spell_immunity', 'Character', '4-mythic', true, 'dragon');
    await initCard('eel', 4, 5, 2, 100, 'play_set_attack1', 'Character', '2-uncommon', true, '');
    await initCard('equip_ring', 1, 0, 3, 100, 'equip_gain_mana', 'Equipment', '2-uncommon', true, '');
    await initCard('fish', 1, 1, 1, 100, 'death_blue_draw', 'Character', '1-common', true, '');
    await initCard('killer_whale', 5, 5, 4, 100, 'play_destroy_less4', 'Character', '3-rare', true, '');
    await initCard('kraken', 6, 5, 5, 100, 'play_haste', 'Character', '3-rare', true, '');
    await initCard('octopus', 4, 2, 5, 100, 'attack_roll_attack_bonus', 'Character', '2-uncommon', true, '');
    await initCard('poison_frog', 3, 2, 2, 100, 'deathtouch', 'Character', '2-uncommon', true, '');
    await initCard('potion_blue', 2, 0, 0, 100, 'spell_shell|spell_heal_full', 'Spell', '1-common', true, '');
    await initCard('pufferfish', 3, 2, 5, 100, 'defense_attack3', 'Character', '1-common', true, '');
    await initCard('sea_monster', 6, 4, 7, 100, 'aura_attack_m1|activate_boost1', 'Character', '4-mythic', true, '');
    await initCard('seagull', 2, 2, 2, 100, 'flying', 'Character', '1-common', true, '');
    await initCard('shark', 4, 4, 4, 100, 'death_other_draw', 'Character', '2-uncommon', true, '');
    await initCard('spell_flood', 3, 0, 0, 100, 'spell_damage_per_hand', 'Spell', '2-uncommon', true, '');
    await initCard('spell_storm', 5, 0, 0, 100, 'spell_return_all', 'Spell', '3-rare', true, '');
    await initCard('spell_submerge', 2, 0, 0, 100, 'spell_add_submerge', 'Spell', '3-rare', true, '');
    await initCard('spell_treasure', 3, 0, 0, 100, 'spell_treasure', 'Spell', '4-mythic', true, '');
    await initCard('spell_wave', 3, 0, 0, 100, 'spell_send_hand', 'Spell', '1-common', true, '');
    await initCard('town_underwater', 3, 0, 7, 100, 'town_aura_blue', 'Artifact', '1-common', true, '');
    await initCard('trap_fish', 3, 0, 0, 100, 'secret_transform_fish', 'Secret', '2-uncommon', true, '');
    await initCard('turtle', 3, 2, 3, 100, 'taunt|shell', 'Character', '1-common', true, '');


}

init();