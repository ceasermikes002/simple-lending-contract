import { ethers } from "hardhat";

async function main() {
    // Get the contract factory for "Lending"
    const Lending = await ethers.getContractFactory("Lending");

    // Deploy the contract
    const lendingContract = await Lending.deploy();

    // Wait for the contract to be deployed
    await lendingContract.waitForDeployment();

    // Log the deployed contract address
    console.log("Lending contract deployed at:", lendingContract.target);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
