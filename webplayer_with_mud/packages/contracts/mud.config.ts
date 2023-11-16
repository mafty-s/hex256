import {mudConfig} from "@latticexyz/world/register";

export default mudConfig({
    enums: {
        RarityType: ["COMMON", "UNCOMMON", "RARE", "MYTHIC"],
        PackType: ["FIXED", "RANDOM"],
        TeamType: ["FIRE", "FOREST", "WATER", "NEUTRAL"],
        GameType: ["SOLO", "PVP"],
        GameState: ["INIT", "PLAY", "GAME_ENDED"],
        GamePhase: ["NONE", "START_TURN", "MAIN", "END_TURN"],
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
                cards: "uint8",
                cost: "uint32",
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
        Ability: {
            valueSchema: {
                name: "string",
            },
        },
        CardOnBoards: {
            valueSchema: {
                hp: "uint8",
                hpOngoing: "uint8",
                attack: "uint8",
                attackOngoing: "uint8",
                mana: "uint8",
                manaOngoing: "uint8",
                damage: "uint8",
                exhausted: "bool",
                equippedUid: "bytes32",
                id: "bytes32",
                playerId: "bytes32",
                name: "string",
            }
        },
        Slot: {
            valueSchema: {
                x: "uint8",
                y: "uint8",
                z: "uint8",
            }
        },
        Decks: {
            valueSchema: {
                tid: "string",
                cards: "bytes32[]",
            }
        },
        Matches: {
            valueSchema: {
                gameType: "GameType",
                gameState: "GameState",
                gamePhase: "GamePhase",
                firstPlayer: "bytes32",
                currentPlayer: "bytes32",
                turnCount: "uint8",
                uid: "string",
                players: "bytes32[]",
            }
        },
        Players: {
            valueSchema: {
                owner: "address",
                hp: "uint8",
                mana: "uint8",
                hpMax: "uint8",
                manaMax: "uint8",
                isAI: "bool",
                name: "string",
                deck: "string",
                // cards_deck: "bytes32[]",
                // cards_hand: "bytes32[]",
                // cards_board: "bytes32[]",
                // cards_equip: "bytes32[]",
                // cards_discard: "bytes32[]",
                // cards_secret: "bytes32[]",
                // cards_temp: "bytes32[]",
            }
        },
        PlayersCard: {
            valueSchema: {
                cardsDeck: "bytes32[]",
                cardsHand: "bytes32[]",
                cardsBoard: "bytes32[]",
                cardsEquip: "bytes32[]",
                cardsDiscard: "bytes32[]",
                // cards_secret: "bytes32[]",
                // cards_temp: "bytes32[]",
            }
        },
        ActionHistory: {
            valueSchema: {
                historyType: "uint8",
                cardId: "bytes32",
            }
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
