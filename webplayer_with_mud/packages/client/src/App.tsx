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
        initCard('ashes_snake', 5, 6, 4, 100, 'stealth');
        initCard('bull_heat', 3, 2, 5, 100, 'add_spell_damage1');
        initCard('cave', 2, 0, 5, 100, 'aura_ability_red');
        initCard('dark_stallion', 4, 4, 5, 100, 'activate_roll_send_hand');
        initCard('dragon_red', 7, 9, 7, 100, 'spell_immunity');
        initCard('equip_sword', 2, 0, 2, 100, 'equip_attack1|equip_attack_no_damage|equip_attack_use');
        initCard('fire_chicken', 2, 1, 1, 100, 'death_egg');
        initCard('fire_element', 5, 7, 3, 100, 'play_damage_all2');
        initCard('firefox', 4, 4, 4, 100, 'activate_select_discard_spell');
        initCard('hell_hound', 4, 4, 2, 100, 'fury');
        initCard('imp', 2, 2, 1, 100, 'play_deal_damage1');
        initCard('lava_beast', 3, 2, 3, 100, 'after_spell_attack2');
        initCard('phoenix', 6, 6, 6, 100, 'activate_damage2|death_egg');
        initCard('potion_red', 2, 0, 0, 100, 'spell_attack1|spell_fury');
        initCard('reaper', 6, 6, 6, 100, 'turn_kill_lowest');
        initCard('spell_aerial_strike', 3, 0, 0, 100, 'spell_summon_eagle');
        initCard('spell_armageddon', 5, 0, 0, 100, 'spell_destroy_all');
        initCard('spell_burn', 4, 0, 0, 100, 'spell_destroy');
        initCard('spell_split', 2, 0, 0, 100, 'spell_add_attack_suffer');
        initCard('spell_stones', 2, 0, 0, 100, 'spell_damage1|spell_draw1');
        initCard('town_volcano', 3, 0, 7, 100, 'town_aura_red');
        initCard('trap_explosive', 3, 0, 0, 100, 'trap_damage_all2');
        initCard('wolf_furious', 5, 3, 4, 100, 'fury|turn_add_attack1');
        initCard('armored_beast', 4, 3, 6, 100, 'taunt');
        initCard('bear', 5, 4, 5, 100, 'play_choice_taunt_fury');
        initCard('dragon_green', 7, 7, 9, 100, 'spell_immunity');
        initCard('equip_shield', 2, 0, 2, 100, 'equip_armor2|equip_taunt|equip_defend_use');
        initCard('gorilla', 4, 0, 6, 100, 'play_roll_attack');
        initCard('mammoth', 6, 7, 6, 100, 'trample');
        initCard('owl', 3, 2, 3, 100, 'play_silence');
        initCard('potion_green', 2, 0, 0, 100, 'spell_hp2|spell_taunt');
        initCard('raccoon', 2, 2, 3, 100, 'play_select_discard');
        initCard('sasquatch', 5, 6, 4, 100, 'turn_stealth');
        initCard('snake_venom', 2, 1, 3, 100, 'attack_poison|defend_poison');
        initCard('spell_extinct', 2, 0, 0, 100, 'spell_add_play_extinct');
        initCard('spell_growth', 5, 0, 0, 100, 'spell_ally_attack_2|spell_ally_hp_2');
        initCard('spell_hibernate', 3, 0, 0, 100, 'spell_hibernate');
        initCard('spell_roots', 3, 0, 0, 100, 'spell_paralyse');
        initCard('spell_stomp', 2, 0, 0, 100, 'spell_kill_lowest_hp');
        initCard('town_forest', 3, 0, 7, 100, 'town_aura_green');
        initCard('trap_spike', 3, 0, 0, 100, 'trap_paralyse3');
        initCard('tree_angry', 3, 3, 5, 100, 'regen_all');
        initCard('unicorn', 6, 5, 6, 100, 'play_boost2|activate_send_hand');
        initCard('wolf_alpha', 3, 3, 2, 100, 'play_summon_wolf|aura_wolf');
        initCard('wolf_stalker', 3, 4, 2, 100, 'stealth');
        initCard('woodland', 2, 0, 5, 100, 'turn_green_heal');
        initCard('hero_fire', 0, 0, 0, 100, 'activate_fire');
        initCard('hero_forest', 0, 0, 0, 100, 'activate_forest');
        initCard('hero_water', 0, 0, 0, 100, 'activate_water');
        initCard('coin', 0, 0, 0, 100, 'spell_coin');
        initCard('dragon_egg', 2, 0, 0, 100, 'spell_dragon_create');
        initCard('flame_eagle', 1, 1, 1, 100, 'flying|play_haste');
        initCard('phoenix_egg', 0, 0, 3, 100, 'egg_growth');
        initCard('wolf_baby', 1, 1, 1, 100, '');
        initCard('bay', 2, 0, 5, 100, 'death_blue_draw');
        initCard('crab_mana', 2, 3, 1, 100, 'attack_player_mana2');
        initCard('dragon_blue', 7, 8, 8, 100, 'spell_immunity');
        initCard('eel', 4, 5, 2, 100, 'play_set_attack1');
        initCard('equip_ring', 1, 0, 3, 100, 'equip_gain_mana');
        initCard('fish', 1, 1, 1, 100, 'death_blue_draw');
        initCard('killer_whale', 5, 5, 4, 100, 'play_destroy_less4');
        initCard('kraken', 6, 5, 5, 100, 'play_haste');
        initCard('octopus', 4, 2, 5, 100, 'attack_roll_attack_bonus');
        initCard('poison_frog', 3, 2, 2, 100, 'deathtouch');
        initCard('potion_blue', 2, 0, 0, 100, 'spell_shell|spell_heal_full');
        initCard('pufferfish', 3, 2, 5, 100, 'defense_attack3');
        initCard('sea_monster', 6, 4, 7, 100, 'aura_attack_m1|activate_boost1');
        initCard('seagull', 2, 2, 2, 100, 'flying');
        initCard('shark', 4, 4, 4, 100, 'death_other_draw');
        initCard('spell_flood', 3, 0, 0, 100, 'spell_damage_per_hand');
        initCard('spell_storm', 5, 0, 0, 100, 'spell_return_all');
        initCard('spell_submerge', 2, 0, 0, 100, 'spell_add_submerge');
        initCard('spell_treasure', 3, 0, 0, 100, 'spell_treasure');
        initCard('spell_wave', 3, 0, 0, 100, 'spell_send_hand');
        initCard('town_underwater', 3, 0, 7, 100, 'town_aura_blue');
        initCard('trap_fish', 3, 0, 0, 100, 'secret_transform_fish');
        initCard('turtle', 3, 2, 3, 100, 'taunt|shell');


        initPack("standard", 1, 5, [80, 12, 6, 2], 100);
        initPack("elite", 1, 5, [0, 0, 80, 20], 250);

        // fire_deck,Fire Starter,hero_fire,
        createDeck("fire_deck", "hero_fire", "imp|imp|lava_beast|lava_beast|fire_chicken|firefox|firefox|hell_hound|ashes_snake|fire_element|wolf_furious|phoenix|dragon_red|spell_burn|spell_burn|potion_red|potion_red|trap_explosive|spell_armageddon|town_volcano");
        createDeck("forest_deck", "hero_forest", "wolf_alpha|wolf_alpha|wolf_stalker|wolf_stalker|tree_angry|tree_angry|owl|raccoon|armored_beast|bear|sasquatch|unicorn|dragon_green|spell_roots|spell_roots|potion_green|potion_green|spell_growth|trap_spike|town_forest");
        createDeck("water_deck", "hero_water", "fish|crab_mana|crab_mana|turtle|turtle|poison_frog|eel|eel|pufferfish|killer_whale|kraken|sea_monster|dragon_blue|spell_wave|spell_wave|spell_storm|potion_blue|potion_blue|trap_fish|town_underwater");

    };


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
                    unityInstance.SetFullscreen(1);
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

    useEffect(() => {
        // window.addTask = addTask;
        // window.addUser = addUser;
        window.getUser = getUser;
        // window.initCard = initCard;
        // window.initPack = initPack;
        window.init = init;
        // window.buyCard = buyCard;
        // window.getCard = getCard;
        window.calculateKeccak256Hash = calculateKeccak256Hash;
        // window.incr = incr;
        // window.getRandomCardByRarity = getRandomCardByRarity;
        // window.openPack = openPack;
        window.runApiTask = async (url, json_data) => {
            console.log("111", url, JSON.parse(json_data))
        }

        initUnity();

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
