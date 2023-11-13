import {mudConfig} from "@latticexyz/world/register";

export default mudConfig({
    enums: {
        AnimalType: ["NONE", "DOG", "CAT", "SQUIREL"],
    },
    tables: {
        CounterSingleton: {
            keySchema: {},
            valueSchema: "uint256",
        },
        Users: {
            valueSchema: {
                owner: "address",
                coin: "uint256",
                xp: "uint256",
                createdAt: "uint256",
                cards: "uint256[]",
                packs: "uint256[]",
                id: "string",
                avatar: "string",
                cardback: "string",
            }
        },
        Cards: {
            valueSchema: {
                mana: "uint8",
                attack: "uint8",
                hp: "uint8",
                cost: "uint32",
                createdAt: "uint256",
                tid: "string",
                cardType: "string",
                team: "string",
                rarity: "string",
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
