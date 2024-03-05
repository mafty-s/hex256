import {Contract, ethers, JsonRpcProvider, Wallet} from 'ethers';
// import IWorldAbi from "../../contracts/out/IWorld.sol/IWorld.abi.json";
import fs from 'fs';

const loadJSON = (path) => JSON.parse(fs.readFileSync(new URL(path, import.meta.url)));
const sleep = (ms) => {
    return new Promise(resolve => setTimeout(resolve, ms));
}

const calculateKeccak256Hash = (name) => {
    const encodedName = ethers.AbiCoder.defaultAbiCoder().encode(['string'], [name]);
    const keccakHash = ethers.keccak256(encodedName);
    return keccakHash;
}

let createDeck = async (world_contract, name, hero, cards) => {
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

let nonce = 0;

async function init() {
    let private_key = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";
    let provider = new JsonRpcProvider("http://127.0.0.1:8545");
    let wallet = new Wallet(private_key, provider);

    const world_abi = loadJSON('../../contracts/out/IWorld.sol/IWorld.abi.json');

    let world_address = "0x6e9474e9c83676b9a71133ff96db43e7aa0a4342";
    let world_contract = new Contract(world_address, world_abi, wallet);

    nonce = await provider.getTransactionCount(wallet.address);
    console.log("nonce", nonce);

    await createDeck(world_contract, 'fire_deck', 'hero_fire', 'phoenix|phoenix|phoenix|phoenix|phoenix|phoenix|phoenix|hell_hound|ashes_snake|fire_element|wolf_furious|phoenix|dragon_red|spell_burn|spell_burn|potion_red|potion_red|trap_explosive|spell_armageddon|town_volcano');
    await createDeck(world_contract, 'forest_deck', 'hero_forest', 'wolf_alpha|wolf_alpha|wolf_stalker|wolf_stalker|tree_angry|tree_angry|owl|raccoon|armored_beast|bear|sasquatch|unicorn|dragon_green|spell_roots|spell_roots|potion_green|potion_green|spell_growth|trap_spike|town_forest');
    await createDeck(world_contract, 'water_deck', 'hero_water', 'fish|crab_mana|crab_mana|turtle|turtle|poison_frog|eel|eel|pufferfish|killer_whale|kraken|sea_monster|dragon_blue|spell_wave|spell_wave|spell_storm|potion_blue|potion_blue|trap_fish|town_underwater');
    await createDeck(world_contract, 'test_deck', 'hero_fire', 'wolf_alpha|wolf_alpha|wolf_stalker|wolf_stalker|tree_angry|tree_angry|armored_beast|armored_beast|raccoon|raccoon|owl|owl|bear|bear|sasquatch|unicorn|dragon_green|trap_spike|spell_roots|spell_growth|potion_green|town_forest|imp|imp|lava_beast|lava_beast|fire_chicken|fire_chicken|firefox|firefox|wolf_furious|wolf_furious|fire_element|fire_element|phoenix|dragon_red|spell_burn|spell_armageddon|potion_red|trap_explosive|town_volcano|fish|fish|turtle|turtle|crab_mana|crab_mana|eel|pufferfish|pufferfish|killer_whale|killer_whale|sea_monster|kraken|dragon_blue|potion_blue|spell_wave|spell_storm|trap_fish|town_underwater|seagull|seagull|shark|spell_flood|spell_treasure|spell_treasure|octopus|bull_heat|dark_stallion|reaper|spell_aerial_strike|spell_stones|spell_stones|mammoth|gorilla|snake_venom|snake_venom|spell_hibernate|spell_stomp|spell_stomp|bay|cave|woodland|spell_split|spell_extinct|spell_submerge|equip_sword|equip_shield|equip_ring|dragon_egg');
    await createDeck(world_contract, 'level1_ai', '', 'coin|coin|coin');
    await createDeck(world_contract, 'level1_player', '', 'spell_growth|spell_growth|crab_mana|crab_mana|coin');
    await createDeck(world_contract, 'level2_ai', '', 'imp|imp|spell_stones|fire_chicken|fire_chicken|spell_burn');
    await createDeck(world_contract, 'level2_player', '', 'eel|potion_green|potion_green|potion_green|potion_green|potion_green');
    await createDeck(world_contract, 'level3_ai', '', 'potion_red|hell_hound|hell_hound|hell_hound|spell_burn');
    await createDeck(world_contract, 'level3_player', '', 'phoenix|phoenix|phoenix|phoenix|snake_venom|mammoth');
    await createDeck(world_contract, 'level4_ai', '', 'ashes_snake|spell_stones|ashes_snake|spell_stones|ashes_snake|phoenix');
    await createDeck(world_contract, 'level4_player', '', 'snake_venom|snake_venom|snake_venom|snake_venom|snake_venom|snake_venom|snake_venom|snake_venom');
    await createDeck(world_contract, 'level5_ai', '', 'fire_chicken|firefox|town_volcano|hell_hound|spell_burn|fire_chicken|fire_chicken');
    await createDeck(world_contract, 'level5_player', '', 'owl|town_forest|spell_roots|raccoon|snake_venom|tree_angry|potion_green');
}

init();