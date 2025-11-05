import type { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config();

const privateKey = process.env.PRIVATE_KEY ? process.env.PRIVATE_KEY : "";
const privateKey2 = process.env.PRIVATE_KEY_2 ? process.env.PRIVATE_KEY_2 : "";

const config: HardhatUserConfig = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: process.env.SEPOLIA_ALCHEMY_RPC,
      accounts: [privateKey, privateKey2],
    },
  },
};

export default config;
