// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {StoreSwitch} from "@latticexyz/store/src/StoreSwitch.sol";

import {IWorld} from "../src/codegen/world/IWorld.sol";
import {Tasks, TasksData} from "../src/codegen/index.sol";
import {Cards, CardsData} from "../src/codegen/index.sol";

contract PostDeploy is Script {
    function run(address worldAddress) external {
        // Specify a store so that you can use tables directly in PostDeploy
        StoreSwitch.setStoreAddress(worldAddress);

        // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcasting transactions from the deployer account
        vm.startBroadcast(deployerPrivateKey);

        // We can set table records directly
        //    Tasks.set("1", TasksData({ description: "Walk the dog", createdAt: block.timestamp, completedAt: 0 }));
        //
        //    // Or we can call our own systems
        //    IWorld(worldAddress).addTask("Take out the trash");
        //
        //    bytes32 key = IWorld(worldAddress).addTask("Do the dishes");
        //    IWorld(worldAddress).completeTask(key);

        Cards.set(keccak256(abi.encode("ashes_snake")), CardsData({mana : 5, attack : 6, hp : 4, cost : 100, createdAt : 1, tid : "ashes_snake", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("bull_heat")), CardsData({mana : 3, attack : 2, hp : 5, cost : 100, createdAt : 1, tid : "bull_heat", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("cave")), CardsData({mana : 2, attack : 0, hp : 5, cost : 100, createdAt : 1, tid : "cave", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("dark_stallion")), CardsData({mana : 4, attack : 4, hp : 5, cost : 100, createdAt : 1, tid : "dark_stallion", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("dragon_red")), CardsData({mana : 7, attack : 9, hp : 7, cost : 100, createdAt : 1, tid : "dragon_red", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("equip_sword")), CardsData({mana : 2, attack : 0, hp : 2, cost : 100, createdAt : 1, tid : "equip_sword", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("fire_chicken")), CardsData({mana : 2, attack : 1, hp : 1, cost : 100, createdAt : 1, tid : "fire_chicken", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("fire_element")), CardsData({mana : 5, attack : 7, hp : 3, cost : 100, createdAt : 1, tid : "fire_element", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("firefox")), CardsData({mana : 4, attack : 4, hp : 4, cost : 100, createdAt : 1, tid : "firefox", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("hell_hound")), CardsData({mana : 4, attack : 4, hp : 2, cost : 100, createdAt : 1, tid : "hell_hound", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("imp")), CardsData({mana : 2, attack : 2, hp : 1, cost : 100, createdAt : 1, tid : "imp", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("lava_beast")), CardsData({mana : 3, attack : 2, hp : 3, cost : 100, createdAt : 1, tid : "lava_beast", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("phoenix")), CardsData({mana : 6, attack : 6, hp : 6, cost : 100, createdAt : 1, tid : "phoenix", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("potion_red")), CardsData({mana : 2, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "potion_red", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("reaper")), CardsData({mana : 6, attack : 6, hp : 6, cost : 100, createdAt : 1, tid : "reaper", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("spell_aerial_strike")), CardsData({mana : 3, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "spell_aerial_strike", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("spell_armageddon")), CardsData({mana : 5, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "spell_armageddon", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("spell_burn")), CardsData({mana : 4, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "spell_burn", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("spell_split")), CardsData({mana : 2, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "spell_split", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("spell_stones")), CardsData({mana : 2, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "spell_stones", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("town_volcano")), CardsData({mana : 3, attack : 0, hp : 7, cost : 100, createdAt : 1, tid : "town_volcano", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("trap_explosive")), CardsData({mana : 3, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "trap_explosive", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("wolf_furious")), CardsData({mana : 5, attack : 3, hp : 4, cost : 100, createdAt : 1, tid : "wolf_furious", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("armored_beast")), CardsData({mana : 4, attack : 3, hp : 6, cost : 100, createdAt : 1, tid : "armored_beast", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("bear")), CardsData({mana : 5, attack : 4, hp : 5, cost : 100, createdAt : 1, tid : "bear", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("dragon_green")), CardsData({mana : 7, attack : 7, hp : 9, cost : 100, createdAt : 1, tid : "dragon_green", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("equip_shield")), CardsData({mana : 2, attack : 0, hp : 2, cost : 100, createdAt : 1, tid : "equip_shield", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("gorilla")), CardsData({mana : 4, attack : 0, hp : 6, cost : 100, createdAt : 1, tid : "gorilla", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("mammoth")), CardsData({mana : 6, attack : 7, hp : 6, cost : 100, createdAt : 1, tid : "mammoth", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("owl")), CardsData({mana : 3, attack : 2, hp : 3, cost : 100, createdAt : 1, tid : "owl", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("potion_green")), CardsData({mana : 2, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "potion_green", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("raccoon")), CardsData({mana : 2, attack : 2, hp : 3, cost : 100, createdAt : 1, tid : "raccoon", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("sasquatch")), CardsData({mana : 5, attack : 6, hp : 4, cost : 100, createdAt : 1, tid : "sasquatch", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("snake_venom")), CardsData({mana : 2, attack : 1, hp : 3, cost : 100, createdAt : 1, tid : "snake_venom", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("spell_extinct")), CardsData({mana : 2, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "spell_extinct", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("spell_growth")), CardsData({mana : 5, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "spell_growth", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("spell_hibernate")), CardsData({mana : 3, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "spell_hibernate", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("spell_roots")), CardsData({mana : 3, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "spell_roots", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("spell_stomp")), CardsData({mana : 2, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "spell_stomp", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("town_forest")), CardsData({mana : 3, attack : 0, hp : 7, cost : 100, createdAt : 1, tid : "town_forest", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("trap_spike")), CardsData({mana : 3, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "trap_spike", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("tree_angry")), CardsData({mana : 3, attack : 3, hp : 5, cost : 100, createdAt : 1, tid : "tree_angry", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("unicorn")), CardsData({mana : 6, attack : 5, hp : 6, cost : 100, createdAt : 1, tid : "unicorn", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("wolf_alpha")), CardsData({mana : 3, attack : 3, hp : 2, cost : 100, createdAt : 1, tid : "wolf_alpha", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("wolf_stalker")), CardsData({mana : 3, attack : 4, hp : 2, cost : 100, createdAt : 1, tid : "wolf_stalker", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("woodland")), CardsData({mana : 2, attack : 0, hp : 5, cost : 100, createdAt : 1, tid : "woodland", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("hero_fire")), CardsData({mana : 0, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "hero_fire", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("hero_forest")), CardsData({mana : 0, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "hero_forest", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("hero_water")), CardsData({mana : 0, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "hero_water", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("coin")), CardsData({mana : 0, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "coin", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("dragon_egg")), CardsData({mana : 2, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "dragon_egg", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("flame_eagle")), CardsData({mana : 1, attack : 1, hp : 1, cost : 100, createdAt : 1, tid : "flame_eagle", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("phoenix_egg")), CardsData({mana : 0, attack : 0, hp : 3, cost : 100, createdAt : 1, tid : "phoenix_egg", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("wolf_baby")), CardsData({mana : 1, attack : 1, hp : 1, cost : 100, createdAt : 1, tid : "wolf_baby", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("bay")), CardsData({mana : 2, attack : 0, hp : 5, cost : 100, createdAt : 1, tid : "bay", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("crab_mana")), CardsData({mana : 2, attack : 3, hp : 1, cost : 100, createdAt : 1, tid : "crab_mana", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("dragon_blue")), CardsData({mana : 7, attack : 8, hp : 8, cost : 100, createdAt : 1, tid : "dragon_blue", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("eel")), CardsData({mana : 4, attack : 5, hp : 2, cost : 100, createdAt : 1, tid : "eel", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("equip_ring")), CardsData({mana : 1, attack : 0, hp : 3, cost : 100, createdAt : 1, tid : "equip_ring", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("fish")), CardsData({mana : 1, attack : 1, hp : 1, cost : 100, createdAt : 1, tid : "fish", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("killer_whale")), CardsData({mana : 5, attack : 5, hp : 4, cost : 100, createdAt : 1, tid : "killer_whale", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("kraken")), CardsData({mana : 6, attack : 5, hp : 5, cost : 100, createdAt : 1, tid : "kraken", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("octopus")), CardsData({mana : 4, attack : 2, hp : 5, cost : 100, createdAt : 1, tid : "octopus", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("poison_frog")), CardsData({mana : 3, attack : 2, hp : 2, cost : 100, createdAt : 1, tid : "poison_frog", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("potion_blue")), CardsData({mana : 2, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "potion_blue", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("pufferfish")), CardsData({mana : 3, attack : 2, hp : 5, cost : 100, createdAt : 1, tid : "pufferfish", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("sea_monster")), CardsData({mana : 6, attack : 4, hp : 7, cost : 100, createdAt : 1, tid : "sea_monster", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("seagull")), CardsData({mana : 2, attack : 2, hp : 2, cost : 100, createdAt : 1, tid : "seagull", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("shark")), CardsData({mana : 4, attack : 4, hp : 4, cost : 100, createdAt : 1, tid : "shark", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("spell_flood")), CardsData({mana : 3, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "spell_flood", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("spell_storm")), CardsData({mana : 5, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "spell_storm", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("spell_submerge")), CardsData({mana : 2, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "spell_submerge", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("spell_treasure")), CardsData({mana : 3, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "spell_treasure", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("spell_wave")), CardsData({mana : 3, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "spell_wave", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("town_underwater")), CardsData({mana : 3, attack : 0, hp : 7, cost : 100, createdAt : 1, tid : "town_underwater", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("trap_fish")), CardsData({mana : 3, attack : 0, hp : 0, cost : 100, createdAt : 1, tid : "trap_fish", cardType : "1", team : "1", rarity : "1"}));
        Cards.set(keccak256(abi.encode("turtle")), CardsData({mana : 3, attack : 2, hp : 3, cost : 100, createdAt : 1, tid : "turtle", cardType : "1", team : "1", rarity : "1"}));

        vm.stopBroadcast();
    }
}
