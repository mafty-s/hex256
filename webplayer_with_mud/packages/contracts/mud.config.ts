import {mudConfig} from "@latticexyz/world/register";

export default mudConfig({
  enums: {
    AnimalType: ["NONE", "DOG", "CAT", "SQUIREL"],
    PackType: ["Fixed", "Random"]
  },
  tables: {
    CounterSingleton: {
      keySchema: {},
      valueSchema: "uint256",
    },
    Packs: {
      valueSchema: {
        packType:"PackType",
        id: "string",
        cards: "uint256[]",
      }
    },
    Users: {
      valueSchema: {
        owner: "address",
        coin: "uint256",
        xp: "uint256",
        createdAt: "uint256",
        cards: "uint8[]",
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
