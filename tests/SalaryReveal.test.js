const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SimpleSalaryReveal", function () {
  it("Should deploy successfully", async function () {
    const SimpleSalaryReveal = await ethers.getContractFactory("SimpleSalaryReveal");
    const salaryReveal = await SimpleSalaryReveal.deploy();
    
    expect(await salaryReveal.getAddress()).to.be.properAddress;
    console.log("✅ SimpleSalaryReveal deployed successfully!");
  });

  it("Should allow salary submission", async function () {
    const SimpleSalaryReveal = await ethers.getContractFactory("SimpleSalaryReveal");
    const salaryReveal = await SimpleSalaryReveal.deploy();
    
    // Submit a salary
    await salaryReveal.submitSalary(80000, 3, 2);
    
    // Check if submission was recorded
    const hasSubmitted = await salaryReveal.checkSubmission(await ethers.provider.getSigner(0).getAddress());
    expect(hasSubmitted).to.be.true;
    console.log("✅ Salary submitted successfully!");
  });
});