import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  tables: {
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
