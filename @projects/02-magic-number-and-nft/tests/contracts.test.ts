const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NFT tests", () => {
  it("should return true and assign NFT when given correct input", async () => {
    // const proof = require('../zk/proof.json');
    const NFTPrize = await ethers.getContractFactory("NFTPrize");
    const nft = await NFTPrize.deploy();
    await nft.deployed();
    const transaction = await nft.mintToken(); // Minting the token
    const tx = await transaction.wait(); // Waiting for the token to be minted

    const event = tx.events[0];
    const value = event.args[2];
    const tokenId = value.toNumber(); // Getting the tokenID
    console.log(tokenId);
  });
});
