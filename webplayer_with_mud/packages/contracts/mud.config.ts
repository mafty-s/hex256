import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  tables: {
    Users:{
      valueSchema: {
        id: "uint256",
        avatar: "string",
        cardback: "string",
        coin: "uint256",
        xp: "uint256",
        createdAt: "uint256",
      }
    },
    Cards:{
      valueSchema: {
        tid: "string",
        type: "string",
        team: "string",
        rarity: "string",
        mana: "uint256",
        attack: "uint256",
        hp: "uint256",
        cost: "uint256",
        createdAt: "uint256",
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
