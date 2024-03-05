import {Contract, ethers, JsonRpcProvider, Wallet} from 'ethers';
// import IWorldAbi from "../../contracts/out/IWorld.sol/IWorld.abi.json";
import * as fs from 'fs';
import * as common from "./common.cjs";

// @ts-ignore
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

const getCardType = (str) => {
    const cardType = common.CardType[str];
    if (cardType === undefined) {
        console.error("not exist getCardType", str)
    }
    return cardType;
}

const getRarityType = (str) => {
    const cardType = common.RarityType[str];
    if (cardType === undefined) {
        // console.error("not exist getRarityType", str)
        return common.RarityType.NONE;
    }
    return cardType;
}

const getCardTrait = (str) => {
    const cardType = common.CardTrait[str];
    if (cardType === undefined) {
        // console.error("not exist getCardTrait", str)
        return common.CardTrait.None;
    }
    return cardType;
}
const getAbilityTrigger = (str) => {
    const cardType = common.AbilityTrigger[str];
    if (cardType === undefined) {
        // console.error("not exist getCardTrait", str)
        return common.AbilityTrigger.None;
    }
    return cardType;
}

const getAbilityTarget = (str) => {
    const cardType = common.AbilityTarget[str];
    if (cardType === undefined) {
        // console.error("not exist getCardTrait", str)
        return common.AbilityTarget.None;
    }
    return cardType;
}


function convertToCamelCase(str) {
    var words = str.split('_');
    for (var i = 1; i < words.length; i++) {
        words[i] = words[i].charAt(0).toUpperCase() + words[i].slice(1);
    }
    str = words.join('');
    return str.charAt(0).toUpperCase() + str.slice(1);
}

function convertToEnumFormat(str) {
    // 将字符串中的大写字母前添加下划线，然后全部转为大写
    const formattedStr = str.replace(/([A-Z])/g, '_$1').toUpperCase();

    // 如果字符串以下划线开头，则去掉开头的下划线
    if (formattedStr.startsWith('_')) {
        return formattedStr.slice(1);
    }

    return formattedStr;
}

const arrStr2Bytes32 = (arr_str) => {
    if (arr_str.length == 0) {
        return [];
    }
    const arr = arr_str.split('|');
    const arr_bytes32 = arr.map((item) => {
        return calculateKeccak256Hash(item);
    });
    return arr_bytes32;
}

const initCard = async (name, mana, attack, hp, cost, abilities_str, cardType, rarity, is_deckbuilding, trait) => {
    const cardTypeCode = getCardType(cardType);
    let rarity_str = convertToEnumFormat(rarity);
    const rarityCode = getRarityType(rarity_str.substr(2,));
    const traitCode = getCardTrait(convertToCamelCase(trait));
    const tx = await world_contract.initCard(name, mana, attack, hp, cost, arrStr2Bytes32(abilities_str), cardTypeCode, rarityCode, is_deckbuilding, traitCode, {
        nonce: nonce++
    });
    tx.wait().then((receipt) => {
        console.log("initCard", name, receipt.hash);
    });
};

let nonce = 0;
let world_contract = null;


const getSelectorFromArrStr = (arrstr, formater) => {
    if (arrstr.length === 0) {
        return [];
    }
    const arr = arrstr.split('|');
    const arr_bytes4 = arr.map((item) => {
        return formater(item);
    });
    return arr_bytes4;
}

const getConditionSelector = (name) => {
    if (name.length === 0) {
        return null
    }
    const functionName = convertToPascalCase(name) + '(bytes32,bytes32,uint8,bytes32,bytes32)';
    const functionSelector = ethers.keccak256(ethers.toUtf8Bytes(functionName)).slice(0, 10);
    // console.log(name, functionName, functionSelector)

    return functionSelector;
}

function convertToPascalCase(str) {
    return str.replace(/_([a-z])/g, function (match, letter) {
        return letter.toUpperCase();
    }).replace(/^([a-z])/, function (match, letter) {
        return letter.toUpperCase();
    });
}

const getEffectSelector = (name) => {
    if (name.length === 0) {
        return null
    }
    //0xb618c8ba
    // bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card
    const functionName = 'Effect' + convertToPascalCase(name) + '(bytes32,bytes32,bytes32,bytes32,uint8)';
    const functionSelector = ethers.keccak256(ethers.toUtf8Bytes(functionName)).slice(0, 10);
    // console.log(functionName, functionSelector)

    return functionSelector;
}

