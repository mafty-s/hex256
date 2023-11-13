import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  enums: {
    AnimalType: ["NONE", "DOG", "CAT", "SQUIREL"],
  },
  tables: {
    Users:{
      valueSchema: {
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
    Cards:{
      valueSchema: {
        mana: "uint256",
        attack: "uint256",
        hp: "uint256",
        cost: "uint256",
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
