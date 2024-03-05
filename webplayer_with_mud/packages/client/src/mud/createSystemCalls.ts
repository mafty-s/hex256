/*
 * Create the system calls that the client can use to ask
 * for changes in the World state (using the System contracts).
 */

import {decodeEventLog, decodeFunctionData, Hex} from "viem";
import {SetupNetworkResult} from "./setupNetwork";
import {ethers} from "ethers";
import {AbilityTarget, AbilityTrigger, Action, CardTrait, CardType, RarityType, Status} from "./common";
import {abilities} from "./abilities";

import GMSystemAbi from "contracts/out/GmSystem.sol/GmSystem.abi.json";
import AbilitySystemAbi from "contracts/out/AbilitySystem.sol/AbilitySystem.abi.json";
import AbilitySecretsSystemAbi from "contracts/out/AbilitySecretsSystem.sol/AbilitySecretsSystem.abi.json";
import ConditionSystemAbi from "contracts/out/ConditionSystem.sol/ConditionSystem.abi.json";
import Effect1SystemAbi from "contracts/out/Effect1System.sol/Effect1System.abi.json";
import Effect2SystemAbi from "contracts/out/Effect2System.sol/Effect2System.abi.json";
import Effect3SystemAbi from "contracts/out/Effect3System.sol/Effect3System.abi.json";
import Effect4SystemAbi from "contracts/out/Effect4System.sol/Effect4System.abi.json";
import Effect5SystemAbi from "contracts/out/Effect5System.sol/Effect5System.abi.json";
import Effect6SystemAbi from "contracts/out/Effect6System.sol/Effect6System.abi.json";

