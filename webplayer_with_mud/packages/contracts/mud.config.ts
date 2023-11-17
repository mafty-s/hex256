import {mudConfig} from "@latticexyz/world/register";


export default mudConfig({
    enums: {
        SelectorType: ["NONE", "SELECT_TARGET", "SELECTOR_CARD", "SELECTOR_CHOICE"],
        Status: ["NONE", "ATTACK_BONUS", "HP_BONUS", "STEALTH", "INVINCIBILITY", "SHELL", "PROTECTION", "PROTECTED", "ARMOR", "SPELL_IMMUNITY", "DEATHTOUCH", "FURY", "INTIMIDATE", "FLYING", "TRAMPLE", "LIFE_STEAL", "SILENCED", "PARALYSED", "POISONED", "SLEEP"],
        RarityType: ["COMMON", "UNCOMMON", "RARE", "MYTHIC"],
        PackType: ["FIXED", "RANDOM"],
        TeamType: ["FIRE", "FOREST", "WATER", "NEUTRAL"],
        GameType: ["SOLO", "PVP"],
        GameState: ["INIT", "PLAY", "GAME_ENDED"],
        GamePhase: ["NONE", "START_TURN", "MAIN", "END_TURN"],
        CardType: ["NONE", "HERO", "CHARACTER", "SPELL", "ARTIFACT", "SECRET", "EQUIPMENT"],
        AbilityTrigger: ["NONE", "ONGOING", "ACTIVATE", "ON_PLAY", "ON_PLAY_OTHER", "START_OF_TURN", "END_OF_TURN", "ON_BEFORE_ATTACK", "ON_AFTER_ATTACK", "ON_BEFORE_DEFEND", "ON_AFTER_DEFEND", "ON_KILL", "ON_DEATH", "ON_DEATH_OTHER"],
        AbilityTarget: ["NONE", "SELF", "PLAYER_SELF", "PLAYER_OPPONENT", "ALL_PLAYERS", "ALL_CARDS_BOARD", "ALL_CARDS_HAND", "ALL_CARDS_ALL_PILES", "ALL_SLOTS", "ALL_CARD_DATA", "PLAY_TARGET", "ABILITY_TRIGGERER", "EQUIPPED_CARD", "SELECT_TARGET", "CARD_SELECTOR", "CHOICE_SELECTOR", "LAST_PLAYED", "LAST_TARGETED", "LAST_DESTROYED", "LAST_SUMMONED"],
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
                cardType: "CardType",
                tid: "string",
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
        MatchesExtended: {
            valueSchema: {
                selector: "SelectorType",
                selectorPlayerId: "bytes32",
                lastPlayed: "bytes32",
                lastTarget: "bytes32",
                lastDestroyed: "bytes32",
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
            }
        },
        PlayerCardsDeck: "bytes32[]",
        PlayerCardsHand: "bytes32[]",
        PlayerCardsBoard: "bytes32[]",
        PlayerCardsEquip: "bytes32[]",
        PlayerCardsDiscard: "bytes32[]",
        PlayerCardsSecret: "bytes32[]",
        PlayerCardsTemp: "bytes32[]",
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
