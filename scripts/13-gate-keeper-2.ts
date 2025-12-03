import { ethers } from "hardhat";
import fs from "fs";
import path from "path";
import { formatEther } from "ethers";

async function main() {
  // get contract by address & abi
  const instanceAddress = "0x0CC80438EEEFa296C66A0F95288Eda56dEbB3Fb0";

  const abiPath = path.join(__dirname, "..", "abis", "gate_keeper_2.json");
  if (!fs.existsSync(abiPath)) {
    console.error(`ABI file not found at ${abiPath}`);
    process.exit(1);
  }
  const abiJson = JSON.parse(fs.readFileSync(abiPath, "utf8"));

  const [signer] = await ethers.getSigners();

  const contract = new ethers.Contract(instanceAddress, abiJson, signer);
  console.log("Attached to contract:", contract.target);

  // function call
  console.log(await contract.entrant());

  const attackContract = await ethers.getContractFactory("GatekeeperTwoAttack");
  const attack = await attackContract.deploy(instanceAddress);
  await attack.waitForDeployment();

  console.log(await contract.entrant());
}

main().catch((err) => {
  console.error("Error:", err);
  process.exitCode = 1;
});