const getStatus = (str) => {
    const status = common.Status[str];
    if (status === undefined) {
        console.error("not exist getStatus", str)
        return common.Status.None;
    }
    return status;
}


const initAbility = async (id, trigger, target, value, manaCost, duration, exhaust, effect_str, conditionsTarget, conditionsTrigger, filtersTarget, chainAbilities, status) => {

    const key = calculateKeccak256Hash(id);

    const trigger_code = getAbilityTrigger(convertToEnumFormat(trigger));
    const target_code = getAbilityTarget((target));
    let status_code = [];
    if (status.length !== 0) {
        status_code = status.split("|").map((i) => {
            let name = convertToCamelCase(i);
            let status = getStatus(name);
            if (status) {
                return status;
            } else {
                // console.error("status not found", name);
            }
        });
    }
    status_code = status_code.filter((i) => {
        return i !== undefined && i!==null
    });
    // console.log("initAbility", id, key, status, status_code);
    //
    //
    const conditionsTarget_byes32 = getSelectorFromArrStr(conditionsTarget, getConditionSelector);
    const conditionsTrigger_byes32 = getSelectorFromArrStr(conditionsTrigger, getConditionSelector);
    const filtersTarget_byes32 = getSelectorFromArrStr(filtersTarget, getFilterSelector);
    const chainAbilities_byes32 = arrStr2Bytes32(chainAbilities);

    const tx = await world_contract.initAbility(
        id,
        trigger_code,
        target_code,
        value,
        manaCost,
        duration,
        exhaust,
        getSelectorFromArrStr(effect_str, getEffectSelector),
        status_code,
        {
            nonce: nonce++
        }
    );
    tx.wait().then((receipt) => {
        console.log("initAbility", id, receipt.hash);
    });
    const tx2 = await world_contract.initAbilityExtend(
        id,
        conditionsTarget_byes32,
        conditionsTrigger_byes32,
        filtersTarget_byes32,
        chainAbilities_byes32,
        {
            nonce: nonce++,
        });

    tx2.wait().then((receipt) => {
        console.log("initAbilityExtend", id, receipt.hash);
    });

    // await waitForTransaction(tx2);

    // ablities[key.toString()] = id;
    // return tx;
}

