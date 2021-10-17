const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NFT tests", () => {
  it("should mint and return NFT id and assign NFT when given correct input", async () => {
    const [_, signer1] = await ethers.getSigners();
    const proof = require("../zk/proof.json");
    const NFTPrize = await ethers.getContractFactory("NFTPrize");
    const nft = await NFTPrize.deploy();
    await nft.deployed();
    const transaction = await nft
      .connect(signer1)
      .validateAndMintToken(proof.proof, proof.inputs); // Try minting the token
    const tx = await transaction.wait(); // Waiting for the token to be minted

    const event = tx.events[0];
    const value = event.args[2];
    const tokenId = value.toNumber();
    expect(tokenId).to.eq(1);
    const nftOwner = await nft.ownerOf(1);
    expect(nftOwner).to.eq(signer1.address);
  });

  it("should not mint NFT when given incorrect input", async () => {
    const proof = require("../zk/proof.json");
    const NFTPrize = await ethers.getContractFactory("NFTPrize");
    const nft = await NFTPrize.deploy();
    await nft.deployed();
    // Make the proof invalid
    proof.proof.a = [
      "0x0c6a0d84b75abf537af3686c38a9d0d73adaf3c555e7f44c4f3fa37c7b365b15",
      "0x1e08a93f36aa7228b80a4b56fa952bc47aed36beb02a9f28f3c3f0dccdc25270",
    ];
    await expect(
      nft.validateAndMintToken(proof.proof, proof.inputs)
    ).to.be.revertedWith("invalid_proof");
  });
});
