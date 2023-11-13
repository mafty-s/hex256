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
