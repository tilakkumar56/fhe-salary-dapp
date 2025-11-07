const hre = require("hardhat");

async function main() {
  console.log("🚀 Deploying FHE Salary dApp...");
  
  // Deploy PrivateSalaryReveal contract
  try {
    console.log("📦 Deploying PrivateSalaryReveal contract...");
    
    const PrivateSalaryReveal = await hre.ethers.getContractFactory("PrivateSalaryReveal");
    const privateSalaryReveal = await PrivateSalaryReveal.deploy();
    
    await privateSalaryReveal.deployed();
    
    console.log("✅ PrivateSalaryReveal deployed to:", privateSalaryReveal.address);
    console.log("🔗 Frontend contract address:", privateSalaryReveal.address);
    console.log("📝 Copy this address to your frontend HTML file!");
    
    return privateSalaryReveal.address;
    
  } catch (error) {
    console.error("❌ Deployment failed:", error.message);
    
    // Show available contracts for debugging
    console.log("🔍 Checking available contracts...");
    try {
      const contractNames = await hre.artifacts.getAllFullyQualifiedNames();
      console.log("📋 Available contracts:", contractNames);
    } catch (e) {
      console.log("❌ Could not get contract list:", e.message);
    }
    
    process.exit(1);
  }
}

main().catch((error) => {
  console.error("💥 Script failed:", error);
  process.exitCode = 1;
});