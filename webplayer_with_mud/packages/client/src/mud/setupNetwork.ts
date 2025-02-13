/*
 * The MUD client code is built on top of viem
 * (https://viem.sh/docs/getting-started.html).
 * This line imports the functions we need from it.
 */
import {createPublicClient, fallback, webSocket, http, createWalletClient, Hex, parseEther, ClientConfig} from "viem";
import {createFaucetService} from "@latticexyz/services/faucet";
import {syncToZustand} from "@latticexyz/store-sync/zustand";
import {getNetworkConfig} from "./getNetworkConfig";
import IWorldAbi from "contracts/out/IWorld.sol/IWorld.abi.json";
import {createBurnerAccount, getContract, transportObserver, ContractWrite} from "@latticexyz/common";
import {Subject, share} from "rxjs";

/*
 * Import our MUD config, which includes strong types for
 * our tables and other config options. We use this to generate
 * things like RECS components and get back strong types for them.
 *
 * See https://mud.dev/templates/typescript/contracts#mudconfigts
 * for the source of this information.
 */
import mudConfig from "contracts/mud.config";

export type SetupNetworkResult = Awaited<ReturnType<typeof setupNetwork>>;

export async function setupNetwork() {
    const networkConfig = await getNetworkConfig();

    /*
     * Create a viem public (read only) client
     * (https://viem.sh/docs/clients/public.html)
     */

    const domain = window.location.hostname;
    const domainWithPort = window.location.host;
    const protocol = window.location.protocol;
    console.log(domain, domainWithPort, protocol);
    let websocket_url = "";
    let api_url = "";
    if (protocol == "https:") {
        websocket_url = "wss://" + domainWithPort + "/ws";
        api_url = "https://" + domainWithPort + "/api";
    }
    if (protocol == "http:") {
        websocket_url = "ws://" + domainWithPort + "/ws";
        api_url = "http://" + domainWithPort + "/api";
    }

    //redstone
    websocket_url = "wss://rpc.holesky.redstone.xyz/ws"
    api_url = "https://rpc.holesky.redstone.xyz"

    const clientOptions = {
        chain: networkConfig.chain,
        // transport: transportObserver(fallback([webSocket("ws://127.0.0.1:8545"), http("http://127.0.0.1:8545")])),
        transport: transportObserver(fallback([webSocket(websocket_url), http(api_url)])),
        pollingInterval: 1000,
    } as const satisfies ClientConfig;

    const publicClient = createPublicClient(clientOptions);

    /*
     * Create a temporary wallet and a viem client for it
     * (see https://viem.sh/docs/clients/wallet.html).
     */
    const burnerAccount = createBurnerAccount(networkConfig.privateKey as Hex);
    const burnerWalletClient = createWalletClient({
        ...clientOptions,
        account: burnerAccount,
    });

    /*
     * Create an observable for contract writes that we can
     * pass into MUD dev tools for transaction observability.
     */
    const write$ = new Subject<ContractWrite>();

    /*
     * Create an object for communicating with the deployed World.
     */
    const worldContract = getContract({
        address: networkConfig.worldAddress as Hex,
        abi: IWorldAbi,
        publicClient,
        walletClient: burnerWalletClient,
        onWrite: (write) => write$.next(write),
    });

    /*
     * Sync on-chain state into RECS and keeps our client in sync.
     * Uses the MUD indexer if available, otherwise falls back
     * to the viem publicClient to make RPC calls to fetch MUD
     * events from the chain.
     */
    const {tables, useStore, latestBlock$, storedBlockLogs$, waitForTransaction} = await syncToZustand({
        config: mudConfig,
        address: networkConfig.worldAddress as Hex,
        publicClient,
        startBlock: BigInt(networkConfig.initialBlockNumber),
    });

    /*
     * If there is a faucet, request (test) ETH if you have
     * less than 1 ETH. Repeat every 20 seconds to ensure you don't
     * run out.
     */
    if (networkConfig.faucetServiceUrl) {
        const address = burnerAccount.address;
        console.info("[Dev Faucet]: Player address -> ", address);

        const faucet = createFaucetService(networkConfig.faucetServiceUrl);

        const requestDrip = async () => {
            const balance = await publicClient.getBalance({address});
            console.info(`[Dev Faucet]: Player balance -> ${balance}`);
            const lowBalance = balance < parseEther("1");
            if (lowBalance) {
                console.info("[Dev Faucet]: Balance is low, dripping funds to player");
                // Double drip
                await faucet.dripDev({address});
                await faucet.dripDev({address});
            }
        };

        requestDrip();
        // Request a drip every 20 seconds
        setInterval(requestDrip, 20000);
    }

    return {
        tables,
        useStore,
        publicClient,
        walletClient: burnerWalletClient,
        latestBlock$,
        storedBlockLogs$,
        waitForTransaction,
        worldContract,
        write$: write$.asObservable().pipe(share()),
    };
}
