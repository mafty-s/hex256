/*
 * Create the system calls that the client can use to ask
 * for changes in the World state (using the System contracts).
 */

import {Hex} from "viem";
import {SetupNetworkResult} from "./setupNetwork";
import {decodeFunctionData} from "viem";
import worlds from "contracts/worlds.json";

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
    const addTask = async (label: string) => {
        const tx = await worldContract.write.addTask([label]);
        await waitForTransaction(tx);
        return tx;
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

    const getUserByKey = async (key: string) => {
        const user = await worldContract.read.getUserByKey([key]);
        return user;
    };

    const getUserByOwner = async (owner: string) => {
        const user = await worldContract.read.getUserByOwner([owner]);
        return user;
    };

    const initCard = async (name: string, mana: number, attack: number, hp: number, cost: number) => {
        const tx = await worldContract.write.initCard([name, mana, attack, hp, cost]);
        await waitForTransaction(tx);
        return tx;
    };

    const initPack = async (name: string, packType: number, cards: number, rarities: number[], cost: number) => {
        const tx = await worldContract.write.initPack([name, packType, cards, rarities, cost]);
        await waitForTransaction(tx);
        return tx;
    };


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

    const openPack = async (name: string) => {
        console.log("worldContract", worldContract);
        const hash = await worldContract.write.OpenPack([name]);
        await waitForTransaction(hash);

        const transaction = await publicClient.getTransaction({hash})
        const transactionReceipt = await publicClient.waitForTransactionReceipt({hash});
        const {functionName, args} = decodeFunctionData({abi: worldContract.abi, data: transaction.input});

        const result = await publicClient.simulateContract({
            account: transaction.from,
            address: transaction.to!,
            abi: worldContract.abi,
            functionName,
            args,
            // simulation happens at the end of the block, so we need to use the previous block number
            blockNumber: transactionReceipt.blockNumber - 1n,
            // TODO: do we need to include value, nonce, gas price, etc. to properly simulate?
        });

        return {hash, transaction, transactionReceipt, functionName, args, result};
    };

    let a = async () => {
        // const transactionResultPromise = getTransactionResult(publicClient,worldContract.worldAbi, worldContract.write);
        // const transaction = usePromise(transactionPromise);
        // const transactionReceipt = usePromise(transactionReceiptPromise);
        // const transactionResult = usePromise(transactionResultPromise);
    }

    const out = {
        addTask,
        toggleTask,
        deleteTask,
        addUser,
        getUser,
        getUserByKey,
        getUserByOwner,
        initCard,
        initPack,
        buyCard,
        sellCard,
        getCard,
        buyPack,
        incr,
        getRandomCardByRarity,
        openPack
    };

    window.mud = out;

    return out;
}
