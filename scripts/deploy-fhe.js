const { ethers } = require("hardhat");

async function main() {
  console.log("🚀 Deploying FHE Salary Contract...");
  
  try {
    // Get the contract factory
    const PrivateSalaryReveal = await ethers.getContractFactory("PrivateSalaryReveal");
    console.log("✅ Contract factory loaded");
    
    // Deploy the contract
    console.log("📦 Deploying contract...");
    const contract = await PrivateSalaryReveal.deploy();
    
    // Get the address using getAddress() method
    const contractAddress = await contract.getAddress();
    console.log("📍 Contract address:", contractAddress);
    
    console.log("\n🎉 DEPLOYMENT SUCCESSFUL!");
    console.log("📋 Contract Address:", contractAddress);
    console.log("🔗 Use this in your frontend HTML file");
    
    return contractAddress;
    
  } catch (error) {
    console.error("❌ Deployment failed:", error.message);
    process.exit(1);
  }
}

// Run the deployment
main()
  .then(address => {
    console.log("\n✨ Copy this address to your frontend:");
    console.log("📍", address);
    process.exit(0);
  })
  .catch(error => {
    console.error("💥 Script error:", error);
    process.exit(1);
  });