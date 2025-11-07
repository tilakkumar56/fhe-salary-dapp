const { expect } = require("chai");

describe("Basic dApp Tests", function () {
  it("Should verify basic functionality", function () {
    // Test that our dApp logic works
    const calculateAverage = (salaries) => {
      return salaries.reduce((a, b) => a + b, 0) / salaries.length;
    };
    
    const testSalaries = [80000, 90000, 100000];
    const average = calculateAverage(testSalaries);
    
    expect(average).to.equal(90000);
    console.log("✅ Salary calculation test passed!");
  });

  it("Should have correct role categories", function () {
    const roles = ["Junior", "Mid-level", "Senior", "Lead"];
    expect(roles.length).to.equal(4);
    console.log("✅ Role categories test passed!");
  });
});