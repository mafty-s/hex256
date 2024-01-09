/*
 * Create the system calls that the client can use to ask
 * for changes in the World state (using the System contracts).
 */

import {Hex} from "viem";
import {SetupNetworkResult} from "./setupNetwork";
import {decodeFunctionData} from "viem";
import worlds from "contracts/worlds.json";
import {ethers} from "ethers";
import {AbilityTarget, AbilityTrigger, RarityType, CardType} from "./common";

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
        const arr = arr_str.split('|');
        const arr_bytes32 = arr.map((item) => {
            return calculateKeccak256Hash(item);
        });
        return arr_bytes32;
    }

    const getEffectSelector = (name) => {
        const functionName = name + '(bytes32,bytes32,bytes32,bool)';
        const functionSelector = ethers.keccak256(ethers.toUtf8Bytes(functionName)).slice(0, 10);
        return functionSelector;
    }

    const getEffectSelectorFromArrStr = (arrstr: string) => {
        const arr = arrstr.split('|');
        const arr_bytes4 = arr.map((item) => {
            return getEffectSelector(item);
        });
        return arr_bytes4;
    }

    const getAbilityTarget = (str: string) => {
        const abilityTarget: AbilityTarget = AbilityTarget[str as keyof typeof AbilityTarget];
        return abilityTarget;
    }

    const getAbilityTrigger = (str: string) => {
        const abilityTrigger: AbilityTrigger = AbilityTrigger[str as keyof typeof AbilityTrigger];
        return abilityTrigger;
    }

    const getRarityType = (str: string) => {
        const rarityType: RarityType = RarityType[str as keyof typeof RarityType];
        return rarityType;
    }

    const getCardType = (str: string) => {
        const cardType: CardType = CardType[str as keyof typeof CardType];
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
        const user = await worldContract.read.getUser();
        return user;
    };

    const IsBoardCard = async (key: string) => {
        return await worldContract.read.IsBoardCard([key]);
    };


    const getUserByKey = async (key: string) => {
        const user = await worldContract.read.getUserByKey([key]);
        return user;
    };

    const getUserByOwner = async (owner: string) => {
        const user = await worldContract.read.getUserByOwner([owner]);
        return user;
    };

    const initCard = async (name: string, mana: number, attack: number, hp: number, cost: number, abilities_str: string, cardType: string, rarity: string) => {
        const cardTypeCode = getCardType(convertToEnumFormat(cardType));
        let rarity_str = convertToEnumFormat(rarity);
        const rarityCode = getRarityType(rarity_str.substr(2,));
        const tx = await worldContract.write.initCard([name, mana, attack, hp, cost, arrStr2Bytes32(abilities_str), cardTypeCode, rarityCode]);
        await waitForTransaction(tx);
        return tx;
    };

    const initPack = async (name: string, packType: number, cards: number, rarities: number[], cost: number) => {
        const tx = await worldContract.write.initPack([name, packType, cards, rarities, cost]);
        await waitForTransaction(tx);
        return tx;
    };

    const initDeck = async (name: string, hero: string, cards: string[]) => {
        const tx = await worldContract.write.initDeck([name, hero, cards]);
        await waitForTransaction(tx);
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

    const initAbility = async (id: string, trigger: string, target: string, value: number, manaCost: number, duration: number, exhaust: boolean, effect_str) => {

        const trigger_code = getAbilityTrigger(convertToEnumFormat(trigger));
        const target_code = getAbilityTarget(convertToEnumFormat(target));

        const tx = await worldContract.write.initAbility([id, trigger_code, target_code, value, manaCost, duration, exhaust, getEffectSelectorFromArrStr(effect_str)]);
        await waitForTransaction(tx);
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

    const getTxResult = async (hash: string) => {
        const transaction = await publicClient.getTransaction({hash})
        const transactionReceipt = await publicClient.waitForTransactionReceipt({hash});
        const {functionName, args} = decodeFunctionData({abi: worldContract.abi, data: transaction.input});

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

    const gameSetting = async (game_uid: string) => {
        const tx = await worldContract.write.GameSetting([game_uid]);
        await waitForTransaction(tx);
        let result = {
            game_uid: game_uid
        }
        return {tx, result};
    }

    const sleep = (ms: number) => {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    const playerSetting = async (username: string, game_uid: string, desk_id: string, is_ai: boolean, hp: number, mana: number, dcards: number,pid:number) => {
        await sleep(200)

        const hash = await worldContract.write.PlayerSetting([username, game_uid, desk_id, is_ai, hp, mana, dcards]);
        await waitForTransaction(hash);

        const tx_result = await getTxResult(hash);

        const player_key = calculateKeccak256HashTwoString(game_uid, username);

        const card_pool = await worldContract.read.getPlayerCards([player_key]);
        console.log("card_pool", card_pool)

        let res = {
            player_name: username,
            cards: [],
            hand: [],
            deck: [],
            board: [],
            all: [],
            mana:mana,
            hp:hp,
            is_ai:is_ai,
            dcards:dcards,
            pid:pid
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

    const getPlayerCards = async (game_id,name) => {
        const player_key = calculateKeccak256HashTwoString(game_id, name);

        const cards = await worldContract.read.getPlayerCards([player_key]);
        return cards;
    }

    const playCard = async (game_id:string, player_name:string, card_id:string, slot, skip_cost, card_key) => {
        const game_key = calculateKeccak256Hash(game_id);
        // const card_config_key = calculateKeccak256Hash(card_id);
        const player_key = calculateKeccak256HashTwoString(game_id, player_name);
        // const card_key = calculateKeccak256HashTwoBytes32(card_config_key, player_key);
        // let slot = {x: 0, y: 0, z: 0}

        // function PlayCard(bytes32 game_key, bytes32 player_key, bytes32 card_key, Slot memory slot, bool skip_cost) public {

        console.log("card_key", card_key);
        const hash = await worldContract.write.PlayCard([game_key, player_key, card_key, slot, skip_cost]);
        await waitForTransaction(hash);

        const tx_result = await getTxResult(hash);

        const result = {
            card_uid: card_key,
            slot_x: slot.x,
            slot_y: 1,//slot.y,
            slot_p: slot.p,
            mana_cost : tx_result.result.mana_cost,
            player_mana : tx_result.result.player_mana,
        }
        return convertBigIntToInt({hash, tx_result, result});
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

    const attackCard = async (game_id, player_id, attacker_key,slot, skip_cost, target_key) => {
        const game_key = calculateKeccak256Hash(game_id);
        const tx = await worldContract.write.AttackTarget([game_key, attacker_key, target_key, false]);
        await waitForTransaction(tx);
        return tx;
    }

    const attackPlayer = async (game_id, player_id, card_id, target_id, skip_cost, card_key) => {

    }

    const saveDeck = async (tid: string, hero: string, cards: string) => {
        const hero_key = calculateKeccak256Hash(hero);
        const cards_keys = cards.split(",").map((card) => calculateKeccak256Hash(card));
        const tx = await worldContract.write.addDeck([tid, hero_key, cards_keys]);
        await waitForTransaction(tx);
        return tx;
    }


    const endTurn = async (game_uid: string, player_name: string, player_id: number) => {
        console.log("game_uid", game_uid);
        console.log("player_name", player_name);
        console.log("player_id", player_id);

        player_id = player_id==1?0:1;

        const game_key = calculateKeccak256Hash(game_uid);
        const tx = await worldContract.write.EndTurn([game_key, player_id]);
        await waitForTransaction(tx);

        const tx_result = await getTxResult(tx);
        console.log("tx-result",tx_result)

        // return tx;
        return {
            player_id: player_id == 0 ? 1 : 0,
            board_card_key:tx_result.result.board_card_key,
            mana:tx_result.result.mana,
        }
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


    const out = {
        convertBigIntToInt,
        calculateKeccak256Hash,
        addTask,
        toggleTask,
        deleteTask,
        addUser,
        getUser,
        getUserByKey,
        getUserByOwner,
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
        IsBoardCard,
        getPlayerCards,
        endTurn,
    };

    window.mud = out;

    return out;
}
