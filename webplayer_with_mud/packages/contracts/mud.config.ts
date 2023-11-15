import {mudConfig} from "@latticexyz/world/register";

export default mudConfig({
    enums: {
        RarityType: ["COMMON", "UNCOMMON", "RARE", "MYTHIC"],
        PackType: ["FIXED", "RANDOM"],
        TeamType: ["FIRE", "FOREST", "WATER", "NEUTRAL"],
    },
    tables: {
        CounterSingleton: {
            keySchema: {},
            valueSchema: "uint256",
        },
        CardCommonSingleton: {
            keySchema: {},
            valueSchema: "bytes32[]",
        },
        Packs: {
            valueSchema: {
                packType: "PackType",
                cards:"uint8",
                cost:"uint32",
                id: "string",
                rarities: "uint8[]",
            }
        },
        Users: {
            valueSchema: {
                owner: "address",
                coin: "uint256",
                xp: "uint256",
                createdAt: "uint256",
                cards: "bytes32[]",
                packs: "bytes32[]",
                id: "string",
                avatar: "string",
                cardback: "string",
            }
        },
        Cards: {
            valueSchema: {
                rarity: "RarityType",
                mana: "uint8",
                attack: "uint8",
                hp: "uint8",
                cost: "uint32",
                tid: "string",
                cardType: "string",
                team: "string",
            },
        },
        Tasks: {
            valueSchema: {
                createdAt: "uint256",
                completedAt: "uint256",
                description: "string",
            },
        },
    },
});
