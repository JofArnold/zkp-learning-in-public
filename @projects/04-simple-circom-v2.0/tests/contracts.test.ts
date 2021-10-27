const { buildContractCallArgs, genProof } = require("../src/utils");

const { expect } = require("chai");
const { ethers } = require("hardhat");
const path = require("path");

describe("NFT tests", () => {
  it("should mint and return NFT id and assign NFT when given correct proof", async () => {
    const [_, signer1] = await ethers.getSigners();
    const NFTPrize = await ethers.getContractFactory("NFTPrize");
    const nft = await NFTPrize.deploy();
    await nft.deployed();

    // Generate proof
    const { proof, publicSignals } = await genProof(
      { a: 1, b: 4 },
      path.resolve(__dirname, "../zk/circuit_js/circuit.wasm"),
      path.resolve(__dirname, "../zk/circuit_final.zkey")
    );
    console.log(proof, publicSignals);
    const callArgs = buildContractCallArgs(proof, publicSignals);
    const transaction = await nft
      .connect(signer1)
      .validateAndMintToken(...callArgs); // Try minting the token
    const tx = await transaction.wait(); // Waiting for the token to be minted
    const event = tx.events[0];
    const value = event.args[2];
    const tokenId = value.toNumber();
    expect(tokenId).to.eq(1);
    const nftOwner = await nft.ownerOf(1);
    expect(nftOwner).to.eq(signer1.address);
  });
});