// import { getTransactionResult } from "";

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
    /*
     * The parameter list informs TypeScript that:
     *
     * - The first parameter is expected to be a
     *   SetupNetworkResult, as defined in setupNetwork.ts
     *
     *   Out of this parameter, we only care about two fields:
     *   - worldContract (which comes from getContract, see
     *     https://github.com/latticexyz/mud/blob/main/templates/react/packages/client/src/mud/setupNetwork.ts#L63-L69).
     *
     *   - waitForTransaction (which comes from syncToRecs, see
     *     https://github.com/latticexyz/mud/blob/main/templates/react/packages/client/src/mud/setupNetwork.ts#L77-L83).
     *
     * - From the second parameter, which is a ClientComponent,
     *   we only care about Counter. This parameter comes to use
     *   through createClientComponents.ts, but it originates in
     *   syncToRecs
     *   (https://github.com/latticexyz/mud/blob/main/templates/react/packages/client/src/mud/setupNetwork.ts#L77-L83).
     */
    {tables, useStore, worldContract, waitForTransaction, publicClient}: SetupNetworkResult
) {

    const convertBigIntToInt = (obj) => {
        if (typeof obj !== 'object' || obj === null) {
            // 基本类型或 null，直接返回
            return obj;
        }

        if (Array.isArray(obj)) {
            // 数组类型
            return obj.map(item => convertBigIntToInt(item));
        }

        // 对象类型
        const convertedObj = {};
        for (let key in obj) {
            if (obj.hasOwnProperty(key)) {
                const value = obj[key];
                if (typeof value === 'bigint') {
                    convertedObj[key] = Number(value);
                } else {
                    convertedObj[key] = convertBigIntToInt(value);
                }
            }
        }

        return convertedObj;
    }

    const calculateKeccak256Hash = (name) => {
        const encodedName = ethers.AbiCoder.defaultAbiCoder().encode(['string'], [name]);
        const keccakHash = ethers.keccak256(encodedName);
        return keccakHash;
    }

    const calculateKeccak256HashTwoString = (str1, str2) => {
        const encodedName = ethers.AbiCoder.defaultAbiCoder().encode(['string', 'string'], [str1, str2]);
        const keccakHash = ethers.keccak256(encodedName);
        return keccakHash;
    }

    const calculateKeccak256HashTwoBytes32 = (str1, str2) => {
        const encodedName = ethers.AbiCoder.defaultAbiCoder().encode(['bytes32', 'bytes32'], [str1, str2]);
        const keccakHash = ethers.keccak256(encodedName);
        return keccakHash;
    }

    const arrStr2Bytes32 = (arr_str: string) => {
        if (arr_str.length == 0) {
            return [];
        }
        const arr = arr_str.split('|');
        const arr_bytes32 = arr.map((item) => {
            return calculateKeccak256Hash(item);
        });
        return arr_bytes32;
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
        console.log(functionName, functionSelector)

        return functionSelector;
    }

    const getFilterSelector = (name) => {
        if (name.length === 0) {
            return null
        }
        //0xb618c8ba
        // bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card
        const functionName = convertToPascalCase(name) + '(bytes32,bytes32,bytes32[],uint8)';
        const functionSelector = ethers.keccak256(ethers.toUtf8Bytes(functionName)).slice(0, 10);
        console.log(functionName, functionSelector)

        return functionSelector;
    }

    const getConditionSelector = (name) => {
        if (name.length === 0) {
            return null
        }
        const functionName = convertToPascalCase(name) + '(bytes32,bytes32,uint8,bytes32,bytes32)';
        const functionSelector = ethers.keccak256(ethers.toUtf8Bytes(functionName)).slice(0, 10);
        console.log(name, functionName, functionSelector)

        return functionSelector;
    }

    const getSelectorFromArrStr = (arrstr: string, formater) => {
        if (arrstr.length === 0) {
            return [];
        }
        const arr = arrstr.split('|');
        const arr_bytes4 = arr.map((item) => {
            return formater(item);
        });
        return arr_bytes4;
    }

    const getAbilityTarget = (str: string) => {
        const abilityTarget: AbilityTarget = AbilityTarget[str as keyof typeof AbilityTarget];
        if (abilityTarget === undefined) {
            console.error("not exist getAbilityTarget", str)
        }
        return abilityTarget;
    }

    const getStatus = (str: string) => {
        const status: Status = Status[str as keyof typeof Status];
        if (status === undefined) {
            console.error("not exist getStatus", str)
        }
        return status;
    }


    const getAbilityTrigger = (str: string) => {
        const abilityTrigger: AbilityTrigger = AbilityTrigger[str as keyof typeof AbilityTrigger];
        if (abilityTrigger === undefined) {
            console.error("not exist getAbilityTrigger", str)
        }
        return abilityTrigger;
    }

    const getRarityType = (str: string) => {
        const rarityType: RarityType = RarityType[str as keyof typeof RarityType];
        if (rarityType === undefined) {
            console.error("not exist getRarityType", str)
        }
        return rarityType;
    }

    const getCardTrait = (str: string) => {
        const trait: CardTrait = CardTrait[str as keyof typeof CardTrait];
        if (trait === undefined) {
            //console.error("not exist getCardTrait", str)
            return CardTrait.None;
        }
        return trait;
    }


    const getCardType = (str: string) => {
        const cardType: CardType = CardType[str as keyof typeof CardType];
        if (cardType == undefined) {
            console.error("not exist getCardType", str)
        }
        return cardType;
    }

    const addTask = async (label: string) => {
        // const tx = await worldContract.write.addTask([label]);
        // await waitForTransaction(tx);
        // return tx;
    };

    const toggleTask = async (key: Hex) => {
        const isComplete = (useStore.getState().getValue(tables.Tasks, {key})?.completedAt ?? 0n) > 0n;
        const tx = isComplete ? await worldContract.write.resetTask([key]) : await worldContract.write.completeTask([key]);
        await waitForTransaction(tx);
        return tx;
    };

    const deleteTask = async (key: Hex) => {
        const tx = await worldContract.write.deleteTask([key]);
        await waitForTransaction(tx);
        return tx;
    };

    const addUser = async (name: string) => {
        const tx = await worldContract.write.addUser([name]);
        await waitForTransaction(tx);
        return tx;
    };

    const getUser = async () => {
        const address = walletClient.account.address;
        return await getUserByKey(address);
        //     const user = await worldContract.read.getUser();
        //     return user;
        //
        //     console.log(address);
        //
        //     // return state.getRecord(tables.Users, {address});
    };

    const IsBoardCard = async (key: string) => {
        return await worldContract.read.IsBoardCard([key]);
    };


    const getUserByKey = async (key: string) => {
        const user = await worldContract.read.getUserByKey([key]);
        return user;
    };

    const initCard = async (name: string, mana: number, attack: number, hp: number, cost: number, abilities_str: string, cardType: string, rarity: string, is_deckbuilding: boolean, trait: string) => {
        const cardTypeCode = getCardType((cardType));
        let rarity_str = convertToEnumFormat(rarity);
        const rarityCode = getRarityType(rarity_str.substr(2,));
        const traitCode = getCardTrait(convertToCamelCase(trait));
        const tx = await worldContract.write.initCard([name, mana, attack, hp, cost, arrStr2Bytes32(abilities_str), cardTypeCode, rarityCode, is_deckbuilding, traitCode]);
        // await waitForTransaction(tx);
        console.log("init_card", name, calculateKeccak256Hash(name));
        return tx;
    };

    const initPack = async (name: string, packType: number, cards: number, rarities: number[], cost: number) => {
        const tx = await worldContract.write.initPack([name, packType, cards, rarities, cost]);
        // await waitForTransaction(tx);
        return tx;
    };

    const initDeck = async (name: string, hero: string, cards: string[]) => {
        const tx = await worldContract.write.initDeck([name, hero, cards]);
        // await waitForTransaction(tx);
        return tx;
    };

    function convertToEnumFormat(str: string): string {
        // 将字符串中的大写字母前添加下划线，然后全部转为大写
        const formattedStr = str.replace(/([A-Z])/g, '_$1').toUpperCase();

        // 如果字符串以下划线开头，则去掉开头的下划线
        if (formattedStr.startsWith('_')) {
            return formattedStr.slice(1);
        }

        return formattedStr;
    }

    function convertToCamelCase(str) {
        var words = str.split('_');
        for (var i = 1; i < words.length; i++) {
            words[i] = words[i].charAt(0).toUpperCase() + words[i].slice(1);
        }
        str = words.join('');
        return str.charAt(0).toUpperCase() + str.slice(1);
    }

    // let ablities = [];
    const initAbility = async (
        id: string, trigger: string, target: string, value: number, manaCost: number, duration: number, exhaust: boolean, effect_str: string, conditionsTarget: string, conditionsTrigger: string, filtersTarget: string, chainAbilities: string, status: string) => {

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
                    console.error("status not found", name);
                }
            });
        }
        console.log("initAbility", id, key, status, status_code);


        const conditionsTarget_byes32 = getSelectorFromArrStr(conditionsTarget, getConditionSelector);
        const conditionsTrigger_byes32 = getSelectorFromArrStr(conditionsTrigger, getConditionSelector);
        const filtersTarget_byes32 = getSelectorFromArrStr(filtersTarget, getFilterSelector);
        const chainAbilities_byes32 = arrStr2Bytes32(chainAbilities);

        const tx = await worldContract.write.initAbility([
            id,
            trigger_code,
            target_code,
            value,
            manaCost,
            duration,
            exhaust,
            getSelectorFromArrStr(effect_str, getEffectSelector),
            status_code
        ]);

        // await waitForTransaction(tx);

        const tx2 = await worldContract.write.initAbilityExtend([
            id,
            conditionsTarget_byes32,
            conditionsTrigger_byes32,
            filtersTarget_byes32,
            chainAbilities_byes32,
        ]);

        // await waitForTransaction(tx2);

        // ablities[key.toString()] = id;
        return tx;
    }

    const buyCard = async (card_id: string, quantity: number) => {
        const tx = await worldContract.write.buyCard([card_id, quantity]);
        await waitForTransaction(tx);
        return tx;
    }

    const sellCard = async (card_id: string, quantity: number) => {
        const tx = await worldContract.write.sellCard([card_id, quantity]);
        await waitForTransaction(tx);
        return tx;
    }

    const buyPack = async (pack_id: string, quantity: number) => {
        const tx = await worldContract.write.buyPack([pack_id, quantity]);
        await waitForTransaction(tx);
        return tx;
    }

    const getCard = async (card_id: string) => {
        const card = await worldContract.read.getCard([card_id]);
        return card;
    }

    const getRandomCardByRarity = async () => {
        const card = await worldContract.read.getRandomCardByRarity([]);
        return card;
    }

    const incr = async () => {
        const tx = await worldContract.write.incr([]);
        await waitForTransaction(tx);
        return tx;
    }

    function getEvent(log) {
        let event = null;
        try {
            event = decodeEventLog({
                abi: worldContract.abi,
                data: log.data,
                topics: log.topics
            });
            return event;
        } catch (e) {

        }
        try {
            event = decodeEventLog({
                abi: GMSystemAbi,
                data: log.data,
                topics: log.topics
            });
            return event;
        } catch (e) {

        }
        try {
            event = decodeEventLog({
                abi: AbilitySystemAbi,
                data: log.data,
                topics: log.topics
            });
            return event;
        } catch (e) {

        }

        try {
            event = decodeEventLog({
                abi: AbilitySecretsSystemAbi,
                data: log.data,
                topics: log.topics
            });
            return event;
        } catch (e) {

        }

        try {
            event = decodeEventLog({
                abi: ConditionSystemAbi,
                data: log.data,
                topics: log.topics
            });
        } catch (e) {

        }

        try {
            event = decodeEventLog({
                abi: Effect1SystemAbi,
                data: log.data,
                topics: log.topics
            });
            return event;
        } catch (e) {

        }

        try {
            event = decodeEventLog({
                abi: Effect2SystemAbi,
                data: log.data,
                topics: log.topics
            });
            return event;
        } catch (e) {

        }

        try {
            event = decodeEventLog({
                abi: Effect3SystemAbi,
                data: log.data,
                topics: log.topics
            });
            return event;
        } catch (e) {

        }

        try {
            event = decodeEventLog({
                abi: Effect4SystemAbi,
                data: log.data,
                topics: log.topics
            });
            return event;
        } catch (e) {

        }

        try {
            event = decodeEventLog({
                abi: Effect5SystemAbi,
                data: log.data,
                topics: log.topics
            });
            return event;

        } catch (e) {

        }

        try {
            event = decodeEventLog({
                abi: Effect6SystemAbi,
                data: log.data,
                topics: log.topics
            });
            return event;
        } catch (e) {

        }
        return event;

    }

    const getTxResult = async (hash: string) => {
        const transaction = await publicClient.getTransaction({hash})
        const transactionReceipt = await publicClient.waitForTransactionReceipt({hash});
        const {functionName, args} = decodeFunctionData({abi: worldContract.abi, data: transaction.input});

        let events = [];
        if (transactionReceipt.logs && transactionReceipt.logs.length > 0) {
            for (let i = 0; i < transactionReceipt.logs.length; i++) {
                let event = getEvent(transactionReceipt.logs[i]);
                if (event && event.eventName.startsWith("Event")) {
                    events.push(event);
                }
            }
        }

        console.log(functionName, "events", events);

        const tx_result = await publicClient.simulateContract({
            account: transaction.from,
            address: transaction.to!,
            abi: worldContract.abi,
            functionName,
            args,
            // simulation happens at the end of the block, so we need to use the previous block number
            blockNumber: transactionReceipt.blockNumber - 1n,
            // TODO: do we need to include value, nonce, gas price, etc. to properly simulate?
        });

        console.log("getTxResult result", tx_result.result);

        return tx_result;
    }

    const openPack = async (name: string) => {
        console.log("worldContract", worldContract);
        const hash = await worldContract.write.OpenPack([calculateKeccak256Hash(name)]);
        await waitForTransaction(hash);
        const tx_result = await getTxResult(hash);
        return convertBigIntToInt({hash, tx_result});
    };

    let now_game_uid = null;
    const gameSetting = async (game_uid: string) => {
        now_game_uid = game_uid;
        const tx = await worldContract.write.GameSetting([game_uid]);
        await waitForTransaction(tx);
        let result = {
            game_uid: game_uid
        }
        return {res: result};
    }

    const sleep = (ms: number) => {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    const checkPlayerSetting = async (username: string, game_uid: string) => {
        console.log("checkPlayerSetting", username, game_uid);

        await sleep(5500);

        const player_key = calculateKeccak256HashTwoString(game_uid, username);

        console.log("player_key", player_key)

        const card_pool = await worldContract.read.getPlayerCards([player_key]);

        let res = {
            player_name: username,
            cards: [],
            hand: [],
            deck: [],
            board: [],
            all: [],
            // mana:mana,
            // hp:hp,
            // is_ai:is_ai,
            // dcards:dcards,
            // pid:pid,
            game_uid: game_uid
        };

        res.player_name = card_pool[0];
        res.cards = card_pool[1];
        res.hand = card_pool[2];
        res.deck = card_pool[3];
        res.board = card_pool[4];
        res.all = res.hand.concat(res.deck);

        // if (res.player_name == "Player") {
        //     res.player_name = "test"
        // }

        //await sleep(1500);
        console.log(res);
        return convertBigIntToInt(res);

    }

    let player_name = null;
    const playerSetting = async (username: string, game_uid: string, desk_id: string, is_ai: boolean, hp: number, mana: number,
                                 dcards: number, pid: number, not_shuffle: boolean) => {
        if (!is_ai) {
            player_name = username;
        } else {
            pid = 1;
        }

        console.log("pid", pid);
        console.log("need_shuffle", !not_shuffle);
        await sleep(200)

        //todo
        mana = 10;

        const hash = await worldContract.write.PlayerSetting([username, game_uid, desk_id, is_ai, hp, mana, dcards, !not_shuffle, pid]);
        await waitForTransaction(hash);

        const tx_result = await getTxResult(hash);

        const player_key = calculateKeccak256HashTwoString(game_uid, username);

        const card_pool = await worldContract.read.getPlayerCards([player_key]);
        console.log("card_pool", card_pool)

        // let intervel = setInterval(async () => {
        //     console.log("1")
        // },1000);


        let res = {
            player_name: username,
            cards: [],
            hand: [],
            deck: [],
            board: [],
            all: [],
            mana: mana,
            hp: hp,
            is_ai: is_ai,
            dcards: dcards,
            pid: pid,
            game_uid: game_uid
        }

        res.player_name = card_pool[0];
        res.cards = card_pool[1];
        res.hand = card_pool[2];
        res.deck = card_pool[3];
        res.board = card_pool[4];
        res.all = res.hand.concat(res.deck);

        // if (res.player_name == "Player") {
        //     res.player_name = "test"
        // }

        await sleep(1500);
        return convertBigIntToInt({hash, tx_result, res});
    }

    const getPlayerCards = async (game_id, name) => {
        const player_key = calculateKeccak256HashTwoString(game_id, name);

        const cards = await worldContract.read.getPlayerCards([player_key]);
        return cards;
    }

    const playCard = async (game_id: string, player_name: string, card_id: string, slot, skip_cost, card_key) => {
        const game_key = calculateKeccak256Hash(game_id);
        // const card_config_key = calculateKeccak256Hash(card_id);
        const player_key = calculateKeccak256HashTwoString(game_id, player_name);
        // const card_key = calculateKeccak256HashTwoBytes32(card_config_key, player_key);
        // let slot = {x: 0, y: 0, z: 0}

        // function PlayCard(bytes32 game_key, bytes32 player_key, bytes32 card_key, Slot memory slot, bool skip_cost) public {

        console.log("game_key", game_key);
        console.log("player_key", player_key);
        console.log("card_key", card_key);
        console.log("slot", slot);

        const slot_encode = EncodeSlot(slot);

        const hash = await worldContract.write.PlayCard([game_key, player_key, card_key, slot_encode]);
        await waitForTransaction(hash);
        const tx_result = await getTxResult(hash);

        return [];
        // console.log("tx-result", tx_result)

        // const result = {
        //     card_uid: card_key,
        //     slot_x: slot.x,
        //     slot_y: 1,//slot.y,
        //     slot_p: slot.p,
        //     mana_cost: tx_result.result[0],
        //     player_mana: tx_result.result[1],
        // }
        // return convertBigIntToInt({hash, tx_result, result});
    }

    const moveCard = async (game_id, player_id, card_id, slot, skip_cost, card_key) => {
        const game_key = calculateKeccak256Hash(game_id);
        const card_config_key = calculateKeccak256Hash(card_id);
        const player_key = calculateKeccak256HashTwoString(game_id, player_id);
        // const card_key = calculateKeccak256HashTwoBytes32(card_config_key, player_key);
        // console.log("card_key", card_key);

        // let slot = {x: 0, y: 0, z: 0}

        // function PlayCard(bytes32 game_key, bytes32 player_key, bytes32 card_key, Slot memory slot, bool skip_cost) public {

        const tx = await worldContract.write.MoveCard([game_key, player_key, card_key, slot]);
        await waitForTransaction(tx);

        const result = {
            card_uid: card_key,
            slot_x: slot.x,
            slot_y: 1,//slot.y,
            slot_p: slot.p,
        }
        return {tx, result};
    }

    const attackCard = async (game_id, player_id, attacker_key, slot, skip_cost, target_key) => {
        const game_key = calculateKeccak256Hash(game_id);
        const tx = await worldContract.write.AttackTarget([game_key, attacker_key, target_key, false]);
        await waitForTransaction(tx);

        return {
            attacker_uid: attacker_key,
            target_uid: target_key,
        };
    }

    const attackPlayer = async (game_uid: string, cardkey: string, target: number) => {
        const game_key = calculateKeccak256Hash(game_uid);
        const tx = await worldContract.write.AttackPlayer([game_key, cardkey, target, false]);
        await waitForTransaction(tx);
        return {
            attacker_uid: cardkey,
            target_id: target,
        };
    }

    const saveDeck = async (tid: string, hero: string, cards: string) => {
        const hero_key = calculateKeccak256Hash(hero);
        const cards_keys = cards.split(",").map((card) => calculateKeccak256Hash(card));
        const tx = await worldContract.write.addDeck([tid, hero_key, cards_keys]);
        await waitForTransaction(tx);
        return tx;
    }


    const endTurn = async (game_uid: string, player_name: string, player_id: string) => {
        console.log("game_uid", game_uid);
        console.log("player_name", player_name);
        console.log("player_id", player_id);


        const game_key = calculateKeccak256Hash(game_uid);
        const player_key = calculateKeccak256HashTwoString(game_uid, player_name);
        const tx = await worldContract.write.EndTurn([game_key]);
        await waitForTransaction(tx);

        const tx_result = await getTxResult(tx);
        console.log("tx-result", tx_result)

        // return tx;
        // return {
        //     operator_player_key: player_key,
        //     opponent_player_key: tx_result.result[0],
        //     board_card_key: tx_result.result[1],
        //     mana: tx_result.result[2],
        //     mana_max: tx_result.result[3]
        // }
    }

    const test = async () => {
        const a = calculateKeccak256Hash("a")
        const tx = await worldContract.write.callEffectToPlayer([a, a, a]);
        await waitForTransaction(tx);
        return tx;
    }


    const test2 = async () => {
        const a = calculateKeccak256Hash("a")
        const tx = await worldContract.write.callEffectToPlayer2([a, a, a]);
        await waitForTransaction(tx);
        return tx;
    }

    const test3 = async () => {
        const a = calculateKeccak256Hash("a")
        const tx = await worldContract.write.callEffectToPlayer3([a, a, a]);
        await waitForTransaction(tx);
        return tx;
    }

    const testCoinCard = async () => {
        const a = calculateKeccak256Hash("a")
        const tx = await worldContract.write.TestCoinCard([]);
        await waitForTransaction(tx);
        return tx;
    }

    const testRevert = async () => {
        const tx = await worldContract.write.testRevert([]);
        await waitForTransaction(tx);
        return tx;
    }

    // const EndTurn


    // let a = async () => {
    //     // const transactionResultPromise = getTransactionResult(publicClient,worldContract.worldAbi, worldContract.write);
    //     // const transaction = usePromise(transactionPromise);
    //     // const transactionReceipt = usePromise(transactionReceiptPromise);
    //     // const transactionResult = usePromise(transactionResultPromise);
    // }


    const startMatchmaking = async (game_uid: string, nb_players: number) => {
        console.log("game_uid", game_uid);
        console.log("nb_players", nb_players);

        const tx = await worldContract.write.StartMatchmaking([nb_players]);
        await waitForTransaction(tx);

        const tx_result = await getTxResult(tx);
        console.log("tx-result", tx_result)

        return {
            game: Number(tx_result.result[0]),
            players: tx_result.result[1].players,
            nb_players: tx_result.result[1].nbPlayers,
        };
    }

    const checkMatchmaking = async (match_id: number) => {
        const record = await worldContract.read.CheckMatchmaking([match_id]);
        return {
            game: match_id,
            players: record.players,
            nb_players: record.nbPlayers,
        };
    }

    function DecodeSlotX(slot: number) {
        return Math.floor(slot % 10);
    }

    function DecodeSlotY(slot: number) {
        return Math.floor((slot / 10) % 10);
    }

    function DecodeSlotP(slot: number) {
        return Math.floor(slot / 100);
    }

    function EncodeSlot(slot) {
        return slot.x + (slot.y * 10) + (slot.p * 100);
    }

    let index = 0;
    const checkAction = async (username: string, game_uid: string) => {
        // const player_key = calculateKeccak256HashTwoString(game_uid, username);
        const game_key = calculateKeccak256Hash(game_uid);

        try {
            const record = await worldContract.read.GetAction([game_key, index]);
            // public ushort type;
            // public string card_uid;
            // public string target_uid;
            // public int slot_x;
            // public int slot_y;
            // public int slot_p;
            // public int player_id;
            let res = convertBigIntToInt({
                len: record[0],
                type: record[1].actionType,
                card_uid: record[1].cardId,
                target_uid: record[1].target,
                slot_x: DecodeSlotX(record[1].slot),
                slot_y: DecodeSlotY(record[1].slot),
                slot_p: DecodeSlotP(record[1].slot),
                player_id: record[1].playerId,
                value: record[1].value
            });

            if (res.type == Action.SelectChoice) {
                const game_extend = await worldContract.read.GetGameExtend([game_key]);
                console.log('game_extend', game_extend);
                window.MyUnityInstance.SendMessage('Client', 'OnChangeGameExtendSuccess', JSON.stringify({
                    selector: (Number)(game_extend[0]),
                    selectorCasterUid: game_extend[1],
                    selectorPlayerId: game_extend[2],
                    selectorAbility: abilities[game_extend[3]],
                }))
                index++;
                return;
            }

            if (res.type === Action.PlayCard) {
                res.type = 1000;
            }
            if (res.type === Action.Attack) {
                res.type = 1010;
            }
            if (res.type === Action.AttackPlayer) {
                res.type = 1012;
            }
            if (res.type === Action.Move) {
                res.type = 1015;
            }
            if (res.type === Action.EndTurn) {
                res.type = 2015;
            }

            console.log("action", res);

            index++;
            return res;
        } catch (e) {
            //console.warn(e);
            return null;
        }
    }

    const selectCard = async (game_uid: string, card_id: string, card_uid: string) => {
        console.log("selectCard", game_uid, card_id, card_uid);
        const game_key = calculateKeccak256Hash(game_uid);
        const tx = await worldContract.write.SelectCard([game_key, card_uid]);
        await waitForTransaction(tx);

        const tx_result = await getTxResult(tx);

        const target_card = await worldContract.read.GetCard([card_uid]);
        console.log("tx-result", tx_result)
        console.log("target_card", target_card)
        return {
            card_uid: card_uid,
            hp: (Number)(target_card[0]),
            mana: (Number)(target_card[1]),
            attack: (Number)(target_card[2]),
            damage: (Number)(target_card[3]),
        }
    }

    const selectPlayer = async (game_uid: string, caster: string) => {
        const game_key = calculateKeccak256Hash(game_uid);
        const tx = await worldContract.write.SelectPlayer([game_key, caster]);
        await waitForTransaction(tx);

        const tx_result = await getTxResult(tx);
        console.log("tx-result", tx_result)
    }

    const selectSlot = async (game_uid: string, slot_x: number, slot_y: number, slot_p: number) => {
        const game_key = calculateKeccak256Hash(game_uid);
        let slot_encode = EncodeSlot({x: slot_x, y: slot_y, p: slot_p});
        const tx = await worldContract.write.SelectSlot([game_key, slot_encode]);
        await waitForTransaction(tx);

        const tx_result = await getTxResult(tx);
        console.log("tx-result", tx_result)

    }

    const cancelSelection = async (game_uid: string) => {
        const game_key = calculateKeccak256Hash(game_uid);
        const tx = await worldContract.write.CancelSelection([game_key]);
        await waitForTransaction(tx);

        const tx_result = await getTxResult(tx);
        console.log("tx-result", tx_result)
    }

    const getRandomEmptySlot = async (game_uid: string, player: string) => {
        const game_key = calculateKeccak256Hash(game_uid);
        const player_key = calculateKeccak256HashTwoString(game_uid, player);
        const slot = await worldContract.read.GetRandomEmptySlot([player_key]);
        return slot;
    }

    const getAllSlot = async () => {
        const slots = await worldContract.read.GetAllSlot([]);
        return slots;
    }

    const setMana = async () => {
        const key = calculateKeccak256Hash(now_game_uid);
        await worldContract.write.setMana([key]);
    }

    const addCardOnEmptySlots = async (card_name: string) => {
        // const key = calculateKeccak256Hash(now_game_uid);
        await worldContract.write.AddCardOnEmptySlots([now_game_uid, player_name, card_name]);
    }

    const addCard = async (card_name: string) => {
        // const key = calculateKeccak256Hash(now_game_uid);
        const tx = await worldContract.write.AddCard([now_game_uid, player_name, card_name]);
        const transaction = await waitForTransaction(tx);

        const tx_result = await getTxResult(tx);
        console.log(tx, transaction, tx_result);
    }

    const getSlotCard = async (slot_x, slot_y, slot_p) => {
        const game_key = calculateKeccak256Hash(now_game_uid);
        return worldContract.read.GetSlotCards([game_key, {x: slot_x, y: slot_y, p: slot_p}]);
    }

    const getEmptySlots = async (game_uid: string, player: string) => {
        const game_key = calculateKeccak256Hash(game_uid);
        const player_key = calculateKeccak256HashTwoString(game_uid, player);
        return worldContract.read.GetEmptySlots([player_key]);
    }

    const triggerCardAbilityType = async (caster) => {
        await worldContract.write.TriggerCardAbilityType([AbilityTrigger.ON_PLAY, caster, caster, true]);
    }

    const isConditionFunctionExist = async (selector: string) => {
        return await worldContract.read.IsConditionFunctionExist([selector]);
    }

    const setGameEnd = async () => {
        const game_uid = now_game_uid;
        const game_key = calculateKeccak256Hash(game_uid);
        return await worldContract.write.SetGameEnd([game_key]);
    }

    const out = {
        convertBigIntToInt,
        calculateKeccak256Hash,
        addTask,
        toggleTask,
        deleteTask,
        addUser,
        getUser,
        getUserByKey,
        initCard,
        initPack,
        initDeck,
        initAbility,
        buyCard,
        sellCard,
        getCard,
        buyPack,
        incr,
        getRandomCardByRarity,
        openPack,
        gameSetting,
        playerSetting,
        playCard,
        moveCard,
        saveDeck,
        attackPlayer,
        attackCard,
        getAbilityTarget,
        getEffectSelector,
        test,
        test2,
        test3,
        testRevert,
        testCoinCard,
        IsBoardCard,
        getPlayerCards,
        endTurn,
        startMatchmaking,
        checkMatchmaking,
        checkPlayerSetting,
        checkAction,
        selectCard,
        selectPlayer,
        selectSlot,
        cancelSelection,
        getRandomEmptySlot,
        getAllSlot,
        setMana,
        addCard,
        getSlotCard,
        getEmptySlots,
        addCardOnEmptySlots,
        triggerCardAbilityType,
        isConditionFunctionExist,
        setGameEnd,
        // ablities,
    };

    window.mud = out;

    return out;
}
