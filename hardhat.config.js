require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.19",
  networks: {
    sepolia: {
      // Free public RPC endpoints:
      url: "https://rpc.sepolia.org", // Option 1
      // OR
      // url: "https://ethereum-sepolia-rpc.publicnode.com", // Option 2
      // OR  
      // url: "https://sepolia.gateway.tenderly.co", // Option 3
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
    },
    localhost: {
      url: "http://127.0.0.1:8545"
    }
  }
};