import hre from "hardhat";

async function main() {
  console.log("Starting deployment on network:", hre.network.name);

  // Deploy CoopLedger
  const CoopLedger = await hre.ethers.getContractFactory("CoopLedger");
  const coopLedger = await CoopLedger.deploy();
  await coopLedger.waitForDeployment();
  const coopLedgerAddress = await coopLedger.getAddress();
  console.log(`CoopLedger deployed to: ${coopLedgerAddress}`);

  // Deploy VoteGovernance
  const VoteGovernance = await hre.ethers.getContractFactory("VoteGovernance");
  const voteGovernance = await VoteGovernance.deploy();
  await voteGovernance.waitForDeployment();
  const voteGovernanceAddress = await voteGovernance.getAddress();
  console.log(`VoteGovernance deployed to: ${voteGovernanceAddress}`);

  // Deploy ReportAnchor
  const ReportAnchor = await hre.ethers.getContractFactory("ReportAnchor");
  const reportAnchor = await ReportAnchor.deploy();
  await reportAnchor.waitForDeployment();
  const reportAnchorAddress = await reportAnchor.getAddress();
  console.log(`ReportAnchor deployed to: ${reportAnchorAddress}`);

  console.log("\n--- Deployment Summary ---");
  console.log("RPC URL:", hre.network.config.url);
  console.log("CoopLedger Address:", coopLedgerAddress);
  console.log("VoteGovernance Address:", voteGovernanceAddress);
  console.log("ReportAnchor Address:", reportAnchorAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