const getFilterSelector = (name) => {
    if (name.length === 0) {
        return null
    }
    //0xb618c8ba
    // bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card
    const functionName = convertToPascalCase(name) + '(bytes32,bytes32,bytes32[],uint8)';
    const functionSelector = ethers.keccak256(ethers.toUtf8Bytes(functionName)).slice(0, 10);
    // console.log(functionName, functionSelector)

    return functionSelector;
}


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


    await initAbility('activate_boost1', 'Activate', 'AllCardsBoard', 1, 0, 1, true, '', 'is_character|is_ally', '', '', '', 'attack');
    await initAbility('activate_burst', 'Activate', 'Self', 1, 0, 0, false, 'damage', '', '', '', 'chain_gain_attack', '');
    await initAbility('activate_damage2', 'Activate', 'SelectTarget', 2, 3, 0, false, 'damage', 'is_not_empty|is_not_self|ai_is_enemy', '', '', '', '');
    await initAbility('activate_discard', 'Activate', 'AllCardsHand', 1, 0, 0, true, 'discard', 'is_in_hand|is_enemy', '', 'filter_random_1', '', '');
    await initAbility('activate_fire', 'Activate', 'SelectTarget', 1, 2, 0, true, 'damage', 'is_not_empty|ai_is_enemy', 'once_per_turn', '', '', '');
    await initAbility('activate_forest', 'Activate', 'SelectTarget', 2, 2, 0, true, 'heal', 'is_not_empty|ai_is_ally', 'once_per_turn', '', '', '');
    await initAbility('activate_select_discard_spell', 'Activate', 'CardSelector', 0, 2, 0, false, 'send_hand', 'is_in_discard|is_spell|is_ally', 'has_discard_spell', '', '', '');
    await initAbility('activate_send_hand', 'Activate', 'SelectTarget', 0, 0, 0, true, 'send_hand', 'is_character|is_not_self|ai_is_enemy', '', '', '', '');
    await initAbility('activate_water', 'Activate', 'PlayerSelf', 1, 3, 0, true, 'draw', '', 'once_per_turn', '', '', '');
    await initAbility('chain_gain_attack', 'None', 'Self', 1, 0, 0, false, 'add_attack', '', '', '', '', '');
    await initAbility('activate_roll_send_hand', 'Activate', 'SelectTarget', 0, 2, 0, false, 'roll_d6', 'is_character|is_not_self|ai_is_enemy', '', '', 'roll_send_hand', '');
    await initAbility('attack_roll_attack_bonus', 'OnBeforeAttack', 'Self', 0, 0, 0, false, 'roll_d6', '', '', '', 'roll_attack_bonus', '');
    await initAbility('play_roll_attack', 'OnPlay', 'Self', 0, 0, 0, false, 'roll_d6', '', '', '', 'roll_add_attack', '');
    await initAbility('roll_add_attack', 'None', 'Self', 0, 0, 0, false, 'add_attack_roll', '', '', '', '', '');
    await initAbility('roll_attack_bonus', 'None', 'Self', 6, 0, 1, false, '', '', 'rolled_4P', '', '', 'attack');
    await initAbility('roll_send_hand', 'None', 'LastTargeted', 0, 0, 0, false, 'send_hand', '', 'rolled_4P', '', '', '');
    await initAbility('chain_equip_use', 'None', 'Self', -1, 0, 0, false, 'add_hp', '', '', '', '', '');
    await initAbility('equip_armor2', 'Ongoing', 'EquippedCard', 2, 0, 0, false, '', '', '', '', '', 'armor');
    await initAbility('equip_attack1', 'Ongoing', 'EquippedCard', 1, 0, 0, false, 'add_attack', '', '', '', '', '');
    await initAbility('equip_attack2', 'Ongoing', 'EquippedCard', 2, 0, 0, false, 'add_attack', '', '', '', '', '');
    await initAbility('equip_attack_no_damage', 'OnBeforeAttack', 'EquippedCard', 0, 0, 1, false, '', '', '', '', '', 'intimidate');
    await initAbility('equip_attack_use', 'OnAfterAttack', 'Self', -1, 0, 0, false, 'add_hp', '', '', '', '', '');
    await initAbility('equip_defend_use', 'OnAfterDefend', 'Self', -1, 0, 0, false, 'add_hp', '', '', '', '', '');
    await initAbility('equip_gain_mana', 'StartOfTurn', 'PlayerSelf', 2, 0, 0, false, 'gain_mana', '', '', '', 'chain_equip_use', '');
    await initAbility('equip_mana_kill', 'OnKill', 'PlayerSelf', 3, 0, 0, false, 'gain_mana', '', '', '', '', '');
    await initAbility('equip_taunt', 'Ongoing', 'EquippedCard', 0, 0, 0, false, '', '', '', '', '', 'taunt');
    await initAbility('add_spell_damage1', 'Ongoing', 'PlayerSelf', 1, 0, 0, false, 'add_spell_damage', '', '', '', '', '');
    await initAbility('aura_ability_red', 'Ongoing', 'AllCardsBoard', 0, 0, 0, false, 'add_ability_activate_burst', 'is_red|is_ally|is_character', '', '', '', '');
    await initAbility('aura_attack_m1', 'Ongoing', 'AllCardsBoard', -1, 0, 0, false, 'add_attack', 'is_character|is_not_self|is_enemy', '', '', '', '');
    await initAbility('aura_wolf', 'Ongoing', 'AllCardsBoard', 1, 0, 0, false, 'add_attack', 'is_character|is_wolf|is_not_self|is_ally', '', '', '', '');
    await initAbility('deathtouch', 'Ongoing', 'Self', 0, 0, 0, false, '', '', '', '', '', 'deathtouch');
    await initAbility('defense_attack3', 'Ongoing', 'Self', 3, 0, 0, false, 'add_attack', '', 'is_not_your_turn', '', '', '');
    await initAbility('flying', 'Ongoing', 'Self', 0, 0, 0, false, '', '', '', '', '', 'flying');
    await initAbility('fury', 'Ongoing', 'Self', 0, 0, 0, false, '', '', '', '', '', 'fury');
    await initAbility('lifesteal', 'Ongoing', 'Self', 0, 0, 0, false, '', '', '', '', '', 'lifesteal');
    await initAbility('spell_immunity', 'Ongoing', 'Self', 0, 0, 0, false, '', '', '', '', '', 'spell_immunity');
    await initAbility('taunt', 'Ongoing', 'Self', 0, 0, 0, false, '', '', '', '', '', 'taunt');
    await initAbility('town_aura_blue', 'Ongoing', 'AllCardsHand', -1, 0, 0, false, 'add_mana', 'is_blue|is_ally', '', '', '', '');
    await initAbility('town_aura_green', 'Ongoing', 'AllCardsBoard', 2, 0, 0, false, 'add_hp', 'is_character|is_green|is_ally', '', '', '', '');
    await initAbility('town_aura_red', 'Ongoing', 'AllCardsBoard', 2, 0, 0, false, 'add_attack', 'is_character|is_red|is_ally', '', '', '', '');
    await initAbility('trample', 'Ongoing', 'Self', 0, 0, 0, false, '', '', '', '', '', 'trample');
    await initAbility('after_spell_attack2', 'OnPlayOther', 'Self', 2, 0, 0, false, 'add_attack', '', 'is_spell|is_ally', '', '', '');
    await initAbility('attack_player_mana2', 'OnAfterAttack', 'PlayerSelf', 2, 0, 0, false, 'gain_mana', '', 'is_player', '', '', '');
    await initAbility('attack_poison', 'OnBeforeAttack', 'AbilityTriggerer', 1, 0, 0, false, '', 'is_not_self|is_character', '', '', '', 'poisoned');
    await initAbility('attack_suffer_damage', 'OnBeforeAttack', 'Self', 3, 0, 0, false, 'damage', '', '', '', '', '');
    await initAbility('chain_draw', 'None', 'PlayerSelf', 1, 0, 0, false, 'draw', '', '', '', '', '');
    await initAbility('death_blue_draw', 'OnDeathOther', 'PlayerSelf', 1, 0, 0, false, 'draw', '', 'is_ally|is_blue|is_character', '', '', '');
    await initAbility('death_egg', 'OnDeath', 'Self', 2, 0, 0, false, 'summon_egg', '', '', '', '', '');
    await initAbility('death_heal2', 'OnDeath', 'PlayerSelf', 2, 0, 0, false, 'heal', '', '', '', '', '');
    await initAbility('death_other_draw', 'OnDeathOther', 'PlayerSelf', 1, 0, 0, false, 'draw', '', 'is_character', '', '', '');
    await initAbility('defend_discard', 'OnBeforeDefend', 'AllCardsHand', 1, 0, 0, false, 'discard', 'is_enemy', '', 'filter_random_1', '', '');
    await initAbility('defend_poison', 'OnBeforeDefend', 'AbilityTriggerer', 1, 0, 0, false, '', 'is_not_self|is_character', '', '', '', 'poisoned');
    await initAbility('egg_growth', 'StartOfTurn', 'Self', 1, 0, 0, false, 'add_growth', '', '', '', 'egg_transform', '');
    await initAbility('egg_transform', 'StartOfTurn', 'Self', 0, 0, 0, false, 'transform_phoenix', '', 'is_growth3', '', '', '');
    await initAbility('kill_draw2', 'OnKill', 'PlayerSelf', 2, 0, 0, false, 'draw', '', 'is_character', '', '', '');
    await initAbility('play_other_sacrifice', 'OnPlayOther', 'Self', 0, 0, 0, false, 'destroy', '', 'is_ally|is_character', '', '', '');
    await initAbility('regen3', 'StartOfTurn', 'Self', 3, 0, 0, false, 'heal', '', '', '', '', '');
    await initAbility('regen_all', 'StartOfTurn', 'Self', 99, 0, 0, false, 'heal', '', '', '', '', '');
    await initAbility('turn_add_attack1', 'StartOfTurn', 'Self', 1, 0, 0, false, 'add_attack', '', '', '', '', '');
    await initAbility('turn_green_heal', 'StartOfTurn', 'AllCardsBoard', 3, 0, 0, false, 'heal', 'is_green|is_ally', '', '', '', '');
    await initAbility('turn_kill_lowest', 'StartOfTurn', 'AllCardsBoard', 0, 0, 0, false, 'destroy', 'is_character', '', 'filter_lowest_attack', '', '');
    await initAbility('turn_stealth', 'EndOfTurn', 'Self', 0, 0, 0, false, 'clear_taunt', '', 'has_board_characters2', '', '', 'stealth');
    await initAbility('choice_fury', 'None', 'Self', 0, 0, 0, false, '', '', '', '', '', 'fury');
    await initAbility('choice_taunt', 'None', 'Self', 0, 0, 0, false, '', '', '', '', '', 'taunt');
    await initAbility('play_boost2', 'OnPlay', 'SelectTarget', 2, 0, 2, true, '', 'is_character|is_not_self|ai_is_ally', '', '', '', 'attack|hp');
    await initAbility('play_choice_taunt_fury', 'OnPlay', 'ChoiceSelector', 0, 0, 0, false, '', '', '', '', 'choice_taunt|choice_fury', '');
    await initAbility('play_deal_damage1', 'OnPlay', 'SelectTarget', 1, 0, 0, false, 'damage', 'is_not_self|is_not_empty|ai_is_enemy', '', '', '', '');
    await initAbility('play_damage_all2', 'OnPlay', 'AllCardsBoard', 2, 0, 0, false, 'damage', 'is_not_self', '', '', '', '');
    await initAbility('play_destroy_less4', 'OnPlay', 'SelectTarget', 0, 0, 0, false, 'destroy', 'is_not_self|is_character|is_attack_4L|is_enemy', '', '', 'chain_draw', '');
    await initAbility('play_discard', 'OnPlay', 'AllCardsAllPiles', 1, 0, 0, false, 'discard', 'is_in_hand|is_enemy', '', 'filter_random_1', '', '');
    await initAbility('play_haste', 'OnPlay', 'Self', 0, 0, 0, false, 'unexhaust', '', '', '', '', '');
    await initAbility('play_poison', 'OnPlay', 'SelectTarget', 1, 0, 0, false, '', 'is_not_self|is_character|ai_is_enemy', '', '', '', 'poisoned');
    await initAbility('play_select_discard', 'OnPlay', 'CardSelector', 0, 0, 0, false, 'send_hand', 'is_in_discard|is_character|is_ally', 'has_discard_character', '', '', '');
    await initAbility('play_set_attack1', 'OnPlay', 'SelectTarget', 1, 0, 0, false, 'set_attack', 'is_not_self|is_character|is_enemy', '', '', '', '');
    await initAbility('play_silence', 'OnPlay', 'SelectTarget', 0, 0, 0, false, 'clear_status_all|reset_stats', 'is_not_self|is_card|ai_is_enemy', '', '', '', 'silenced');
    await initAbility('play_summon_wolf', 'OnPlay', 'AllSlots', 1, 0, 0, false, 'summon_wolf', 'is_slot_empty|is_ally|is_slot_next_to', '', 'filter_random_1', '', '');
    await initAbility('shell', 'OnPlay', 'Self', 0, 0, 0, false, '', '', '', '', '', 'shell');
    await initAbility('stealth', 'OnPlay', 'Self', 0, 0, 0, false, '', '', '', '', '', 'stealth');
    await initAbility('chain_clear_temp', 'None', 'None', 0, 0, 0, false, 'clear_temp', '', '', '', '', '');
    await initAbility('chain_discover', 'None', 'CardSelector', 0, 0, 0, false, 'send_hand', 'is_in_temp|is_ally', '', '', '', '');
    await initAbility('chain_hibernate', 'None', 'PlayTarget', 0, 0, 4, false, 'exhaust', 'is_character', '', '', '', 'sleep');
    await initAbility('chain_treasure', 'None', 'CardSelector', 0, 0, 0, false, 'send_hand', 'is_ally|is_in_deck', '', 'filter_first_6', '', '');
    await initAbility('spell_add_attack_suffer', 'OnPlay', 'PlayTarget', 0, 0, 0, false, 'add_ability_suffer_damage', 'is_character|is_enemy', '', '', '', '');
    await initAbility('spell_add_play_extinct', 'OnPlay', 'PlayTarget', 0, 0, 0, false, 'add_ability_play_sacrifice', 'is_card|is_enemy', '', '', '', '');
    await initAbility('spell_add_submerge', 'OnPlay', 'PlayTarget', 0, 0, 0, false, 'add_ability_defend_discard', 'is_card|is_ally', '', '', '', '');
    await initAbility('spell_ally_attack_2', 'OnPlay', 'AllCardsBoard', 2, 0, 0, false, 'add_attack', 'is_ally|is_character', '', '', '', '');
    await initAbility('spell_ally_hp_2', 'OnPlay', 'AllCardsBoard', 2, 0, 0, false, 'add_hp', 'is_ally', '', '', '', '');
    await initAbility('spell_armor2', 'OnPlay', 'PlayTarget', 2, 0, 0, false, '', 'is_card|is_ally', '', '', '', 'armor');
    await initAbility('spell_attack1', 'OnPlay', 'PlayTarget', 1, 0, 0, false, 'add_attack', 'is_character|is_ally', '', '', '', '');
    await initAbility('spell_coin', 'OnPlay', 'PlayerSelf', 1, 0, 0, false, 'gain_mana', '', '', '', '', '');
    await initAbility('spell_damage1', 'OnPlay', 'PlayTarget', 1, 0, 0, false, 'damage', 'is_not_empty|ai_is_enemy', '', '', '', '');
    await initAbility('spell_damage3', 'OnPlay', 'PlayTarget', 3, 0, 0, false, 'damage', 'is_not_empty|ai_is_enemy', '', '', '', '');
    await initAbility('spell_destroy', 'OnPlay', 'PlayTarget', 0, 0, 0, false, 'destroy', 'is_card|ai_is_enemy', '', '', '', '');
    await initAbility('spell_destroy_all', 'OnPlay', 'AllCardsBoard', 0, 0, 0, false, 'destroy', 'is_character', '', '', '', '');
    await initAbility('spell_dragon_create', 'OnPlay', 'AllCardData', 0, 0, 0, false, 'create_temp', 'is_dragon|is_deckbuilding', '', 'filter_random_3', 'chain_discover|chain_clear_temp', '');
    await initAbility('spell_draw1', 'OnPlay', 'PlayerSelf', 1, 0, 0, false, 'draw', '', '', '', '', '');
    await initAbility('spell_fury', 'OnPlay', 'PlayTarget', 0, 0, 0, false, '', 'is_character|is_ally', '', '', '', 'fury');
    await initAbility('spell_heal_full', 'OnPlay', 'PlayTarget', 99, 0, 0, false, 'heal', 'is_card|is_ally', '', '', '', '');
    await initAbility('spell_hibernate', 'OnPlay', 'PlayTarget', 4, 0, 0, false, 'add_attack|add_hp', 'is_character', '', '', 'chain_hibernate', '');
    await initAbility('spell_hp2', 'OnPlay', 'PlayTarget', 2, 0, 0, false, 'add_hp', 'is_card|is_ally', '', '', '', '');
    await initAbility('spell_kill_lowest_hp', 'OnPlay', 'AllCardsBoard', 0, 0, 0, false, 'destroy', 'is_character', '', 'filter_lowest_hp|filter_random_1', '', '');
    await initAbility('spell_paralyse', 'OnPlay', 'PlayTarget', 0, 0, 6, false, '', 'is_character|is_enemy', '', '', '', 'paralysed');
    await initAbility('spell_return_all', 'OnPlay', 'AllCardsBoard', 0, 0, 0, false, 'send_hand', '', '', '', '', '');
    await initAbility('spell_send_hand', 'OnPlay', 'PlayTarget', 0, 0, 0, false, 'send_hand', 'is_card|ai_is_enemy', '', '', '', '');
    await initAbility('spell_damage_per_hand', 'OnPlay', 'AllCardsBoard', 1, 0, 0, false, 'set_hp', 'is_character', '', '', '', '');
    await initAbility('spell_shell', 'OnPlay', 'PlayTarget', 0, 0, 0, false, '', 'is_card|is_ally', '', '', '', 'shell');
    await initAbility('spell_summon_eagle', 'OnPlay', 'PlayerSelf', 0, 0, 0, false, 'summon_eagle|summon_eagle|summon_eagle', '', '', '', '', '');
    await initAbility('spell_taunt', 'OnPlay', 'PlayTarget', 0, 0, 0, false, '', 'is_card|is_ally|is_not_stealth', '', '', '', 'taunt');
    await initAbility('spell_treasure', 'OnPlay', 'CardSelector', 0, 0, 0, false, 'send_hand', 'is_ally|is_in_deck', '', 'filter_first_7', 'chain_treasure', '');
    await initAbility('trap_damage_all2', 'OnBeforeAttack', 'AllCardsBoard', 2, 0, 0, false, 'damage', 'is_character|is_enemy', 'is_character|is_enemy', '', '', '');
    await initAbility('trap_paralyse3', 'OnAfterAttack', 'AbilityTriggerer', 0, 0, 6, false, '', '', 'is_character|is_enemy', '', '', 'paralysed');
    await initAbility('secret_transform_fish', 'OnPlayOther', 'AbilityTriggerer', 1, 0, 0, false, 'transform_fish', '', 'is_character|is_enemy', '', '', '');
}

init();