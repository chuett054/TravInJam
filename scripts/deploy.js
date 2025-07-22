const { ethers } = require("hardhat");

async function main() {
  // compile & get your factory
  const Demo = await ethers.getContractFactory("CarClaimDemo");

  // deploy
  const demo = await Demo.deploy();

  // wait for it to actually hit the chain
  await demo.waitForDeployment();

  // address is in demo.target
  console.log(`Contract deployed at: ${demo.target}`);
}

main().catch((e) => {
  console.error(e);
  process.exitCode = 1;
});