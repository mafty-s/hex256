import {useMUD} from "./MUDContext";
import React, {useEffect} from 'react';
import {ethers} from 'ethers';
import * as console from "console";

export const App = () => {
    const {
        network: {tables, useStore, walletClient},
        systemCalls: {
            addTask,
            toggleTask,
            deleteTask,
            addUser,
            // getUser,
            getUserByOwner,
            initCard,
            initPack,
            initDeck,
            initAbility,
            calculateKeccak256Hash,
            convertBigIntToInt,
            buyCard,
            getCard,
            incr,
            getRandomCardByRarity,
            openPack
        },
    } = useMUD();

    // const tasks = useStore((state) => {
    //     const records = Object.values(state.getRecords(tables.Tasks));
    //     records.sort((a, b) => Number(a.value.createdAt - b.value.createdAt));
    //     return records;
    // });
    //
    // const cards = useStore((state) => {
    //     const records = Object.values(state.getRecords(tables.Cards));
    //     records.sort((a, b) => Number(a.value.createdAt - b.value.createdAt));
    //     return records;
    // });
    //
    // const users = useStore((state) => {
    //     const records = Object.values(state.getRecords(tables.Users));
    //     records.sort((a, b) => Number(a.value.createdAt - b.value.createdAt));
    //     // console.log("users", records);
    //     return records;
    // });


    function unityShowBanner(msg, type) {
        function updateBannerVisibility() {
            warningBanner.style.display = warningBanner.children.length ? 'block' : 'none';
        }

        var div = document.createElement('div');
        div.innerHTML = msg;
        warningBanner.appendChild(div);
        if (type == 'error') div.style = 'background: red; padding: 10px;';
        else {
            if (type == 'warning') div.style = 'background: yellow; padding: 10px;';
            setTimeout(function () {
                warningBanner.removeChild(div);
                updateBannerVisibility();
            }, 5000);
        }
        updateBannerVisibility();
    }

    let createDeck = (name, hero, cards) => {
        let cards_arr = cards.split('|');
        let cards_keys = [];
        for (let i = 0; i < cards_arr.length; i++) {
            let card_id = cards_arr[i];
            let card_key = calculateKeccak256Hash(card_id);
            cards_keys.push(card_key);
        }
        initDeck(name, calculateKeccak256Hash(hero), cards_keys);
    }

    let init = () => {
        initCard('ashes_snake', 5, 6, 4, 100, 'stealth', 'Character', '2-uncommon');
        initCard('bull_heat', 3, 2, 5, 100, 'add_spell_damage1', 'Character', '1-common');
        initCard('cave', 2, 0, 5, 100, 'aura_ability_red', 'Artifact', '3-rare');
        initCard('dark_stallion', 4, 4, 5, 100, 'activate_roll_send_hand', 'Character', '2-uncommon');
        initCard('dragon_red', 7, 9, 7, 100, 'spell_immunity', 'Character', '4-mythic');
        initCard('equip_sword', 2, 0, 2, 100, 'equip_attack1|equip_attack_no_damage|equip_attack_use', 'Equipment', '2-uncommon');
        initCard('fire_chicken', 2, 1, 1, 100, 'death_egg', 'Character', '1-common');
        initCard('fire_element', 5, 7, 3, 100, 'play_damage_all2', 'Character', '2-uncommon');
        initCard('firefox', 4, 4, 4, 100, 'activate_select_discard_spell', 'Character', '2-uncommon');
        initCard('hell_hound', 4, 4, 2, 100, 'fury', 'Character', '1-common');
        initCard('imp', 2, 2, 1, 100, 'play_deal_damage1', 'Character', '1-common');
        initCard('lava_beast', 3, 2, 3, 100, 'after_spell_attack2', 'Character', '1-common');
        initCard('phoenix', 6, 6, 6, 100, 'activate_damage2|death_egg', 'Character', '4-mythic');
        initCard('potion_red', 2, 0, 0, 100, 'spell_attack1|spell_fury', 'Spell', '1-common');
        initCard('reaper', 6, 6, 6, 100, 'turn_kill_lowest', 'Character', '3-rare');
        initCard('spell_aerial_strike', 3, 0, 0, 100, 'spell_summon_eagle', 'Spell', '4-mythic');
        initCard('spell_armageddon', 5, 0, 0, 100, 'spell_destroy_all', 'Spell', '3-rare');
        initCard('spell_burn', 4, 0, 0, 100, 'spell_destroy', 'Spell', '1-common');
        initCard('spell_split', 2, 0, 0, 100, 'spell_add_attack_suffer', 'Spell', '3-rare');
        initCard('spell_stones', 2, 0, 0, 100, 'spell_damage1|spell_draw1', 'Spell', '2-uncommon');
        initCard('town_volcano', 3, 0, 7, 100, 'town_aura_red', 'Artifact', '1-common');
        initCard('trap_explosive', 3, 0, 0, 100, 'trap_damage_all2', 'Secret', '2-uncommon');
        initCard('wolf_furious', 5, 3, 4, 100, 'fury|turn_add_attack1', 'Character', '3-rare');
        initCard('armored_beast', 4, 3, 6, 100, 'taunt', 'Character', '1-common');
        initCard('bear', 5, 4, 5, 100, 'play_choice_taunt_fury', 'Character', '2-uncommon');
        initCard('dragon_green', 7, 7, 9, 100, 'spell_immunity', 'Character', '4-mythic');
        initCard('equip_shield', 2, 0, 2, 100, 'equip_armor2|equip_taunt|equip_defend_use', 'Equipment', '2-uncommon');
        initCard('gorilla', 4, 0, 6, 100, 'play_roll_attack', 'Character', '2-uncommon');
        initCard('mammoth', 6, 7, 6, 100, 'trample', 'Character', '3-rare');
        initCard('owl', 3, 2, 3, 100, 'play_silence', 'Character', '2-uncommon');
        initCard('potion_green', 2, 0, 0, 100, 'spell_hp2|spell_taunt', 'Spell', '1-common');
        initCard('raccoon', 2, 2, 3, 100, 'play_select_discard', 'Character', '1-common');
        initCard('sasquatch', 5, 6, 4, 100, 'turn_stealth', 'Character', '3-rare');
        initCard('snake_venom', 2, 1, 3, 100, 'attack_poison|defend_poison', 'Character', '1-common');
        initCard('spell_extinct', 2, 0, 0, 100, 'spell_add_play_extinct', 'Spell', '3-rare');
        initCard('spell_growth', 5, 0, 0, 100, 'spell_ally_attack_2|spell_ally_hp_2', 'Spell', '3-rare');
        initCard('spell_hibernate', 3, 0, 0, 100, 'spell_hibernate', 'Spell', '4-mythic');
        initCard('spell_roots', 3, 0, 0, 100, 'spell_paralyse', 'Spell', '1-common');
        initCard('spell_stomp', 2, 0, 0, 100, 'spell_kill_lowest_hp', 'Spell', '2-uncommon');
        initCard('town_forest', 3, 0, 7, 100, 'town_aura_green', 'Artifact', '1-common');
        initCard('trap_spike', 3, 0, 0, 100, 'trap_paralyse3', 'Secret', '2-uncommon');
        initCard('tree_angry', 3, 3, 5, 100, 'regen_all', 'Character', '1-common');
        initCard('unicorn', 6, 5, 6, 100, 'play_boost2|activate_send_hand', 'Character', '4-mythic');
        initCard('wolf_alpha', 3, 3, 2, 100, 'play_summon_wolf|aura_wolf', 'Character', '2-uncommon');
        initCard('wolf_stalker', 3, 4, 2, 100, 'stealth', 'Character', '1-common');
        initCard('woodland', 2, 0, 5, 100, 'turn_green_heal', 'Artifact', '3-rare');
        initCard('hero_fire', 0, 0, 0, 100, 'activate_fire', 'Hero', '4-mythic');
        initCard('hero_forest', 0, 0, 0, 100, 'activate_forest', 'Hero', '4-mythic');
        initCard('hero_water', 0, 0, 0, 100, 'activate_water', 'Hero', '4-mythic');
        initCard('coin', 0, 0, 0, 100, 'spell_coin', 'Spell', '1-common');
        initCard('dragon_egg', 2, 0, 0, 100, 'spell_dragon_create', 'Spell', '4-mythic');
        initCard('flame_eagle', 1, 1, 1, 100, 'flying|play_haste', 'Character', '1-common');
        initCard('phoenix_egg', 0, 0, 3, 100, 'egg_growth', 'Artifact', '1-common');
        initCard('wolf_baby', 1, 1, 1, 100, '', 'Character', '1-common');
        initCard('bay', 2, 0, 5, 100, 'death_blue_draw', 'Artifact', '3-rare');
        initCard('crab_mana', 2, 3, 1, 100, 'attack_player_mana2', 'Character', '1-common');
        initCard('dragon_blue', 7, 8, 8, 100, 'spell_immunity', 'Character', '4-mythic');
        initCard('eel', 4, 5, 2, 100, 'play_set_attack1', 'Character', '2-uncommon');
        initCard('equip_ring', 1, 0, 3, 100, 'equip_gain_mana', 'Equipment', '2-uncommon');
        initCard('fish', 1, 1, 1, 100, 'death_blue_draw', 'Character', '1-common');
        initCard('killer_whale', 5, 5, 4, 100, 'play_destroy_less4', 'Character', '3-rare');
        initCard('kraken', 6, 5, 5, 100, 'play_haste', 'Character', '3-rare');
        initCard('octopus', 4, 2, 5, 100, 'attack_roll_attack_bonus', 'Character', '2-uncommon');
        initCard('poison_frog', 3, 2, 2, 100, 'deathtouch', 'Character', '2-uncommon');
        initCard('potion_blue', 2, 0, 0, 100, 'spell_shell|spell_heal_full', 'Spell', '1-common');
        initCard('pufferfish', 3, 2, 5, 100, 'defense_attack3', 'Character', '1-common');
        initCard('sea_monster', 6, 4, 7, 100, 'aura_attack_m1|activate_boost1', 'Character', '4-mythic');
        initCard('seagull', 2, 2, 2, 100, 'flying', 'Character', '1-common');
        initCard('shark', 4, 4, 4, 100, 'death_other_draw', 'Character', '2-uncommon');
        initCard('spell_flood', 3, 0, 0, 100, 'spell_damage_per_hand', 'Spell', '2-uncommon');
        initCard('spell_storm', 5, 0, 0, 100, 'spell_return_all', 'Spell', '3-rare');
        initCard('spell_submerge', 2, 0, 0, 100, 'spell_add_submerge', 'Spell', '3-rare');
        initCard('spell_treasure', 3, 0, 0, 100, 'spell_treasure', 'Spell', '4-mythic');
        initCard('spell_wave', 3, 0, 0, 100, 'spell_send_hand', 'Spell', '1-common');
        initCard('town_underwater', 3, 0, 7, 100, 'town_aura_blue', 'Artifact', '1-common');
        initCard('trap_fish', 3, 0, 0, 100, 'secret_transform_fish', 'Secret', '2-uncommon');
        initCard('turtle', 3, 2, 3, 100, 'taunt|shell', 'Character', '1-common');


        initPack("standard", 1, 5, [80, 12, 6, 2], 100);
        initPack("elite", 1, 5, [0, 0, 80, 20], 250);

        // fire_deck,Fire Starter,hero_fire,
        createDeck('fire_deck', 'hero_fire', 'imp|imp|lava_beast|lava_beast|fire_chicken|firefox|firefox|hell_hound|ashes_snake|fire_element|wolf_furious|phoenix|dragon_red|spell_burn|spell_burn|potion_red|potion_red|trap_explosive|spell_armageddon|town_volcano');
        createDeck('forest_deck', 'hero_forest', 'wolf_alpha|wolf_alpha|wolf_stalker|wolf_stalker|tree_angry|tree_angry|owl|raccoon|armored_beast|bear|sasquatch|unicorn|dragon_green|spell_roots|spell_roots|potion_green|potion_green|spell_growth|trap_spike|town_forest');
        createDeck('test_deck', 'hero_fire', 'wolf_alpha|wolf_alpha|wolf_stalker|wolf_stalker|tree_angry|tree_angry|armored_beast|armored_beast|raccoon|raccoon|owl|owl|bear|bear|sasquatch|unicorn|dragon_green|trap_spike|spell_roots|spell_growth|potion_green|town_forest|imp|imp|lava_beast|lava_beast|fire_chicken|fire_chicken|firefox|firefox|wolf_furious|wolf_furious|fire_element|fire_element|phoenix|dragon_red|spell_burn|spell_armageddon|potion_red|trap_explosive|town_volcano|fish|fish|turtle|turtle|crab_mana|crab_mana|eel|pufferfish|pufferfish|killer_whale|killer_whale|sea_monster|kraken|dragon_blue|potion_blue|spell_wave|spell_storm|trap_fish|town_underwater|seagull|seagull|shark|spell_flood|spell_treasure|spell_treasure|octopus|bull_heat|dark_stallion|reaper|spell_aerial_strike|spell_stones|spell_stones|mammoth|gorilla|snake_venom|snake_venom|spell_hibernate|spell_stomp|spell_stomp|bay|cave|woodland|spell_split|spell_extinct|spell_submerge|equip_sword|equip_shield|equip_ring|dragon_egg');
        createDeck('water_deck', 'hero_water', 'fish|crab_mana|crab_mana|turtle|turtle|poison_frog|eel|eel|pufferfish|killer_whale|kraken|sea_monster|dragon_blue|spell_wave|spell_wave|spell_storm|potion_blue|potion_blue|trap_fish|town_underwater');
        createDeck('level1_ai', '', 'hell_hound|hell_hound|wolf_furious');
        createDeck('level1_player', '', 'crab_mana|crab_mana|crab_mana|crab_mana|crab_mana');
        createDeck('level2_ai', '', 'imp|imp|spell_stones|fire_chicken|fire_chicken|spell_burn');
        createDeck('level2_player', '', 'potion_green|potion_green|potion_green|potion_green|potion_green|potion_green');
        createDeck('level3_ai', '', 'potion_red|hell_hound|hell_hound|hell_hound|spell_burn');
        createDeck('level3_player', '', 'mammoth|snake_venom|spell_stomp|spell_stomp|snake_venom|mammoth');
        createDeck('level4_ai', '', 'ashes_snake|spell_stones|ashes_snake|spell_stones|ashes_snake|phoenix');
        createDeck('level4_player', '', 'snake_venom|armored_beast|bear|spell_growth|gorilla|wolf_alpha|unicorn|spell_growth');
        createDeck('level5_ai', '', 'fire_chicken|firefox|town_volcano|hell_hound|spell_burn|fire_chicken|fire_chicken');
        createDeck('level5_player', '', 'owl|town_forest|spell_roots|raccoon|snake_venom|tree_angry|potion_green');

    };


    const initAbliities = () => {
        initAbility('activate_boost1', 'Activate', 'AllCardsBoard', 1, 0, 1, true, '', '', '', '', 'attack');
        initAbility('activate_burst', 'Activate', 'Self', 1, 0, 0, false, 'damage', '', '', 'chain_gain_attack', '');
        initAbility('activate_damage2', 'Activate', 'SelectTarget', 2, 3, 0, false, 'damage', '', '', '', '');
        initAbility('activate_discard', 'Activate', 'AllCardsHand', 1, 0, 0, true, 'discard', '', 'filter_random_1', '', '');
        initAbility('activate_fire', 'Activate', 'SelectTarget', 1, 2, 0, true, 'damage', 'once_per_turn', '', '', '');
        initAbility('activate_forest', 'Activate', 'SelectTarget', 2, 2, 0, true, 'heal', 'once_per_turn', '', '', '');
        initAbility('activate_select_discard_spell', 'Activate', 'CardSelector', 0, 2, 0, false, 'send_hand', 'has_discard_spell', '', '', '');
        initAbility('activate_send_hand', 'Activate', 'SelectTarget', 0, 0, 0, true, 'send_hand', '', '', '', '');
        initAbility('activate_water', 'Activate', 'PlayerSelf', 1, 3, 0, true, 'draw', 'once_per_turn', '', '', '');
        initAbility('chain_gain_attack', 'None', 'Self', 1, 0, 0, false, 'add_attack', '', '', '', '');
        initAbility('activate_roll_send_hand', 'Activate', 'SelectTarget', 0, 2, 0, false, 'roll_d6', '', '', 'roll_send_hand', '');
        initAbility('attack_roll_attack_bonus', 'OnBeforeAttack', 'Self', 0, 0, 0, false, 'roll_d6', '', '', 'roll_attack_bonus', '');
        initAbility('play_roll_attack', 'OnPlay', 'Self', 0, 0, 0, false, 'roll_d6', '', '', 'roll_add_attack', '');
        initAbility('roll_add_attack', 'None', 'Self', 0, 0, 0, false, 'add_attack_roll', '', '', '', '');
        initAbility('roll_attack_bonus', 'None', 'Self', 6, 0, 1, false, '', 'rolled_4P', '', '', 'attack');
        initAbility('roll_send_hand', 'None', 'LastTargeted', 0, 0, 0, false, 'send_hand', 'rolled_4P', '', '', '');
        initAbility('chain_equip_use', 'None', 'Self', -1, 0, 0, false, 'add_hp', '', '', '', '');
        initAbility('equip_armor2', 'Ongoing', 'EquippedCard', 2, 0, 0, false, '', '', '', '', 'armor');
        initAbility('equip_attack1', 'Ongoing', 'EquippedCard', 1, 0, 0, false, 'add_attack', '', '', '', '');
        initAbility('equip_attack2', 'Ongoing', 'EquippedCard', 2, 0, 0, false, 'add_attack', '', '', '', '');
        initAbility('equip_attack_no_damage', 'OnBeforeAttack', 'EquippedCard', 0, 0, 1, false, '', '', '', '', 'intimidate');
        initAbility('equip_attack_use', 'OnAfterAttack', 'Self', -1, 0, 0, false, 'add_hp', '', '', '', '');
        initAbility('equip_defend_use', 'OnAfterDefend', 'Self', -1, 0, 0, false, 'add_hp', '', '', '', '');
        initAbility('equip_gain_mana', 'StartOfTurn', 'PlayerSelf', 2, 0, 0, false, 'gain_mana', '', '', 'chain_equip_use', '');
        initAbility('equip_mana_kill', 'OnKill', 'PlayerSelf', 3, 0, 0, false, 'gain_mana', '', '', '', '');
        initAbility('equip_taunt', 'Ongoing', 'EquippedCard', 0, 0, 0, false, '', '', '', '', 'taunt');
        initAbility('add_spell_damage1', 'Ongoing', 'PlayerSelf', 1, 0, 0, false, 'add_spell_damage', '', '', '', '');
        initAbility('aura_ability_red', 'Ongoing', 'AllCardsBoard', 0, 0, 0, false, 'add_ability_activate_burst', '', '', '', '');
        initAbility('aura_attack_m1', 'Ongoing', 'AllCardsBoard', -1, 0, 0, false, 'add_attack', '', '', '', '');
        initAbility('aura_wolf', 'Ongoing', 'AllCardsBoard', 1, 0, 0, false, 'add_attack', '', '', '', '');
        initAbility('deathtouch', 'Ongoing', 'Self', 0, 0, 0, false, '', '', '', '', 'deathtouch');
        initAbility('defense_attack3', 'Ongoing', 'Self', 3, 0, 0, false, 'add_attack', 'is_not_your_turn', '', '', '');
        initAbility('flying', 'Ongoing', 'Self', 0, 0, 0, false, '', '', '', '', 'flying');
        initAbility('fury', 'Ongoing', 'Self', 0, 0, 0, false, '', '', '', '', 'fury');
        initAbility('lifesteal', 'Ongoing', 'Self', 0, 0, 0, false, '', '', '', '', 'lifesteal');
        initAbility('spell_immunity', 'Ongoing', 'Self', 0, 0, 0, false, '', '', '', '', 'spell_immunity');
        initAbility('taunt', 'Ongoing', 'Self', 0, 0, 0, false, '', '', '', '', 'taunt');
        initAbility('town_aura_blue', 'Ongoing', 'AllCardsHand', -1, 0, 0, false, 'add_mana', '', '', '', '');
        initAbility('town_aura_green', 'Ongoing', 'AllCardsBoard', 2, 0, 0, false, 'add_hp', '', '', '', '');
        initAbility('town_aura_red', 'Ongoing', 'AllCardsBoard', 2, 0, 0, false, 'add_attack', '', '', '', '');
        initAbility('trample', 'Ongoing', 'Self', 0, 0, 0, false, '', '', '', '', 'trample');
        initAbility('after_spell_attack2', 'OnPlayOther', 'Self', 2, 0, 0, false, 'add_attack', 'is_spell|is_ally', '', '', '');
        initAbility('attack_player_mana2', 'OnAfterAttack', 'PlayerSelf', 2, 0, 0, false, 'gain_mana', 'is_player', '', '', '');
        initAbility('attack_poison', 'OnBeforeAttack', 'AbilityTriggerer', 1, 0, 0, false, '', '', '', '', 'poisoned');
        initAbility('attack_suffer_damage', 'OnBeforeAttack', 'Self', 3, 0, 0, false, 'damage', '', '', '', '');
        initAbility('chain_draw', 'None', 'PlayerSelf', 1, 0, 0, false, 'draw', '', '', '', '');
        initAbility('death_blue_draw', 'OnDeathOther', 'PlayerSelf', 1, 0, 0, false, 'draw', 'is_ally|is_blue|is_character', '', '', '');
        initAbility('death_egg', 'OnDeath', 'Self', 2, 0, 0, false, 'summon_egg', '', '', '', '');
        initAbility('death_heal2', 'OnDeath', 'PlayerSelf', 2, 0, 0, false, 'heal', '', '', '', '');
        initAbility('death_other_draw', 'OnDeathOther', 'PlayerSelf', 1, 0, 0, false, 'draw', 'is_character', '', '', '');
        initAbility('defend_discard', 'OnBeforeDefend', 'AllCardsHand', 1, 0, 0, false, 'discard', '', 'filter_random_1', '', '');
        initAbility('defend_poison', 'OnBeforeDefend', 'AbilityTriggerer', 1, 0, 0, false, '', '', '', '', 'poisoned');
        initAbility('egg_growth', 'StartOfTurn', 'Self', 1, 0, 0, false, 'add_growth', '', '', 'egg_transform', '');
        initAbility('egg_transform', 'StartOfTurn', 'Self', 0, 0, 0, false, 'transform_phoenix', 'is_growth3', '', '', '');
        initAbility('kill_draw2', 'OnKill', 'PlayerSelf', 2, 0, 0, false, 'draw', 'is_character', '', '', '');
        initAbility('play_other_sacrifice', 'OnPlayOther', 'Self', 0, 0, 0, false, 'destroy', 'is_ally|is_character', '', '', '');
        initAbility('regen3', 'StartOfTurn', 'Self', 3, 0, 0, false, 'heal', '', '', '', '');
        initAbility('regen_all', 'StartOfTurn', 'Self', 99, 0, 0, false, 'heal', '', '', '', '');
        initAbility('turn_add_attack1', 'StartOfTurn', 'Self', 1, 0, 0, false, 'add_attack', '', '', '', '');
        initAbility('turn_green_heal', 'StartOfTurn', 'AllCardsBoard', 3, 0, 0, false, 'heal', '', '', '', '');
        initAbility('turn_kill_lowest', 'StartOfTurn', 'AllCardsBoard', 0, 0, 0, false, 'destroy', '', 'filter_lowest_attack', '', '');
        initAbility('turn_stealth', 'EndOfTurn', 'Self', 0, 0, 0, false, 'clear_taunt', 'has_board_characters2', '', '', 'stealth');
        initAbility('choice_fury', 'None', 'Self', 0, 0, 0, false, '', '', '', '', 'fury');
        initAbility('choice_taunt', 'None', 'Self', 0, 0, 0, false, '', '', '', '', 'taunt');
        initAbility('play_boost2', 'OnPlay', 'SelectTarget', 2, 0, 2, true, '', '', '', '', 'attack|hp');
        initAbility('play_choice_taunt_fury', 'OnPlay', 'ChoiceSelector', 0, 0, 0, false, '', '', '', 'choice_taunt|choice_fury', '');
        initAbility('play_deal_damage1', 'OnPlay', 'SelectTarget', 1, 0, 0, false, 'damage', '', '', '', '');
        initAbility('play_damage_all2', 'OnPlay', 'AllCardsBoard', 2, 0, 0, false, 'damage', '', '', '', '');
        initAbility('play_destroy_less4', 'OnPlay', 'SelectTarget', 0, 0, 0, false, 'destroy', '', '', 'chain_draw', '');
        initAbility('play_discard', 'OnPlay', 'AllCardsAllPiles', 1, 0, 0, false, 'discard', '', 'filter_random_1', '', '');
        initAbility('play_haste', 'OnPlay', 'Self', 0, 0, 0, false, 'unexhaust', '', '', '', '');
        initAbility('play_poison', 'OnPlay', 'SelectTarget', 1, 0, 0, false, '', '', '', '', 'poisoned');
        initAbility('play_select_discard', 'OnPlay', 'CardSelector', 0, 0, 0, false, 'send_hand', 'has_discard_character', '', '', '');
        initAbility('play_set_attack1', 'OnPlay', 'SelectTarget', 1, 0, 0, false, 'set_attack', '', '', '', '');
        initAbility('play_silence', 'OnPlay', 'SelectTarget', 0, 0, 0, false, 'clear_status_all|reset_stats', '', '', '', 'silenced');
        initAbility('play_summon_wolf', 'OnPlay', 'AllSlots', 1, 0, 0, false, 'summon_wolf', '', 'filter_random_1', '', '');
        initAbility('shell', 'OnPlay', 'Self', 0, 0, 0, false, '', '', '', '', 'shell');
        initAbility('stealth', 'OnPlay', 'Self', 0, 0, 0, false, '', '', '', '', 'stealth');
        initAbility('chain_clear_temp', 'None', 'None', 0, 0, 0, false, 'clear_temp', '', '', '', '');
        initAbility('chain_discover', 'None', 'CardSelector', 0, 0, 0, false, 'send_hand', '', '', '', '');
        initAbility('chain_hibernate', 'None', 'PlayTarget', 0, 0, 4, false, 'exhaust', '', '', '', 'sleep');
        initAbility('chain_treasure', 'None', 'CardSelector', 0, 0, 0, false, 'send_hand', '', 'filter_first_6', '', '');
        initAbility('spell_add_attack_suffer', 'OnPlay', 'PlayTarget', 0, 0, 0, false, 'add_ability_suffer_damage', '', '', '', '');
        initAbility('spell_add_play_extinct', 'OnPlay', 'PlayTarget', 0, 0, 0, false, 'add_ability_play_sacrifice', '', '', '', '');
        initAbility('spell_add_submerge', 'OnPlay', 'PlayTarget', 0, 0, 0, false, 'add_ability_defend_discard', '', '', '', '');
        initAbility('spell_ally_attack_2', 'OnPlay', 'AllCardsBoard', 2, 0, 0, false, 'add_attack', '', '', '', '');
        initAbility('spell_ally_hp_2', 'OnPlay', 'AllCardsBoard', 2, 0, 0, false, 'add_hp', '', '', '', '');
        initAbility('spell_armor2', 'OnPlay', 'PlayTarget', 2, 0, 0, false, '', '', '', '', 'armor');
        initAbility('spell_attack1', 'OnPlay', 'PlayTarget', 1, 0, 0, false, 'add_attack', '', '', '', '');
        initAbility('spell_coin', 'OnPlay', 'PlayerSelf', 1, 0, 0, false, 'gain_mana', '', '', '', '');
        initAbility('spell_damage1', 'OnPlay', 'PlayTarget', 1, 0, 0, false, 'damage', '', '', '', '');
        initAbility('spell_damage3', 'OnPlay', 'PlayTarget', 3, 0, 0, false, 'damage', '', '', '', '');
        initAbility('spell_destroy', 'OnPlay', 'PlayTarget', 0, 0, 0, false, 'destroy', '', '', '', '');
        initAbility('spell_destroy_all', 'OnPlay', 'AllCardsBoard', 0, 0, 0, false, 'destroy', '', '', '', '');
        initAbility('spell_dragon_create', 'OnPlay', 'AllCardData', 0, 0, 0, false, 'create_temp', '', 'filter_random_3', 'chain_discover|chain_clear_temp', '');
        initAbility('spell_draw1', 'OnPlay', 'PlayerSelf', 1, 0, 0, false, 'draw', '', '', '', '');
        initAbility('spell_fury', 'OnPlay', 'PlayTarget', 0, 0, 0, false, '', '', '', '', 'fury');
        initAbility('spell_heal_full', 'OnPlay', 'PlayTarget', 99, 0, 0, false, 'heal', '', '', '', '');
        initAbility('spell_hibernate', 'OnPlay', 'PlayTarget', 4, 0, 0, false, 'add_attack|add_hp', '', '', 'chain_hibernate', '');
        initAbility('spell_hp2', 'OnPlay', 'PlayTarget', 2, 0, 0, false, 'add_hp', '', '', '', '');
        initAbility('spell_kill_lowest_hp', 'OnPlay', 'AllCardsBoard', 0, 0, 0, false, 'destroy', '', 'filter_lowest_hp|filter_random_1', '', '');
        initAbility('spell_paralyse', 'OnPlay', 'PlayTarget', 0, 0, 6, false, '', '', '', '', 'paralysed');
        initAbility('spell_return_all', 'OnPlay', 'AllCardsBoard', 0, 0, 0, false, 'send_hand', '', '', '', '');
        initAbility('spell_send_hand', 'OnPlay', 'PlayTarget', 0, 0, 0, false, 'send_hand', '', '', '', '');
        initAbility('spell_damage_per_hand', 'OnPlay', 'AllCardsBoard', 1, 0, 0, false, 'set_hp', '', '', '', '');
        initAbility('spell_shell', 'OnPlay', 'PlayTarget', 0, 0, 0, false, '', '', '', '', 'shell');
        initAbility('spell_summon_eagle', 'OnPlay', 'PlayerSelf', 0, 0, 0, false, 'summon_eagle|summon_eagle|summon_eagle', '', '', '', '');
        initAbility('spell_taunt', 'OnPlay', 'PlayTarget', 0, 0, 0, false, '', '', '', '', 'taunt');
        initAbility('spell_treasure', 'OnPlay', 'CardSelector', 0, 0, 0, false, 'send_hand', '', 'filter_first_7', 'chain_treasure', '');
        initAbility('trap_damage_all2', 'OnBeforeAttack', 'AllCardsBoard', 2, 0, 0, false, 'damage', 'is_character|is_enemy', '', '', '');
        initAbility('trap_paralyse3', 'OnAfterAttack', 'AbilityTriggerer', 0, 0, 6, false, '', 'is_character|is_enemy', '', '', 'paralysed');
        initAbility('secret_transform_fish', 'OnPlayOther', 'AbilityTriggerer', 1, 0, 0, false, 'transform_fish', 'is_character|is_enemy', '', '', '');
    }

    let initUnity = () => {
        // console.log("walletClient", walletClient.account.address)
        // console.log("initUnity");
        var container = document.querySelector("#unity-container");
        var canvas = document.querySelector("#unity-canvas");
        var loadingBar = document.querySelector("#unity-loading-bar");
        var progressBarFull = document.querySelector("#unity-progress-bar-full");
        var fullscreenButton = document.querySelector("#unity-fullscreen-button");
        var warningBanner = document.querySelector("#unity-warning");


        var buildUrl = "Build";
        var loaderUrl = buildUrl + "/hex256_build.loader.js";
        var config = {
            dataUrl: buildUrl + "/hex256_build.data",
            frameworkUrl: buildUrl + "/hex256_build.framework.js",
            codeUrl: buildUrl + "/hex256_build.wasm",
            streamingAssetsUrl: "StreamingAssets",
            companyName: "DefaultCompany",
            productName: "My project",
            productVersion: "1.09",
            showBanner: unityShowBanner,
        };


        if (/iPhone|iPad|iPod|Android/i.test(navigator.userAgent)) {
            // Mobile device style: fill the whole browser client area with the game canvas:

            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, height=device-height, initial-scale=1.0, user-scalable=no, shrink-to-fit=yes';
            document.getElementsByTagName('head')[0].appendChild(meta);
            container.className = "unity-mobile";
            canvas.className = "unity-mobile";

            // To lower canvas resolution on mobile devices to gain some
            // performance, uncomment the following line:
            // config.devicePixelRatio = 1;

            // unityShowBanner('WebGL builds are not supported on mobile devices.');
        } else {
            // Desktop style: Render the game canvas in a window that can be maximized to fullscreen:

            // canvas.style.width = "100vw";
            // canvas.style.height = "100vh";

            canvas.style.width = "960px";
            canvas.style.height = "600px";
        }


        var script = document.createElement("script");
        script.src = loaderUrl;
        script.onload = () => {
            createUnityInstance(canvas, config, (progress) => {
                progressBarFull.style.width = 100 * progress + "%";
            }).then((unityInstance) => {
                window.MyUnityInstance = unityInstance;
                loadingBar.style.display = "none";
                fullscreenButton.onclick = () => {
                    unitynstance.SetFullscreen(1);
                };
            }).catch((message) => {
                console.error(message);
            });
        };
        document.body.appendChild(script);
    }


    let getUser = async () => {
        let user = await getUserByOwner(walletClient.account.address)
        user = convertBigIntToInt(user);
        // console.log("getUser from App.tsx", user)
        return user;
    }

    useEffect(async () => {
        // window.addTask = addTask;
        // window.addUser = addUser;
        window.getUser = getUser;
        // window.initCard = initCard;
        // window.initPack = initPack;
        window.init = init;
        window.initAbliities = initAbliities;
        // window.buyCard = buyCard;
        // window.getCard = getCard;
        window.calculateKeccak256Hash = calculateKeccak256Hash;
        // window.incr = incr;
        // window.getRandomCardByRarity = getRandomCardByRarity;
        // window.openPack = openPack;
        window.runApiTask = async (url, json_data) => {
            console.log("111", url, JSON.parse(json_data))
        }

        while (true) {
            const user = await getUser();
            if (user && user.owner != '0x0000000000000000000000000000000000000000') {
                initUnity();
                break;
            } else {
                await addUser(walletClient.account.address)
            }
        }
        return () => {
        };
    }, []);


    return (
        <>
            <div id="unity-container" className="unity-desktop">
                <canvas id="unity-canvas">
                </canvas>
                <div id="unity-loading-bar">
                    <div id="unity-logo"></div>
                    <div id="unity-progress-bar-empty">
                        <div id="unity-progress-bar-full"></div>
                    </div>
                </div>
                <div id="unity-warning"></div>
                <div id="unity-footer">
                    <div id="unity-webgl-logo"></div>
                    <div id="unity-fullscreen-button"></div>
                    <div id="unity-build-title">My project</div>

                </div>
            </div>

            {/*<div className="mud_devtool">*/}
            {/*    /!*<div id="card">*!/*/}
            {/*    /!*    {cards.map((card) => (*!/*/}
            {/*    /!*        <div key={card.id}>*!/*/}
            {/*    /!*            {card.value.tid}*!/*/}
            {/*    /!*        </div>*!/*/}
            {/*    /!*    ))}*!/*/}
            {/*    /!*</div>*!/*/}

            {/*    <table>*/}
            {/*        <tbody>*/}
            {/*        {tasks.map((task) => (*/}
            {/*            <tr key={task.id}>*/}
            {/*                <td align="right">*/}
            {/*                    <input*/}
            {/*                        type="checkbox"*/}
            {/*                        checked={task.value.completedAt > 0n}*/}
            {/*                        title={task.value.completedAt === 0n ? "Mark task as completed" : "Mark task as incomplete"}*/}
            {/*                        onChange={async (event) => {*/}
            {/*                            event.preventDefault();*/}
            {/*                            const checkbox = event.currentTarget;*/}

            {/*                            checkbox.disabled = true;*/}
            {/*                            try {*/}
            {/*                                await toggleTask(task.key.key);*/}
            {/*                            } finally {*/}
            {/*                                checkbox.disabled = false;*/}
            {/*                            }*/}
            {/*                        }}*/}
            {/*                    />*/}
            {/*                </td>*/}
            {/*                <td>{task.value.completedAt > 0n ?*/}
            {/*                    <s>{task.value.description}</s> : <>{task.value.description}</>}</td>*/}
            {/*                <td align="right">*/}
            {/*                    <button*/}
            {/*                        type="button"*/}
            {/*                        title="Delete task"*/}
            {/*                        style={styleUnset}*/}
            {/*                        onClick={async (event) => {*/}
            {/*                            event.preventDefault();*/}
            {/*                            if (!window.confirm("Are you sure you want to delete this task?")) return;*/}

            {/*                            const button = event.currentTarget;*/}
            {/*                            button.disabled = true;*/}
            {/*                            try {*/}
            {/*                                await deleteTask(task.key.key);*/}
            {/*                            } finally {*/}
            {/*                                button.disabled = false;*/}
            {/*                            }*/}
            {/*                        }}*/}
            {/*                    >*/}
            {/*                        &times;*/}
            {/*                    </button>*/}
            {/*                </td>*/}
            {/*            </tr>*/}
            {/*        ))}*/}
            {/*        </tbody>*/}
            {/*        <tfoot>*/}
            {/*        <tr>*/}
            {/*            <td>*/}
            {/*                <input type="checkbox" disabled/>*/}
            {/*            </td>*/}
            {/*            <td colSpan={2}>*/}
            {/*                <form*/}
            {/*                    onSubmit={async (event) => {*/}
            {/*                        event.preventDefault();*/}
            {/*                        const form = event.currentTarget;*/}
            {/*                        const fieldset = form.querySelector("fieldset");*/}
            {/*                        if (!(fieldset instanceof HTMLFieldSetElement)) return;*/}

            {/*                        const formData = new FormData(form);*/}
            {/*                        const desc = formData.get("description");*/}
            {/*                        if (typeof desc !== "string") return;*/}

            {/*                        fieldset.disabled = true;*/}
            {/*                        try {*/}
            {/*                            await addTask(desc);*/}
            {/*                            form.reset();*/}
            {/*                        } finally {*/}
            {/*                            fieldset.disabled = false;*/}
            {/*                        }*/}
            {/*                    }}*/}
            {/*                >*/}
            {/*                    <fieldset style={styleUnset}>*/}
            {/*                        <input type="text" name="description"/>{" "}*/}
            {/*                        <button type="submit" title="Add task">*/}
            {/*                            Add*/}
            {/*                        </button>*/}
            {/*                    </fieldset>*/}
            {/*                </form>*/}
            {/*            </td>*/}
            {/*        </tr>*/}
            {/*        </tfoot>*/}
            {/*    </table>*/}
            {/*</div>*/}


        </>
    )
        ;
};
